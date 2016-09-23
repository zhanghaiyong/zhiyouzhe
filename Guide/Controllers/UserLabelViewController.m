//
//  UserLabelViewController.m
//  Guide
//
//  Created by ksm on 16/8/16.
//  Copyright © 2016年 ksm. All rights reserved.
//

#define NICK    (@"昵称")
#define COLLEGE (@"就读学院")
#define WEIXIN  (@"微信")
#define QQ      (@"QQ")
#define EMAIL   (@"邮箱")
#define WORK_STATUS (@"我的职业")

#import "UserLabelViewController.h"
@interface UserLabelViewController ()<UITextFieldDelegate>
{
    UIButton *saveBtn;
    AccountModel *account;
}

@property (weak, nonatomic) IBOutlet UITextField *content;
@end

@implementation UserLabelViewController


- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self.content becomeFirstResponder];
    account = [AccountModel account];
    
    if ([self.title isEqualToString:NICK]) {
        
        self.content.text = account.nickname;
        
    }else if ([self.title isEqualToString:COLLEGE]) {
        
        self.content.text = account.college;
        
    }else if ([self.title isEqualToString:WEIXIN]) {
        
        self.content.text = account.weixin;
        
    }else if ([self.title isEqualToString:QQ]) {
        
        self.content.text = account.qq;
        
    }else if ([self.title isEqualToString:EMAIL]) {
        
        self.content.text = account.email;
    }else if ([self.title isEqualToString:WORK_STATUS]) {
    
        self.content.text = account.occupation;
    }
    
    [self setNavigationLeft:@"icon_back_iphone"];
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn sizeToFit];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    saveBtn.userInteractionEnabled = NO;
    [saveBtn setTitleColor:lever2Color forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.content addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    
    if ([string isEqualToString:@" "] || [string isEqualToString:@"\n"]) {
        return NO;
    }
    
    NSString *tempString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    saveBtn.userInteractionEnabled = YES;
    [saveBtn setTitleColor:lever1Color forState:UIControlStateNormal];
    
    if ([self.title isEqualToString:NICK]) {
        
        if (tempString.length > 10) {
            
            self.content.text = [self.content.text substringToIndex:10];
            [[HUDConfig shareHUD]Tips:@"昵称长度不能超过10" delay:DELAY];
            return NO;
        }
    }
    
    if ([self.title isEqualToString:EMAIL]) {
        
        if (tempString.length > 50) {
            self.content.text = [self.content.text substringToIndex:50];
            [[HUDConfig shareHUD]Tips:@"邮箱长度不能超过50" delay:DELAY];
            return NO;
        }
    }
    
    if ([self.title isEqualToString:WEIXIN] || [self.title isEqualToString:QQ] || [self.title isEqualToString:WORK_STATUS] || [self.title isEqualToString:COLLEGE]) {
        
        if (tempString.length > 15) {
            self.content.text = [self.content.text substringToIndex:15];
            [[HUDConfig shareHUD]Tips:@"长度不能超过15" delay:DELAY];
            return NO;
        }
    }

    return YES;
}


- (void)valueChanged:(UITextField *)textField {

    if ([self.title isEqualToString:NICK]) {
        
        if (textField.text.length > 10) {
            [[HUDConfig shareHUD]Tips:@"昵称长度不能超过10" delay:DELAY];
            self.content.text = [self.content.text substringToIndex:10];
        }
    }
    
    if ([self.title isEqualToString:EMAIL]) {
        if (textField.text.length > 50) {
            [[HUDConfig shareHUD]Tips:@"邮箱长度不能超过50" delay:DELAY];
            self.content.text = [self.content.text substringToIndex:50];
        }
    }
    
    if ([self.title isEqualToString:WEIXIN] || [self.title isEqualToString:QQ] || [self.title isEqualToString:WORK_STATUS] || [self.title isEqualToString:COLLEGE]) {
        if (textField.text.length > 15) {
            [[HUDConfig shareHUD]Tips:@"长度不能超过15" delay:DELAY];
            self.content.text = [self.content.text substringToIndex:15];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (saveBtn.userInteractionEnabled == YES) {

        [self postData];
    }
    
    return YES;
}

- (void)saveAction {

    if (saveBtn.userInteractionEnabled == YES) {
        
        [self postData];
    }
}

- (void)postData {

//    if ([self.title isEqualToString:NICK]) {
//        
//        self.params.nickname = self.content.text;
//        
//    }else if ([self.title isEqualToString:COLLEGE]) {
//        
//        self.params.college = self.content.text;
//        
//    }else if ([self.title isEqualToString:WEIXIN]) {
//        
//        self.params.weixin = self.content.text;
//        
//    }else if ([self.title isEqualToString:QQ]) {
//        
//        self.params.qq = self.content.text;
//        
//    }else if ([self.title isEqualToString:EMAIL]) {
    
    if (self.content.left == 0) {
        
        [[HUDConfig shareHUD]Tips:@"请填写信息" delay:DELAY];
        return;
    }
    
    if ([self.title isEqualToString:EMAIL]) {
        if (![self.content.text isEmail]) {
            
            [[HUDConfig shareHUD]Tips:@"请填写正确的邮箱" delay:DELAY];
            return;
        }
    }
//
//        self.params.email = self.content.text;
//    }else if ([self.title isEqualToString:WORK_STATUS]) {
//    
//        self.params.occupation = self.content.text;
//    }
    
//    NSLog(@"%@",self.params.mj_keyValues);
//    
//     [[HUDConfig shareHUD] alwaysShow];
//    [KSMNetworkRequest postRequest:KInfoEdit params:self.params.mj_keyValues success:^(id responseObj) {
//        [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
//        FxLog(@"%@",responseObj);
//        if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
//        
//            NSDictionary *dic = [responseObj objectForKey:@"data"];
//            
//            if ([dic.allKeys containsObject:@"nickname"]) {
//                account.nickname = [dic objectForKey:@"nickname"];
//            }
//            if ([dic.allKeys containsObject:@"college"]) {
//                account.college = [dic objectForKey:@"college"];
//            }
//            if ([dic.allKeys containsObject:@"weixin"]) {
//                account.weixin = [dic objectForKey:@"weixin"];
//            }
//            if ([dic.allKeys containsObject:@"qq"]) {
//                account.qq = [dic objectForKey:@"qq"];
//            }
//            if ([dic.allKeys containsObject:@"email"]) {
//                account.email = [dic objectForKey:@"email"];
//            }
//            if ([dic.allKeys containsObject:@"occupation"]) {
//                account.occupation = [dic objectForKey:@"occupation"];
//            }
//            
//            [AccountModel saveAccount:account];
            self.block(self.content.text);
            
            [self.navigationController popViewControllerAnimated:YES];
//        }
    
//    } failure:^(NSError *error) {
//        
//         [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
//        
//    } type:2];
}

- (void)returnSetValue:(UserLabelBlock)block {

    _block = block;
}

@end
