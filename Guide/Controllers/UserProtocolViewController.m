//
//  UserProtocolViewController.m
//  Guide
//
//  Created by ksm on 16/6/3.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "UserProtocolViewController.h"

@interface UserProtocolViewController ()


@end

@implementation UserProtocolViewController

//- (void)viewDidAppear:(BOOL)animated{
//
//    [super viewDidAppear:animated];
//
//    self.hidesBottomBarWhenPushed = NO;
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    
//    [super viewWillDisappear:animated];
//    
//    self.hidesBottomBarWhenPushed = YES;
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationLeft:@"icon_back_iphone"];
    self.title = @"用户协议";

}

@end
