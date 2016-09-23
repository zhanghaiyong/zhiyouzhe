//
//  KnowSecondRegisterVC.m
//  Guide
//
//  Created by ksm on 16/4/8.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "KnowFirstRegisterVC.h"
#import "CityItemViewController.h"
#import "UserLabelViewController.h"
#import "UserTableViewController.h"
#import "BirthdayViewController.h"
#import "CityModel.h"
#import "AvatarViewController.h"
#import "ZZPhotoController.h"
#import "TakePhotoViewController.h"
#import "DriverLicenseViewController.h"
#import "PostImageTool.h"
#import "InfoParams.h"
#import "KnowSecondRegisterVC.h"
#import "KnowThreeRegisterVC.h"
#import "PageInfo.h"
#import "CostModel.h"
#import "UpImgViewController.h"
@interface KnowFirstRegisterVC () {
    //当前选中的服务金额对应按钮
    UIButton *currentBtn;
    AccountModel *account;
    CostModel    *costs;
    //传过来的城市
    CityModel *cityModel;

    BOOL repeatInfo;
    
//    NSString *imageName;
}

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
/**
 *  昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
/**
 *  年龄
 */
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
/**
 *  性别
 */
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
/**
 *  所在地
 */
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
/**
 *  工作状态
 */
@property (weak, nonatomic) IBOutlet UILabel *workStatusLabel;
/**
 *  在读院校
 */
@property (weak, nonatomic) IBOutlet UILabel *collegeLabel;
/**
 *  学历
 */
@property (weak, nonatomic) IBOutlet UILabel *degreeLabel;
/**
 *  微信
 */
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;
/**
 *  QQ
 */
@property (weak, nonatomic) IBOutlet UILabel *QQLabel;
/**
 *  邮箱
 */
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
/**
 *  服务城市
 */
@property (weak, nonatomic) IBOutlet UILabel *severCity;
/**
 *  带车服务
 */
@property (weak, nonatomic) IBOutlet UILabel *carSeverLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

//第一个服务金额按钮
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;


@property (nonatomic,strong)InfoParams *params;
@end

@implementation KnowFirstRegisterVC

-(InfoParams *)params {
    
    if (_params == nil) {
        
        InfoParams *params = [[InfoParams alloc]init];
        _params = params;
    }
    
    return _params;
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.hidesBottomBarWhenPushed = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    account = [AccountModel account];
    currentBtn = _firstBtn;
    
    //查看是否过期
//    NSDate *date = [Uitils getUserDefaultsForKey:GETCOSTTIME];
//    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
//    // 过期了
//    if (interval > 60*60*24 || !date) {
        
        [self costList];
        
//    }else { //未过期
//    
//        costs = [CostModel cost];
//        
//        NSIndexPath *pathIndex = [NSIndexPath indexPathForRow:1 inSection:1];
//        UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:pathIndex];
//        
//        for (int i = 0; i<6; i++) {
//            
//            UIButton *sender    = (UIButton *)[cell viewWithTag:100+i];
//            NSDictionary *dic   = costs.costArray[i];
//            NSLog(@"dic         = %@",dic);
//            [sender setTitle:[[dic objectForKey:@"price"] stringByReplacingOccurrencesOfString:@".00" withString:@"元"] forState:UIControlStateNormal];
//            if ([[dic objectForKey:@"price"] isEqualToString:account.serviceCharge]) {
//
//            currentBtn.selected = NO;
//            currentBtn          = sender;
//            sender.selected     = YES;
//            }
//        }
//    }
    
    //编辑状态下
    if (self.isEdit) {
        
        self.title = @"个人资料";

        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn sizeToFit];
        [leftBtn setImage:[UIImage imageNamed:@"icon_back_iphone"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = leftItem;
//        _nextButton.hidden = YES;
        
//        //将已经上传过的数据展示到对应的字断
        
        [Uitils cacheImage:account.headiconUrl withImageV:self.avatarImg withPlaceholder:@"icon_head_default_iphone" completed:^(UIImage *image) {
            self.avatarImg.layer.borderColor = MainColor.CGColor;
            self.avatarImg.layer.borderWidth = 1;
        }];
        
        self.nickLabel.text = account.nickname;
        self.ageLabel.text = account.age;
        self.sexLabel.text = account.sex;
        self.areaLabel.text = account.serviceCity;
        self.workStatusLabel.text = account.occupation;
        self.collegeLabel.text = account.college;
        self.degreeLabel.text = account.degree;
        self.weixinLabel.text = account.weixin;
        self.QQLabel.text = account.qq;
        self.emailLabel.text = account.email;
        self.severCity.text = account.serviceCity;
        self.carSeverLabel.text = [Uitils statusCode:account.serviceCarAuth];
        
    }else { //注册状态下
        self.title = @"身份认证";
        [self.navigationItem setHidesBackButton:TRUE animated:NO];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStatus) name:REFRESH_STATUS object:nil];
}

