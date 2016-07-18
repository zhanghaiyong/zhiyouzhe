//
//  IncomeDetailCell.m
//  Guide
//
//  Created by ksm on 16/4/21.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "IncomeDetailCell.h"

@implementation IncomeDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)configCell :(id)info{
    NSString *typeString = [info objectForKey:@"earningsType"];
    _methodLabel.text = [typeString isEqualToString:@"0"]?@"收入":@"提现";
    _moneyLabel.text = [NSString stringWithFormat:@"%.2f",[[info objectForKey:@"earningsMoney"] floatValue]];
    _timeLabel.text = [info objectForKey:@"earningsDate"];
    NSString *status = [info objectForKey:@"withdrawStatus"];
    if (![typeString isEqualToString:@"0"]) {
        _statusLabel.text = [status isEqualToString:@"0"]?@"未到账":@"已到账";
    }
    else {
        _statusLabel.text = nil;
    }
}
@end
