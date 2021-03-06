//
//  PersonalViewController.m
//  Guide
//
//  Created by ksm on 16/4/8.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "PersonalViewController.h"
#import "LDXScore.h"
#import "KnowFirstRegisterVC.h"
#import "KnowThreeRegisterVC.h"
#import "KnowSecondRegisterVC.h"
#import "SeverTimeViewController.h"
#import "MywalletViewController.h"
@interface PersonalViewController (){

    AccountModel *account;
}

@property (weak, nonatomic) IBOutlet LDXScore *starRanting;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userNickName;
@property (weak, nonatomic) IBOutlet UIButton *userSex;
@property (weak, nonatomic) IBOutlet UILabel *identifierLabel;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"个人";
    
    

}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    account = [AccountModel account];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStatus) name:REFRESH_STATUS object:nil];
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    account = [AccountModel account];
    
    NSDictionary *params = @{@"zid":account.id,@"ztoken":account.token};
    [KSMNetworkRequest getRequest:KLevel params:params success:^(id responseObj) {
        
        FxLog(@"level = %@",responseObj);
        
        if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
            
            self.starRanting.show_star = [[responseObj objectForKey:@"data"] integerValue];
        }
        
    } failure:^(NSError *error) {
        
    } type:0];
    
    
    [Uitils cacheImage:account.headiconUrl withImageV:_userAvatar withPlaceholder:@"icon_head_default_iphone" completed:^(UIImage *image) {
    
        _userAvatar.layer.borderColor = MainColor.CGColor;
        _userAvatar.layer.borderWidth = 1;
        
    }];
    _userNickName.text = account.nickname.length>10?[account.nickname substringWithRange:NSMakeRange(0, 10)]:account.nickname;
    _userSex.selected = [account.sex isEqualToString:@"男"]? NO :YES;
    switch ([account.identificationState intValue]) {
        case 0:
            _identifierLabel.text = @"未认证";
            break;
        case 1:
            _identifierLabel.text = @"认证中";
            break;
        case 2:
            _identifierLabel.text = @"已认证";
            break;
        default:
            break;
    }
}

- (void)refreshStatus {

    switch ([account.identificationState intValue]) {
        case 0:
            _identifierLabel.text = @"未认证";
            break;
        case 1:
            _identifierLabel.text = @"认证中";
            break;
        case 2:
            _identifierLabel.text = @"已认证";
            break;
        default:
            break;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.hidesBottomBarWhenPushed = NO;
    
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return 5;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    
    if (indexPath.section == 0) {
        
        KnowFirstRegisterVC *knowFirst = [storyboard instantiateViewControllerWithIdentifier:@"KnowFirstRegisterVC"];
        knowFirst.isEdit = YES;
        [self.navigationController pushViewController:knowFirst animated:YES];
    }else {
    
        switch (indexPath.row) {
            case 0: {//认证
                
                if ([account.identificationState isEqualToString:@"1"]) {
                    [[HUDConfig shareHUD]Tips:@"认证审核中,请耐心等待" delay:DELAY];return;
                }
                if ([account.identificationState isEqualToString:@"2"]) {
                    [[HUDConfig shareHUD]Tips:@"您的认证已经通过" delay:DELAY];return;
                }
                KnowThreeRegisterVC *guideVC = [storyboard instantiateViewControllerWithIdentifier:@"KnowThreeRegisterVC"];
                guideVC.isEdit = YES;
                [self.navigationController pushViewController:guideVC animated:YES];
            }
                break;
            case 1: {//服务时间
                
                SeverTimeViewController *severTime = [[SeverTimeViewController alloc]init];
                [self.navigationController pushViewController:severTime animated:YES];
            }
                
                break;
            case 2: //钱包
            {
                if (![account.identificationState isEqualToString:@"2"]) {
                    [[HUDConfig shareHUD]Tips:@"未认证通过,暂无钱包信息" delay:DELAY];
                    return;
                }
                else {
                    UIStoryboard *storyboard1 = [UIStoryboard storyboardWithName:@"Know" bundle:nil];
                    MywalletViewController *knowSecond = [storyboard1 instantiateViewControllerWithIdentifier:@"MywalletViewController"];
                    
                    [self.navigationController pushViewController:knowSecond animated:YES];
                }
            }
                break;
            case 3: { //服务
                
                KnowSecondRegisterVC *knowSecond = [storyboard instantiateViewControllerWithIdentifier:@"KnowSecondRegisterVC"];
                knowSecond.isEdit = YES;
                [self.navigationController pushViewController:knowSecond animated:YES];
            }
                break;
            case 4: //评星
                
                break;
            case 5: //指南
                
                break;
            case 6: //游记
                
                break;
            case 7: //设置
                
                break;
                
            default:
                break;
        }
    }
}


@end
