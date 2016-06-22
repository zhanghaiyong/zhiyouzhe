//
//  ChatAppointmentOrder.m
//  Guide
//
//  Created by ksm on 16/6/6.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "ChatAppointmentOrder.h"

@implementation ChatAppointmentOrder
{

    UIButton *appointmnt;
    UIButton *chat;
    UIView   *lineView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
        self.backgroundColor = backgroudColor;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {

    appointmnt = [[UIButton alloc]initWithFrame:CGRectZero];
    [appointmnt setTitleColor:lever1Color forState:UIControlStateNormal];
    [appointmnt setTitle:@"预约订单" forState:UIControlStateNormal];
    appointmnt.tag = 100;
    appointmnt.backgroundColor = [UIColor whiteColor];
    [appointmnt addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    appointmnt.titleLabel.font = lever2Font;
    [self addSubview:appointmnt];
    
    chat = [[UIButton alloc]initWithFrame:CGRectZero];
    [chat setTitleColor:lever2Color forState:UIControlStateNormal];
    chat.titleLabel.font = lever2Font;
    chat.tag = 200;
    chat.backgroundColor = [UIColor whiteColor];
    [chat setTitle:@"聊一聊" forState:UIControlStateNormal];
    [chat addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:chat];
    
    lineView  = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = MainColor;
    [self addSubview:lineView];
}

- (void)layoutSubviews {

    appointmnt.frame = CGRectMake(0, 0, (self.width-1)/2, self.height-1);
    chat.frame = CGRectMake(appointmnt.right+1, 0, (self.width-1)/2, self.height-1);
    
    lineView.frame = CGRectMake(appointmnt.width/2-30, self.height-8, 60, 2);
    
}

- (void)switchOrderType:(ChatAppointBlock)block {

    self.block = block;
}

- (void)buttonAction:(UIButton *)sender {

    [sender setTitleColor:lever1Color forState:UIControlStateNormal];
    NSInteger flag;
    if (sender.tag == 100) {
        [chat setTitleColor:lever2Color forState:UIControlStateNormal];
        flag = 1;
    }else {
        flag = 2;
        [appointmnt setTitleColor:lever2Color forState:UIControlStateNormal];
    }
    
    self.block(flag);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        lineView.center = CGPointMake(sender.center.x, lineView.center.y);
    }];
    
}

@end
