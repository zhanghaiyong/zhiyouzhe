//
//  KnowSecondRegisterVC.m
//  Guide
//
//  Created by ksm on 16/4/8.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "KnowFirstRegisterVC.h"
#import "CityItemViewController.h"
#import "CityModel.h"
#import "BirthdayView.h"
#import "ZZPhotoController.h"
#import "TakePhotoViewController.h"
#import "DriverLicenseViewController.h"
#import "PostImageTool.h"
#import "InfoParams.h"
#import "KnowSecondRegisterVC.h"
#import "KnowThreeRegisterVC.h"
#import "PageInfo.h"
#import "CostModel.h"
@interface KnowFirstRegisterVC ()<UITextFieldDelegate,BirthdayViewDelegate>
{
    //当前选中的服务金额对应按钮
    UIButton *currentBtn;
    AccountModel *account;
    CostModel    *costs;
    //传过来的城市
    CityModel *cityModel;
    
    UIButton *saveBtn;
    NSString *imageName;
}

//第一个服务金额按钮
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
//下一步
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
//昵称
@property (weak, nonatomic) IBOutlet UITextField *nickLabel;
//性别
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
//大学
@property (weak, nonatomic) IBOutlet UITextField *collegeTF;
//年龄
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
//签名
@property (weak, nonatomic) IBOutlet UITextField *signLabel;
//城市
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
//带车服务
@property (weak, nonatomic) IBOutlet UILabel *driverLicenseLabel;

//选择生日
@property (nonatomic,strong)BirthdayView *birthdayView;

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

-(BirthdayView *)birthdayView {
    
    if (_birthdayView == nil) {
        
        BirthdayView *birthdayView = [[[NSBundle mainBundle] loadNibNamed:@"BirthdayView" owner:self options:nil] lastObject];
        birthdayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        birthdayView.delegate = self;
        _birthdayView = birthdayView;
    }
    
    return _birthdayView;
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
        saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn sizeToFit];
        saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        saveBtn.userInteractionEnabled = NO;
        [saveBtn setTitleColor:lever2Color forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
        self.navigationItem.rightBarButtonItem = item;
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn sizeToFit];
        [leftBtn setImage:[UIImage imageNamed:@"icon_back_iphone"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = leftItem;
        _nextButton.hidden = YES;
        
        //将已经上传过的数据展示到对应的字断
        imageName = account.headiconUrl;
        [Uitils cacheImage:account.headiconUrl withImageV:_avatar withPlaceholder:@"icon_head_default_iphone" completed:^(UIImage *image) {
            _avatar.layer.borderColor = MainColor.CGColor;
            _avatar.layer.borderWidth = 1;
        }];
        _nickLabel.text = account.nickname;
        _sexLabel.text  = account.sex;
        _ageLabel.text  = account.age;
        _collegeTF.text = account.college;
        _collegeTF.textAlignment = NSTextAlignmentRight;
        _signLabel.text = account.signature;
        _signLabel.textAlignment = NSTextAlignmentRight;
        _cityLabel.text = account.serviceCity;
        _driverLicenseLabel.text = [Uitils statusCode:account.serviceCarAuth];
        
        
    }else { //注册状态下
        self.title = @"完善资料(1/3)";
        [self.navigationItem setHidesBackButton:TRUE animated:NO];
        
    }
}

