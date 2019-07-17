

#import "SocketHelper.h"
#import <AsyncSocket.h>
#import <AsyncUdpSocket.h>

@interface SocketHelper ()<AsyncUdpSocketDelegate,AsyncSocketDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) AsyncUdpSocket *udpSocket;
@property (nonatomic,strong) AsyncSocket *socket;
@property (nonatomic,strong) NSMutableDictionary *socketBlockDict;
@property (nonatomic,strong) NSMutableDictionary *socketDataDict;
@end

@implementation SocketHelper
+ (SocketHelper *)Share {
    static dispatch_once_t _socketOnce;
    static SocketHelper *_socketInstance = nil;
    dispatch_once(&_socketOnce, ^{
        _socketInstance = [[self alloc] init];
    });
    return _socketInstance;
}

- (id)init {
    self = [super init];
    self.socketBlockDict = [NSMutableDictionary dictionary];
    self.socketDataDict = [NSMutableDictionary dictionary];
    return self;
}

-(NSString *) NSDataToHexString:(NSData *)data
{
    if (data == nil) {
        return nil;
    }
    NSMutableString* hexString = [NSMutableString string];
    const unsigned char *p = [data bytes];
    for (int i=0; i < [data length]; i++) {
        [hexString appendFormat:@"%02x", *p++];
    }
    return hexString;
}

