//
//  NewsCell.h
//  Guide
//
//  Created by ksm on 16/4/21.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *messageType;
@property (weak, nonatomic) IBOutlet UILabel *messageContent;
@property (weak, nonatomic) IBOutlet UILabel *fromTime;
@property (weak, nonatomic) IBOutlet UIButton *countBtn;
@end
