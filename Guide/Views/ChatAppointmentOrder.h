//
//  ChatAppointmentOrder.h
//  Guide
//
//  Created by ksm on 16/6/6.
//  Copyright © 2016年 ksm. All rights reserved.
//

typedef void(^ChatAppointBlock)(NSInteger flag);

#import <UIKit/UIKit.h>

@interface ChatAppointmentOrder : UIView

@property (nonatomic,copy)ChatAppointBlock block;

- (void)switchOrderType:(ChatAppointBlock)block;

@end
