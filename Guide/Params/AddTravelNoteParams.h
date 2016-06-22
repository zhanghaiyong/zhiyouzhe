//
//  AddTravelNoteParams.h
//  Guide
//
//  Created by ksm on 16/5/26.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "BaseParams.h"

@interface AddTravelNoteParams : NSObject

@property (nonatomic,strong)NSString *zid;
@property (nonatomic,strong)NSString *ztoken;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *photoUrl;

@end
