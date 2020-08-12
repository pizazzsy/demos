//
//  NotificationService.m
//  sever
//
//  Created by 承启通 on 2020/8/10.
//  Copyright © 2020 tianyixin. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
//    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    NSLog(@"收到推送消息，可进行处理");

    // 重写一些东西
    self.bestAttemptContent.title = @"我是标题";
    self.bestAttemptContent.subtitle = @"我是子标题";
    self.bestAttemptContent.body = @"来自徐不同";
   
    self.bestAttemptContent.categoryIdentifier = @"myNotificationCategory";
    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
