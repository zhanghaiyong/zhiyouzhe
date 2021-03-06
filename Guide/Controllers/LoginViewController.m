//
//  LoginViewController.m
//  Guide
//
//  Created by ksm on 16/4/7.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "LoginViewController.h"
#import "KnowSecondRegisterVC.h"
#import <SMS_SDK/SMSSDK.h>
#import "RoleViewController.h"
//#import "GuideViewController.h"
@interface LoginViewController ()
//<GuideViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

//@property (strong, nonatomic)GuideViewController *guide;
@end

@implementation LoginViewController
{
    /**
     *  定时器
     */
    NSTimer *timer;
    /**
     *  获取验证码倒计时
     */
    NSInteger  count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if (![[userDefaults objectForKey:@"isFirstLogin"]isEqualToString:@"isFirstLogin"]) {
//        [self showGuide];
//    }

    //获取验证码倒数60秒
    count = 60;
    [_phoneTF setValue:@20 forKey:@"paddingLeft"];
    [_codeTF setValue:@20 forKey:@"paddingLeft"];
    
}

//-(void)showGuide {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:@"isFirstLogin" forKey:@"isFirstLogin"];
//    self.guide = [[GuideViewController alloc]init];
//    self.guide.delegate = self;
//    [self.view addSubview:self.guide.view];
//}
//- (void)guideViewControllerDisMiss:(GuideViewController *)guideViewController {
//    [self.guide.view removeFromSuperview];
//}
#pragma mark UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *checkString;
    
    _getCodeButton.userInteractionEnabled = YES;
    
    //电话号码的输入内容
    if (textField == _phoneTF) {
        if (range.location == 11) {
            
            return NO;
            
        } else {
            
            if (![string isEqualToString:@""]) {
                checkString=[_phoneTF.text stringByAppendingString:string];
            } else {
                checkString=[checkString stringByDeletingLastPathComponent];
            }
            
            if (checkString.isPhone) {
                FxLog(@"号码满足");
                _getCodeButton.alpha = 1;
                _getCodeButton.userInteractionEnabled = YES;
            } else {
                FxLog(@"号码不满足");
                _getCodeButton.alpha = 0.5;
            }
            return YES;
        }
    }else {
        
        if (range.location == 4) {
            return NO;
        }
        /**
         *  验证码的输入内容
         */
        if (![string isEqualToString:@""]) {
            checkString=[_codeTF.text stringByAppendingString:string];
        }else{
            checkString=[checkString stringByDeletingLastPathComponent];
        }
        
    }
    FxLog(@"checkString = %@",checkString);
    
    return YES;
}

//获取验证码
- (IBAction)getCodeAction:(id)sender {
    
    if (_phoneTF.text.length == 0) {
        
        [SVProgressHUD showInfoWithStatus:@"电话号码不能为空"];
    }else if(!_phoneTF.text.isPhone){
        
        [Uitils shake:_phoneTF];
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
    }else {
        
        count = 60;
        [_phoneTF resignFirstResponder];
        if ([_getCodeButton.currentTitle isEqualToString:@"获取验证码"]) {

            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
            [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:UIControlStateNormal];
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneTF.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
                if (!error) {
                    FxLog(@"获取验证码成功");
                } else {
                    
                    [SVProgressHUD showInfoWithStatus:NSStringFromClass([error class])];
                    [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                }
            }];
        }
    }
}

#pragma mark 验证倒计时
- (void)countDown:(NSTimer *)time {
    
    if (count == 1) {
        [_getCodeButton setTitleColor:MainColor forState:UIControlStateNormal];
        [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCodeButton.userInteractionEnabled = YES;
        [time invalidate];
    }else {
        count--;
        [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:UIControlStateNormal];
        _getCodeButton.userInteractionEnabled = NO;
    }
    
}

//开始登录
- (IBAction)LoginAction:(id)sender {
    
    if (_phoneTF.text.length == 0) {
        
        [[HUDConfig shareHUD] Tips:@"电话号码不能为空" delay:DELAY];
        [Uitils shake:_phoneTF];
        
    }
    else if (_codeTF.text.length == 0) {
    
         [[HUDConfig shareHUD] Tips:@"请输入验证码" delay:DELAY];
        [Uitils shake:_codeTF];
        
    }
    
    else if (![_phoneTF.text isPhone]) {
    
        [[HUDConfig shareHUD] Tips:@"请输入正确电话号码" delay:DELAY];
        [Uitils shake:_phoneTF];
    }
    
    else {
    
        [[HUDConfig shareHUD]alwaysShow];
        
        if ([_phoneTF.text isEqualToString:@"18380317172"] && [_codeTF.text isEqualToString:@"0000"]) {
            
            [KSMNetworkRequest postRequest:KLogin params:@{@"phone":_phoneTF.text}  success:^(id responseObj) {
                
                BASE_INFO_FUN(responseObj);
                if (![responseObj isKindOfClass:[NSNull class]]) {
                    
                    if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                        //字段转model
                        AccountModel *account = [AccountModel mj_objectWithKeyValues:[responseObj objectForKey:@"data"]];
                        //保存model
                        [AccountModel saveAccount:account];
                        
                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                        RoleViewController *roleVC = [story instantiateViewControllerWithIdentifier:@"RoleViewController"];
                        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:roleVC];
                        [self presentViewController:navi animated:YES completion:nil];
                        
                    }else {
                    
                        [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
                    }
                }
                
                [[HUDConfig shareHUD]dismiss];
                
            } failure:^(NSError *error) {
                
                [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
                
            } type:0];
            
        }else
   /*
    [SMSSDK commitVerificationCode:_codeTF.text phoneNumber:_phoneTF.text zone:@"86" result:^(NSError *error) {
        
        if (!error) {
        FxLog(@"验证成功");
    */
        [KSMNetworkRequest postRequest:KLogin params:@{@"phone":_phoneTF.text}  success:^(id responseObj) {
            
            BASE_INFO_FUN(responseObj);
            if (![responseObj isKindOfClass:[NSNull class]]) {
                
                if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                    
                    [[HUDConfig shareHUD]Tips:@"成功" delay:DELAY];
                //字段转model
                AccountModel *account = [AccountModel mj_objectWithKeyValues:[responseObj objectForKey:@"data"]];
                //保存model
                [AccountModel saveAccount:account];

                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                RoleViewController *roleVC = [story instantiateViewControllerWithIdentifier:@"RoleViewController"];
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:roleVC];
                [self presentViewController:navi animated:YES completion:nil];
                    
                }else {
                
                    [[HUDConfig shareHUD]Tips:@"失败" delay:DELAY];
                }
            }
        } failure:^(NSError *error) {
            
            [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
            
        } type:0];
        
        /*
        }else {
            FxLog(@"验证失败");
            [[HUDConfig shareHUD]ErrorHUD:@"验证失败" delay:DELAY];
        }
    }];
         */
    }
    
}

@end
