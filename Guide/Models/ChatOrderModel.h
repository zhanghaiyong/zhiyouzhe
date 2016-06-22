//
//  ChatOrderModel.h
//  Guide
//
//  Created by ksm on 16/6/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatOrderModel : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *orderCode;
@property (nonatomic,strong)NSString *orderMoney;
@property (nonatomic,strong)NSString *orderState;
@property (nonatomic,strong)NSString *orderTime;
@property (nonatomic,strong)NSString *paymentMethod;
@property (nonatomic,strong)NSString *vHeadiconUrl;
@property (nonatomic,strong)NSString *vNickname;
@property (nonatomic,strong)NSString *vPhone;
@property (nonatomic,strong)NSString *vSex;
@property (nonatomic,strong)NSString *visitorId;
@property (nonatomic,strong)NSString *zHeadiconUrl;
@property (nonatomic,strong)NSString *zNickname;
@property (nonatomic,strong)NSString *zPhone;
@property (nonatomic,strong)NSString *zServiceCity;
@property (nonatomic,strong)NSString *zSex;
@property (nonatomic,strong)NSString *zhiliaoId;

@end
