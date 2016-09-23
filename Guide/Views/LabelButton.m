//
//  LabelButton.m
//  Guide
//
//  Created by ksm on 16/8/18.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "LabelButton.h"

@implementation LabelButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = MainColor;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        
        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        xButton.frame = CGRectMake(self.width-2.5, -2.5, 5, 5);
        [xButton setImage:[UIImage imageNamed:@"CLOSE-拷贝-4"] forState:UIControlStateNormal];
        [xButton addTarget:self action:@selector(colseLabel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:xButton];
    }
    return self;
}

- (void)colseLabel {
    
    FxLog(@"sfdfxgfhfg");
}

@end
