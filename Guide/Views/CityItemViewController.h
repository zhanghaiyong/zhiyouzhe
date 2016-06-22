//
//  CityItemViewController.h
//  Guide
//
//  Created by ksm on 16/4/13.
//  Copyright © 2016年 ksm. All rights reserved.
//

typedef void(^CallBlock)(id model);

#import "BaseViewController.h"

@interface CityItemViewController : UIViewController

@property (nonatomic, copy) CallBlock callBlock;

- (void)returnBindCity:(CallBlock)block;

@end
