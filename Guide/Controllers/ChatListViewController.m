//
//  ChatListViewController.m
//  Guide
//
//  Created by ksm on 16/4/8.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "SDKKey.h"
#import "NoChatList.h"
#import "LoginViewController.h"
#import "JiPush.h"
@interface ChatListViewController ()<RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate>
{
    AccountModel *account;
}
@end

@implementation ChatListViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    NSInteger unreadCount =  [[RCIMClient sharedRCIMClient]getUnreadCount:@[@(ConversationType_PRIVATE)]];
    
    FxLog(@"unreadCount = %ld",unreadCount);
    
    if (unreadCount > 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",unreadCount];
            
         });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.tabBarItem.badgeValue = nil;
            
        });
    }
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.hidesBottomBarWhenPushed = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidDisappear:(BOOL)animated {

    [[HUDConfig shareHUD]dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"聊一聊";
    account = [AccountModel account];
    
     [[RCIM sharedRCIM]setReceiveMessageDelegate:self];
    
    self.conversationListTableView.separatorColor = [UIColor clearColor];
    //连接状态监听器
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    
    NoChatList *noChatList = [[[NSBundle mainBundle]loadNibNamed:@"NoChatList" owner:self options:nil] lastObject];
    noChatList.frame = self.conversationListTableView.frame;
    noChatList.label1.text = @"";
    noChatList.label2.text = @"暂无人找你聊天";
    self.emptyConversationView = noChatList;
    
    //当网络断开时，是否在Tabel View Header中显示网络连接不可用的提示。
    self.isShowNetworkIndicatorView = YES;
    
    //当连接状态变化SDK自动重连时，是否在NavigationBar中显示连接中的提示
    self.showConnectingStatusOnNavigatorBar = YES;
    
    //设置头像为圆形
    [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    
    //设置头像大小
    [self setConversationPortraitSize:CGSizeMake(60, 60)];
    
    //设置显示的会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];

    
    
    //禁止接受系统消息推送
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:6 targetId:account.id isBlocked:NO success:^(RCConversationNotificationStatus nStatus) {
        
    } error:^(RCErrorCode status) {
        
    }];
    
//    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn setTitle:@"知了介绍" forState:UIControlStateNormal];
//    [rightBtn sizeToFit];
//    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//    [rightBtn setTitleColor:lever1Color forState:UIControlStateNormal];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark RCIM
/**
 *  表格选中事件
 *
 *  @param conversationModelType 数据模型类型
 *  @param model                 数据模型
 *  @param indexPath             索引
 */
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    
    FxLog(@"%@ ",model);
    if (model.conversationType == ConversationType_PRIVATE){
    
        ChatViewController *chat = [[ChatViewController alloc]init];
        //会话类型
        chat.conversationType = model.conversationType;
        //会话id
        chat.targetId = model.targetId;
        chat.title = model.conversationTitle;
        [self.navigationController pushViewController:chat animated:YES];
    }
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
                             atIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = cell.model.lastestMessage.mj_keyValues;
    NSString *str = [[dic objectForKey:@"content"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([str isMobilphone] || [str isTelephone] || [str isEmail] ) {
        
        NSString * searchStr = str;
        NSString * regExpStr = @"[0-9]";
        NSString * replacement = @"*";
        // 创建 NSRegularExpression 对象,匹配 正则表达式
        NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:regExpStr options:NSRegularExpressionCaseInsensitive error:nil];                                                                  NSString *resultStr = searchStr;
        // 替换匹配的字符串为searchStr
        resultStr = [regExp stringByReplacingMatchesInString:searchStr options:NSMatchingReportProgress range:NSMakeRange(0, searchStr.length)withTemplate:replacement]; NSLog(@"nsearchStr = %@nresultStr = %@",searchStr,resultStr);
            UILabel *textLabel = [cell.contentView.subviews lastObject];
            textLabel.text = resultStr;
    }
}


- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    

}


- (void)didReceiveMessageNotification:(NSNotification *)notification {

    [super didReceiveMessageNotification:notification];
    
    NSInteger unreadCount =  [[RCIMClient sharedRCIMClient]getUnreadCount:@[@(ConversationType_PRIVATE)]];
    FxLog(@"unreadCount = %ld",unreadCount);
    if (unreadCount > 0) {    
        dispatch_async(dispatch_get_main_queue(), ^{
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",unreadCount];
        FxLog(@"unreadCount = %@",self.tabBarItem.badgeValue);
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.tabBarItem.badgeValue = nil;
        });
    }
}

- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)lef {
    
    NSLog(@"asfs = %@",message);
 
    if (message.conversationType == 6) {
        
        for (RCConversationModel *model in self.conversationListDataSource) {
            
            if ([model.targetId isEqualToString:message.targetId]) {
                BOOL yes = [[RCIMClient sharedRCIMClient]removeConversation:model.conversationType targetId:model.targetId];
                if (yes) {
                    
                    [[HUDConfig shareHUD]Tips:@"本次聊天已结束" delay:DELAY];
                    [[RCIMClient sharedRCIMClient] clearMessages:model.conversationType targetId:model.targetId];
                    [self refreshConversationTableViewIfNeeded];
                }
            }
        }
    }
}

/*!
 IMKit连接状态的的监听器
 
 @param status  SDK与融云服务器的连接状态
 
 @discussion 如果您设置了IMKit消息监听之后，当SDK与融云服务器的连接状态发生变化时，会回调此方法。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    
    switch (status) {
        case 0:
//            [[HUDConfig shareHUD] SuccessHUD:@"连接成功" delay:DELAY];
            [[HUDConfig shareHUD]dismiss];
            break;
        case 31011:
            [[HUDConfig shareHUD] Tips:@"与服务器的连接已断开" delay:DELAY];
            break;
        case 31004:
//            [[HUDConfig shareHUD] ErrorHUD:@"Token无效" delay:DELAY];
            [[HUDConfig shareHUD]dismiss];
            break;
        case 12:
//            [[HUDConfig shareHUD] Tips:@"已注销" delay:DELAY];
            [[HUDConfig shareHUD]dismiss];
            break;
        case 11:
//            [[HUDConfig shareHUD] ErrorHUD:@"连接失败或未连接" delay:DELAY];
            [[HUDConfig shareHUD]dismiss];
            break;
        case 10:
            [[HUDConfig shareHUD] LoadHUD:@"连接中..." delay:NSTimeIntervalSince1970];
            break;
        case 6:
        {

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"当前账号在其他设备登录,请重新登录" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [AccountModel deleteAccount];
                [Uitils UserDefaultRemoveObjectForKey:TOKEN];
                [[JiPush shareJpush] setAlias:@""];
                
                LoginViewController *loginController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
                [UIApplication sharedApplication].keyWindow.rootViewController = loginController;
                
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case 5:
            [[HUDConfig shareHUD] Tips:@"切换到 WIFI 网络" delay:DELAY];
            break;
        case 4:
            [[HUDConfig shareHUD] Tips:@"切换到 3G 或 4G 高速网络" delay:DELAY];
            break;
        case 3:
            [[HUDConfig shareHUD] Tips:@"切换到2G(GPRS、EDGE)低速网络" delay:DELAY];
            break;
        case 2:
            [[HUDConfig shareHUD] Tips:@"切换到飞行模式" delay:DELAY];
            break;
        case 1:
            [[HUDConfig shareHUD] Tips:@"当前设备网络不可用" delay:DELAY];
            break;
        default:
            break;
    }
}

@end