- (void)refreshStatus {
    
    account = [AccountModel account];
    self.carSeverLabel.text = [Uitils statusCode:account.serviceCarAuth];
}

- (void)costList {

    [[HUDConfig shareHUD]alwaysShow];
    
    BaseParams *params = [[BaseParams alloc]init];
    [KSMNetworkRequest getRequest:KGetCostList params:params.mj_keyValues success:^(id responseObj) {
        
        [[HUDConfig shareHUD]dismiss];
        
        FxLog(@"costList ＝ %@",responseObj);
        if (![responseObj isKindOfClass:[NSNull class]]) {
            
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
            
            NSArray *array = [responseObj objectForKey:@"data"];
            costs = [[CostModel alloc]init];
            costs.costArray = array;
            [CostModel saveCost:costs];
            
            //存储最新的请求时间
            [Uitils setUserDefaultsObject:[NSDate date] ForKey:GETCOSTTIME];
            
            NSIndexPath *pathIndex = [NSIndexPath indexPathForRow:1 inSection:3];
            UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:pathIndex];
            
            for (int i = 0; i<costs.costArray.count; i++) {
                
                UIButton *sender = (UIButton *)[cell viewWithTag:100+i];
                NSDictionary *dic = costs.costArray[i];
                FxLog(@"dic = %@",dic);
                [sender setTitle:[[dic objectForKey:@"price"] stringByReplacingOccurrencesOfString:@".00" withString:@"元"] forState:UIControlStateNormal];
                if ([[dic objectForKey:@"price"] intValue] == [account.serviceCharge intValue]) {
                    
                    currentBtn.selected = NO;
                    currentBtn = sender;
                    sender.selected = YES;
                }
            }
        }
        }
        
    } failure:^(NSError *error) {
         [[HUDConfig shareHUD]dismiss];
    } type:0];
    
}

- (IBAction)serveMonry:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if (currentBtn != button) {
        currentBtn.selected = NO;
        currentBtn = button;
        button.selected = YES;
    }
    
