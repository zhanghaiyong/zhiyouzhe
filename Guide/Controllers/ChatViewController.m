//
//  ChatViewController.m
//  RCIMDemo
//
//  Created by ksm on 16/3/4.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "ChatViewController.h"
#import "SDKKey.h"
#import "IQKeyboardManager.h"
@interface ChatViewController ()<RCIMReceiveMessageDelegate>

@end

@implementation ChatViewController

- (void)viewWillAppear:(BOOL)animated {

    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = YES;
    
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[RCIM sharedRCIM]setReceiveMessageDelegate:self];

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn sizeToFit];
    [leftBtn setImage:[UIImage imageNamed:@"icon_back_iphone"] forState:UIControlStateNormal];
    [leftBtn setAction:^{
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

    //设置工具栏的样式
    
    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER];

    //设置聊天背景色
//    self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];
    
    /**
     *  默认No,如果Yes, 当消息不在最下方时显示 右下角新消息数图标
     */
    self.enableNewComingMessageIcon = YES;
    
    //头像形状
    [self setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    
//    //设置聊天背景图
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"效果图1"]];
    
}



/**
 *  将要显示会话消息，可以修改RCMessageBaseCell的头像形状，添加自定定义的UI修饰，建议不要修改里面label 文字的大小，cell 大小是根据文字来计算的，如果修改大小可能造成cell 显示出现问题
 *
 *  @param cell      cell
 *  @param indexPath indexPath
 */
- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cellUserInfo = %@",cell.model.userInfo);
    
//    //设置文本字体颜色等等
//    if ([cell isMemberOfClass:[RCTextMessageCell class]]) {
//        
//        RCTextMessageCell *textCell = (RCTextMessageCell *)cell;
//        //可以修改cell的背景图
////        textCell.bubbleBackgroundView.image = [UIImage imageNamed:@"效果图1"];
//        UILabel *textLabel = (UILabel *)textCell.textLabel;
//        textLabel.textColor = [UIColor blueColor];
//        
//        
//    }

}


/*!
 点击Cell中的消息内容的回调
 
 @param model 消息Cell的数据模型
 
 @discussion SDK在此点击事件中，针对SDK中自带的图片、语音、位置等消息有默认的处理，如查看、播放等。
 您在重写此回调时，如果想保留SDK原有的功能，需要注意调用super。
 */

- (void)didTapMessageCell:(RCMessageModel *)model {

    NSLog(@"点击cell ＝ %@",model);
}


/*!
 点击Cell中URL的回调
 
 @param url   点击的URL
 @param model 消息Cell的数据模型
 */
- (void)didTapUrlInMessageCell:(NSString *)url
                         model:(RCMessageModel *)model {

    NSLog(@"点击url");
}

/*!
 点击Cell中电话号码的回调
 
 @param phoneNumber 点击的电话号码
 @param model       消息Cell的数据模型
 */
- (void)didTapPhoneNumberInMessageCell:(NSString *)phoneNumber
                                 model:(RCMessageModel *)model {

    NSLog(@"点击phone");
}

/*!
 点击Cell中头像的回调
 
 @param userId  点击头像对应的用户ID
 */
- (void)didTapCellPortrait:(NSString *)userId {

    NSLog(@"点击头像");
}

/*!
 长按Cell中头像的回调
 
 @param userId  头像对应的用户ID
 */
- (void)didLongPressCellPortrait:(NSString *)userId {

    NSLog(@"长按头像");
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)lef {
    
    NSLog(@"content = %@",message.content.mj_keyValues);
    
    if (message.conversationType == 6) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
             
        BOOL yes = [[RCIMClient sharedRCIMClient]removeConversation:self.conversationType targetId:self.targetId];
        if (yes) {
          BOOL isClear = [[RCIMClient sharedRCIMClient] clearMessages:self.conversationType targetId:self.targetId];
            
            if (isClear) {
                
                [[HUDConfig shareHUD]Tips:@"本次聊天已结束" delay:DELAY];
                [self.navigationController popViewControllerAnimated:YES];;
            }
        }
        NSLog(@"xoxoxo %@ ",message.content.mj_keyValues);
            
          });
    }
     
}


@end
