//
//  UpImgViewController.m
//  Guide
//
//  Created by ksm on 16/8/17.
//  Copyright © 2016年 ksm. All rights reserved.
//

#define SELFTV     (@"您时怎样的人？性格是逗逼还是高冷？让旅行者更了解您")
#define SELF_LIFE  (@"为什么来到这座城市？有怎样的旅游经历？")
#define SELF_CITY  (@"谈谈您眼中的城市吧，繁华还是宁静？在这儿生活有什么与众不同的感受？")
#define SELF_SEVER (@"成为知了后，会怎么和旅行者吃喝玩乐，可以推荐您擅长的路线和推荐的经典或者小店")
#define SELF_SIGN  (@"编辑您的个性签名让更多人关注您")
#define PHOTO_COUNT (@"个人照片（0张）")

#import "UpImgViewController.h"
#import "KnowSecondRegisterVC.h"
#import "TakePhotoViewController.h"
#import "ZZPhotoController.h"
#import "PostImageTool.h"
#import "InfoParams.h"
#import "LabelViewController.h"
@interface UpImgViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{

    BOOL editTextV; //个人介绍
    BOOL tapButton; //生活
//    BOOL myCityFlag; //城市
//    BOOL mySvevrFlag; //服务
//    BOOL mySignFlag; //签名
    NSMutableArray *selfIntroductionsPhoto; //个人介绍配图
    NSMutableArray *selflifeIntroductionsPhoto; //个人生活介绍配图
    NSMutableArray *selfcityIntroductionsPhoto; //城市介绍配图
    NSMutableArray *servicesIntroductionsPhoto; //服务介绍配图
    AccountModel *account;
    
}
@property (nonatomic,strong)InfoParams *params;

/**
 *  图片个数
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneCount;
/**
 *  个人介绍
 */
@property (weak, nonatomic) IBOutlet UITextView *selfIntroductionsTV;
@property (weak, nonatomic) IBOutlet UIImageView *selfIntroductionsImg1;
@property (weak, nonatomic) IBOutlet UIImageView *selfIntroductionsImg2;
@property (weak, nonatomic) IBOutlet UILabel *selfIntroductionsTV_Count;

/**
 *  关于您的生活
 */
@property (weak, nonatomic) IBOutlet UITextView *selflifeIntroductionsTV;
@property (weak, nonatomic) IBOutlet UIImageView *selflifeIntroductionsImg1;
@property (weak, nonatomic) IBOutlet UIImageView *selflifeIntroductionsImg2;
@property (weak, nonatomic) IBOutlet UILabel *selflifeIntroductionsTV_Count;


/**
 *  关于您的服务
 */
@property (weak, nonatomic) IBOutlet UITextView *servicesIntroductionsTV;
@property (weak, nonatomic) IBOutlet UIImageView *servicesIntroductionsImg1;
@property (weak, nonatomic) IBOutlet UIImageView *servicesIntroductionsImg2;
@property (weak, nonatomic) IBOutlet UILabel *servicesIntroductionsTV_Count;

/**
 *  关于您所载城市
 */
@property (weak, nonatomic) IBOutlet UITextView *selfcityIntroductionsTV;
@property (weak, nonatomic) IBOutlet UIImageView *selfcityIntroductionsImg1;
@property (weak, nonatomic) IBOutlet UIImageView *selfcityIntroductionsImg2;
@property (weak, nonatomic) IBOutlet UILabel *selfcityIntroductionsTV_Count;
/**
 *  个性签名
 */
@property (weak, nonatomic) IBOutlet UITextView *selfdomLabelTV;
@property (weak, nonatomic) IBOutlet UILabel *selfdomLabelTV_Count;
@end

@implementation UpImgViewController

