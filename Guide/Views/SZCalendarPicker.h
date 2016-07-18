//
//  SZCalendarPicker.h
//  SZCalendarPicker
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarModel.h"

@interface SZCalendarPicker : UIView<UICollectionViewDelegate , UICollectionViewDataSource>
@property (nonatomic , strong) NSDate *date;
@property (nonatomic , strong) NSDate *today;
@property (nonatomic , strong) NSArray *CalendarModels;
//原状态为不接单日
@property (nonatomic, copy) void(^noReceive)(NSString *dateString, BOOL isTap);

//原状态为可接单日
@property (nonatomic, copy) void(^receive)(NSString *dateString, BOOL isTap);


+ (instancetype)showOnView:(UIView *)view;
@end
