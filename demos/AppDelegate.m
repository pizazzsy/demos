//
//  AppDelegate.m
//  demos
//
//  Created by jack on 2018/8/27.
//  Copyright © 2018年 tianyixin. All rights reserved.
//

#import "AppDelegate.h"
#import  <UserNotifications/UserNotifications.h>


@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    BTabBarController *btVC = [[BTabBarController alloc]init];
//    [self.window makeKeyAndVisible];
//    self.window.rootViewController = btVC;
//    [IQKeyboardManager sharedManager].enable = YES;
//    
//    [Bugly startWithAppId:@"67e1b343b8"];
    [self registPush:application andOptions:launchOptions];
    return YES;

}


-(void)registPush:(UIApplication *)application andOptions:(NSDictionary *)launchOptions{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                  NSLog(@"========%@",settings);
        }];
    } else {
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            //IOS8，创建UIUserNotificationSettings，并设置消息的显示类类型
            UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
            [application registerUserNotificationSettings:notiSettings];
        }
    }
    UNNotificationAction * likeAction;              //喜欢
    UNNotificationAction * ingnoreAction;           //取消
    UNNotificationAction * emojiAction;             //自定义表情
    UNTextInputNotificationAction * inputAction;    //文本输入
    
    likeAction = [UNNotificationAction actionWithIdentifier:@"action_like"
                                                      title:@"点赞"
                                                    options:UNNotificationActionOptionForeground];

    inputAction = [UNTextInputNotificationAction actionWithIdentifier:@"action_input"
                                                                title:@"评论"
                                                              options:UNNotificationActionOptionForeground
                                                 textInputButtonTitle:@"发送"
                                                 textInputPlaceholder:@"说点什么"];
    
    emojiAction = [UNNotificationAction actionWithIdentifier:@"action_emoji"
                                                       title:@"表情"
                                                     options:UNNotificationActionOptionForeground];
    
    ingnoreAction = [UNNotificationAction actionWithIdentifier:@"action_cancel"
                                                         title:@"忽略"
                                                       options:UNNotificationActionOptionForeground];

    UNNotificationCategory * category;
    category = [UNNotificationCategory categoryWithIdentifier:@"myNotificationCategory"
                                                         actions:@[likeAction, inputAction, ingnoreAction]
                                               intentIdentifiers:@[]
                                                         options:UNNotificationCategoryOptionNone];
       
    NSSet * sets = [NSSet setWithObjects:category, nil];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:sets];
       
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

#pragma mark - 申请通知权限


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =[[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token:%@",token);
}
//获取DeviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"[DeviceToken Error]:%@\n",error.description);
}
#pragma mark - iOS10 收到通知（本地和远端） UNUserNotificationCenterDelegate

//App处于前台接收通知时
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{

    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
}
    

//App通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{

    completionHandler(); // 系统要求执行这个方法
}
#pragma mark -iOS 10之前收到通知

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"iOS6及以下系统，收到通知:%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"iOS7及以上系统，收到通知:%@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
    //此处省略一万行需求代码。。。。。。
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
