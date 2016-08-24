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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            
            RongCloudTokenParams *params = [[RongCloudTokenParams alloc]init];
            params.userId                = account.id;
//            NSString *string = account.nickname.length ==0 || account.nickname.length>10?@"111":[account.nickname substringWithRange:NSMakeRange(0, 10)];
            NSString *string = account.nickname;
            if (string.length ==0) {
                string =@"1111";
            }
            else if (string.length >10) {
                string = [string substringWithRange:NSMakeRange(0, 10)];
            }
            
            params.userName              = string;
            params.portraitUri           = [NSString stringWithFormat:@"%@%@",KImageUrl,account.headiconUrl];
            
            [[HUDConfig shareHUD] alwaysShow];
            
            RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:account.id name:account.nickname portrait:[NSString stringWithFormat:@"%@%@",KImageUrl,account.headiconUrl]];
            [RCIM sharedRCIM].currentUserInfo = userInfo;
            NSLog(@"currentUserInfo = %@",userInfo);
            
            [KSMNetworkRequest getRequest:KGgetRongCloudToken params:params.mj_keyValues success:^(id responseObj) {
            
                [[HUDConfig shareHUD] dismiss];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"  dic = %@",dic);
                [[SDKKey shareSDKKey] RCIMConnectWithToken:[dic objectForKey:@"data"]];
            
                
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
                    UpImgViewController *KnowSecond = [story instantiateViewControllerWithIdentifier:@"UpImgViewControlle"];
                    [self.navigationController pushViewController:KnowSecond animated:YES];
                    return;
                }
                
                //没有上传6张以上照片
                if (account.skillLabel.length == 0) {
                    
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                    LabelViewController *LabelView = [story instantiateViewControllerWithIdentifier:@"LabelViewController"];
                    [self.navigationController pushViewController:LabelView animated:YES];
                    return;
                }
                
                UITabBarController *TabBar = [PageInfo pageControllers];
                [self presentViewController:TabBar animated:YES completion:nil];
                
                
            } failure:^(NSError *error) {

                [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
                NSLog(@"sdfsd = %@",error.localizedDescription);
                
            } type:1];
            
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


@end
