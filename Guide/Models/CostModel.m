//
//  CostModel.m
//  Guide
//
//  Created by ksm on 16/6/6.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "CostModel.h"

@implementation CostModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder  encodeObject:_costArray forKey:@"costArray"];
//    [aCoder encodeObject:_price forKey:@"price"];
//    [aCoder encodeObject:_state forKey:@"state"];
}

//解的时候调用，告诉系统哪个属性要解档，如何解档
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        //一定要赋值
        _costArray = [aDecoder decodeObjectForKey:@"costArray"];
//        _price  = [aDecoder decodeObjectForKey:@"price"];
//        _state = [aDecoder decodeObjectForKey:@"state"];
    }
    return self;
}

+ (void)saveCost:(CostModel * __nonnull)cost {

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cost];
    //保存账号信息：数据存储一般我们开发中会搞一个业务类，专门处理数据的存储
    //好处：以后我不想归档，用数据库，直接改业务类
    [Uitils setUserDefaultsObject:data ForKey:Cost];
}

+ (CostModel * __nonnull)cost {
    
    NSData *data = [Uitils getUserDefaultsForKey:Cost];
    if (data) {
        CostModel *cost = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return cost;
    }else {
        
        return nil;
    }
}

@end
