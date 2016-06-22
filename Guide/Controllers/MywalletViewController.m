//
//  WalletViewController.m
//  Guide
//
//  Created by ksm on 16/4/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "MywalletViewController.h"
#import "WithDrawView.h"
#import "IncomeDetailViewController.h"
@interface MywalletViewController ()

@property (nonatomic,strong)WithDrawView *withDraw;

@end

@interface MywalletViewController ()

@end

@implementation MywalletViewController

-(WithDrawView *)withDraw {

    if (_withDraw == nil) {
        WithDrawView *withDraw = [[[NSBundle mainBundle] loadNibNamed:@"WithDrawView" owner:self options:nil] lastObject];
        withDraw.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        withDraw.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.4];
        _withDraw = withDraw;
    }
    return _withDraw;
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.hidesBottomBarWhenPushed = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的钱包";
    [self setNavigationLeft:@"icon_back_iphone"];
    
    [self setNavigationRightTitle:@"收支明细"];
}


- (IBAction)showWithDrawView:(id)sender {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.withDraw];
}


- (void)doRight:(UIButton *)sender {

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Know" bundle:nil];
    IncomeDetailViewController *incomeDetail = [storyBoard instantiateViewControllerWithIdentifier:@"IncomeDetailViewController"];
    [self.navigationController pushViewController:incomeDetail animated:YES];
}

@end
