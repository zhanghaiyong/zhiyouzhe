//
//  SDKKey.m
//  Guide
//
//  Created by ksm on 16/4/28.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "SDKKey.h"
#import <SMS_SDK/SMSSDK.h>
#import "IQKeyboardManager.h"
#import "KSMNetworkRequest.h"
#import "GetVisitorParams.h"

@implementation SDKKey

+ (SDKKey *)shareSDKKey
{
    static SDKKey *sdkkey = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sdkkey = [[SDKKey alloc] init];
    });
    
    return sdkkey;
}

//短信验证
- (void)SMSSDKKey {

    [SMSSDK registerApp:(NSString *)SMSKey withSecret:(NSString * )SMSecret];
}

//设置键盘自动关闭
- (void)IQKeyboard {

    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
}

//容云
- (void)RCIMKey:(UIApplication *)application {

    [[RCIM sharedRCIM] initWithAppKey:(NSString *)RCIMKey];

    //开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus = YES;
    //开启发送已读回执（只支持单聊）
    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList = @[@(ConversationType_PRIVATE)];
    //是否在发送的所有消息中携带当前登录的用户信息，默认值为NO
    [RCIM sharedRCIM].enableMessageAttachUserInfo = NO;
    
    /**
     * 容云 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
}

- (void)RCIMConnectWithToken:(NSString *)token success:(SuccessBlock)successHandler failure:(FailureBlock)failureHandler{

    FxLog(@"RongCloudToken = %@",token);
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        
        FxLog(@"连接成功 = %@",userId);
        
//        dispatch_async(dispatch_get_main_queue(), ^{
            ////设置用户信息源
            [[RCIM sharedRCIM]setUserInfoDataSource:self];
//        });
        
        successHandler();
     
    } error:^(RCConnectErrorCode status) {
        FxLog(@"连接失败 ＝ %ld",(long)status);
        failureHandler();
        
    } tokenIncorrect:^{
        
    }];
    
}




/**
 *  获取用户信息。
 *
 *  @param userId     用户 Id。
 *  @param completion 用户信息
 */
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    
    AccountModel *account = [AccountModel account];
    if ([userId isEqualToString:account.id]) {
        RCUserInfo *update = [[RCUserInfo alloc]init];
        update.userId = userId;
        update.name = account.nickname;
        update.portraitUri = [NSString stringWithFormat:@"%@%@",KImageUrl,account.headiconUrl];
        
        
        RCUserInfo *userInfo = [RCIM sharedRCIM].currentUserInfo;
        userInfo.portraitUri = [NSString stringWithFormat:@"%@%@",KImageUrl,account.headiconUrl];
        userInfo.name = account.nickname;
        
        return completion(update);
        
    }else {
    
        GetVisitorParams *params = [[GetVisitorParams alloc]init];
        params.vid = userId;
        params.zid = account.id;
        params.ztoken = account.token;
        FxLog(@"%@",params.mj_keyValues);
        
        [KSMNetworkRequest postRequest:KGetVisiterMsg params:params.mj_keyValues success:^(id responseObj) {
            NSDictionary *dic = [responseObj objectForKey:@"data"];
            
            if (![dic isKindOfClass:[NSNull class]]) {
                RCUserInfo *visiterInfo = [[RCUserInfo alloc]init];
                visiterInfo.userId = [dic objectForKey:@"id"];
                visiterInfo.name = [dic objectForKey:@"nickname"];
                visiterInfo.portraitUri = [NSString stringWithFormat:@"%@%@",KVisiterUrl,[dic objectForKey:@"headiconUrl"]];
                FxLog(@"游客信息 ＝ %@",[NSString stringWithFormat:@"%@%@",KVisiterUrl,[dic objectForKey:@"headiconUrl"]]);
                return completion(visiterInfo);
            }
        } failure:^(NSError *error) {
            
        } type:0];
    }
     return completion(nil);
}


@end
