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
#import "InfoParams.h"
@interface UserLabelViewController ()<UITextFieldDelegate>
{
    UIButton *saveBtn;
    AccountModel *account;
}

@property (nonatomic,strong)InfoParams *params;
@property (weak, nonatomic) IBOutlet UITextField *content;
@end

@implementation UserLabelViewController

-(InfoParams *)params {
    
    if (_params == nil) {
        
        InfoParams *params = [[InfoParams alloc]init];
        _params = params;
    }
    
    return _params;
}

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
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    saveBtn.userInteractionEnabled = YES;
    [saveBtn setTitleColor:lever1Color forState:UIControlStateNormal];
    return YES;
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

    if ([self.title isEqualToString:NICK]) {
        
        self.params.nickname = self.content.text;
        
    }else if ([self.title isEqualToString:COLLEGE]) {
        
        self.params.college = self.content.text;
        
    }else if ([self.title isEqualToString:WEIXIN]) {
        
        self.params.weixin = self.content.text;
        
    }else if ([self.title isEqualToString:QQ]) {
        
        self.params.qq = self.content.text;
        
    }else if ([self.title isEqualToString:EMAIL]) {
        
        self.params.email = self.content.text;
    }else if ([self.title isEqualToString:WORK_STATUS]) {
    
        self.params.occupation = self.content.text;
    }
    
    NSLog(@"%@",self.params.mj_keyValues);
    
     [[HUDConfig shareHUD] alwaysShow];
    [KSMNetworkRequest postRequest:KInfoEdit params:self.params.mj_keyValues success:^(id responseObj) {
        [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
        
            NSDictionary *dic = [responseObj objectForKey:@"data"];
            
            if ([dic.allKeys containsObject:@"nickname"]) {
                account.nickname = [dic objectForKey:@"nickname"];
            }
            if ([dic.allKeys containsObject:@"college"]) {
                account.college = [dic objectForKey:@"college"];
            }
            if ([dic.allKeys containsObject:@"weixin"]) {
                account.weixin = [dic objectForKey:@"weixin"];
            }
            if ([dic.allKeys containsObject:@"qq"]) {
                account.qq = [dic objectForKey:@"qq"];
            }
            if ([dic.allKeys containsObject:@"email"]) {
                account.email = [dic objectForKey:@"email"];
            }
            if ([dic.allKeys containsObject:@"occupation"]) {
                account.occupation = [dic objectForKey:@"occupation"];
            }
            
            [AccountModel saveAccount:account];
            self.block(self.content.text);
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
         [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
        
    } type:2];
}

- (void)returnSetValue:(UserLabelBlock)block {

    _block = block;
}

@end
