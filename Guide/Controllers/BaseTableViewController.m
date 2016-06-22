//
//  BaseTableViewController.m
//  Guide
//
//  Created by ksm on 16/4/8.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController
{
    
    UIImageView *navBarHairlineImageView;
}
- (void)dealloc {
    
    BASE_INFO_FUN(@"未发生内存泄漏");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
     navBarHairlineImageView.hidden = YES;
}

//在页面消失的时候就让出现
-(void)viewWillDisappear:(BOOL)animated
{
    navBarHairlineImageView.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = backgroudColor;
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


- (void)setNavigationTitleImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    self.navigationItem.titleView = imageView;
}

- (UIButton *)customButton:(NSString *)imageName
                  selector:(SEL)sel
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn sizeToFit];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)setNavigationLeft:(NSString *)imageName
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[self customButton:imageName selector:@selector(doBack:)]];
    
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setNavigationRight:(NSString *)imageName
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[self customButton:imageName selector:@selector(doRight:)]];
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setNavigationRightTitle:(NSString *)title {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn setTitleColor:lever1Color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doRight:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setNavigationLeftTitle:(NSString *)title {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn setTitleColor:lever1Color forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
}


- (void)doRight:(UIButton *)sender
{
    
}

- (void)doBack:(UIButton *)sender
{
    [[HUDConfig shareHUD] dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
