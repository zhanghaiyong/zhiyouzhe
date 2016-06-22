//
//  CostModel.h
//  Guide
//
//  Created by ksm on 16/6/6.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CostModel : NSObject<NSCoding>

@property (nonatomic,strong)NSArray *costArray;

+ (void)saveCost:(CostModel * __nonnull)cost;

+ (CostModel * __nonnull)cost;

@end