//    saveBtn.userInteractionEnabled = YES;
//    [saveBtn setTitleColor:lever1Color forState:UIControlStateNormal];
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    repeatInfo = YES;
    
    UITableViewCell *titleCell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *titleLabel = [titleCell.contentView viewWithTag:100];

    UILabel *contentLabel = [titleCell.contentView viewWithTag:101];
    
    switch (indexPath.section) {
        case 0:
                switch (indexPath.row) {
                    case 0: {
                     
                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                        AvatarViewController *avatarVC = [story instantiateViewControllerWithIdentifier:@"AvatarViewController"];
                        avatarVC.title = titleLabel.text;
                        avatarVC.imageStr = account.headiconUrl;
                        
                        [avatarVC returnAvatar:^(UIImage *avatar) {
                            
                            self.avatarImg.image = avatar;
                        }];
                        
                        [self.navigationController pushViewController:avatarVC animated:NO];
                    }
                        break;
                    case 1:{ //昵称
                        
                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                        UserLabelViewController *userLabel = [story instantiateViewControllerWithIdentifier:@"UserLabelViewController"];
                        userLabel.title = titleLabel.text;
                        [userLabel returnSetValue:^(NSString *context) {
                            
                            self.nickLabel.text = context;
                            contentLabel.text = context;
                        }];
                        
                        [self.navigationController pushViewController:userLabel animated:YES];
                    }
                        break;
                        
                    case 2:{ //年龄
                        
                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                        BirthdayViewController *setBirthday = [story instantiateViewControllerWithIdentifier:@"BirthdayViewController"];
                        [setBirthday returnSetValue:^(NSString *context) {
                            
                            self.ageLabel.text = context;
                            contentLabel.text = context;

                        }];
                        setBirthday.title = titleLabel.text;
                        [self.navigationController pushViewController:setBirthday animated:YES];
                    }
                        break;
                        
                    case 3:{ //性别
                        
                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                        UserTableViewController *userTable = [story instantiateViewControllerWithIdentifier:@"UserTableViewController"];
                        [userTable returnSetValue:^(NSString *context) {
                            
                            self.sexLabel.text = context;
                            contentLabel.text = context;
                            
                        }];
                        userTable.title = titleLabel.text;
                        [self.navigationController pushViewController:userTable animated:YES];
                    }
                        break;
                    case 4:  //所在地
                    {
                        CityItemViewController *area = [[CityItemViewController alloc]init];
                        [area returnBindCity:^(id model) {
                            cityModel = (CityModel *)model;
                            
                            self.areaLabel.text = cityModel.cityName;
                            contentLabel.text = cityModel.cityName;
                        }];
                        [self.navigationController pushViewController:area animated:YES];
                    }
                        break;
                        
                    default:
                        break;
                }

            break;
            
        case 1:
            
            if (indexPath.row == 2) {  // 最高学历

                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                UserTableViewController *userTable = [story instantiateViewControllerWithIdentifier:@"UserTableViewController"];
                [userTable returnSetValue:^(NSString *context) {
                    
                    self.degreeLabel.text = context;

                    contentLabel.text = context;
                    
                }];
                userTable.title = titleLabel.text;
                [self.navigationController pushViewController:userTable animated:YES];
                
            }else {   //在读院校  工作状态 －－
            
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                UserLabelViewController *userLabel = [story instantiateViewControllerWithIdentifier:@"UserLabelViewController"];
                userLabel.title = titleLabel.text;
                [userLabel returnSetValue:^(NSString *context) {
                    
                    if (indexPath.row == 0) {
                        
                        self.workStatusLabel.text = context;
                    }else {
                        
                        self.collegeLabel.text = context;
                    }
                    
                    contentLabel.text = context;
                }];
                
                [self.navigationController pushViewController:userLabel animated:YES];
            }
            break;
            
        case 2:{ //微信 qq 邮箱
            
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            UserLabelViewController *userLabel = [story instantiateViewControllerWithIdentifier:@"UserLabelViewController"];
            [userLabel returnSetValue:^(NSString *context) {
                
                switch (indexPath.row) {
                    case 0:
                        self.weixinLabel.text = context;
                        break;
                    case 1:
                        self.QQLabel.text = context;
                        break;
                    case 2:
                        self.emailLabel.text = context;
                        break;
                        
                    default:
                        break;
                }
                
                
                contentLabel.text = context;
            }];
            userLabel.title = titleLabel.text;
            [self.navigationController pushViewController:userLabel animated:YES];
        }
            
            break;
            
        case 3:
            
            if (indexPath.row == 2) {
                
                {
                    CityItemViewController *area = [[CityItemViewController alloc]init];
                    [area returnBindCity:^(id model) {
                        cityModel = (CityModel *)model;
                        
                        self.severCity.text = cityModel.cityName;
                        contentLabel.text = cityModel.cityName;
                    }];
                    [self.navigationController pushViewController:area animated:YES];
                }
            }else if (indexPath.row == 3) {
            
                //认证驾照
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                DriverLicenseViewController *driverLicense = [story instantiateViewControllerWithIdentifier:@"DriverLicenseViewController"];
                [driverLicense returnCarStatus:^(NSString *model) {

                    self.carSeverLabel.text = model;
                    contentLabel.text = model;

                }];
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:driverLicense];
                [self presentViewController:navi animated:YES completion:nil];
            }
            
            break;
           
        default:
            break;
    }

}


#pragma mark BirthdayViewDelegate
- (void)selectedBirthday:(NSString *)birthdayString {

    _ageLabel.text = birthdayString;

}

