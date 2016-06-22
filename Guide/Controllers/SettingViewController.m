//
//  SettingViewController.m
//  Guide
//
//  Created by ksm on 16/4/13.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "SettingViewController.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cacheCase;

@end

@implementation SettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    [self setNavigationLeft:@"icon_back_iphone"];
    
    NSInteger cacheSize = [SDWebImageManager.sharedManager.imageCache getSize];
    
    NSLog(@"cacheSize = %ld",(long)(long)cacheSize);
    
    if (cacheSize/(1024*1024*1024) > 0) {
        
        _cacheCase.text = [NSString stringWithFormat:@"%.1fGB",(float)cacheSize/(1024*1024*1024)];
        
    }else if(cacheSize/(1024*1024) > 0) {
        
        _cacheCase.text = [NSString stringWithFormat:@"%.1fMB",(float)cacheSize/(1024*1024)];
        
    }else if (cacheSize/(1024) > 0) {
        
        _cacheCase.text = [NSString stringWithFormat:@"%.1fKB",(float)cacheSize/1024];
        
    }else {
        
        _cacheCase.text = [NSString stringWithFormat:@"%.1fB",(float)cacheSize];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 0:{
            
            [SVProgressHUD showWithStatus:@"清除中..."];
            [SDWebImageManager.sharedManager.imageCache clearMemory];
            [SDWebImageManager.sharedManager.imageCache clearDiskOnCompletion:^{
                
                [SVProgressHUD showSuccessWithStatus:@"清除成功"];
                 _cacheCase.text = @"0.0B";
                
            }];
        }
            break;
        default:
            break;
    }
}
- (IBAction)logoutAction:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出当前用户" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        AccountModel *account = [AccountModel account];
//        
//        NSString *url = [NSString stringWithFormat:@"%@?%@",KLogout,account.id];
//        
//        [KSMNetworkRequest postRequest:url params:nil success:^(id responseObj) {
//            
//            NSLog(@"%@",responseObj);
//            
//        } failure:^(NSError *error) {
//            
//        } type:1];
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *login = [story instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [UIApplication sharedApplication].keyWindow.rootViewController = login;
        [AccountModel deleteAccount];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleDestructive handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end