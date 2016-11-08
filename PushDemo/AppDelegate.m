//
//  AppDelegate.m
//  PushDemo
//
//  Created by xu cuiping on 2016/11/1.
//  Copyright © 2016年 yonyou. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"


@interface AppDelegate ()

@property (nonatomic,assign) int pushCount;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.pushCount = 0;
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  ViewController *homeVC = [[ViewController alloc] init];
  UINavigationController *NVC = [[UINavigationController alloc] initWithRootViewController:homeVC];
  self.window.rootViewController = NVC;
  
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  //注册本地推送
  UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
  center.delegate = self;
  //获取当前的通知设置
  [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
    NSLog(@"%@",settings);
  }];
  //请求推送权限
  [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
    if (!error) {
      NSLog(@"request authorization succeeded!");
    }
  }];
  //注册远程推送
  [[UIApplication sharedApplication] registerForRemoteNotifications];
    return YES;
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
  
  //应用在前台时是否弹出通知，设置在前台展示时通知的形式
  //让它只显示 alert 和 sound ,而忽略 badge
  completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
  
}

//点击推送消息或者点击action的回调
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
  NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
  NSString *categoryIdentifier = response.notification.request.content.categoryIdentifier;
  if([categoryIdentifier isEqualToString:@"category1"])
  {
    if([response.actionIdentifier isEqualToString:@"action1"])
    {
      UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"IOS10的通知好强大" message:@"😊" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
      [alertView show];
    }
  }
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
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken NS_AVAILABLE_IOS(3_0)
{
  NSLog(@"deviceToken:%@",deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0)
{
  NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error);
}


@end
