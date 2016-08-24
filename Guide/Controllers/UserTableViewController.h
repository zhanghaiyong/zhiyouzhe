//
//  UserTableViewController.h
//  Guide
//
//  Created by ksm on 16/8/16.
//  Copyright © 2016年 ksm. All rights reserved.
//

typedef void(^UserTableBlock)(NSString *context);
#import "BaseViewController.h"

@interface UserTableViewController : BaseViewController

@property (nonatomic,copy)UserTableBlock block;

- (void)returnSetValue:(UserTableBlock)block;

@end
