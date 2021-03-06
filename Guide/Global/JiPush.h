//
//  JiPush.h
//  Guide
//
//  Created by ksm on 16/4/28.
//  Copyright © 2016年 ksm. All rights reserved.
//
//测试 	192e6ba190574c47ad3f39dd  正式  59fb4a2ef0cea05e7798bab4
static NSString *appKey = @"59fb4a2ef0cea05e7798bab4";
static NSString *channel = @"Publish channel";
static BOOL isProduction = true;

#import <Foundation/Foundation.h>
#import <JPUSHService.h>
#import <UserNotifications/UserNotifications.h>
@interface JiPush : NSObject<JPUSHRegisterDelegate>

@property(nonatomic, strong) NSString   *userId;
@property(nonatomic, strong) NSString   *aliasName;
@property(nonatomic, strong) NSString   *topicName;

+ (JiPush *)shareJpush;
- (void)addObserver;
- (void)registerPush:(NSDictionary *)launchOptions;
- (void)unregisterPush;
- (void)registerDeviceToken:(NSData *)deviceToken;
- (void)handleNotification:(NSDictionary *)userInfo;

- (void)setAlias:(NSString *)alias;
- (void)unsetAlias;
- (void)setTopic:(NSString *)topic;
- (void)unsetTopic;
- (void)showLocalNotificationAtFront:(UILocalNotification *)notification;

@end
