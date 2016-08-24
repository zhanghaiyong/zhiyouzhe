//
//  BirthdayViewController.h
//  Guide
//
//  Created by ksm on 16/8/16.
//  Copyright © 2016年 ksm. All rights reserved.
//

typedef void(^setAgeBlock)(NSString *context);

#import "BaseViewController.h"

@interface BirthdayViewController : BaseViewController

@property (nonatomic,copy)setAgeBlock block;

- (void)returnSetValue:(setAgeBlock)block;

@end
