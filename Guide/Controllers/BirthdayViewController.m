//
//  BirthdayViewController.m
//  Guide
//
//  Created by ksm on 16/8/16.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "BirthdayViewController.h"
#import "BirthdayView.h"
#import "InfoParams.h"

@interface BirthdayViewController ()<BirthdayViewDelegate>
{

    AccountModel *account;
}

@property (nonatomic,strong)InfoParams *params;

@end

@implementation BirthdayViewController

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
    [self setNavigationLeft:@"icon_back_iphone"];
    
    BirthdayView *birthdayView = [[[NSBundle mainBundle] loadNibNamed:@"BirthdayView" owner:self options:nil] lastObject];
    birthdayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    birthdayView.delegate = self;
    [self.view addSubview:birthdayView];
}

- (void)selectedBirthday:(NSString *)age star:(NSString *)star {
    
//    self.params.age = [NSString stringWithFormat:@"%@岁,%@",age,star];
//    
//    FxLog(@"%@",self.params.mj_keyValues);
//    
//    [[HUDConfig shareHUD] alwaysShow];
//    [KSMNetworkRequest postRequest:KInfoEdit params:self.params.mj_keyValues success:^(id responseObj) {
//        
//        FxLog(@"responseObj = %@",responseObj);
//        [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
//        
//        if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
//            
//            NSDictionary *dic = [responseObj objectForKey:@"data"];
//            
//            if ([dic.allKeys containsObject:@"age"]) {
//                account.age = [dic objectForKey:@"age"];
//            }
//
//            [AccountModel saveAccount:account];
            self.block([NSString stringWithFormat:@"%@岁,%@",age,star]);
            
            [self.navigationController popViewControllerAnimated:YES];
//        }
//        
//    } failure:^(NSError *error) {
//        
//        [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
//        
//    } type:2];
    
}

- (void)returnSetValue:(setAgeBlock)block {

    _block = block;
}



@end
