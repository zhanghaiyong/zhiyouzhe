//
//  SeverTimeCollectionViewCell.m
//  Guide
//
//  Created by ksm on 16/5/27.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "SeverTimeCell.h"

@implementation SeverTimeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
//        _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
//        _itemImageView.clipsToBounds = YES;
//        _itemImageView.image = [UIImage imageNamed:@"pic_sights_deafuit_iphone"];
//        [self addSubview:_itemImageView];
//        
//        
//        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, _itemImageView.bottom, self.width, 30)];
//        _label.textAlignment = NSTextAlignmentCenter;
//        _label.font = [UIFont boldSystemFontOfSize:16];
//        _label.backgroundColor = [UIColor clearColor];
//        _label.textColor = lever1Color;
//        [self addSubview:_label];
        
        _sender = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [_sender setTitleColor:lever1Color forState:UIControlStateNormal];
        _sender.titleLabel.font = [UIFont systemFontOfSize:14];
        _sender.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_sender addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sender];
        _sender.selected = YES;
        
        _roleImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-17, self.height-17, 17, 17)];
//        _roleImage.hidden = YES;
        _roleImage.image = [UIImage imageNamed:@"icon_pitchon_iphone"];
        [self addSubview:_roleImage];
        
    }
    return self;
}

- (void)tapThisCell:(CallBlock)block {

    _callBack = block;
}



- (void)tap:(UIButton *)button {

    NSLog(@"%ld",button.tag);
    if (button.selected) {
        [_sender setTitleColor:lever3Color forState:UIControlStateNormal];
        button.selected = NO;
        _roleImage.hidden = YES;
        
    }else {
        [_sender setTitleColor:lever1Color forState:UIControlStateNormal];
        _roleImage.hidden = NO;
        button.selected = YES;
    }
    
    self.callBack(self);
}

@end
