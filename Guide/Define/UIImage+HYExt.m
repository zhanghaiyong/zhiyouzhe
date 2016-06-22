//
//  UIImage+HYExt.m
//  Guide
//
//  Created by ksm on 16/6/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "UIImage+HYExt.h"

@implementation UIImage (HYExt)

+ (UIImage *)CompressorWidth:(CGFloat)width {

    UIImage *sourceImage = (UIImage *)self;
    //未压缩的大小
    CGFloat oW = sourceImage.size.width;
    CGFloat oH = sourceImage.size.height;
    
    //压缩后的高度
    CGFloat height = oH*width/oW;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    [sourceImage drawInRect:CGRectMake(0, 0, width, height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
   // 使当前的context出堆栈
     UIGraphicsEndImageContext();
   // 返回新的改变大小后的图片
    return scaledImage;
}

@end
