//
//  SDKKey.h
//  Guide
//
//  Created by ksm on 16/4/28.
//  Copyright © 2016年 ksm. All rights reserved.
//
//测试pvxdm17jxjxvr  appstore   e5t4ouvptkqaa
static NSString *RCIMKey = @"e5t4ouvptkqaa";

#import <Foundation/Foundation.h>

/**
 请求成功block
 */
typedef void (^SuccessBlock)(void);

/**
 请求失败block
 */
typedef void (^FailureBlock) (void);

@interface SDKKey : NSObject<RCIMUserInfoDataSource>
+ (SDKKey *)shareSDKKey;
//短信验证
- (void)SMSSDKKey;


//设置键盘自动关闭
- (void)IQKeyboard;

//容云
- (void)RCIMKey:(UIApplication *)application;
- (void)RCIMConnectWithToken:(NSString *)token success:(SuccessBlock)successHandler failure:(FailureBlock)failureHandler;

@end
