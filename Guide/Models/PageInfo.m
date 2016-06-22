//
//  GuidePageInfo.m
//  Guide
//
//  Created by ksm on 16/4/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "PageInfo.h"
#import "RootTabBarController.h"

@implementation PageInfo

+ (UITabBarController *)pageControllers {

    NSMutableArray *controllers = [NSMutableArray array];
    NSArray *pages = [self pages];
    UIViewController *pageController = nil;
    UINavigationController *navPage = nil;
    
    UIStoryboard *loginStoryB = [UIStoryboard storyboardWithName:@"Know" bundle:nil];
    RootTabBarController *rootTabBar = [loginStoryB instantiateViewControllerWithIdentifier:@"RootTabBarController"];
    
    for (PageInfo *pageInfo in pages) {
        
        pageController = [loginStoryB instantiateViewControllerWithIdentifier:pageInfo.ClassName];
        navPage = [[UINavigationController alloc] initWithRootViewController:pageController];
        pageController.tabBarItem.image = [UIImage imageNamed:pageInfo.Image];
        pageController.tabBarItem.title = pageInfo.Title;
        pageController.tabBarItem.selectedImage = [UIImage imageNamed:pageInfo.SelectImage];
//        pageController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        [controllers addObject:navPage];
    }
    
    rootTabBar.viewControllers = controllers;
    
    return rootTabBar;

    
}

+ (NSArray *)pages
{
    NSString *configFile = [[NSBundle mainBundle] pathForResource:@"KnowTabBar" ofType:@"plist"];
    NSArray *pageConfigs = [NSArray arrayWithContentsOfFile:configFile];
    NSMutableArray *pages = [[NSMutableArray alloc] init];
    
    if (pageConfigs.count <= 0) {
        BASE_ERROR_FUN(@"没有配置TabBarPages.plist");
    }
    
    for (NSDictionary *dict in pageConfigs) {
        PageInfo *info = [PageInfo mj_objectWithKeyValues:dict];
        [pages addObject:info];
    }
    
    return pages;
}

@end
