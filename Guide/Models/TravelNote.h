//
//  TravelNote.h
//  Guide
//
//  Created by ksm on 16/4/15.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelNote : NSObject
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *zhiliaoId;
@property (nonatomic,strong)NSString *addTime;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *photoUrl;

@end
