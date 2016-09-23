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
        
        
        [[HUDConfig shareHUD]dismiss];
        
        FxLog(@"loadOrderDetailData = %@",responseObj);
        if (![responseObj isKindOfClass:[NSNull class]]) {
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                NSDictionary *dic = [responseObj objectForKey:@"data"];
                orderModel = [AppointOrderModel mj_objectWithKeyValues:dic];
                
                [self refreshView];
            }
        }
    } failure:^(NSError *error) {
        
        [[HUDConfig shareHUD]ErrorHUD:@"失败" delay:DELAY];
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
    
    
    //    "0"; //待付款
    //    "1"; //待出行
    //    "2"; //退款中
    //    "3"; //已退款
    //    "4";//行程中
    //    "5";//已结束
    switch ([orderModel.orderState integerValue]) {
        case 0:
            
            self.scoreView.hidden = YES;
            self.tipsLabel.hidden = NO;
            self.tipsLabel.text = @"待付款";
            
            break;
        case 1:
            self.scoreView.hidden = YES;
            self.tipsLabel.hidden = NO;
            self.tipsLabel.text = @"待出行";
            
            break;
        case 2:
            
            self.scoreView.hidden = YES;
            self.tipsLabel.hidden = NO;
            self.tipsLabel.text = @"退款中";
            
            break;
        case 3:
            
            self.scoreView.hidden = YES;
            self.tipsLabel.hidden = NO;
            self.scores.show_star = [orderModel.orderGrade integerValue];
            
            break;
        case 4:
            
            self.scoreView.hidden = NO;
            self.tipsLabel.hidden = YES;
            self.scores.show_star = [orderModel.orderGrade integerValue];
            
            break;
        case 5:
            
            self.scoreView.hidden = NO;
            self.tipsLabel.hidden = YES;
            self.scores.show_star = [orderModel.orderGrade integerValue];
            
            break;
            
        default:
            
            self.scoreView.hidden = NO;
            self.tipsLabel.hidden = YES;
            self.scores.show_star = [orderModel.orderGrade integerValue];
            
            break;
    }
    
    NSLog(@"sdgfsfh = %@",orderModel.orderGrade);
    
//    if ([orderModel.orderState integerValue] == 0 || [orderModel.orderState integerValue] == 1 || [orderModel.orderState integerValue] == 2 || [orderModel.orderState integerValue] == 3 || [orderModel.orderState integerValue] == 4) {
//        
//        self.scoreView.hidden = YES;
//        self.tipsLabel.hidden = NO;
//    }else {
//    
//        self.scoreView.hidden = NO;
//        self.tipsLabel.hidden = YES;
//    }
}

@end
