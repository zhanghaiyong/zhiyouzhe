//
//  OrderDetailViewController.h
//  Guide
//
//  Created by ksm on 16/4/20.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "BaseViewController.h"
#import "LDXScore.h"
@interface OrderDetailViewController : BaseViewController

@property (nonatomic,strong)NSString *orderCode;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;

@property (weak, nonatomic) IBOutlet LDXScore *scores;

@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@end
