//
//  GuideController.m
//  GoodInCome
//
//  Created by 宋伟 on 15/3/11.
//  Copyright (c) 2015年 KMTeam. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()


@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initScrollView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)initScrollView{
    _contentScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    for (NSInteger i = 0; i < 5; i ++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(_contentScrollView.frame.size.width * i, 0, _contentScrollView.frame.size.width, _contentScrollView.frame.size.height)];
        [view setBackgroundColor:[UIColor clearColor]];
        view.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        [imageView setBackgroundColor:[UIColor whiteColor]];
        [imageView setImage:[UIImage imageNamed:[self getImageName:i]]];
        
        [view addSubview:imageView];
        if (i==4) {
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
            [view addGestureRecognizer:gesture];
            view.userInteractionEnabled = YES;
        }
//        [gesture setObject:@(i)];
        
        [_contentScrollView addSubview:view];
    }
    
    [_contentScrollView setContentSize:CGSizeMake(_contentScrollView.frame.size.width * 5, _contentScrollView.frame.size.height)];
    [_contentScrollView setBackgroundColor:[UIColor clearColor]];
    [_contentScrollView setPagingEnabled:YES];
    [_contentScrollView setBounces:NO];
    [_contentScrollView setShowsHorizontalScrollIndicator:NO];
    [_contentScrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_contentScrollView];
}

- (NSString *)getImageName:(NSInteger)index{
    NSArray *array = @[@"guide1",@"guide2",@"guide3",@"guide4",@"guide5"];
    return array[index];
}

- (void)gestureAction:(UIGestureRecognizer *)sender{
//    NSInteger i = [sender.object integerValue];
//    if (i != 3) {
//        [_contentScrollView scrollRectToVisible:CGRectMake(_contentScrollView.frame.size.width * (i + 1), 0, _contentScrollView.frame.size.width, _contentScrollView.frame.size.height) animated:YES];
//    }else{
        if([self.delegate respondsToSelector:@selector(guideViewControllerDisMiss:)]){
            [self.delegate guideViewControllerDisMiss:self];
        }
//    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation != UIInterfaceOrientationPortrait){
        return YES;
    }
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


-(BOOL)shouldAutorotate
{
    return YES;
}

@end
