//
//  CityItemViewController.h
//  Guide
//
//  Created by ksm on 16/4/13.
//  Copyright © 2016年 ksm. All rights reserved.
//

typedef void(^severCityBlock)(id model);

#import "BaseViewController.h"

@interface CityItemViewController : UIViewController

@property (nonatomic, copy) severCityBlock callBlock;

- (void)returnBindCity:(severCityBlock)block;

@end