- (void)back{

//    //通过保存按钮的交互来盘点是否修改了信息，提示信息，是直接退出，还是继续编辑
//    if (saveBtn.userInteractionEnabled == YES) {
//        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"还未保存，是否退出" preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        }]];
//        [alert addAction:[UIAlertAction actionWithTitle:@"继续编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }]];
//        
//        [self presentViewController:alert animated:YES completion:nil];
//        
//    }else {
    
        [self.navigationController popViewControllerAnimated:YES];
//    }
}


- (IBAction)nextActionKInfoEdit:(id)sender {
    
    if (!repeatInfo) {
        
        if (_isEdit) {
            
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            UpImgViewController *UpImg = [story instantiateViewControllerWithIdentifier:@"UpImgViewController"];
            [self.navigationController pushViewController:UpImg animated:YES];
        }else {
        
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            KnowThreeRegisterVC *KnowThree = [story instantiateViewControllerWithIdentifier:@"KnowThreeRegisterVC"];
            KnowThree.isEdit = self.isEdit;
            [self.navigationController pushViewController:KnowThree animated:YES];
        }
    }
    
    else {
        
        [self postData];
    }
}


- (void)postData {
   
    
    [[HUDConfig shareHUD] alwaysShow];
    //所有字断不能为空
        if (self.avatarImg.image == nil ||
            self.nickLabel.text.length == 0 ||
            self.ageLabel.text.length  == 0 ||
            self.sexLabel.text.length  == 0 ||
            self.areaLabel.text.length  == 0 ||
            self.workStatusLabel.text.length == 0 ||
            self.collegeLabel.text.length  == 0 ||
            self.degreeLabel.text.length  == 0 ||
            self.weixinLabel.text.length  == 0 ||
            self.QQLabel.text.length  == 0 ||
            self.emailLabel.text.length  == 0 ||
            self.severCity.text.length  == 0)  {
    
            [SVProgressHUD showErrorWithStatus:@"请完善资料"];
            return;
        }
    self.params.nickname = self.nickLabel.text;
    self.params.age = self.ageLabel.text;
    self.params.sex = self.sexLabel.text;
    self.params.serviceCity = cityModel.cityName;
    self.params.cityId = cityModel.id;
    self.params.occupation = self.workStatusLabel.text;
    self.params.college = self.collegeLabel.text;
    self.params.degree =  self.degreeLabel.text;
    self.params.weixin = self.weixinLabel.text;
    self.params.qq = self.QQLabel.text;
    self.params.email = self.emailLabel.text;
    //服务费用
    self.params.serviceCharge = [NSString stringWithFormat:@"%ld",[[costs.costArray[currentBtn.tag-100] objectForKey:@"price"] integerValue]];

    FxLog(@"%@",self.params.mj_keyValues);
 
    [KSMNetworkRequest postRequest:KInfoEdit params:self.params.mj_keyValues success:^(id responseObj) {
        
        FxLog(@"%@",responseObj);
        
        if (![responseObj isKindOfClass:[NSNull class]]) {
            
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                
                [[HUDConfig shareHUD]Tips:@"成功" delay:DELAY];
                NSDictionary *dic = [responseObj objectForKey:@"data"];
                AccountModel *saveAccount = [AccountModel mj_objectWithKeyValues:dic];
                [AccountModel saveAccount:saveAccount];

                
//                if (!_isEdit) {
                
                    //没有身份认证
                    //                if (account.realName.length == 0) {
                    
                if (_isEdit) {
                    
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                    UpImgViewController *UpImg = [story instantiateViewControllerWithIdentifier:@"UpImgViewController"];
                    [self.navigationController pushViewController:UpImg animated:YES];
                }else {
                    
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                    KnowThreeRegisterVC *KnowThree = [story instantiateViewControllerWithIdentifier:@"KnowThreeRegisterVC"];
                    KnowThree.isEdit = self.isEdit;
                    [self.navigationController pushViewController:KnowThree animated:YES];
                }
            }else {
            
                [[HUDConfig shareHUD]Tips:@"失败" delay:DELAY];
            }
        }
        
        
    } failure:^(NSError *error) {
        
        [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
        
    } type:2];
}


@end
