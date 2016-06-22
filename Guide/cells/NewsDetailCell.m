//
//  NewsDetailCell.m
//  Guide
//
//  Created by ksm on 16/4/21.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "NewsDetailCell.h"

@implementation NewsDetailCell


- (void)cellAutoLayoutHeight:(NSString *)content {
    
    self.messageContent.preferredMaxLayoutWidth = CGRectGetWidth(self.messageContent.frame);
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc]initWithString:content];
    [strAtt addAttributes:@{NSForegroundColorAttributeName:lever1Color} range:NSMakeRange(0, strAtt.length-4)];
    [strAtt addAttributes:@{NSForegroundColorAttributeName:specialRed} range:NSMakeRange(strAtt.length-4, 4)];
    self.messageContent.attributedText = strAtt;
    
}

- (IBAction)refuseOrAgree:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSInteger flag;
    switch (button.tag) {
        case 100:  //拒绝
            
            flag = 1;
            
            break;
        case 101: //同意
            
            flag = 2;
            
            break;
            
        default:
            break;
    }
    
    self.callBlock(flag);
}

- (void)returnOption:(NewsDetailCellBlock)block {

    self.callBlock = block;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
