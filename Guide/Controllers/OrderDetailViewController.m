//
//  OrderDetailViewController.m
//  Guide
//
//  Created by ksm on 16/4/20.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "AppointOrderModel.h"
@interface OrderDetailViewController ()
{

    AccountModel *account;
    AppointOrderModel *orderModel;
}


@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    [self setNavigationLeft:@"icon_back_iphone"];
    account = [AccountModel account];
    
    [self loadOrderDetailData];
}

- (void)loadOrderDetailData {

    NSDictionary *params = @{@"zid":account.id,@"ztoken":account.token,@"orderId":self.orderCode};
    [[HUDConfig shareHUD]alwaysShow];
    
    [KSMNetworkRequest getRequest:KAppointOrderDetail params:params success:^(id responseObj) {
        
        [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
        
        NSLog(@"loadOrderDetailData = %@",responseObj);
        if (![responseObj isKindOfClass:[NSNull class]]) {
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                NSDictionary *dic = [responseObj objectForKey:@"data"];
                orderModel = [AppointOrderModel mj_objectWithKeyValues:dic];
                
                [self refreshView];
            }
        }
    } failure:^(NSError *error) {
        
        [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
        [[HUDConfig shareHUD]dismiss];
        
    } type:0];
}

- (void)refreshView {

    //订单号
    self.orderCodeLabel.text = [NSString stringWithFormat:@"订单号：%@",orderModel.orderCode];
    [Uitils cacheVisitorImage:orderModel.vHeadiconUrl withImageV:self.avatarImg withPlaceholder:@"icon_head_default_iphone"];
    self.nickNameLabel.text = orderModel.vNickname;
    self.sexButton.selected = [orderModel.vSex isEqualToString:@"男"]? NO :YES;
    self.orderTimeLabel.text = [NSString stringWithFormat:@"时间：%@",orderModel.orderTime];
    self.telLabel.text = [NSString stringWithFormat:@"电话：%@",orderModel.vPhone];
    self.priceLabel.text = [NSString stringWithFormat:@"收费：%@",orderModel.orderMoney];
    
    if ([orderModel.orderState integerValue] == 1 || [orderModel.orderState integerValue] == 2) {
        
        self.scoreView.hidden = YES;
        self.tipsLabel.hidden = NO;
    }else {
    
        self.scoreView.hidden = NO;
        self.tipsLabel.hidden = YES;
    }
}

@end
