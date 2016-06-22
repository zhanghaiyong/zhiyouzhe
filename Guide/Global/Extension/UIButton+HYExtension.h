//
//  UIButton+XTExtension.h
//  XFilesPro
//
//  Created by 青秀斌 on 14-6-24.
//  Copyright (c) 2014年 深圳元度科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (HYExtension)

//为按钮添加点击事件
- (void)setAction:(void (^)(void))action;
- (void)setAction1:(void (^)(UIButton *button))action;
@end
