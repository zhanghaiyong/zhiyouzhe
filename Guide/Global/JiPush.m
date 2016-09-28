//
//  JiPush.m
//  Guide
//
//  Created by ksm on 16/4/28.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "JiPush.h"

@implementation JiPush

+ (JiPush *)shareJpush
{
    static JiPush *jpush = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jpush = [[JiPush alloc] init];
    });
    
    return jpush;
}

- (void)addObserver {

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(method1) name:kJPFNetworkDidSetupNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(method2) name:kJPFNetworkDidCloseNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(method3) name:kJPFNetworkDidRegisterNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(method4) name:kJPFNetworkDidLoginNotification object:nil];
}

- (void)registerPush:(NSDictionary *)launchOptions {

    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //Required
    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[UIApplication sharedApplication].applicationIconBadgeNumber + 1];
        
        [[JiPush shareJpush]handleNotification:userInfo];
        FxLog(@"推送 收到通知:%@", userInfo);
        completionHandler(UIBackgroundFetchResultNewData);
        
   /*
        NSDictionary *aps = [userInfo valueForKey:@"aps"];
       NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
        NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
        NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
  */
        NSString *type = [userInfo objectForKey:@"type"];
        
        if ([type isEqualToString:@"01"]) {
            AccountModel *account = [AccountModel account];
            account.identificationState = @"2";
            [AccountModel saveAccount:account];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_STATUS object:self userInfo:nil];
            
        }else if ([type isEqualToString:@"02"]) {
            
            AccountModel *account = [AccountModel account];
            account.identificationState = @"3";
            [AccountModel saveAccount:account];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_STATUS object:self userInfo:nil];
            
        }else if ([type isEqualToString:@"03"]) {
            
            AccountModel *account = [AccountModel account];
            account.serviceCarAuth = @"2";
            [AccountModel saveAccount:account];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_STATUS object:self userInfo:nil];
            
        }else if ([type isEqualToString:@"04"]) {
            
            AccountModel *account = [AccountModel account];
            account.serviceCarAuth = @"3";
            [AccountModel saveAccount:account];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_STATUS object:self userInfo:nil];
            
        }
        
        //    [[HUDConfig shareHUD]Tips:type delay:110];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_ORDER object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_APPOINT object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"appointOrder" object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chatOrder" object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_SYSTEM object:self userInfo:nil];
        
    }else {
    
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[UIApplication sharedApplication].applicationIconBadgeNumber + 1];
        
        [[JiPush shareJpush]handleNotification:userInfo];
        FxLog(@"推送 收到通知:%@", userInfo);
        completionHandler(UIBackgroundFetchResultNewData);
        
        
        /*
         NSDictionary *aps = [userInfo valueForKey:@"aps"];
         NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
         NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
         NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
         */
        NSString *type = [userInfo objectForKey:@"type"];
        
        if ([type isEqualToString:@"01"]) {
            AccountModel *account = [AccountModel account];
            account.identificationState = @"2";
            [AccountModel saveAccount:account];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_STATUS object:self userInfo:nil];
            
        }else if ([type isEqualToString:@"02"]) {
            
            AccountModel *account = [AccountModel account];
            account.identificationState = @"3";
            [AccountModel saveAccount:account];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_STATUS object:self userInfo:nil];
            
        }else if ([type isEqualToString:@"03"]) {
            
            AccountModel *account = [AccountModel account];
            account.serviceCarAuth = @"2";
            [AccountModel saveAccount:account];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_STATUS object:self userInfo:nil];
            
        }else if ([type isEqualToString:@"04"]) {
            
            AccountModel *account = [AccountModel account];
            account.serviceCarAuth = @"3";
            [AccountModel saveAccount:account];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_STATUS object:self userInfo:nil];
            
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_ORDER object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_APPOINT object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"appointOrder" object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chatOrder" object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_SYSTEM object:self userInfo:nil];
    }
    
    
    completionHandler();  // 系统要求执行这个方法
}

- (void)unregisterPush {

//    [JPUSHService ]
}

- (void)registerDeviceToken:(NSData *)deviceToken {

    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)handleNotification:(NSDictionary *)userInfo {

    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)showLocalNotificationAtFront:(UILocalNotification *)notification {

   //  [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)setAlias:(NSString *)alias {
    
    [JPUSHService setAlias:alias callbackSelector:@selector(exchane) object:self];

}
- (void)unsetAlias {

}

- (void)setTopic:(NSString *)topic {

}

- (void)unsetTopic {

    
}

- (void)exchane {

    FxLog(@"设置别名");
}

#pragma  mark notifitionMethod 
- (void)method1 {
    
    FxLog(@"建立连接");
}

- (void)method2 {
    
    FxLog(@"关闭连接");
}

- (void)method3 {
    
    FxLog(@"注册成功");
}

- (void)method4 {
    
    FxLog(@"登录成功");
    NSString *registration = [JPUSHService registrationID];
    FxLog(@"%@",registration);
    
}
@end
