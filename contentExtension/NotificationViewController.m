//
//  NotificationViewController.m
//  contentExtension
//
//  Created by xu cuiping on 2016/11/9.
//  Copyright © 2016年 yonyou. All rights reserved.
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

//下拉自定义通知进详情时调用
- (void)didReceiveNotification:(UNNotification *)notification {
    self.label.text = notification.request.content.body;
}


//点击自定义通知的action时调用，如果没有实现这个协议，action走之前的-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler这个回调
- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption option))completion
{
  
}

@end
