//
//  NewsDetailCell.h
//  Guide
//
//  Created by ksm on 16/4/21.
//  Copyright © 2016年 ksm. All rights reserved.
//

typedef void(^NewsDetailCellBlock)(NSInteger flag);

#import <UIKit/UIKit.h>

@interface NewsDetailCell : UITableViewCell

//消息类型
@property (weak, nonatomic) IBOutlet UILabel *messageType;
//消息时间
@property (weak, nonatomic) IBOutlet UILabel *messageTime;
//消息内容
@property (weak, nonatomic) IBOutlet UILabel *messageContent;
//拒绝按钮
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;
//同意按钮
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
//拒绝按钮的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refuseHeight;
//同意按钮的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *agreeHeight;
//内容距离下边距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBottom;

@property (nonatomic,copy)NewsDetailCellBlock callBlock;

- (void)returnOption:(NewsDetailCellBlock)block;

- (void)cellAutoLayoutHeight:(NSString *)content;

- (IBAction)refuseOrAgree:(id)sender;

@end
