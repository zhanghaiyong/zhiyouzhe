//
//  UIView+Ext.h
//  HelpDemo
//
//  Created by ksm on 16/3/21.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);


CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (HYExt)

@property CGPoint origin;


@property CGSize size;


@property (readonly) CGPoint bottomLeft;

@property (readonly) CGPoint bottomRight;

@property (readonly) CGPoint topRight;


@property CGFloat height;

@property CGFloat width;


@property CGFloat top;

@property CGFloat left;


@property CGFloat bottom;

@property CGFloat right;



- (void) moveBy: (CGPoint) delta;

- (void) scaleBy: (CGFloat) scaleFactor;

- (void) fitInSize: (CGSize) aSize;



@end