-(InfoParams *)params {
    
    if (_params == nil) {
        
        InfoParams *params = [[InfoParams alloc]init];
        _params = params;
    }
    
    return _params;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationLeft:@"icon_back_iphone"];
    self.title = @"身份认证2";
    selfIntroductionsPhoto = [NSMutableArray array]; //个人介绍配图
    selflifeIntroductionsPhoto = [NSMutableArray array];; //个人生活介绍配图
    selfcityIntroductionsPhoto = [NSMutableArray array];; //城市介绍配图
    servicesIntroductionsPhoto = [NSMutableArray array];; //服务介绍配图
    account = [AccountModel account];
    
    if (account.photoPaths.length != 0) {
        
        NSArray *photos = [account.photoPaths componentsSeparatedByString:@","];
        //照片
        self.phoneCount.text = [NSString stringWithFormat:@"个人照片（%ld张）",photos.count];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        for (int i = 0; i<photos.count; i++) {
            UIButton *imageBtn = [cell.contentView viewWithTag:100+i];
            imageBtn.hidden = NO;
            [imageBtn setImage:nil forState:UIControlStateNormal];
            [imageBtn setTitle:@"" forState:UIControlStateNormal];
//            [imageBtn setBackgroundImage:photos[i] forState:UIControlStateNormal];
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:imageBtn.frame];
            [Uitils cacheImage:photos[i] withImageV:imageV withPlaceholder:@"" completed:^(UIImage *image) {
                
                [imageBtn setBackgroundImage:imageV.image forState:UIControlStateNormal];
            }];
        }
        
        //个人介绍
        self.selfIntroductionsTV.text = account.selfIntroductions;
        [selfIntroductionsPhoto addObjectsFromArray:[account.selfIntroductionsPhoto componentsSeparatedByString:@","]];
        switch (selfIntroductionsPhoto.count) {
            case 0:
                break;
            case 1:
                [Uitils cacheImage:selfIntroductionsPhoto[0] withImageV:self.selfIntroductionsImg1 withPlaceholder:@"" completed:^(UIImage *image) {
                }];
                break;
            case 2:
                [Uitils cacheImage:selfIntroductionsPhoto[0] withImageV:self.selfIntroductionsImg1 withPlaceholder:@"" completed:^(UIImage *image) {
                }];
                [Uitils cacheImage:selfIntroductionsPhoto[1] withImageV:self.selfIntroductionsImg2 withPlaceholder:@"" completed:^(UIImage *image) {
                }];
                break;
                
            default:
                break;
        }
        self.selfIntroductionsTV_Count.text = [NSString stringWithFormat:@"%ld/400",account.selfIntroductions.length];
        
        //您的生活
        self.selflifeIntroductionsTV.text = account.selflifeIntroductions;
        [selflifeIntroductionsPhoto addObjectsFromArray:[account.selflifeIntroductionsPhoto componentsSeparatedByString:@","]];
        switch (selflifeIntroductionsPhoto.count) {
            case 0:
                break;
            case 1:
                [Uitils cacheImage:selflifeIntroductionsPhoto[0] withImageV:self.selflifeIntroductionsImg1 withPlaceholder:@"" completed:^(UIImage *image) {
                }];
                break;
            case 2:
                [Uitils cacheImage:selflifeIntroductionsPhoto[0] withImageV:self.selflifeIntroductionsImg1 withPlaceholder:@"" completed:^(UIImage *image) {
                }];
                [Uitils cacheImage:selflifeIntroductionsPhoto[1] withImageV:self.selflifeIntroductionsImg2 withPlaceholder:@"" completed:^(UIImage *image) {
                }];
                break;
                
            default:
                break;
        }
        self.selflifeIntroductionsTV_Count.text = [NSString stringWithFormat:@"%ld/400",account.selflifeIntroductions.length];
        
        
        //您的服务
        self.servicesIntroductionsTV.text = account.servicesIntroductions;
        [servicesIntroductionsPhoto addObjectsFromArray:[account.servicesIntroductionsPhoto componentsSeparatedByString:@","]];
        switch (servicesIntroductionsPhoto.count) {
            case 0:
                break;
            case 1:
                [Uitils cacheImage:servicesIntroductionsPhoto[0] withImageV:self.servicesIntroductionsImg1 withPlaceholder:@"" completed:^(UIImage *image) {
                }];
                break;
            case 2:
                [Uitils cacheImage:servicesIntroductionsPhoto[0] withImageV:self.servicesIntroductionsImg1 withPlaceholder:@"" completed:^(UIImage *image) {
                }];
                [Uitils cacheImage:servicesIntroductionsPhoto[1] withImageV:self.servicesIntroductionsImg2 withPlaceholder:@"" completed:^(UIImage *image) {
                }];
                break;
                
            default:
                break;
        }
        self.servicesIntroductionsTV_Count.text = [NSString stringWithFormat:@"%ld/400",account.servicesIntroductions.length];
        
        //您的城市
        self.selfcityIntroductionsTV.text = account.selfcityIntroductions;
        [selfcityIntroductionsPhoto addObjectsFromArray:[account.selfcityIntroductionsPhoto componentsSeparatedByString:@","]];
        switch (selfcityIntroductionsPhoto.count) {
            case 0:
                break;
            case 1:
                [Uitils cacheImage:selfcityIntroductionsPhoto[0] withImageV:self.selfcityIntroductionsImg1 withPlaceholder:@"" completed:^(UIImage *image) {
                }];
                break;
            case 2:
                [Uitils cacheImage:selfcityIntroductionsPhoto[0] withImageV:self.selfcityIntroductionsImg1 withPlaceholder:@"" completed:^(UIImage *image) {
                }];
                [Uitils cacheImage:selfcityIntroductionsPhoto[1] withImageV:self.selfcityIntroductionsImg2 withPlaceholder:@"" completed:^(UIImage *image) {
                }];
                break;
                
            default:
                break;
        }
        self.selfcityIntroductionsTV_Count.text = [NSString stringWithFormat:@"%ld/400",account.selfcityIntroductions.length];
        
        //个性签名
        self.selfdomLabelTV.text = account.selfdomLabel;
        self.selfdomLabelTV_Count.text = [NSString stringWithFormat:@"%ld/400",account.selfdomLabel.length];
        
        
    }


}


