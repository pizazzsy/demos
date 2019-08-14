//
//  BlueToothLinkViewController.m
//  demos
//
//  Created by ra on 2019/8/9.
//  Copyright © 2019 tianyixin. All rights reserved.
//

#import "BlueToothLinkViewController.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface BlueToothLinkViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager; //中心管理者
@property (nonatomic, strong) CBPeripheral *peripheral; //连接到的外设
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic; //写特征
@property (nonatomic, strong) CBCharacteristic *readCharacteristic; //读特征
@property (nonatomic, strong) NSMutableArray *peripherals;
@property(nonatomic,strong)UITextField *text;
@property(nonatomic,strong)UILabel *Lab;
@end

@implementation BlueToothLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];     //创建实例进行蓝牙管理
    self.peripherals= [NSMutableArray array];
    // Do any additional setup after loading the view.
    
    _text=[[UITextField alloc]initWithFrame:CGRectMake(20, 50, self.view.width-40, 50)];
    [_text setBorderStyle:UITextBorderStyleRoundedRect];
    [_text.layer setBorderWidth:0.5];
    [self.view addSubview:_text];
    
    UIButton*button=[UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:CGRectMake(20, 120, 100, 50)];
    [button setTitle:@"发送数据" forState:0];
    [button addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _Lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 190, self.view.width-40, 50)];
    [self.view addSubview:_Lab];
}
-(void)BtnClick{
    
//    Byte byte[] = {0xCC, 0x01, 0x55, 0x98};
//    NSData *data2 = [NSData dataWithBytes:byte length:4];
    
    if (_text.text.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请不要输入空指令"];
        return;
    }
    NSData*data=[self convertHexStrToData:_text.text];
    
//    NSMutableData *data=[[NSMutableData alloc] initWithCapacity:0];
//    int8_t byte0 = 0xCC;
//    [data appendBytes:&byte0 length:sizeof(byte0)];
//    int8_t byte1 = 0x01;
//    [data appendBytes:&byte1 length:sizeof(byte1)];
//    int8_t byte2 = 0x55;
//    [data appendBytes:&byte2 length:sizeof(byte2)];
//    int8_t byte3 = 0x98;
//    [data appendBytes:&byte3 length:sizeof(byte3)];
//    [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    
    [self.peripheral writeValue:data forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithResponse];

}
- (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

//查询蓝牙打开状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    // 蓝牙可用，开始扫描外设
    switch(central.state){
        case CBCentralManagerStatePoweredOn:
        {
            //扫描周边蓝牙外设.
            //CBCentralManagerScanOptionAllowDuplicatesKey为true表示允许扫到重名，false表示不扫描重名的。
            NSLog(@"蓝牙已打开,准备扫描外设");
            [SVProgressHUD showWithStatus:@"正在搜索蓝牙"];
            [_centralManager scanForPeripheralsWithServices:nil options:nil];
            //扫描语句：写nil表示扫描所有蓝牙外设，如果传上面的kServiceUUID,那么只能扫描出FFEO这个服务的外设
        }
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"这个应用程序是无权使用蓝牙低功耗");
            break;
        case CBCentralManagerStatePoweredOff:
            [SVProgressHUD showErrorWithStatus:@"请打开蓝牙"];
            NSLog(@"蓝牙目前已关闭");
            break;
        default:
            break;
    }
}
//搜索蓝牙回调
-(void)centralManager:(CBCentralManager*)central didDiscoverPeripheral:(CBPeripheral*)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber*)RSSI{
    NSLog(@"蓝牙名称%@",peripheral.name);
    if([peripheral.name isEqualToString:@"Coma-V1"]) {//只连接Coma-V1的蓝牙
        //尝试着连接蓝牙
        NSLog(@"尝试连接蓝牙:%@", peripheral.name);
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"尝试连接蓝牙:%@",peripheral.name]];
        self.peripheral=peripheral;//useful
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}
//连接蓝牙回调
-(void)centralManager:(CBCentralManager*)central didConnectPeripheral:(CBPeripheral*)peripheral{
    //检测是否连接到设备
    NSLog(@"蓝牙连接成功:%@", peripheral.name);
    [SVProgressHUD dismiss];
//    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"蓝牙连接成功:%@",peripheral.name]];
    //停止扫描
    [_centralManager stopScan];
//    NSUUID *uuidStr = peripheral.identifier;
    //发现服务
    self.peripheral= peripheral;
    self.peripheral.delegate=self;
    [self.peripheral discoverServices:nil];
}
// 发现外设服务里的特征的时候调用的代理方法(这个是比较重要的方法，你在这里可以通过事先知道UUID找到你需要的特征，订阅特征，或者这里写入数据给特征也可以)
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
//    for (CBCharacteristic *cha in service.characteristics) {
//        NSLog(@"  服务名称--%s, line = %d, char = %@", __FUNCTION__, __LINE__, cha);
//         _characteristic=cha;
//    }
    NSLog(@"发现特征%@",service.characteristics);
    for (CBCharacteristic *c in service.characteristics) {
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"FAA1"]]) {
            
            [_peripheral readValueForCharacteristic:c];
            [_peripheral setNotifyValue:YES forCharacteristic:c];
            _readCharacteristic=c;
            NSLog(@"读特征");
        }
        
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"FAA2"]]) {
            _writeCharacteristic=c;
            NSLog(@"写特征");
        }
        NSLog(@"%@",c.UUID);
    }
}


-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@"发现服务");
    if (error)
    {
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    //服务并不是我们的目标，也没有实际意义。我们需要用的是服务下的特征，查询（每一个服务下的若干）特征
    for (CBService *service in peripheral.services)
    {
//        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:@"FAA0"]] forService:service];
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:@"FAA1"],[CBUUID UUIDWithString:@"FAA2"]] forService:service];
        NSLog(@"udid:%@",service.UUID);
//        [peripheral discoverCharacteristics:nil forService:service];
    }
}
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error{
//    NSData *data = characteristic.value;
//    NSString *value = [self hexadecimalString:data];
     NSLog(@"蓝牙读取到的数据:%@",characteristic.value);
    _Lab.text=[NSString stringWithFormat:@"读取到数据%@",characteristic.value];
}
-(void)centralManager:(CBCentralManager*)central didDisconnectPeripheral:(CBPeripheral*)peripheral error:(NSError*)error{
    NSLog(@"蓝牙连接失败:%@", error);
}
#pragma mark 连接外设——失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"蓝牙连接失败:%@", error);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {
    
    NSLog(@"write value success(写入成功) : %@", characteristic);
    if (error) {
        
        NSLog(@"%s, line = %d, erro = %@",__FUNCTION__,__LINE__,error.description);
        
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
