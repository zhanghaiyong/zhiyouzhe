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
{
    AccountModel *account;
    NSMutableArray *_dataArray;
}

@end

@implementation IncomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    account = [AccountModel account];
    
    self.title = @"收支明细";
    [self setNavigationLeft:@"icon_back_iphone"];
    
    _dataArray = [NSMutableArray array];
    
    [self getIncomeDetail];
}

#pragma mark UITableViewDelegate &&Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    IncomeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"IncomeDetailCell" owner:self options:nil] lastObject];
        [cell configCell:_dataArray[indexPath.row]];
    }
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

-(void) getIncomeDetail {
    [[HUDConfig shareHUD]alwaysShow];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [KSMNetworkRequest postRequest:KGetIncomeDetail params:@{@"zid":account.id,@"ztoken":account.token,@"walletId":[userDefaults objectForKey:@"WalletId"]} success:^(id responseObj) {
        
        [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
        
        BASE_INFO_FUN(responseObj);
        if (![responseObj isKindOfClass:[NSNull class]]) {
            
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                
                _dataArray = [responseObj objectForKey:@"data"];
                
                [self.tableView reloadData];
                
            }
        }
    } failure:^(NSError *error) {
        
        [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
        
    } type:0];
}
@end
