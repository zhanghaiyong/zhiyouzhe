//
//  GuideSecondRegisterVC.m
//  Guide
//
//  Created by ksm on 16/4/7.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "KnowThreeRegisterVC.h"
#import "PageInfo.h"
#import "RootTabBarController.h"
#import "TakePhotoViewController.h"
#import "PostImageTool.h"
#import "InfoParams.h"
#import "UpImgViewController.h"
@interface KnowThreeRegisterVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *idcard;
@property (weak, nonatomic) IBOutlet UIImageView *frontImage;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (nonatomic,strong)InfoParams *params;
@end

@implementation KnowThreeRegisterVC
{

    //正面照片名字
    NSString *frontImageName;
    //反面照片名字
    NSString *backImageName;
    AccountModel *account;
    UIButton *rightBtn ;
    BOOL repeatInfo;
}

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
    
    if (self.isEdit) {
        self.title  = @"我的认证";
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        [rightBtn sizeToFit];
        rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];;
        //在没有修改信息的情况下，保存按钮不能使用
        rightBtn.userInteractionEnabled = NO;
        [rightBtn setTitleColor:lever2Color forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
        
    
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn sizeToFit];
        [leftBtn setImage:[UIImage imageNamed:@"icon_back_iphone"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = leftItem;
        
        //编辑状态下，隐藏”下一步“按钮
        self.finishButton.hidden = YES;
        
        //将原来的数据填充到对应的字断
        self.nameLabel.text = account.realName;
        self.idcard.text = account.idcardNumber;
        
        if (account.idcardConsUrl) {
            
            self.frontImage.contentMode = UIViewContentModeScaleToFill;
        }else {
        
            self.frontImage.contentMode = UIViewContentModeCenter;
        }
        
        [Uitils cacheImage:account.idcardConsUrl withImageV:_frontImage withPlaceholder:@"bg_update_iphone" completed:^(UIImage *image) {
            frontImageName = account.idcardConsUrl;
        }];
        
        if (account.idcardProsUrl) {
            
            self.backImage.contentMode = UIViewContentModeScaleToFill;
        }else {
            
            self.backImage.contentMode = UIViewContentModeCenter;
        }
        [Uitils cacheImage:account.idcardProsUrl withImageV:_backImage withPlaceholder:@"bg_update_iphone" completed:^(UIImage *image) {
            
            backImageName = account.idcardProsUrl;
        }];
        
    }else { //注册状态下
        self.title = @"身份认证1";
       [self.navigationItem setHidesBackButton:TRUE animated:NO];
    }
    
        [self.nameLabel addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    
}

//编辑状态下的退出
- (void)back:(UIButton *)sender {
    
    //通过保存按钮的交互来盘点是否修改了信息，提示信息，是直接退出，还是继续编辑
    if (rightBtn.userInteractionEnabled == YES) {
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [_idcard resignFirstResponder];
    [_nameLabel resignFirstResponder];
    
    NSString *imageName = nil;
    
    if (indexPath.row == 2 || indexPath.row == 3) {
        
        switch (indexPath.row) {
            case 2:
                imageName = [NSString stringWithFormat:@"%@frontImageName",account.id];
                frontImageName = imageName;
                break;
            case 3:

                imageName = [NSString stringWithFormat:@"%@backImageName",account.id];
                backImageName = imageName;
                break;
                
            default:
                break;
        }
        //选择照片
        TakePhotoViewController *takePhotoVC = [[TakePhotoViewController alloc]init];
        [takePhotoVC returnImage:^(UIImage *image) {
            
            switch (indexPath.row) {
                case 2:
                    self.frontImage.contentMode = UIViewContentModeScaleToFill;
                    _frontImage.image = image;
                    break;
                case 3:
                    self.backImage.contentMode = UIViewContentModeScaleToFill;
                    _backImage.image = image;
                    break;
                default:
                    break;
            }
            //选择照片的同时，将保存按钮的交互打开
            rightBtn.userInteractionEnabled = YES;
            repeatInfo = YES;
            [rightBtn setTitleColor:lever1Color forState:UIControlStateNormal];
            
            //选择的照片上传七牛
            [[PostImageTool shareTool] QiniuPostImage:image imageKey:imageName Success:^{
                
                BASE_INFO_FUN(@"上传成功");
                
            } failure:^(NSError *error) {
                
                
            }];
        }];
        [self presentViewController:takePhotoVC animated:YES completion:nil];
    }
}

//编辑状态下的提交信息
- (void)saveAction {

    [self postDatatoServer];
}

//注册状态下的提交信息
- (IBAction)nextOrFinishAction:(id)sender {
    
    if (repeatInfo == YES) {
        
        [self postDatatoServer];
        
    }else {
    
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UpImgViewController *KnowThree = [story instantiateViewControllerWithIdentifier:@"UpImgViewController"];
        [self.navigationController pushViewController:KnowThree animated:YES];
    }

}

//信息提交
- (void)postDatatoServer {

    if (_nameLabel.text.length == 0 || _idcard.text.length == 0) {
        [[HUDConfig shareHUD] Tips:@"请填写身份证信息" delay:DELAY];
        return;
    }
    
    if (_frontImage.image == nil) {
        [[HUDConfig shareHUD] Tips:@"请上传身份证正面" delay:DELAY];
        return;
    }
    
    if (_backImage.image == nil) {
        [[HUDConfig shareHUD] Tips:@"请上传身份证反面" delay:DELAY];
        return;
    }
    
    if (![_idcard.text isIdCard]) {
        
        [[HUDConfig shareHUD] Tips:@"请上传正确的身份证号" delay:DELAY];
        return;
    }
    
    
    [[HUDConfig shareHUD] alwaysShow];
    
    self.params.idcardConsUrl = frontImageName;
    self.params.idcardProsUrl = backImageName;
    self.params.realName = self.nameLabel.text;
    self.params.idcardNumber = self.idcard.text;
    
    NSString *urlStr;
    
    if (_isEdit) {
        
        urlStr = KInfoEdit;
    }else {
    
        urlStr = KPersonalAuth;
    }
    
    FxLog(@"KInfoEdit = %@",self.params.mj_keyValues);
    
    [KSMNetworkRequest postRequest:urlStr params:self.params.mj_keyValues success:^(id responseObj) {
        
        [[HUDConfig shareHUD] Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
        
        BASE_INFO_FUN(responseObj);
        
        if (![responseObj isKindOfClass:[NSNull class]]) {
            
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                
                [[HUDConfig shareHUD]Tips:@"成功" delay:DELAY];
                
                NSDictionary *dic = [responseObj objectForKey:@"data"];
                account.idcardConsUrl = [dic objectForKey:@"idcardConsUrl"];
                account.idcardProsUrl = [dic objectForKey:@"idcardProsUrl"];
                account.realName = [dic objectForKey:@"realName"];
                account.idcardNumber = [dic objectForKey:@"idcardNumber"];
                
                [AccountModel saveAccount:account];
//                
//                if (_isEdit) {
//                    
//                    [self.navigationController popViewControllerAnimated:YES];
//                    
//                }else {
                
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                    UpImgViewController *KnowThree = [story instantiateViewControllerWithIdentifier:@"UpImgViewController"];
                    [self.navigationController pushViewController:KnowThree animated:YES];
//                }
            }else {
            
                [[HUDConfig shareHUD]Tips:@"失败" delay:DELAY];
            }
        }
        
    } failure:^(NSError *error) {
        [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
    } type:2];

}

#pragma mark UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if ([string isEqualToString:@" "] || [string isEqualToString:@"\n"]) {
        return NO;
    }
    
    NSString *tempString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == _nameLabel) {
        
        if (tempString.length > 10) {
            
            _nameLabel.text = [_nameLabel.text substringToIndex:10];
            [[HUDConfig shareHUD]Tips:@"昵称长度不能超过10" delay:DELAY];
            return NO;
        }
    }
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {

    rightBtn.userInteractionEnabled = YES;
    repeatInfo = YES;
    [rightBtn setTitleColor:lever1Color forState:UIControlStateNormal];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [_nameLabel resignFirstResponder];
    [_idcard resignFirstResponder];
    return YES;
}

- (void)valueChanged:(UITextField *)textField {
    
    if (textField.text.length > 10) {
        [[HUDConfig shareHUD]Tips:@"昵称长度不能超过10" delay:DELAY];
        self.nameLabel.text = [self.nameLabel.text substringToIndex:10];
    }

}

@end