#pragma mark UITableViewDelegate && UITableVIewDatasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        KnowSecondRegisterVC *setPhotos = [story instantiateViewControllerWithIdentifier:@"KnowSecondRegisterVC"];
        
        [setPhotos returnPhotos:^(NSArray *photos) {
            
            self.phoneCount.text = [NSString stringWithFormat:@"个人照片（%ld张）",photos.count];
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            for (int i = 0; i<photos.count; i++) {
                
                UIButton *imageBtn = [cell.contentView viewWithTag:100+i];
                imageBtn.hidden = NO;
                [imageBtn setImage:nil forState:UIControlStateNormal];
                [imageBtn setTitle:@"" forState:UIControlStateNormal];
                [imageBtn setBackgroundImage:photos[i] forState:UIControlStateNormal];
            }
            
        }];
        
        [self.navigationController pushViewController:setPhotos animated:YES];
    }
}


#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {

    editTextV = YES;
    
    if (textView == self.selfIntroductionsTV) {
        
        if ([self.selfIntroductionsTV.text isEqualToString:SELFTV]) {
            
            textView.text = @"";
        }
    }
    
    if (textView == self.selflifeIntroductionsTV) {
        
        if ([self.selflifeIntroductionsTV.text isEqualToString:SELF_LIFE]) {
            
            textView.text = @"";
        }
    }
    
    if (textView == self.selfcityIntroductionsTV) {
        
        if ([self.selfcityIntroductionsTV.text isEqualToString:SELF_CITY]) {
            
            textView.text = @"";
        }
    }
    
    if (textView == self.servicesIntroductionsTV) {
        
        if ([self.servicesIntroductionsTV.text isEqualToString:SELF_SEVER]) {
            
            textView.text = @"";
        }
    }
    
    if (textView == self.selfdomLabelTV) {
        
        if ([self.selfdomLabelTV.text isEqualToString:SELF_SIGN]) {
            
            textView.text = @"";
        }
    }
    
}

