//
//  NotificationService.m
//  serviceextension
//
//  Created by xu cuiping on 2016/11/7.
//  Copyright © 2016年 yonyou. All rights reserved.
//

#import "NotificationService.h"
#import <UIKit/UIKit.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler
{
  self.contentHandler = contentHandler;
  self.bestAttemptContent = [request.content mutableCopy];
  
  // Modify the notification content here...
  self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [xucpppppp]", self.bestAttemptContent.title];
  NSDictionary *apsDic = [request.content.userInfo objectForKey:@"aps"];
  NSString *attachUrl = [apsDic objectForKey:@"image"];
  NSLog(@"%@",attachUrl);
  if(!attachUrl || [attachUrl isEqualToString:@""])
  {
    //发送push
    self.contentHandler(self.bestAttemptContent);
  }
  //可以在拦截Push的时候添加action
//  self.bestAttemptContent.categoryIdentifier = @"category1";
  //另一种方式
  NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
  
  NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:attachUrl]
                                                      completionHandler:^(NSURL * _Nullable location,
                                                                          NSURLResponse * _Nullable response,
                                                                          NSError * _Nullable error)
  {
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // response.suggestedFilename ： 建议使用的文件名，一般跟服务器端的文件名一致
    NSString *file = [caches stringByAppendingPathComponent:response.suggestedFilename];
    
    // 将临时文件剪切或者复制Caches文件夹
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // AtPath : 剪切前的文件路径
    // ToPath : 剪切后的文件路径
    [mgr moveItemAtPath:location.path toPath:file error:nil];
    
    if (file && ![file  isEqualToString: @""])
    {
      UNNotificationAttachment *attch= [UNNotificationAttachment attachmentWithIdentifier:@"photo"
                               URL:[NSURL URLWithString:[@"file://" stringByAppendingString:file]]
                           options:nil
                             error:nil];
      if(attch)
      {
        self.bestAttemptContent.attachments = @[attch];
      }
    }
    self.contentHandler(self.bestAttemptContent);
  }];

//  NSMutableArray *identifierAry = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"remoteIdentifiers"]];
//  if(!identifierAry)
//  {
//    identifierAry = [[NSMutableArray alloc]initWithCapacity:0];
//  }
//  [identifierAry addObject:request.identifier];
//  [[NSUserDefaults standardUserDefaults] setObject:identifierAry forKey:@"remoteIdentifiers"];
//  if(identifierAry.count > 1)
//  {
//    //取消上一条通知
//    NSString *lastidentifier = [identifierAry objectAtIndex:0];
//    [identifierAry removeObjectAtIndex:0];
//    [[NSUserDefaults standardUserDefaults] setObject:identifierAry forKey:@"remoteIdentifiers"];
//    [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[lastidentifier]];
//  }
  //取消所有的已发送通知
  [[UNUserNotificationCenter currentNotificationCenter]removeAllDeliveredNotifications];
   [downloadTask resume];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
