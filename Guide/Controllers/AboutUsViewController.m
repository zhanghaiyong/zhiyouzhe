//
//  AboutUsViewController.m
//  Guide
//
//  Created by ksm on 16/6/3.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "AboutUsViewController.h"
#import "UserProtocolViewController.h"
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.hidesBottomBarWhenPushed = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationLeft:@"icon_back_iphone"];
    self.title = @"关于我们";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
        
            UIStoryboard *LoginSB = [UIStoryboard storyboardWithName:@"Know" bundle:nil];
            UserProtocolViewController *userProtocol = [LoginSB instantiateViewControllerWithIdentifier:@"UserProtocolViewController"];
            [self.navigationController pushViewController:userProtocol animated:YES];
        }
            break;
        case 1:
            
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