#pragma mark UITextField Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
//    NSString *checkString;
    
    //个人介绍
    if (textView == self.selfIntroductionsTV) {
        
//        mySelfFlag = YES;
        
        if (range.location == 400) {
            
            return NO;
            
        } else {
            
            self.selfIntroductionsTV_Count.text = [NSString stringWithFormat:@"%ld/400",range.location];
            return YES;
        }
    }
    
    //关于你的生活
    if (textView == self.selflifeIntroductionsTV) {
        
//        myLifeFlag = YES;
        
        if (range.location == 400) {
            
            return NO;
            
        } else {
            
            self.selflifeIntroductionsTV_Count.text = [NSString stringWithFormat:@"%ld/400",range.location];
            return YES;
        }
    }
    
    //关于你的城市
    if (textView == self.selfcityIntroductionsTV) {
        
//        myCityFlag = YES;
        if (range.location == 400) {
            
            return NO;
            
        } else {
            
            self.selfcityIntroductionsTV_Count.text = [NSString stringWithFormat:@"%ld/400",range.location];
            return YES;
        }
    }
    
    //关于你的服务
    if (textView == self.servicesIntroductionsTV) {
        
//        mySvevrFlag = YES;
        if (range.location == 400) {
            
            return NO;
            
        } else {
            
            self.servicesIntroductionsTV_Count.text = [NSString stringWithFormat:@"%ld/400",range.location];
            return YES;
        }
    }
    
    //关于签名
    if (textView == self.selfdomLabelTV) {
        
//        mySignFlag = YES;
        if (range.location == 400) {
            
            return NO;
            
        } else {
            
            self.selfdomLabelTV_Count.text = [NSString stringWithFormat:@"%ld/400",range.location];
            return YES;
        }
    }
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}


