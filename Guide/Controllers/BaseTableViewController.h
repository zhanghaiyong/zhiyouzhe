//
//  BaseTableViewController.h
//  Guide
//
//  Created by ksm on 16/4/8.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController

- (void)setNavigationTitleImage:(NSString *)imageName;
- (void)setNavigationLeft:(NSString *)imageName;
- (void)setNavigationRight:(NSString *)imageName;
- (void)doBack:(UIButton *)sender;
- (void)doRight:(UIButton *)sender;
- (void)setNavigationRightTitle:(NSString *)title;
- (void)setNavigationLeftTitle:(NSString *)title;

@end
