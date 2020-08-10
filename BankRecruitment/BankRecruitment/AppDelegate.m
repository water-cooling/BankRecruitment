//
//  AppDelegate.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/3/27.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "AppDelegate.h"
#import "UseGuideViewController.h"
#import "LoginViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "RemoteMessageModel.h"
#import "AFNetworkReachabilityManager.h"
#import "DataBaseManager.h"
#import "UMessage.h"
#import "MineMessageViewController.h"

@interface AppDelegate ()<UseGuideDelegate, UNUserNotificationCenterDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) RemoteMessageModel *remoteMessageModel;
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [DataBaseManager sharedManager];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // Override point for customization after application launch.
    /* 打开调试日志 */
#ifdef DEBUG
    [[UMSocialManager defaultManager] openLog:YES];
#endif
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"59267af8f43e482120000222"];
    [self configUSharePlatforms];
    [self confitUShareSettings];
    
    //友盟消息推送
    [UMessage startWithAppkey:@"59267af8f43e482120000222" launchOptions:launchOptions];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    [UMessage setAutoAlert:NO];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UseGuideViewController *homePageVC = [[UseGuideViewController alloc] init];
    homePageVC.delegate = self;
    self.window.rootViewController = homePageVC;
    [self.window makeKeyAndVisible];
    
    //验证遗漏的票据
    [[LdGlobalObj sharedInstanse] checkUnchekReceipt];
    return YES;
}

- (void)removeGuideView
{
    LoginViewController *homePageVC = [[LoginViewController alloc] init];
    [LdGlobalObj sharedInstanse].loginVC = homePageVC;
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:homePageVC];
    [self.window makeKeyAndVisible];
}

- (void)confitUShareSettings
{
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxf41ad321ed049ffa" appSecret:@"503e667c6581dd7008846d56ce97d12a" redirectURL:@"http://dwjy.com"];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106121473"/*设置QQ平台的appID*/  appSecret:@"qjNVzdO6J2AnvBHC" redirectURL:@"http://dwjy.com"];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    [LdGlobalObj sharedInstanse].deviceToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"-----deviceToken %@" ,[LdGlobalObj sharedInstanse].deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma -mark 接收通知
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    NSLog(@"RemoteNotification : %@", userInfo);
//    NSDictionary *body = userInfo[@"aps"][@"alert"];
//    RemoteMessageModel *model = [RemoteMessageModel model];
//    [model setDataWithDic:body];
//    self.remoteMessageModel = model;
    
//    if([LdGlobalObj sharedInstanse].isWarnExamFlag&&![model.mType containsString:@"全员"])
//    {
//        return;
//    }
    
    //定制自定的的弹出框
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新消息"
                                                            message:@"您收到一个推送消息"
                                                           delegate:self
                                                  cancelButtonTitle:@"等会看"
                                                  otherButtonTitles:@"马上看",nil];
        
        [alertView show];
        
    }
    else
    {
        [self jumpMessageVC];
    }
    
    [UMessage sendClickReportForRemoteNotification:userInfo];
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"RemoteNotification : %@", userInfo);
//    NSDictionary *body = userInfo[@"aps"][@"alert"];
//    RemoteMessageModel *model = [RemoteMessageModel model];
//    [model setDataWithDic:body];
//    self.remoteMessageModel = model;
    
//    if([LdGlobalObj sharedInstanse].isWarnExamFlag&&![model.mType containsString:@"全员"])
//    {
//        return;
//    }
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    
    //定制自定的的弹出框
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新消息"
                                                            message:@"您收到一个推送消息"
                                                           delegate:self
                                                  cancelButtonTitle:@"等会看"
                                                  otherButtonTitles:@"马上看",nil];
        
        [alertView show];
        
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    
    [UMessage sendClickReportForRemoteNotification:userInfo];
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"RemoteNotification : %@", userInfo);
    
//    NSDictionary *body = userInfo[@"aps"][@"alert"];
//    RemoteMessageModel *model = [RemoteMessageModel model];
//    [model setDataWithDic:body];
//    self.remoteMessageModel = model;
    
//    if([LdGlobalObj sharedInstanse].isWarnExamFlag&&![model.mType containsString:@"全员"])
//    {
//        return;
//    }
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
    [UMessage sendClickReportForRemoteNotification:userInfo];
    [self jumpMessageVC];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *btnString = [alertView buttonTitleAtIndex:buttonIndex];
    if([btnString isEqualToString:@"马上看"])
    {
        [self jumpMessageVC];
    }
    else
    {
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 6, 6)];
        redView.tag = 999;
        redView.backgroundColor = [UIColor redColor];
        redView.layer.cornerRadius = 3;
        redView.layer.masksToBounds = YES;
        [[LdGlobalObj sharedInstanse].firstPageVC.messageButton addSubview:redView];
    }
}

- (void)jumpMessageVC
{
    MineMessageViewController *vc = [[MineMessageViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    UINavigationController *currentNav = (UINavigationController *)[LdGlobalObj sharedInstanse].homePageVC.selectedViewController;
    [currentNav pushViewController:vc animated:YES];
}

@end
