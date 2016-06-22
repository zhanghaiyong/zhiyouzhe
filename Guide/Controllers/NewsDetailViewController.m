//
//  NewsDetailViewController.m
//  Guide
//
//  Created by ksm on 16/4/21.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsDetailCell.h"
#import "AppointmentMsgModel.h"
#import "OrderMsgModel.h"
#import "SystemMsgModel.h"
#import "OrderDetailViewController.h"
#import "isAgreeAppointmentParams.h"

@interface NewsDetailViewController ()
{
    AccountModel *account;
}
@property (nonatomic,strong)NSMutableArray *messageArray;

@end

@implementation NewsDetailViewController

-(NSMutableArray *)messageArray {
    
    if (_messageArray == nil) {
        
        NSMutableArray *messageArray = [NSMutableArray array];
        _messageArray = messageArray;
    }
    return _messageArray;
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.hidesBottomBarWhenPushed = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationLeft:@"icon_back_iphone"];
    account = [AccountModel account];
    
    switch (self.msgType) {
        case 0:{//系统

            [self systemMsg];
        }
            break;
        case 1:{//订单
            [self orderMsg];
        }
            break;
        case 2: {//预约
            
            [self appointmentMsg];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark 消息体请求
- (void)systemMsg {
    
    [self.messageArray removeAllObjects];
    
    [[HUDConfig shareHUD]alwaysShow];
    
    NSDictionary *params = @{@"zid":account.id,@"ztoken":account.token};
    [KSMNetworkRequest postRequest:KAllSystemMsg params:params success:^(id responseObj) {
        
        NSLog(@"systemMsg = %@",responseObj);
        [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
        [self.tableView.mj_header endRefreshing];
        
        if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
            if (![[responseObj objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                NSArray *array = [responseObj objectForKey:@"data"];
                NSArray *arrayModel = [SystemMsgModel mj_objectArrayWithKeyValuesArray:array];
                [self.messageArray addObjectsFromArray:arrayModel];
                [self.tableView reloadData];
            }
        }
        
    } failure:^(NSError *error) {
        
        [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
        [self.tableView.mj_header endRefreshing];
        
    } type:0];
}

- (void)orderMsg {
    
    [self.messageArray removeAllObjects];
    
    [[HUDConfig shareHUD]alwaysShow];
    NSDictionary *params = @{@"zid":account.id,@"ztoken":account.token};
    [KSMNetworkRequest postRequest:KAllOrderMsg params:params success:^(id responseObj) {
        
        NSLog(@"orderMsg = %@",responseObj);
        [[HUDConfig shareHUD]dismiss];
        [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
        [self.tableView.mj_header endRefreshing];
        
        if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
            
            if (![[responseObj objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                NSArray *array = [responseObj objectForKey:@"data"];
                NSArray *arrayModel = [OrderMsgModel mj_objectArrayWithKeyValuesArray:array];
                [self.messageArray addObjectsFromArray:arrayModel];
                //刷新tableView
                [self.tableView reloadData];
            }
        }
        
    } failure:^(NSError *error) {
        
        [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
        [self.tableView.mj_header endRefreshing];
        
    } type:0];
}

- (void)appointmentMsg {
    
    [self.messageArray removeAllObjects];
    
    [[HUDConfig shareHUD]alwaysShow];
    NSDictionary *params = @{@"zid":account.id,@"ztoken":account.token};
    [KSMNetworkRequest postRequest:KAllAppointmentMsg params:params success:^(id responseObj) {
        
        NSLog(@"appointmentMsg = %@",responseObj);
        [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
        [self.tableView.mj_header endRefreshing];
        
        if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
            if (![[responseObj objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                NSArray *array = [responseObj objectForKey:@"data"];
                NSArray *arrayModel = [AppointmentMsgModel mj_objectArrayWithKeyValuesArray:array];
                [self.messageArray addObjectsFromArray:arrayModel];
                [self.tableView reloadData];
        }
        }
        
    } failure:^(NSError *error) {
        
        [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
        [self.tableView.mj_header endRefreshing];
        
    } type:0];
}

#pragma mark UITableViewDelegate &&Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"cell";
    NewsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NewsDetailCell" owner:self options:nil] lastObject];
    }
    cell.messageType.text = self.title;
    cell.tag = indexPath.row+100;
    
    switch (self.msgType) {
        case 0:{//系统
            cell.refuseHeight.constant = 1;
            cell.refuseButton.hidden = YES;
            cell.agreeHeight.constant = 1;
            cell.agreeButton.hidden = YES;
            cell.contentBottom.constant = 10;
            
            SystemMsgModel *model = self.messageArray[indexPath.row];
            cell.messageTime.text = [[model.messageTime dateWithFormate:@"yyyy-MM-dd HH:mm:ss"] toTimeDescription];
            cell.messageContent.text = model.messageContent;
        }
            break;
        case 1: {//订单
            cell.refuseHeight.constant = 1;
            cell.refuseButton.hidden = YES;
            cell.agreeHeight.constant = 1;
            cell.agreeButton.hidden = YES;
            cell.contentBottom.constant = 10;
            
            OrderMsgModel *model = self.messageArray[indexPath.row];
            cell.messageTime.text = [[model.messageTime dateWithFormate:@"yyyy-MM-dd HH:mm:ss"] toTimeDescription];;
            
            NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@  点击查看",model.messageContent]];
            [strAtt addAttributes:@{NSForegroundColorAttributeName:lever2Color} range:NSMakeRange(0, strAtt.length-4)];
            [strAtt addAttributes:@{NSForegroundColorAttributeName:specialRed} range:NSMakeRange(strAtt.length-4, 4)];
            cell.messageContent.attributedText = strAtt;
            
        }
            break;
        case 2: {//预约
            
            AppointmentMsgModel *model = self.messageArray[indexPath.row];
            cell.messageTime.text = [[model.messageTime dateWithFormate:@"yyyy-MM-dd HH:mm:ss"] toTimeDescription];
            cell.messageContent.text = model.messageContent;
            
            //处理同意与否
            [cell returnOption:^(NSInteger flag) {
                
                [self isAgreeAppointment:flag indexPath:indexPath];
            }];
            
            //本条消息是否已经处理了（未处理则显示“拒绝”和“同意”按钮）
            if ([model.optionState integerValue] != 0) {
                cell.refuseHeight.constant = 1;
                cell.refuseButton.hidden = YES;
                cell.agreeHeight.constant = 1;
                cell.agreeButton.hidden = YES;
                cell.contentBottom.constant = 10;
            }
        }
            break;
            
        default:
            break;
    }

    return cell;
}


- (void)isAgreeAppointment:(NSInteger)flag indexPath:(NSIndexPath *)indexPath {

    [[HUDConfig shareHUD]alwaysShow];
    AppointmentMsgModel *model = self.messageArray[indexPath.row];
    isAgreeAppointmentParams *params = [[isAgreeAppointmentParams alloc]init];
    params.zid = account.id;
    params.znickName = account.nickname;
    params.ztoken = account.token;
    params.vid = model.visitorId;
    params.messageId = model.id;
    params.optionState = [NSString stringWithFormat:@"%ld",flag];
    
    NSLog(@"mj_keyValues = %@",params.mj_keyValues);
    
    [KSMNetworkRequest postRequest:KDealAppointment params:params.mj_keyValues success:^(id responseObj) {
        [[HUDConfig shareHUD]dismiss];
        [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
        NSLog(@"deal appointment = %@",responseObj);
        
        if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
            [self.tableView beginUpdates];
            model.optionState = [NSString stringWithFormat:@"%ld",flag];
            [self.messageArray replaceObjectAtIndex:indexPath.row withObject:model];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
        
    } failure:^(NSError *error) {
        
        [[HUDConfig shareHUD]dismiss];
        
    } type:0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NewsDetailCell *cell = (NewsDetailCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    
    switch (self.msgType) {
        case 0:{//系统
            SystemMsgModel *model = self.messageArray[indexPath.row];
            [cell cellAutoLayoutHeight:model.messageContent];
        }
            break;
        case 1:{//订单
            
            OrderMsgModel *model = self.messageArray[indexPath.row];
            [cell cellAutoLayoutHeight:model.messageContent];
        }
            break;
        case 2: {//预约
            
            AppointmentMsgModel *model = self.messageArray[indexPath.row];
            [cell cellAutoLayoutHeight:model.messageContent];
        }
            break;
            
        default:
            break;
    }
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_msgType == 1) { //订单消息
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        OrderMsgModel *model = self.messageArray[indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Know" bundle:nil];
        OrderDetailViewController *orderDetail = [storyboard instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
        orderDetail.orderCode = model.orderId;
        [self.navigationController pushViewController:orderDetail animated:YES];
        
    }
}

@end
