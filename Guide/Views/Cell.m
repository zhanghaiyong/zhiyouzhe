//
//  Cell.m
//  CollectionView
//
//  Created by Li Hongjun on 13-5-23.
//  Copyright (c) 2013年 Li Hongjun. All rights reserved.
//

#import "Cell.h"

@implementation Cell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        _itemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _itemButton.titleLabel.font = lever2Font;
        _itemButton.userInteractionEnabled = NO;
        [_itemButton setTitleColor:lever1Color forState:UIControlStateNormal];
        [_itemButton setTitleColor:specialRed forState:UIControlStateSelected];
        [self addSubview:_itemButton];

    }
    return self;
}

@end
