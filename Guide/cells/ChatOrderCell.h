//
//  ChatOrderCell.h
//  Guide
//
//  Created by ksm on 16/6/13.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;
@property (weak, nonatomic) IBOutlet UILabel *appointTime;
@property (weak, nonatomic) IBOutlet UILabel *orderCode;
@property (weak, nonatomic) IBOutlet UILabel *price;
@end
