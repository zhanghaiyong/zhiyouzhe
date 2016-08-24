//
//  AvatarViewController.m
//  Guide
//
//  Created by ksm on 16/8/18.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "AvatarViewController.h"
#import "TakePhotoViewController.h"
#import "PostImageTool.h"
#import "InfoParams.h"
@interface AvatarViewController ()
{

    NSString *avatarName;
    AccountModel *account;
}

@property (nonatomic,strong)InfoParams *params;
@end

@implementation AvatarViewController

-(InfoParams *)params {
    
    if (_params == nil) {
        
        InfoParams *params = [[InfoParams alloc]init];
        _params = params;
    }
    
    return _params;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    account = [AccountModel account];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"上传头像" forState:UIControlStateNormal];
    [saveBtn sizeToFit];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [saveBtn setTitleColor:lever1Color forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(postAvatar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    
}

- (void)postAvatar {

    TakePhotoViewController *TakePhone = [[TakePhotoViewController alloc]init];
    
    [TakePhone returnImage:^(UIImage *image) {
        
        self.BigAvatar.image = image;
        
        avatarName = [NSString stringWithFormat:@"%@%@",account.id,[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]]];
        [[PostImageTool shareTool]QiniuPostImage:image imageKey:avatarName Success:^{
            
            
            [[HUDConfig shareHUD] alwaysShow];
            
            //服务费用
            self.params.headiconUrl = avatarName;;
            
            NSLog(@"%@",self.params.mj_keyValues);
            
            [KSMNetworkRequest postRequest:KInfoEdit params:self.params.mj_keyValues success:^(id responseObj) {
                
                [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
                NSLog(@"%@",responseObj);
                
                if (![responseObj isKindOfClass:[NSNull class]]) {
                    
                    if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                        
                        NSDictionary *dic = [responseObj objectForKey:@"data"];
                        account.headiconUrl = [dic objectForKey:@"headiconUrl"];
                        [AccountModel saveAccount:account];
                        
                        //刷新融云用户头像
                        RCUserInfo *userInfo = [RCIM sharedRCIM].currentUserInfo;
                        userInfo.userId = account.id;
                        userInfo.portraitUri = [NSString stringWithFormat:@"%@%@",KImageUrl,account.headiconUrl];
                        userInfo.name = account.nickname;
                        [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userInfo.userId];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                        self.block (image);
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                
                
            } failure:^(NSError *error) {
                
                [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
                
            } type:2];

            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self presentViewController:TakePhone animated:YES completion:nil];
}

- (void)returnAvatar:(avatarCVBlock)block {

    _block = block;
}

@end
