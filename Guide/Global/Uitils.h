//
//  Uitils.h
//  MouthHealth
//
//  Created by 张海勇 on 15/3/16.
//  Copyright (c) 2015年 张海勇. All rights reserved.
//

typedef void (^loadedImage)(UIImage* image);

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Uitils : NSObject

+ (void)shake:(UITextField *)label;

//+ (void)reach;

//照片压缩
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;


//获取AuthData
+ (id)getUserDefaultsForKey:(NSString *)key;

//保存AuthData
+ (void)setUserDefaultsObject:(id)value ForKey:(NSString *)key;

//删除NSUserdefault
+ (void)UserDefaultRemoveObjectForKey:(NSString *)key;

//图片缓存
+(void)cacheImage:(NSString *)imageName withImageV:(UIImageView *)imageV withPlaceholder:(NSString *)placehImg completed:(loadedImage)loaded;
+(void)cacheVisitorImage:(NSString *)imageName withImageV:(UIImageView *)imageV withPlaceholder:(NSString *)placehImg;

//给你一个方法，输入参数是NSDate，输出结果是星期几的字符串。
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

+ (NSString *)statusCode:(NSString *)codeStr;


@end

             