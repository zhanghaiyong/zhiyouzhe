//
//  RootTabBarController.m
//  Guide
//
//  Created by ksm on 16/4/8.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "RootTabBarController.h"

@interface RootTabBarController ()
{

//    AccountModel *account;
//    NSInteger systemCount;
//    NSInteger orderCount;
//    NSInteger appointCount;
}
@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

//    account = [AccountModel account];
//    
//    //未读系统消息条数
//    [self unreadSystemMsgCount];
//    //未读订单消息条数
//    [self unreadOrderMsgCount];
//    //未读预约消息条数
//    [self unreadAppointmentMsgCount];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSystem) name:REFRESH_SYSTEM object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrder) name:REFRESH_ORDER object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAppoint) name:REFRESH_APPOINT object:nil];
}

//- (void)refreshSystem{
//
//    [self unreadSystemMsgCount];
//}
//
//- (void)refreshOrder {
//
//    [self unreadOrderMsgCount];
//}
//
//- (void)refreshAppoint {
//
//    [self unreadAppointmentMsgCount];
//}
//
////未读系统消息条数
//- (void)unreadSystemMsgCount {
//
//    NSDictionary *params = @{@"zid":account.id,@"ztoken":account.token};
//    
//    [KSMNetworkRequest postRequest:KUnreadSystemMsgCount params:params success:^(id responseObj) {
//        
//        NSLog(@"unreadOrderCount = %@",responseObj);
//        if (![responseObj isKindOfClass:[NSNull class]]) {
//            
//            NSString *count = [responseObj objectForKey:@"data"];
//            systemCount = [count integerValue];
//            if (systemCount > 0) {
//                [self.tabBar.items[2] setBadgeValue:[NSString stringWithFormat:@"%ld",systemCount+orderCount+appointCount]];
//            }
//        }
//        
//    } failure:^(NSError *error) {
//        
//    } type:0];
//}
//
////未读订单消息条数
//- (void)unreadOrderMsgCount {
//
//    NSDictionary *params = @{@"zid":account.id,@"ztoken":account.token};
//    [KSMNetworkRequest postRequest:KUnreadOrderMsgCount params:params success:^(id responseObj) {
//        
//        NSLog(@"unreadOrderCount = %@",responseObj);
//        if (![responseObj isKindOfClass:[NSNull class]]) {
//            
//            NSString *count = [responseObj objectForKey:@"data"];
//            orderCount = [count integerValue];
//            if (orderCount > 0) {
//                [self.tabBar.items[2] setBadgeValue:[NSString stringWithFormat:@"%ld",systemCount+orderCount+appointCount]];
//            }
//        }
//        
//    } failure:^(NSError *error) {
//        
//    } type:0];
//
//}
//
////未读预约消息条数
//- (void)unreadAppointmentMsgCount {
//
//    NSDictionary *params = @{@"zid":account.id,@"ztoken":account.token};
//    [KSMNetworkRequest postRequest:KUnreadAppointmentMsgCount params:params success:^(id responseObj) {
//        
//        NSLog(@"unreadOrderCount = %@",responseObj);
//        if (![responseObj isKindOfClass:[NSNull class]]) {
//            
//            NSString *count = [responseObj objectForKey:@"data"];
//            appointCount = [count integerValue];
//            if (appointCount > 0) {
//                [self.tabBar.items[2] setBadgeValue:[NSString stringWithFormat:@"%ld",systemCount+orderCount+appointCount]];
//            }
//        }
//        
//    } failure:^(NSError *error) {
//        
//    } type:0];
//    
//}


@end
