//
//  ScenicHead.m
//  Guide
//
//  Created by ksm on 16/4/11.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "ScenicHead.h"

@implementation ScenicHead

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        

        _searchBar = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchBar.searchBar.placeholder = @"搜索其他景点";
        _searchBar.dimsBackgroundDuringPresentation = NO;
        
        _searchBar.hidesNavigationBarDuringPresentation = NO;
        
        _searchBar.searchBar.frame = CGRectMake(0, 0, self.width, 40.0);
        
        [self addSubview:_searchBar.searchBar];
    }
    return self;
}

@end
