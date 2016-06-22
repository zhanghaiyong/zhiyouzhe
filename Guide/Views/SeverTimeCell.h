//
//  SeverTimeCollectionViewCell.h
//  Guide
//
//  Created by ksm on 16/5/27.
//  Copyright © 2016年 ksm. All rights reserved.
//


typedef void(^CallBlock)(id c);
#import <UIKit/UIKit.h>

@interface SeverTimeCell : UICollectionViewCell

@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)UIButton *sender;
@property (nonatomic,strong)UIImageView *roleImage;

@property (nonatomic,copy)CallBlock callBack;
- (void)tapThisCell:(CallBlock)block;
@end