- (void)costList {

    
    [[HUDConfig shareHUD]alwaysShow];
    
    BaseParams *params = [[BaseParams alloc]init];
    [KSMNetworkRequest getRequest:KGetCostList params:params.mj_keyValues success:^(id responseObj) {
        
        [[HUDConfig shareHUD]dismiss];
        
        NSLog(@"costList ＝ %@",responseObj);
        if (![responseObj isKindOfClass:[NSNull class]]) {
            
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
            
            NSArray *array = [responseObj objectForKey:@"data"];
            costs = [[CostModel alloc]init];
            costs.costArray = array;
            [CostModel saveCost:costs];
            
            //存储最新的请求时间
            [Uitils setUserDefaultsObject:[NSDate date] ForKey:GETCOSTTIME];
            
            NSIndexPath *pathIndex = [NSIndexPath indexPathForRow:1 inSection:1];
            UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:pathIndex];
            
            for (int i = 0; i<6; i++) {
                UIButton *sender = (UIButton *)[cell viewWithTag:100+i];
                NSDictionary *dic = costs.costArray[i];
                NSLog(@"dic = %@",dic);
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
    
    saveBtn.userInteractionEnabled = YES;
    [saveBtn setTitleColor:lever1Color forState:UIControlStateNormal];
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    saveBtn.userInteractionEnabled = YES;
    [saveBtn setTitleColor:lever1Color forState:UIControlStateNormal];
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0: //头像
            {
                TakePhotoViewController *takePhotoVC = [[TakePhotoViewController alloc]init];
                [takePhotoVC returnImage:^(UIImage *image) {

                    _avatar.image = image;
                    imageName = [NSString stringWithFormat:@"%@%@",account.id,[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]]];
                    [[PostImageTool shareTool] QiniuPostImage:image imageKey:imageName Success:^{
                    } failure:^(NSError *error) {
                        
                    }];
                }];
                [self presentViewController:takePhotoVC animated:YES completion:nil];
                
            }
                break;
            case 2: //性别
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    _sexLabel.text = @"男";
                    
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    _sexLabel.text = @"女";
                    
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                }]];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
                break;
            case 3:  //年龄
                [[UIApplication sharedApplication].keyWindow addSubview:self.birthdayView];
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 2) {
    
        switch (indexPath.row) {
            case 0:  //选择服务城市
            {
                CityItemViewController *cityItemVC = [[CityItemViewController alloc]init];
                [cityItemVC returnBindCity:^(id model) {
                    cityModel = (CityModel *)model;
                    
                    _cityLabel.text = cityModel.cityName;
                }];
                
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:cityItemVC];
                [self presentViewController:navi animated:YES completion:nil];
            }
                break;
            case 1:
            {
                [[HUDConfig shareHUD] alwaysShow];
                //    所有字断不能为空
                if (_nickLabel.text.length == 0 ||
                    _sexLabel.text.length  == 0 ||
                    //            _eduLabel.text.length  == 0 ||
                    _sexLabel.text.length  == 0 ||
                    _signLabel.text.length == 0)  {
                    
                    [SVProgressHUD showErrorWithStatus:@"请完善资料"];
                    return;
                }
                
                if (_cityLabel.text.length == 0) {
                    
                    [SVProgressHUD showErrorWithStatus:@"请选择服务城市"];
                    return;
                    
                }
                
                //头像名
                self.params.headiconUrl = imageName;
                //昵称
                self.params.nickname = _nickLabel.text;
                //性别
                self.params.sex = _sexLabel.text;
                //学历
                self.params.college = _collegeTF.text;
                //年龄
                self.params.age = _ageLabel.text;
                //服务费用
                //    DECIMAL_DIG
                self.params.serviceCharge = [[costs.costArray[currentBtn.tag-100] objectForKey:@"price"] intValue];

                //签名
                self.params.signature = _signLabel.text;
                //服务城市id
                self.params.cityId = cityModel.id;
                //服务城市名称
                self.params.serviceCity = cityModel.cityName;
                
                NSLog(@"%@",self.params.mj_keyValues);
                if ([account.serviceCarAuth isEqualToString:@"1"]) {
                    [[HUDConfig shareHUD]Tips:@"带车服务认证中，请耐心等待" delay:DELAY];
                    return;
                }
                if ([account.serviceCarAuth isEqualToString:@"2"]) {
                    [[HUDConfig shareHUD]Tips:@"您已认证带车服务" delay:DELAY];
                    return;
                }
                [KSMNetworkRequest postRequest:KInfoEdit params:self.params.mj_keyValues success:^(id responseObj) {
                    
                    [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
                    NSLog(@"%@",responseObj);
                    
                    if (![responseObj isKindOfClass:[NSNull class]]) {
                        
                        if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                            
                            //认证驾照
                            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                            DriverLicenseViewController *driverLicense = [story instantiateViewControllerWithIdentifier:@"DriverLicenseViewController"];
                            [driverLicense returnCarStatus:^(NSString *model) {
                                
                                _driverLicenseLabel.text = model;
                                
                            }];
                            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:driverLicense];
                            [self presentViewController:navi animated:YES completion:nil];
                        }
                    }
                    
                    
                } failure:^(NSError *error) {
                    
                    [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
                    
                } type:2];
            }
                break;
            default:
                break;
        }
    }
}


