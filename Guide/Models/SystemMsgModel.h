//
//  SystemModel.h
//  Guide
//
//  Created by ksm on 16/6/8.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemMsgModel : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *messageTime;
@property (nonatomic,strong)NSString *messageContent;
@property (nonatomic,strong)NSString *zhiliaoId;
@property (nonatomic,strong)NSString *state;

@end
