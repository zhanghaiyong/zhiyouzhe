//
//  ScenicCell.m
//  Guide
//
//  Created by ksm on 16/4/11.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "ScenicCell.h"

@implementation ScenicCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
        _itemImageView.clipsToBounds = YES;
        _itemImageView.image = [UIImage imageNamed:@"pic_sights_deafuit_iphone"];
        [self addSubview:_itemImageView];
        
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, _itemImageView.bottom, self.width, 30)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont boldSystemFontOfSize:16];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = lever1Color;
        [self addSubview:_label];
    }
    return self;
}

@end
