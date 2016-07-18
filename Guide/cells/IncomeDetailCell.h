//
//  IncomeDetailCell.h
//  Guide
//
//  Created by ksm on 16/4/21.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncomeDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *methodLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

//type 0 shouru  1 tixian

-(void)configCell :(id)info;
@end
