//
//  NotificationViewController.m
//  content
//
//  Created by 承启通 on 2020/8/11.
//  Copyright © 2020 tianyixin. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
//    self.label.text = notification.request.content.body;
    self.label.text = @"哈哈，成功啦";

    
}

@end
