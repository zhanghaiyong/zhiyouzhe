//
//  RoleViewController.m
//  Guide
//
//  Created by ksm on 16/4/7.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "RoleViewController.h"
#import "KnowFirstRegisterVC.h"
#import "UpImgViewController.h"
#import "LabelViewController.h"
#import "RootTabBarController.h"
#import "KnowThreeRegisterVC.h"
#import "PageInfo.h"
#import "RongCloudTokenParams.h"
#import "SDKKey.h"
#import "JiPush.h"
@interface RoleViewController ()
{

    AccountModel *account;
}
@end

@implementation RoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    account = [AccountModel account];
    [[JiPush shareJpush]setAlias:account.id];
    
    self.title = @"选择身份";

}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    [[HUDConfig shareHUD]dismiss];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            
            [[HUDConfig shareHUD]alwaysShow];
            
            if ([Uitils getUserDefaultsForKey:TOKEN]) {
                
                [[SDKKey shareSDKKey] RCIMConnectWithToken:[Uitils getUserDefaultsForKey:TOKEN] success:^{
                    
                    [self intoFace];
                    
                } failure:^{
                    
                }];
                
            }else {
            
                RongCloudTokenParams *params = [[RongCloudTokenParams alloc]init];
                params.userId                = account.id;
                NSString *userName = account.nickname;
                if (userName.length ==0) {
                    userName =[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
                }
                else if (userName.length >10) {
                    userName = [userName substringWithRange:NSMakeRange(0, 10)];
                }
                
                NSString *avatarName;
                if (account.headiconUrl.length ==0) {
                    
                    avatarName = @"icon_head_default_iphonex";
                }
                else {
                    avatarName = account.headiconUrl;
                }
                
                params.userName              = userName;
                params.portraitUri           = avatarName;
    //            1zhengshi  2 ceshi   融云环境
                params.type = @"1";
                
                RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:account.id name:account.nickname portrait:[NSString stringWithFormat:@"%@%@",KImageUrl,account.headiconUrl]];
                [RCIM sharedRCIM].currentUserInfo = userInfo;
                FxLog(@"currentUserInfo = %@",userInfo);
                
                [KSMNetworkRequest getRequest:KGgetRongCloudToken params:params.mj_keyValues success:^(id responseObj) {
                
                    
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
                    [Uitils setUserDefaultsObject:[dic objectForKey:@"data"] ForKey:TOKEN];
                    FxLog(@"  dic = %@",dic);
                    [[SDKKey shareSDKKey] RCIMConnectWithToken:[dic objectForKey:@"data"] success:^{
                        
                        [self intoFace];
                        
                    } failure:^{
                        
                    }];
                    
                } failure:^(NSError *error) {

                    FxLog(@"sdfsd = %@",error.localizedDescription);
                    
                 } type:1];
                }
        }
            break;
            
        case 1:  {//导游

            [[HUDConfig shareHUD] Tips:@"敬请期待" delay:2];
        }
            
            break;
        default:
            break;
    }
}

- (void)intoFace {

    dispatch_async(dispatch_get_main_queue(), ^{
    //第一部分资料没有完善
    if (account.nickname.length == 0) {
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        KnowFirstRegisterVC *KnowFirst = [story instantiateViewControllerWithIdentifier:@"KnowFirstRegisterVC"];
        [self.navigationController pushViewController:KnowFirst animated:YES];
        return;
    }
    
    //没有身份认证
    if (account.realName.length == 0) {
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        KnowThreeRegisterVC *KnowThree = [story instantiateViewControllerWithIdentifier:@"KnowThreeRegisterVC"];
        [self.navigationController pushViewController:KnowThree animated:YES];
        return;
    }
    
    //没有上传6张以上照片
    if (account.photoPaths.length == 0) {
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UpImgViewController *KnowSecond = [story instantiateViewControllerWithIdentifier:@"UpImgViewController"];
        [self.navigationController pushViewController:KnowSecond animated:YES];
        return;
    }
    
    //没有上传6张以上照片
    if (account.selfdomLabel.length == 0) {
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LabelViewController *LabelView = [story instantiateViewControllerWithIdentifier:@"LabelViewController"];
        [self.navigationController pushViewController:LabelView animated:YES];
        return;
    }
    
    UITabBarController *TabBar = [PageInfo pageControllers];
        [self presentViewController:TabBar animated:YES completion:nil];
    });
}


@end