- (IBAction)takePhotoAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    ZZPhotoController *photoController = [[ZZPhotoController alloc]init];
    photoController.selectPhotoOfMax = 2;
    [photoController showIn:self result:^(id responseObject){
    NSArray *array = (NSArray *)responseObject;
        
        tapButton = YES;
        
        switch (button.tag) {
            case 1000: //个人介绍
                
                if (array.count == 1) {
                    
                    self.selfIntroductionsImg1.image = array[0];
                    [selfIntroductionsPhoto addObject:[NSString stringWithFormat:@"%@selfIntroductionsImg1",account.id]];
                    
                    [dic setValue:array[0] forKey:[NSString stringWithFormat:@"%@selfIntroductionsImg1",account.id]];
                }
                if (array.count == 2) {
                    self.selfIntroductionsImg1.image = array[0];
                    self.selfIntroductionsImg2.image = array[1];
                    [selfIntroductionsPhoto addObject:[NSString stringWithFormat:@"%@selfIntroductionsImg1",account.id]];
                    [selfIntroductionsPhoto addObject:[NSString stringWithFormat:@"%@selfIntroductionsImg2",account.id]];
                    
                    [dic setValue:array[0] forKey:[NSString stringWithFormat:@"%@selfIntroductionsImg1",account.id]];
                    [dic setValue:array[1] forKey:[NSString stringWithFormat:@"%@selfIntroductionsImg2",account.id]];
                    
                }
                

                [[PostImageTool shareTool]QiniuPostImages:dic Success:^{
                } failure:^(NSError *error) {
                }];
                
                break;
            case 2000: //关于你的生活
                
                if (array.count == 1) {
                    
                    self.selflifeIntroductionsImg1.image = array[0];
                    [selflifeIntroductionsPhoto addObject:[NSString stringWithFormat:@"%@selflifeIntroductionsImg1",account.id]];
                    
                    [dic setValue:array[0] forKey:[NSString stringWithFormat:@"%@selflifeIntroductionsImg1",account.id]];
                }
                if (array.count == 2) {
                    self.selflifeIntroductionsImg1.image = array[0];
                    self.selflifeIntroductionsImg2.image = array[1];
                    [selflifeIntroductionsPhoto addObject:[NSString stringWithFormat:@"%@selflifeIntroductionsImg1",account.id]];
                    [selflifeIntroductionsPhoto addObject:[NSString stringWithFormat:@"%@selflifeIntroductionsImg2",account.id]];
                    
                    [dic setValue:array[0] forKey:[NSString stringWithFormat:@"%@selflifeIntroductionsImg1",account.id]];
                    [dic setValue:array[1] forKey:[NSString stringWithFormat:@"%@selflifeIntroductionsImg2",account.id]];
                }
                
                [[PostImageTool shareTool]QiniuPostImages:dic Success:^{
                } failure:^(NSError *error) {
                }];
                
                break;
            case 3000: //所在城市
                
                if (array.count == 1) {
                    
                    self.selfcityIntroductionsImg1.image = array[0];
                    [selfcityIntroductionsPhoto addObject:[NSString stringWithFormat:@"%@selfcityIntroductionsImg1",account.id]];
                    
                    [dic setValue:array[0] forKey:[NSString stringWithFormat:@"%@selfcityIntroductionsImg1",account.id]];
                }
                if (array.count == 2) {
                    self.selfcityIntroductionsImg1.image = array[0];
                    self.selfcityIntroductionsImg2.image = array[1];
                    [selfcityIntroductionsPhoto addObject:[NSString stringWithFormat:@"%@selfcityIntroductionsImg1",account.id]];
                    [selfcityIntroductionsPhoto addObject:[NSString stringWithFormat:@"%@selfcityIntroductionsImg2",account.id]];
                    
                    [dic setValue:array[0] forKey:[NSString stringWithFormat:@"%@selfcityIntroductionsImg1",account.id]];
                    [dic setValue:array[1] forKey:[NSString stringWithFormat:@"%@selfcityIntroductionsImg2",account.id]];
                }
                
                [[PostImageTool shareTool]QiniuPostImages:dic Success:^{
                } failure:^(NSError *error) {
                }];
                
                break;
            case 4000: // 你的服务
                
                if (array.count == 1) {
                    
                    self.servicesIntroductionsImg1.image = array[0];
                    [servicesIntroductionsPhoto addObject:[NSString stringWithFormat:@"%@servicesIntroductionsImg1",account.id]];
                    
                    [dic setValue:array[0] forKey:[NSString stringWithFormat:@"%@servicesIntroductionsImg1",account.id]];
                    
                }
                if (array.count == 2) {
                    self.servicesIntroductionsImg1.image = array[0];
                    self.servicesIntroductionsImg2.image = array[1];
                    [servicesIntroductionsPhoto addObject:[NSString stringWithFormat:@"%@servicesIntroductionsImg1",account.id]];
                    [servicesIntroductionsPhoto addObject:[NSString stringWithFormat:@"%@servicesIntroductionsImg2",account.id]];
                    
                    [dic setValue:array[0] forKey:[NSString stringWithFormat:@"%@servicesIntroductionsImg1",account.id]];
                    [dic setValue:array[1] forKey:[NSString stringWithFormat:@"%@servicesIntroductionsImg2",account.id]];
                }
                
                [[PostImageTool shareTool]QiniuPostImages:dic Success:^{
                } failure:^(NSError *error) {
                }];
                
                break;
            default:
                break;
        }
    }];

}

