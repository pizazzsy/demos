//
//  AppDelegate.m
//  demos
//
//  Created by jack on 2018/8/27.
//  Copyright © 2018年 tianyixin. All rights reserved.
//

#import "AppDelegate.h"
#import "BTabBarController.h"
#import <Bugly/Bugly.h>
#import <PushKit/PushKit.h>

@interface AppDelegate ()<RCConnectionStatusChangeDelegate,RCIMReceiveMessageDelegate,RCIMUserInfoDataSource,PKPushRegistryDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    BTabBarController *btVC = [[BTabBarController alloc]init];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = btVC;

    
    [Bugly startWithAppId:@"67e1b343b8"];
    
    [self RongCloudIMConfig];
    [self PushConfig:application];
   
    return YES;
}
//初始化融云SDK并
-(void)RongCloudIMConfig{
//     NSString*token=@"EqTw+3hSJ3yueQPs6ugNhuRaIz1bkaOKFNGuScijx7lKhnps3RW6SQezWAZswTDYr2CqoiyNU8gph32GIqA3cw==";//789456
        NSString*token=@"Gk7kC/Q+ym/arn193zwxsuetBHUbqfBT7BxSq5Y1ZV/k/ZggG8XOuA6nFcavARjNvpYTMtgfyVdj03TaszEbtw==";//456789
    [[RCIM sharedRCIM] initWithAppKey:@"8brlm7uf8j5h3"];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    [RCIMClient sharedRCIMClient].logLevel=RC_Log_Level_Verbose;
    [[RCIM sharedRCIM] connectWithToken:token     success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        NSLog(@"token错误");
    }];
}
//注册Voip服务
-(void)RegistryVoipToken{
        PKPushRegistry *pushRegistry = [[PKPushRegistry alloc]  initWithQueue:dispatch_get_main_queue()];
        pushRegistry.delegate = self;
        pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
}
-(void)PushConfig:(UIApplication *)application{
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
}
//- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type {
//    NSString *str = [NSString stringWithFormat:@"%@",credentials.token];
//    NSString *voipToken = [[[str stringByReplacingOccurrencesOfString:@"<" withString:@""]
//                           stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
//    [[NSUserDefaults standardUserDefaults] setObject:voipToken forKey:@"rcVoIPDeviceToken"];
//    //上传token处理
//}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =[[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    //通过代理方法获得的userid去获取详细信息（）
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId = userId;
    user.name =userId;
    user.portraitUri = @"头像";
    return completion(user);
}
-(void)onConnectionStatusChanged:(RCConnectionStatus)status{
    if (status == ConnectionStatus_Connected) {
        NSLog(@"融云服务器连接成功!");
    } else  {
        if (status == ConnectionStatus_SignUp) {
            NSLog(@"融云服务器断开连接!");
        } else {
            NSLog(@"融云服务器连接失败!");
        }
    }
}
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *testMessage = (RCTextMessage *)message.content;
        NSLog(@"消息内容：%@", testMessage.content);
    }
    NSLog(@"还剩余的未接收的消息数：%d", left);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"demos"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
