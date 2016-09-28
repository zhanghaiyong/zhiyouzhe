
//
//  NewsViewController.m
//  Guide
//
//  Created by ksm on 16/4/8.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsCell.h"
#import "NewsDetailViewController.h"
#import "AppointmentMsgModel.h"
#import "OrderMsgModel.h"
#import "SystemMsgModel.h"
@interface NewsViewController ()

//系统消息
@property (nonatomic,strong)NSMutableArray *systemArray;
//订单消息
@property (nonatomic,strong)NSMutableArray *orderArray;
//预约消息
@property (nonatomic,strong)NSMutableArray *appointmentmArray;

@end

@implementation NewsViewController
{
    
    AccountModel     *account;
    //系统消息未读数
    NSInteger        systemCount;
    //订单消息未读数
    NSInteger        orderCount;
    //预约消息未读数
    NSInteger        appointCount;
    AppointmentMsgModel *appointmentMsgModel;
    OrderMsgModel       *orderMsgModel;
    SystemMsgModel      *systemMsgModel;
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.hidesBottomBarWhenPushed = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.hidesBottomBarWhenPushed = NO;
}

- (void)awakeFromNib {

    account = [AccountModel account];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSystem) name:REFRESH_SYSTEM object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrder) name:REFRESH_ORDER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAppoint) name:REFRESH_APPOINT object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        //未读系统消息条数
        [self unreadSystemMsgCount];
        //未读订单消息条数
        [self unreadOrderMsgCount];
        //未读预约消息条数
        [self unreadAppointmentMsgCount];
        
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark 请求消息未读数
//未读系统消息条数
- (void)unreadSystemMsgCount {
    
    NSDictionary *params = @{@"zid":account.id,@"ztoken":account.token};
    
    [KSMNetworkRequest postRequest:KUnreadSystemMsgCount params:params success:^(id responseObj) {
        [self.tableView.mj_header endRefreshing];
        
        FxLog(@"unreadSystemMsgCount = %@",responseObj);
        if (![responseObj isKindOfClass:[NSNull class]]) {
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
            
                NSString *count = [responseObj objectForKey:@"count"];
                systemCount = [count integerValue];
                if (systemCount > 0 || ![[responseObj objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                    
                if (systemCount+orderCount+appointCount > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",systemCount+orderCount+appointCount]];
                    });
                }else {
                
                    [self.tabBarItem setBadgeValue:nil];
                }
                
                systemMsgModel = [SystemMsgModel mj_objectWithKeyValues:[responseObj objectForKey:@"data"]];
                [self.tableView beginUpdates];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            }
        }
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    } type:0];
}

//未读订单消息条数
- (void)unreadOrderMsgCount {
    
    NSDictionary *params = @{@"zid":account.id,@"ztoken":account.token};
    [KSMNetworkRequest postRequest:KUnreadOrderMsgCount params:params success:^(id responseObj) {
        [self.tableView.mj_header endRefreshing];
        FxLog(@"unreadOrderMsgCount = %@",responseObj);
        if (![responseObj isKindOfClass:[NSNull class]]) {
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
            NSString *count = [responseObj objectForKey:@"count"];
            orderCount = [count integerValue];
            if (orderCount > 0 || ![[responseObj objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                
                if (systemCount+orderCount+appointCount > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",systemCount+orderCount+appointCount]];
                    });
                }else {
                
                    [self.tabBarItem setBadgeValue:nil];
                }
                 orderMsgModel = [OrderMsgModel mj_objectWithKeyValues:[responseObj objectForKey:@"data"]];
                [self.tableView beginUpdates];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            }
        }
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    } type:0];
    
}

//未读预约消息条数
- (void)unreadAppointmentMsgCount {
    
    NSDictionary *params = @{@"zid":account.id,@"ztoken":account.token};
    [KSMNetworkRequest postRequest:KUnreadAppointmentMsgCount params:params success:^(id responseObj) {
        [self.tableView.mj_header endRefreshing];
        FxLog (@"unreadAppointmentMsgCount = %@",responseObj);
        if (![responseObj isKindOfClass:[NSNull class]]) {
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
            NSString *count = [responseObj objectForKey:@"count"];
            appointCount = [count integerValue];
            if (appointCount > 0 || ![[responseObj objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                
                if (systemCount+orderCount+appointCount > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",systemCount+orderCount+appointCount]];
                    });
                }else {
                
                    [self.tabBarItem setBadgeValue:nil];
                }
                
                appointmentMsgModel = [AppointmentMsgModel mj_objectWithKeyValues:[responseObj objectForKey:@"data"]];
                
                [self.tableView beginUpdates];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            }
        }
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    } type:0];
    
}

#pragma mark UITableViewDelegate &&Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NewsCell" owner:self options:nil] lastObject];
    }
    
    switch (indexPath.row) {
        case 0: //系统消息
            cell.logo.image = [UIImage imageNamed:@"icon_system_news_iphone"];
            cell.messageType.text = @"系统消息";
            
            if (systemCount > 0) {
                cell.countBtn.hidden = NO;
                [cell.countBtn setTitle:[NSString stringWithFormat:@"%ld",systemCount] forState:UIControlStateNormal];
            }
            if (systemMsgModel) {
                cell.messageContent.text = systemMsgModel.messageContent;
                cell.fromTime.text = systemMsgModel.messageTime;
            }
            
            break;
        case 1: //订单消息
            cell.logo.image = [UIImage imageNamed:@"icon_order_news_iphone"];
            cell.messageType.text = @"订单消息";
            
            if (orderCount > 0) {
                cell.countBtn.hidden = NO;
                [cell.countBtn setTitle:[NSString stringWithFormat:@"%ld",orderCount] forState:UIControlStateNormal];
            }
            if (orderMsgModel) {
                cell.messageContent.text = orderMsgModel.messageContent;
                cell.fromTime.text = orderMsgModel.messageTime;
            }
            
            break;
        case 2: //预约消息
            cell.logo.image = [UIImage imageNamed:@"icon_yuyue_iphone"];
            cell.messageType.text = @"预约消息";
            
            if (appointCount > 0) {
                cell.countBtn.hidden = NO;
                [cell.countBtn setTitle:[NSString stringWithFormat:@"%ld",appointCount] forState:UIControlStateNormal];
            }
            if (appointmentMsgModel) {
                cell.messageContent.text = appointmentMsgModel.messageContent;
                cell.fromTime.text = [[appointmentMsgModel.messageTime dateWithFormate:@"yyyy-MM-dd HH:mm:ss"] toTimeDescription];
            }
            
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsCell *cell = (NewsCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Know" bundle:nil];
    NewsDetailViewController *newsDetail = [storyboard instantiateViewControllerWithIdentifier:@"NewsDetailViewController"];
    newsDetail.title = cell.messageType.text;
    
    NSInteger badgeValue = [self.tabBarItem.badgeValue integerValue]-[cell.countBtn.currentTitle integerValue];
    
    if (badgeValue > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",badgeValue];
        });
    }else {
    
        self.tabBarItem.badgeValue = nil;
    }
    
    cell.countBtn.hidden = YES;
    [cell.countBtn setTitle:@"" forState:UIControlStateNormal];
    newsDetail.msgType = indexPath.row;
    [self.navigationController pushViewController:newsDetail animated:YES];
}


#pragma mark 推送刷新未读数
- (void)refreshSystem{
    
    [self unreadSystemMsgCount];
}

- (void)refreshOrder {
    
    [self unreadOrderMsgCount];
}

- (void)refreshAppoint {
    
    [self unreadAppointmentMsgCount];
}

@end
