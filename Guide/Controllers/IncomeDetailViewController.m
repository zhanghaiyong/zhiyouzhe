//
//  IncomeDetailViewController.m
//  Guide
//
//  Created by ksm on 16/4/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "IncomeDetailViewController.h"
#import "IncomeDetailCell.h"
@interface IncomeDetailViewController ()

@end

@implementation IncomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收支明细";
    [self setNavigationLeft:@"icon_back_iphone"];
}

#pragma mark UITableViewDelegate &&Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    IncomeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"IncomeDetailCell" owner:self options:nil] lastObject];
    }
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

@end
