//
//  AppDelegate.m
//  Guide
//
//  Created by ksm on 16/4/7.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "JiPush.h"
#import "SDKKey.h"
#import "RoleViewController.h"
#import "PageInfo.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


#pragma mark configureAPIKey
- (void)configure {
    
    //设置主导航栏背景色
    [[UINavigationBar appearance] setBarTintColor:MainColor];
    [[UITabBar appearance]setTintColor:lever1Color];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           lever1Color,
                                                           NSForegroundColorAttributeName,
                                                           nil, NSShadowAttributeName,
                                                           [UIFont boldSystemFontOfSize:17],
                                                           NSFontAttributeName, nil]];
}

//判断二次登陆情况
- (void)judgeSecondLogin {

    self.window                    = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    AccountModel *account          = [AccountModel account];
    
    if (account) {
    NSLog(@"appDelegate            = %@",account.mj_keyValues);
    UIStoryboard *story            = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    RoleViewController *roleVC     = [story instantiateViewControllerWithIdentifier:@"RoleViewController"];
    UINavigationController *navi   = [[UINavigationController alloc]initWithRootViewController:roleVC];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
        
//        //第一步，创建URL
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@",KLoginByToken,account.token]];
//        //第二步，创建请求
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
////        [request setHTTPMethod:@"GET"];//设置请求方式为POST，默认为GET
//        //第三步，连接服务器
//        NSError *error;
//        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
//        
//        if (error == nil) {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingAllowFragments error:nil];
//            BASE_INFO_FUN(dic);
//            
//            if ([[dic objectForKey:@"status"] isEqualToString:@"success"]) {
//                
//                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//                RoleViewController *roleVC = [story instantiateViewControllerWithIdentifier:@"RoleViewController"];
//                roleVC.havePhone = [dic objectForKey:@"photo"];
//                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:roleVC];
//                self.window.rootViewController = navi;
//                [self.window makeKeyAndVisible];
//                
//            }else {
//                
//                UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//                LoginViewController *login = [loginStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//                self.window.rootViewController = login;
//                [self.window makeKeyAndVisible];
//            }
//            
//        }else {
//        
//            UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//            LoginViewController *login = [loginStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//            self.window.rootViewController = login;
//            [self.window makeKeyAndVisible];
//        }
        
    }else {
    
        BASE_INFO_FUN(@"为空");
        UIStoryboard *loginStoryboard  = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *login     = [loginStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.window.rootViewController = login;

         [self.window makeKeyAndVisible];
    }
    
}


- (void)goToViewControllerWith:(NSDictionary*)pushInfo {

    UITabBarController *TabBar = [PageInfo pageControllers];
    [self.window.rootViewController presentViewController:TabBar animated:YES completion:nil];
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //推送注册
    [[JiPush shareJpush] registerPush:launchOptions];
    [[JiPush shareJpush]addObserver];
    //统计App启动的事件
    [[RCIMClient sharedRCIMClient]recordLaunchOptionsEvent:launchOptions];


    //设置键盘自动关闭
    [[SDKKey shareSDKKey] IQKeyboard];

    //短信验证
    [[SDKKey shareSDKKey]SMSSDKKey];

    //容云
    [[SDKKey shareSDKKey]RCIMKey:application];


    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"程序启动的推送 ＝ %@",remoteNotification);
    if (remoteNotification) {

        [[HUDConfig shareHUD] Tips:remoteNotification.description delay:1009000000];
    }
    //设置主色调
    [self configure];

    [self judgeSecondLogin];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

#pragma mark JPush method---------
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);

    //极光推送
    [[JiPush shareJpush]registerDeviceToken:deviceToken];

    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                    withString:@""]stringByReplacingOccurrencesOfString:@">"
                                                    withString:@""]stringByReplacingOccurrencesOfString:@" "
                                                    withString:@""];
    //融云消息推送
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
//注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings: (UIUserNotificationSettings *)notificationSettings {
    
     [application registerForRemoteNotifications];
}
#endif

//IOS 7支持需要
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:application.applicationIconBadgeNumber + 1];
    
    [[JiPush shareJpush]handleNotification:userInfo];
    NSLog(@"推送 收到通知:%@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_SYSTEM object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_ORDER object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_APPOINT object:self userInfo:nil];
}


//收到推送的调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    /*!
     * @abstract 前台展示本地推送
     *
     * @param notification 本地推送对象
     * @param notificationKey 需要前台显示的本地推送通知的标示符
     *
     * @discussion 默认App在前台运行时不会进行弹窗，在程序接收通知调用此接口可实现指定的推送弹窗。
     */
    
    

    //用于显示一个提示框
//    [[JiPush shareJpush] showLocalNotificationAtFront:notification];
    
    #warning 在这里接受远程消息
//    [SVProgressHUD show];
    //fId  消息发送者的用户 ID
    //cType 会话类型。PR指单聊、 DS指讨论组、 GRP指群组、 CS指客服、SYS指系统会话、 MC指应用内公众服务、 MP指跨应用公众服务。
    //oName 消息类型，参考融云消息类型表.消息标志；可自定义消息类型。
    //tId 接收者的用户 Id。
    NSLog(@"%@",notification.userInfo);
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

@end