//十六進位字串轉bytes，可以設定size，padding在左邊
-(NSData *) hexStrToNSData:(NSString *)data withSize:(NSInteger)size
{
    NSInteger add = size*2 - data.length;
    if (add > 0) {
        NSString* tmp = [[NSString string] stringByPaddingToLength:add withString:@"0" startingAtIndex:0];
        data = [tmp stringByAppendingString:data];
    }else if(add<0){
        NSLog(@"hex too long");
        return [self hexStrToNSData:[data substringFromIndex:-add]];
    }
    return [self hexStrToNSData:data];
}
//十六進位字串轉bytes
-(NSData *)hexStrToNSData:(NSString *)hexString {
    NSMutableData *data = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    if (hexString.length%2) {
        //防止奇数长度 丢失半个byte
        hexString = [@"0" stringByAppendingString:hexString];
    }
    int i;
    for (i = 0; i < [hexString length]/2; i++) {
        byte_chars[0] = [hexString characterAtIndex:i * 2];
        byte_chars[1] = [hexString characterAtIndex:i * 2 + 1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

- (NSData *)packageType:(typeID)type message:(NSDictionary *)dict {
    return nil;
}

#define ah2i(c) [self asciiHexToint:c]
- (int)asciiHexToint:(const char)c {
    int r;
    if (c >= '0' && c <= '9') r = (c - '0');
    else if (c >= 'A' && c <= 'F') r = (c - 'A' + 10);
    else if (c >= 'a' && c <= 'f') r = (c - 'a' + 10);
    return r;
}

//异或校验
- (int)xor:(NSData *)data {
    const char *buf = data.bytes;
    int x,i;
    for (i=1,x = buf[0]; i<data.length; i++) {
        x ^= buf[i];
    }
    return x;
}

//打印data
- (void)printf:(NSData *)data {
    NSMutableString *str = [NSMutableString string];
    const char *buf = data.bytes;
    for (int i=0;i<data.length;i++) {
        [str appendFormat:@"%c",buf[i]];
    }
    NSLog(@"printf:\n%@",str);
}
- (NSInteger)unpackageHeader:(NSData *)data {
    return 0;
}

- (id)unpackageMessage:(NSData *)data {
    return nil;
}
#pragma mark - **************** UdpSocket

- (void)sendUdpBoardcast:(udpSocketBlock)block{
    self.udpSocketBlock = block;
    if(!_udpSocket)_udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    NSData *data = [self packageType:typeIDUdp message:nil];
    UInt16 port = 34343;
    [self.udpSocket enableBroadcast:YES error:NULL];
    
    [_udpSocket sendData:data toHost:@"255.255.255.255" port:port withTimeout:-1 tag:0];
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    id result = [self unpackageMessage:data];
//    if ([[result valueForJSONKey:@"typeid"] isEqualToString:@"2FFF"]) {
//        self.udpSocketBlock([result valueForJSONKey:@"data"],nil);
//    }
    // 设置返回NO，则一直保持发现通道
    // 设置返回YES，则发现一个后通道关闭
    return NO;
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{

    NSLog(@"not received");

}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{

    NSLog(@"%@",error);

    NSLog(@"not send");

}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{

    NSLog(@"send");
//    [self.udpSocket enableBroadcast:NO error:NULL];
//    [self.udpSocket bindToPort:34343 error:NULL];
    [self.udpSocket receiveWithTimeout:-1 tag:0];

}

-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    
    NSLog(@"closed");
}


#pragma mark - **************** Socket

- (void)connect:(NSString *)ip port:(NSInteger)number block:(socketBlock)block {
        //如果已经连接，无需再连
        if ([self.socket isConnected]) {
            if(block)block(@{ip:@(number)},nil);
        }else{
            [self.socketBlockDict setObject:block forKey:ip];
            [self.socket disconnect];
            self.socket = [[AsyncSocket alloc] initWithDelegate:self];

            NSError *err;
            BOOL isConn = [self.socket connectToHost:ip onPort:number error:&err];
            if (block&&!isConn) {
                block(nil,err);
            }
        }
}

- (void)send:(typeID)type message:(NSDictionary *)dict block:(socketBlock)block{
    if (self.socket.isConnected) {
        NSString *typeid = [[NSString stringWithFormat:@"%04x",type] uppercaseString];
        if ([self.socketBlockDict valueForKey:typeid]) {
            socketBlock oldBlock = [self.socketBlockDict valueForKey:typeid];
            if (![oldBlock isEqual:[NSNull null]]) {
                oldBlock(nil,[NSError errorWithDomain:@"重复请求失败" code:1 userInfo:nil]);
            }
            return;
        }
        if(block){
            [self.socketBlockDict setObject:block forKey:typeid];
        }else   {
            [self.socketBlockDict setObject:[NSNull null] forKey:typeid];
        }
        NSData *data = [self packageType:type message:dict];
        [self.socket writeData:data withTimeout:-1 tag:0];
        //            [self.socket readDataWithTimeout:-1 tag:0];
        //如果没有等待中的任务才读取
        if(self.socketBlockDict.count<=1){
            [self.socket readDataToLength:6 withTimeout:-1 tag:0];
        }
    }else{
        if(block)block(nil,[NSError errorWithDomain:@"连接已断开" code:100 userInfo:nil]);
    }
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    //[self.socket readDataWithTimeout:-1 tag:0];
//    [self.socket readDataToLength:6 withTimeout:-1 tag:0];
    socketBlock block = [self.socketBlockDict objectForKey:host];
    if (block) {
        block(@{host:@(port)},nil);
        [self.socketBlockDict removeObjectForKey:host];
    }
    NSLog(@"connected");
}
- (void)onSocketDidDisconnect:(AsyncSocket *)sock {

}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"write");
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
//    NSLog(@"data=====%@",data);
    NSInteger len = [self unpackageHeader:data];
    if (len) {
        [sock readDataToLength:len+1 withTimeout:-1 tag:0];
    }else{
        
        
        NSDictionary *rlt = [self unpackageMessage:data];
//        NSLog(@"socket rlt:%@",rlt);
        if (rlt[@"typeid"]) {
            NSInteger type = strtol([rlt[@"typeid"] UTF8String], 0, 16)-1;
            NSString *typeid = [[NSString
                                 stringWithFormat:@"%04lx",(long)type] uppercaseString];
            socketBlock block = [self.socketBlockDict objectForKey:typeid];
            if(![block isEqual:[NSNull null]]){
                block([rlt valueForKey:@"data"],nil);
            }
            [self.socketBlockDict removeObjectForKey:typeid];
        }
        if (self.socketBlockDict.count) {
            [sock readDataToLength:6 withTimeout:-1 tag:0];
        }
    }
}
#pragma mark - UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.cancelButtonIndex) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"stopMB" object:nil];
    }
}
- (void)disconnect{
    [self.udpSocket close];
    self.udpSocket = nil;
}
- (void)tcpSocketDisconnect{
    [self.socket disconnect];
    [self.socketBlockDict removeAllObjects];
}

- (BOOL)socketIsConnect{
    return self.socket.isConnected;
}
@end
