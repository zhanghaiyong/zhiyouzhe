//
//  UIButton+XTExtension.m
//  XFilesPro
//
//  Created by 青秀斌 on 14-6-24.
//  Copyright (c) 2014年 深圳元度科技有限公司. All rights reserved.
//

#import "UIButton+HYExtension.h"
#import <objc/runtime.h>

@implementation UIButton (HYExtension)

- (void)setAction:(void (^)(void))action{
    objc_setAssociatedObject(self, "ButtonAction", action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(xtButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)xtButtonAction:(UIButton *)button{
    void (^action)(void) = objc_getAssociatedObject(self, "ButtonAction");
    if (action) {
        action();
    }
}

- (void)xtButtonAction1:(UIButton *)button{
    void (^action1)(UIButton *) = objc_getAssociatedObject(self, "ButtonAction1");
    if (action1) {
        action1(self);
    }
}

- (void)setAction1:(void (^)(UIButton *))action{
    objc_setAssociatedObject(self, "ButtonAction1", action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(xtButtonAction1:) forControlEvents:UIControlEventTouchUpInside];
}

@end
