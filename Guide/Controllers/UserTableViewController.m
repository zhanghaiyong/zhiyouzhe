//
//  UserTableViewController.m
//  Guide
//
//  Created by ksm on 16/8/16.
//  Copyright © 2016年 ksm. All rights reserved.
//

#define SEX         (@"性别")
#define DEGREE      (@"最高学历")

#import "UserTableViewController.h"
#import "InfoParams.h"

@interface UserTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    AccountModel *account;
    NSMutableArray *dataSource;
}

@property (nonatomic,strong)InfoParams *params;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UserTableViewController

-(InfoParams *)params {
    
    if (_params == nil) {
        
        InfoParams *params = [[InfoParams alloc]init];
        _params = params;
    }
    
    return _params;
}

- (void)setUpData {

    if ([self.title isEqualToString:SEX]) {
        
        [dataSource addObject:@"男"];
        [dataSource addObject:@"女"];
    }else {
        
        [dataSource addObject:@"初中"];
        [dataSource addObject:@"高中"];
        [dataSource addObject:@"中专"];
        [dataSource addObject:@"大专"];
        [dataSource addObject:@"本科"];
        [dataSource addObject:@"研究生"];
        [dataSource addObject:@"硕士"];
        [dataSource addObject:@"博士"];
    }
    
//    [self.tableView reloadData];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    account = [AccountModel account];
    [self setNavigationLeft:@"icon_back_iphone"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    dataSource = [NSMutableArray array];
    [self setUpData];
    
}

#pragma mark UITableVIewDelegate &&UITableViewData
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSString *context = dataSource[indexPath.row];
    
    if ([self.title isEqualToString:SEX]) {
        
        if ([context isEqualToString:account.sex]) {
             cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }

    }else {
        
        if ([context isEqualToString:account.degree]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    cell.textLabel.text = context;
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *context = dataSource[indexPath.row];
    if ([self.title isEqualToString:SEX]) {
        
        self.params.sex = context;

    }else {
        
        self.params.degree = context;
    }
    
    NSLog(@"%@",self.params.mj_keyValues);
    
    [[HUDConfig shareHUD] alwaysShow];
    [KSMNetworkRequest postRequest:KInfoEdit params:self.params.mj_keyValues success:^(id responseObj) {
        [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
            
            NSDictionary *dic = [responseObj objectForKey:@"data"];
            
            if ([dic.allKeys containsObject:@"sex"]) {
                account.sex = [dic objectForKey:@"sex"];
            }
            if ([dic.allKeys containsObject:@"degree"]) {
                account.degree = [dic objectForKey:@"degree"];
            }

            [AccountModel saveAccount:account];
            self.block(context);
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
        [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
        
    } type:2];

}

- (void)returnSetValue:(UserTableBlock)block {

    _block = block;
}

@end