- (IBAction)nextStep:(id)sender {
        
    if ([self.phoneCount.text isEqualToString:PHOTO_COUNT]) {
        
        [[HUDConfig shareHUD]Tips:@"请上传个人照片" delay:DELAY];
        return;
    }
    
    
    if ((selfIntroductionsPhoto.count + selflifeIntroductionsPhoto.count + selfcityIntroductionsPhoto.count + servicesIntroductionsPhoto.count) == 0) {
        
        [[HUDConfig shareHUD]Tips:@"请上传至少一张配图" delay:DELAY];
        return;
    }
    
    
    if ([self.selfIntroductionsTV.text isEqualToString:SELFTV]) {
        [[HUDConfig shareHUD]Tips:@"请填写个人介绍" delay:DELAY];
        return;
    }

    
    if ([self.selflifeIntroductionsTV.text isEqualToString:SELF_LIFE]) {
        
        [[HUDConfig shareHUD]Tips:@"请介绍一下您的生活吧" delay:DELAY];
        return;
    }

    
    if ([self.selfcityIntroductionsTV.text isEqualToString:SELF_CITY]) {
        
        [[HUDConfig shareHUD]Tips:@"请介绍一下您所在的城市吧" delay:DELAY];
        return;
    }
    
    if ([self.selfcityIntroductionsTV.text isEqualToString:SELF_SEVER]) {
        
        [[HUDConfig shareHUD]Tips:@"请介绍一下您的服务吧" delay:DELAY];
        return;
    }

    
    if ([self.selfdomLabelTV.text isEqualToString:SELF_SIGN]) {
        [[HUDConfig shareHUD]Tips:@"编辑你的个性签名" delay:DELAY];
        return;
    }
    
    if (editTextV || tapButton) {
        //个人介绍
        self.params.selfIntroductions = self.selfIntroductionsTV.text;
        self.params.selfIntroductionsPhoto = [selfIntroductionsPhoto componentsJoinedByString:@","];
        
        //生活
        self.params.selflifeIntroductions = self.selflifeIntroductionsTV.text;
        self.params.selflifeIntroductionsPhoto = [selflifeIntroductionsPhoto componentsJoinedByString:@","];
        
        //城市
        self.params.selfcityIntroductions = self.selfcityIntroductionsTV.text;
        self.params.selfcityIntroductionsPhoto = [selfcityIntroductionsPhoto componentsJoinedByString:@","];
        
        //服务
        self.params.servicesIntroductions = self.servicesIntroductionsTV.text;
        self.params.servicesIntroductionsPhoto = [servicesIntroductionsPhoto componentsJoinedByString:@","];
        
        //签名
        self.params.signature = self.selfdomLabelTV.text;
        
        
        NSLog(@"%@",self.params.mj_keyValues);
        
        [KSMNetworkRequest postRequest:KInfoEdit params:self.params.mj_keyValues success:^(id responseObj) {
            
            [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
            NSLog(@"%@",responseObj);
            
            if (![responseObj isKindOfClass:[NSNull class]]) {
                
                if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                    
                    NSDictionary *dic = [responseObj objectForKey:@"data"];
                    account.selfIntroductions = [dic objectForKey:@"selfIntroductions"];
                    account.selfIntroductionsPhoto = [dic objectForKey:@"selfIntroductionsPhoto"];
                    account.selflifeIntroductions = [dic objectForKey:@"selflifeIntroductions"];
                    account.selflifeIntroductionsPhoto = [dic objectForKey:@"selflifeIntroductionsPhoto"];
                    account.selfcityIntroductions = [dic objectForKey:@"selfcityIntroductions"];
                    account.selfcityIntroductionsPhoto = [dic objectForKey:@"selfcityIntroductionsPhoto"];
                    account.servicesIntroductions = [dic objectForKey:@"servicesIntroductions"];
                    account.servicesIntroductionsPhoto = [dic objectForKey:@"servicesIntroductionsPhoto"];
                    account.signature = [dic objectForKey:@"signature"];
                    //保存model
                    [AccountModel saveAccount:account];
                    
                    
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                    LabelViewController *labelVC = [story instantiateViewControllerWithIdentifier:@"LabelViewController"];
                    [self.navigationController pushViewController:labelVC animated:YES];
                }
            }
            
            
        } failure:^(NSError *error) {
            
            [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
            
        } type:2];
        
    }else {
    
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LabelViewController *labelVC = [story instantiateViewControllerWithIdentifier:@"LabelViewController"];
        [self.navigationController pushViewController:labelVC animated:YES];
    }


}
@end
