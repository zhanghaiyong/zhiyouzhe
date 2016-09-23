//
//  OrderListViewController.m
//  Guide
//
//  Created by ksm on 16/4/8.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "OrderListViewController.h"
#import "orderCell.h"
#import "ChatOrderCell.h"
#import "OrderDetailViewController.h"
#import "AppointOrderModel.h"
#import "ChatAppointmentOrder.h"
#import "ChatOrderModel.h"
#import "NoChatList.h"
@interface OrderListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet ChatAppointmentOrder *switchView;
@property (nonatomic,strong)NSMutableArray *AppointOrderArr;
@property (nonatomic,strong)NSMutableArray *ChatOrderArr;
@property (nonatomic,strong)NoChatList *noOrderView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OrderListViewController
{

    AccountModel *account;
    //判断预约订单还是聊天
    NSInteger   appointOrChat;
}

//当列表没有数据时，显示的提示view
-(NoChatList *)noOrderView {

    if (_noOrderView == nil) {
        
        NoChatList *noOrderView = [[[NSBundle mainBundle]loadNibNamed:@"NoChatList" owner:self options:nil] lastObject];
        noOrderView.frame = CGRectMake(0, -100, SCREEN_WIDTH, SCREEN_HEIGHT);
        _noOrderView = noOrderView;
    }
    return _noOrderView;
}

//预约订单数据
-(NSMutableArray *)AppointOrderArr {

    if (_AppointOrderArr == nil) {
        
        NSMutableArray *AppointOrderArr = [NSMutableArray array];
        _AppointOrderArr = AppointOrderArr;
    }
    return _AppointOrderArr;
}

//聊天订单数据
-(NSMutableArray *)ChatOrderArr {
    
    if (_ChatOrderArr == nil) {
        
        NSMutableArray *ChatOrderArr = [NSMutableArray array];
        _ChatOrderArr = ChatOrderArr;
    }
    return _ChatOrderArr;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appointOrder) name:@"appointOrder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatOrder) name:@"chatOrder" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"订单";
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    //默认是预约订单
    appointOrChat = 1;
    //切换订单类型
    [self.switchView switchOrderType:^(NSInteger flag) {
        
        appointOrChat = flag;
        if (flag == 1) {

            [self appointOrder];

        }else {
            
            [self chatOrder];

        }
    }];
    
    account = [AccountModel account];
    
    [self appointOrder];
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        if (appointOrChat == 1) {
//
//            [self appointOrder];
//            
//        }else {
//            
//            [self chatOrder];
//        }
//    }];
//    [self.tableView.mj_header beginRefreshing];

}

//获取预约订单列表
- (void)appointOrder {

    
    [[HUDConfig shareHUD]alwaysShow];
    
    [self.AppointOrderArr removeAllObjects];
    
    NSDictionary *params = @{@"zid":account.id,@"ztoken":account.token};
    
    [KSMNetworkRequest getRequest:KAppointOrder params:params success:^(id responseObj) {
        
        [self.tableView.mj_header endRefreshing];
        
        FxLog(@"appointOrder = %@",responseObj);
        if (![responseObj isKindOfClass:[NSNull class]]) {

            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                
                NSArray *array = [responseObj objectForKey:@"data"];
                NSArray *modelArr = [AppointOrderModel mj_objectArrayWithKeyValuesArray:array];
                [self.AppointOrderArr addObjectsFromArray:modelArr];
                
                
            }
        }else {
        
            [[HUDConfig shareHUD]ErrorHUD:@"失败" delay:DELAY];
        }
        
        [self.tableView reloadData];
        
        [[HUDConfig shareHUD] dismiss];
        
    } failure:^(NSError *error) {
        
        [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
        [self.tableView.mj_header endRefreshing];
        
    } type:0];
    
}

//获取聊天订单列表
- (void)chatOrder {

    
    [[HUDConfig shareHUD]alwaysShow];
    [self.ChatOrderArr removeAllObjects];
    NSDictionary *params = @{@"zid":account.id,@"ztoken":account.token};
    
    [KSMNetworkRequest getRequest:KChatOrder params:params success:^(id responseObj) {
        [self.tableView.mj_header endRefreshing];
        
        
        FxLog(@"chatOrder = %@",responseObj);
        if (![responseObj isKindOfClass:[NSNull class]]) {
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
               
                NSArray *array = [responseObj objectForKey:@"data"];
                NSArray *modelArr = [ChatOrderModel mj_objectArrayWithKeyValuesArray:array];
                [self.ChatOrderArr addObjectsFromArray:modelArr];
            }

        }else {
        
            [[HUDConfig shareHUD]ErrorHUD:@"失败" delay:DELAY];
        }
        
        [self.tableView reloadData];
        
        [[HUDConfig shareHUD] dismiss];
        
    } failure:^(NSError *error) {
        
        [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
        [self.tableView.mj_header endRefreshing];
        
    } type:0];
}

#pragma mark UITableViewDelegate &&Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (appointOrChat == 1) {
        
        return self.AppointOrderArr.count;
        
    }else {
        
        return self.ChatOrderArr.count;;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (appointOrChat) {
        case 1:{
            orderCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"orderCell" owner:self options:nil] lastObject];
            
            AppointOrderModel *model = self.AppointOrderArr[indexPath.row];
            [Uitils cacheVisitorImage:model.vHeadiconUrl withImageV:cell.avatar withPlaceholder:@"icon_head_default_iphone"];
            cell.nickName.text = model.vNickname;
            cell.sexButton.selected = [model.vSex isEqualToString:@"男"]? NO :YES;
            cell.appointTime.text = [NSString stringWithFormat:@"预约时间：%@",model.orderTime];
            cell.orderStatus.text = [model.orderState toDescripte];
            
            if ([model.orderState integerValue] == 3) {
                
                cell.orderStatus.textColor = specialGreed;
                
            }else {
            
                cell.orderStatus.textColor = lever2Color;
            }
            
            return cell;
        }
            break;
        case 2:{
            ChatOrderCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"ChatOrderCell" owner:self options:nil] lastObject];
            
            ChatOrderModel *model = self.ChatOrderArr[indexPath.row];
            [Uitils cacheVisitorImage:model.vHeadiconUrl withImageV:cell.avatar withPlaceholder:@"icon_head_default_iphone"];
            cell.nickName.text = model.vNickname;
            cell.sexButton.selected = [model.vSex isEqualToString:@"男"]? NO :YES;
            cell.appointTime.text = [NSString stringWithFormat:@"预约时间：%@",model.orderTime];
            cell.orderCode.text = [NSString stringWithFormat:@"订单号：%@",model.orderCode];
            cell.price.text = [NSString stringWithFormat:@"收费：%@",model.orderMoney];
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (appointOrChat == 1) {
        return 80;
    }else {
        return 120;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (appointOrChat == 1) {
        
        AppointOrderModel *model = self.AppointOrderArr[indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Know" bundle:nil];
        OrderDetailViewController *orderDetail = [storyboard instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
        orderDetail.orderCode = model.id;
        [self.navigationController pushViewController:orderDetail animated:YES];
    }

}

- (void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
}

@end
