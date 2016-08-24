//
//  UserLabelViewController.h
//  Guide
//
//  Created by ksm on 16/8/16.
//  Copyright © 2016年 ksm. All rights reserved.
//

typedef void(^UserLabelBlock)(NSString *context);

#import "BaseViewController.h"

@interface UserLabelViewController : BaseViewController

@property (nonatomic,copy)UserLabelBlock block;

- (void)returnSetValue:(UserLabelBlock)block;

@end
