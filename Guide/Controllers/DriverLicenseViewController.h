//
//  DriverLicenseViewController.h
//  Guide
//
//  Created by ksm on 16/4/11.
//  Copyright © 2016年 ksm. All rights reserved.
//

typedef void(^CarBlock)(NSString *model);

#import "BaseViewController.h"

@interface DriverLicenseViewController : BaseTableViewController

@property (nonatomic,copy)CarBlock callBlock;

- (void)returnCarStatus:(CarBlock)block;

@end
