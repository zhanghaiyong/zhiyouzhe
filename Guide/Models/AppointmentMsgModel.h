//
//  AppointmentModel.h
//  Guide
//
//  Created by ksm on 16/6/7.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointmentMsgModel : NSObject

@property (nonatomic,strong)NSString *bookingTime;
@property (nonatomic,strong)NSString *bookingType;
@property (nonatomic,strong)NSString *fromTo;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *messageContent;
@property (nonatomic,strong)NSString *messageTime;
@property (nonatomic,strong)NSString *optionState;
@property (nonatomic,strong)NSString *readState;
@property (nonatomic,strong)NSString *remark;
@property (nonatomic,strong)NSString *visitorId;
@property (nonatomic,strong)NSString *zhiliaoId;

@end
