//
//  GuideViewController.h
//  QueenGroup
//
//  Created by sky on 15/9/2.
//  Copyright (c) 2015年 Chengdu Xiaofengche Technalagy. All rights reserved.
//

#import "BaseViewController.h"

@class GuideViewController;

@protocol GuideViewControllerDelegate <NSObject>

- (void)guideViewControllerDisMiss:(GuideViewController *)guideViewController;

@end

@interface GuideViewController : BaseViewController

@property (nonatomic, assign) id<GuideViewControllerDelegate> delegate;

@end