#pragma mark BirthdayViewDelegate
- (void)selectedBirthday:(NSString *)birthdayString {

    _ageLabel.text = birthdayString;
    saveBtn.userInteractionEnabled = YES;
    [saveBtn setTitleColor:lever1Color forState:UIControlStateNormal];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    
    [_signLabel resignFirstResponder];
    [_nickLabel resignFirstResponder];
    [_collegeTF resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    saveBtn.userInteractionEnabled = YES;
    [saveBtn setTitleColor:lever1Color forState:UIControlStateNormal];
    return YES;
}

- (void)back{

    //通过保存按钮的交互来盘点是否修改了信息，提示信息，是直接退出，还是继续编辑
    if (saveBtn.userInteractionEnabled == YES) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"还未保存，是否退出" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"继续编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)saveAction {

    [self postData];
}

- (IBAction)nextAction:(id)sender {
    
    [self postData];
}

- (void)postData {
   
    
    [[HUDConfig shareHUD] alwaysShow];
//    所有字断不能为空
        if (_nickLabel.text.length == 0 ||
            _sexLabel.text.length  == 0 ||
//            _eduLabel.text.length  == 0 ||
            _sexLabel.text.length  == 0 ||
            _signLabel.text.length == 0)  {
    
            [SVProgressHUD showErrorWithStatus:@"请完善资料"];
            return;
        }
    
        if (_cityLabel.text.length == 0) {
    
            [SVProgressHUD showErrorWithStatus:@"请选择服务城市"];
            return;
    
        }
    
    //头像名
    self.params.headiconUrl = imageName;
    //昵称
    self.params.nickname = _nickLabel.text;
    //性别
    self.params.sex = _sexLabel.text;
    //学历
    self.params.college = _collegeTF.text;
    //年龄
    self.params.age = _ageLabel.text;
    //服务费用
//    DECIMAL_DIG
    self.params.serviceCharge = [[costs.costArray[currentBtn.tag-100] objectForKey:@"price"] intValue];
    //签名
    self.params.signature = _signLabel.text;
    //服务城市id
    self.params.cityId = cityModel.id;
    //服务城市名称
    self.params.serviceCity = cityModel.cityName;
    
    NSLog(@"%@",self.params.mj_keyValues);
    
    [KSMNetworkRequest postRequest:KInfoEdit params:self.params.mj_keyValues success:^(id responseObj) {
        
         [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
        NSLog(@"%@",responseObj);
        
        if (![responseObj isKindOfClass:[NSNull class]]) {
            
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                
                NSDictionary *dic = [responseObj objectForKey:@"data"];
                account.age = [dic objectForKey:@"age"];
                account.cityId = [dic objectForKey:@"cityId"];
                account.serviceCity = [dic objectForKey:@"serviceCity"];
                account.college = [dic objectForKey:@"college"];
                account.headiconUrl = [dic objectForKey:@"headiconUrl"];
                account.nickname = [dic objectForKey:@"nickname"];
                account.serviceCharge = [dic objectForKey:@"serviceCharge"];
                NSLog(@"1 is%@ 2is%@",account.serviceCharge,[dic objectForKey:@"serviceCharge"]);
                account.sex = [dic objectForKey:@"sex"];
                account.signature = [dic objectForKey:@"signature"];
                
                [AccountModel saveAccount:account];
                //编辑状态
                if (_isEdit) {
                    
                    RCUserInfo *userInfo = [RCIM sharedRCIM].currentUserInfo;
                    userInfo.userId = account.id;
                    userInfo.portraitUri = [NSString stringWithFormat:@"%@%@",KImageUrl,account.headiconUrl];
                    userInfo.name = account.nickname;
                    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userInfo.userId];
                    [self.navigationController popViewControllerAnimated:YES];

                }else {
                    
                if (account.photoPaths.length == 0) {
    
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                    KnowSecondRegisterVC *KnowSecond = [story instantiateViewControllerWithIdentifier:@"KnowSecondRegisterVC"];
                    [self.navigationController pushViewController:KnowSecond animated:YES];
                    return;
                }
                
                //没有身份认证
                if (account.realName.length == 0) {
                    
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                    KnowThreeRegisterVC *KnowThree = [story instantiateViewControllerWithIdentifier:@"KnowThreeRegisterVC"];
                    [self.navigationController pushViewController:KnowThree animated:YES];
                    return;
                }
                
                UITabBarController *TabBar = [PageInfo pageControllers];
                [self presentViewController:TabBar animated:YES completion:nil];
                
                }
                
            }
        }
        
        
    } failure:^(NSError *error) {
        
        [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
        
    } type:2];
}


@end
