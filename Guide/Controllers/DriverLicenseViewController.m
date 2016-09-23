//
//  DriverLicenseViewController.m
//  Guide
//
//  Created by ksm on 16/4/11.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "DriverLicenseViewController.h"
#import "TakePhotoViewController.h"
#import "InfoParams.h"
#import "PostImageTool.h"
@interface DriverLicenseViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *driverLicenseImage;
@property (nonatomic,strong)InfoParams *params;
@property (weak, nonatomic) IBOutlet UIImageView *carImage;

@end

@implementation DriverLicenseViewController
{
    //驾照
    NSString *driverLicenseImage;
    //车
    NSString *carImage;
    AccountModel *account;
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

    self.title = @"上传驾驶证";
     account = [AccountModel account];
    
    //如果本地数据中已经有了照片，将照片显示
    if (account.drivingLicenseUrl) {
        
        self.driverLicenseImage.contentMode = UIViewContentModeScaleToFill;
        self.carImage.contentMode = UIViewContentModeScaleToFill;
        
        [Uitils cacheImage:account.drivingLicenseUrl withImageV:_driverLicenseImage withPlaceholder:@"pic_jiazhao_up_iphone" completed:^(UIImage *image) {
            driverLicenseImage  = account.drivingLicenseUrl;
        }];
        [Uitils cacheImage:account.carUrl withImageV:_carImage withPlaceholder:@"pic_carpoto_up_iphone" completed:^(UIImage *image) {
            carImage = account.carUrl ;
        }];
    }
    
    [self setNavigationLeft:@"icon_back_iphone"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn sizeToFit];
    [btn setImage:[UIImage imageNamed:@"icon_back_iphone"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
}

- (void)back {

    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

     NSString *imageName = nil;
    switch (indexPath.row) {
        case 0:
            imageName = [NSString stringWithFormat:@"%@driverLicenseImage",account.id];
            driverLicenseImage = imageName;
            break;
        case 1:
            imageName = [NSString stringWithFormat:@"%@carImage",account.id];
            carImage = imageName;
            break;
            
        default:
            break;
    }
    
    TakePhotoViewController *takePhotoVC = [[TakePhotoViewController alloc]init];
    [takePhotoVC returnImage:^(UIImage *image) {
        
        switch (indexPath.row) {
            case 0:
                self.driverLicenseImage.contentMode = UIViewContentModeScaleToFill;
                _driverLicenseImage.image = image;
                break;
            case 1:
                self.carImage.contentMode = UIViewContentModeScaleToFill;
                _carImage.image = image;
                break;
                
            default:
                break;
        }
        
        [[PostImageTool shareTool] QiniuPostImage:image imageKey:imageName Success:^{
            
            BASE_INFO_FUN(@"上传成功");
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    [self presentViewController:takePhotoVC animated:YES completion:nil];
}

- (void)returnCarStatus:(CarBlock)block {

    self.callBlock = block;
}

- (IBAction)sureAction:(id)sender {
    
    if (driverLicenseImage.length == 0) {
        
        [[HUDConfig shareHUD]Tips:@"请上传身份证正面" delay:DELAY];
        return;
    }
    
    if (carImage.length == 0) {
        
         [[HUDConfig shareHUD]Tips:@"请上传身份证反面" delay:DELAY];
        return;
    }
    
    
    [[HUDConfig shareHUD] alwaysShow];
    
    self.params.drivingLicenseUrl = driverLicenseImage;
    self.params.carUrl = carImage;
    
    FxLog(@"身份证 = %@",self.params.mj_keyValues);
    
    [KSMNetworkRequest postRequest:KCarAuth params:self.params.mj_keyValues success:^(id responseObj) {
        
        [[HUDConfig shareHUD] Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
        BASE_INFO_FUN(responseObj);
        if (![responseObj isKindOfClass:[NSNull class]]) {
            
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                
                [[HUDConfig shareHUD] SuccessHUD:@"上传成功" delay:DELAY];
                
                account.drivingLicenseUrl = driverLicenseImage;
                account.carUrl = carImage;
                [AccountModel saveAccount:account];
                
                [self back];
                self.callBlock(@"认证中");
            }
        }
        
    } failure:^(NSError *error) {
        [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
    } type:2];
    

}


@end
