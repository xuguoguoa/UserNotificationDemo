//
//  ViewController.m
//  PushDemo
//
//  Created by xu cuiping on 2016/11/1.
//  Copyright © 2016年 yonyou. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  UIButton  *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 100, 100, 50);
  [button setTitle:@"发送push" forState:UIControlStateNormal];
  [button addTarget:self action:@selector(pushLocalNotification:) forControlEvents:UIControlEventTouchUpInside];
  button.backgroundColor = [UIColor blueColor];
  [self.view addSubview:button];
}

-(void)pushLocalNotification:(NSTimeInterval)timeInterval
{
  timeInterval = 5.0;
  UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
  UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
  content.title = @"这是一个title";
  content.subtitle = @"这是一个subtitle";
  content.body = @"Woah! 这是Body";
  content.badge = @1;
  UNNotificationSound *sound = [UNNotificationSound defaultSound];
  content.sound = sound;
  NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"cell_ic_lookover_norm" ofType:@"png"];
  UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:[NSURL fileURLWithPath:imagePath] options:nil error:nil];
  content.attachments = @[attachment];
  UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
  //添加category
  //设置category
  //UNNotificationActionOptionAuthenticationRequired  执行前需要解锁确认
  //UNNotificationActionOptionDestructive  显示高亮（红色）
  //UNNotificationActionOptionForeground   将会引起程序启动到前台
  
  UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"点击打开app" options:UNNotificationActionOptionForeground];
  
  UNTextInputNotificationAction *action2 = [UNTextInputNotificationAction actionWithIdentifier:@"action2" title:@"回复" options:UNNotificationActionOptionDestructive textInputButtonTitle:@"comment" textInputPlaceholder:@"reply"];
  
  //UNNotificationCategoryOptionNone
  //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
  //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
  UNNotificationCategory *category1 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action2,action1] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
  
  UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"action3" title:@"策略2行为1" options:UNNotificationActionOptionForeground];
  UNNotificationAction *action4 = [UNNotificationAction actionWithIdentifier:@"action4" title:@"策略2行为2" options:UNNotificationActionOptionForeground];
  UNNotificationCategory *category2 = [UNNotificationCategory categoryWithIdentifier:@"category2" actions:@[action3,action4] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
  
  //添加到通知中心
  [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithArray:@[category1,category2]]];
  //触发
  content.categoryIdentifier = @"category1";
  
  NSString *requestIdentifier = @"sampleRequest";
  UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier
                                                                        content:content
                                                                        trigger:trigger1];
  [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
