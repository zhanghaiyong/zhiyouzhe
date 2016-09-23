//
//  AppointOrderModel.h
//  Guide
//
//  Created by ksm on 16/6/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointOrderModel : NSObject
@property (nonnull,strong)NSString *id;
@property (nonnull,strong)NSString *orderCode;
@property (nonnull,strong)NSString *orderMoney;
@property (nonnull,strong)NSString *orderState;
@property (nonnull,strong)NSString *orderTime;
@property (nonnull,strong)NSString *paymentMethod;
@property (nonnull,strong)NSString *vHeadiconUrl;
@property (nonnull,strong)NSString *vNickname;
@property (nonnull,strong)NSString *vPhone;
@property (nonnull,strong)NSString *vSex;
@property (nonnull,strong)NSString *visitorId;
@property (nonnull,strong)NSString *zHeadiconUrl;
@property (nonnull,strong)NSString *zNickname;
@property (nonnull,strong)NSString *zPhone;
@property (nonnull,strong)NSString *zServiceCity;
@property (nonnull,strong)NSString *zSex;
@property (nonnull,strong)NSString *zhiliaoId;
@property (nonnull,strong)NSString *orderGrade;
@end
