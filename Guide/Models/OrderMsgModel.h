//
//  orderModel.h
//  Guide
//
//  Created by ksm on 16/6/3.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderMsgModel : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *messageTime;
@property (nonatomic,strong)NSString *messageContent;
@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,strong)NSString *zhiliaoId;
@property (nonatomic,strong)NSString *state;
@property (nonatomic,strong)NSString *messageType;

@end
