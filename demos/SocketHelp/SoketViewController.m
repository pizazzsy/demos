//
//  SoketViewController.m
//  demos
//
//  Created by ra on 2019/4/1.
//  Copyright © 2019年 tianyixin. All rights reserved.
//

#import "SoketViewController.h"
#import <AsyncSocket.h>
#import <AsyncUdpSocket.h>
@interface SoketViewController ()<AsyncSocketDelegate,AsyncUdpSocketDelegate>
@property (nonatomic,strong) AsyncUdpSocket *udpSocket;
@property (nonatomic,strong) AsyncSocket *socket;
@end

@implementation SoketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    [self sendUdpBoardcast:^(NSDictionary * _Nonnull dic, NSError * _Nonnull err) {
//        NSLog(@"%@",dic);
//    }];
    _udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    _socket =[[AsyncSocket alloc]initWithDelegate:self];
    UInt16 port = 48899;// 此处具体指需询问硬件工程师
    [_socket connectToHost:@"255.255.255.0" onPort:port error:nil];
    
    
    [self.udpSocket enableBroadcast:YES error:NULL];
//    [_socket sendData:[self dataFormMate] toHost:@"255.255.255.255" port:port withTimeout:-1 tag:0];
//    [_socket writeData:[self dataFormMate]  withTimeout:-1 tag:0];
    // Do any additional setup after loading the view.
}

-(NSMutableData*)dataFormMate{
    NSString*ssid=@"dezhu";
    NSString*pwd=@"123456789";
    NSString *str = [NSString stringWithFormat:@"%@\r\n%@",ssid,pwd];
    NSMutableData  *strData = [[NSMutableData alloc]initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]]; // UTF-8编码
    Byte data[2];
    data[0] = (Byte)0x02;
    data[1] = (Byte)(0 & 0xff);
    [strData appendBytes:data length:2];
    return [self dataFormMate2:strData];
}
-(NSMutableData*)dataFormMate2:(NSMutableData*)key{
    Byte *keyBytes=(Byte*)[key bytes];
    NSInteger length=4+key.length;
    Byte cmd[22]={};
    cmd[0]=(Byte)0xff;
    Byte *lengthBytes=(Byte*)[[self int2byte:key.length] bytes];
    cmd[1]=lengthBytes[1];
    cmd[2]=lengthBytes[0];
    // 校验位累加
    cmd[length - 1] = (Byte) (cmd[1] + cmd[2]);
    for (int i = 0; i < key.length; i++) {
        cmd[i + 3] = keyBytes[i];
        cmd[length - 1] += keyBytes[i];
    }
    NSMutableData * cmdData = [NSMutableData dataWithBytes:cmd length:length];
    return cmdData;
}
-(NSData*)int2byte:(NSInteger)res{
    Byte targets[4]={};
    targets[0] = (Byte)(res & 0xff);
    targets[1] = (Byte)((res >> 8) & 0xff);
    targets[2] = (Byte)((res >> 16) & 0xff);
    targets[3] = (Byte)(res >> 24);
    
    NSData * data = [NSData dataWithBytes:targets length:4];
    return data;
    
}
//- (BOOL)connectToHost:(NSString*)hostname onPort:(UInt16)port error:(NSError **)errPtr;
- (void)sendUdpBoardcast:(udpSocketBlock)block{
    self.udpSocketBlock = block;
    if(!_udpSocket)_udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
//     UInt16 port = 48899;// 此处具体指需询问硬件工程师
//    [_udpSocket connectToHost:@"10.10.100.1" onPort:port error:nil];
//    NSData *data = [NSData data];// 此处data是根据硬件要求传参数
    
//    Byte *lengthBytes=(Byte*)[[self dataFormMate] bytes];
//    for (int i=0; i<22; i++) {
//        NSLog(@"%d",lengthBytes[i]);
//    }
    
//    NSLog(@"%@", [self dataFormMate]);
    
//    NSString * str = @"dezhu\r\n123456789";
//    const char *tchar=[str UTF8String];
//    int length=1 + 1 + strlen(tchar);
//    Byte data[length];
//    data[0] = 0x02;
//    data[1] = (Byte) (0 & 0xff);
//    NSData*datainfo=[NSData dataWithBytes:data length:length];
    UInt16 port = 48899;// 此处具体指需询问硬件工程师
    [self.udpSocket enableBroadcast:YES error:NULL];
    [_udpSocket sendData:[self dataFormMate] toHost:@"10.10.100.1" port:port withTimeout:-1 tag:0];
    // 因为不知道具体的ip地址，所以host采用受限广播地址
}
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    // data 接收到的外部设备返回的数据
//    id result = [self unpackageMessage:data];
    // 对数据进行处理，此处调用的 - (id)unpackageMessage:(NSData *)data ;是根据与硬件方面协商的数据格式进行的数据处理
//    if ([[result valueForJSONKey:@"typeid"] isEqualToString:@"xxxx"]) {
//        self.udpSocketBlock([result valueForJSONKey:@"data"],nil);
//    }
    // 判断的到的数据是否为我们需要的数据
    return YES; // 发现设备后，则关闭发现通道
    return NO; // 不关闭发现通道，一直处于发现状态
}
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"成功");
}
-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    
}
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"连接成功");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
