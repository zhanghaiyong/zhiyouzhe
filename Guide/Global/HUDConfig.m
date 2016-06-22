//
//  HUDConfig.m
//  Guide
//
//  Created by ksm on 16/5/31.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "HUDConfig.h"

@implementation HUDConfig

+(HUDConfig *)shareHUD {

    static HUDConfig *hud = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[HUDConfig alloc] init];
    });
    
    return hud;
}

- (void)Tips:(NSString *)tips delay:(NSTimeInterval)second {

        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showInfoWithStatus:tips];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:second];
}

- (void)SuccessHUD:(NSString *)tips delay:(NSTimeInterval)second {

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:tips];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:second];
}

- (void)ErrorHUD:(NSString *)tips delay:(NSTimeInterval)second {
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showErrorWithStatus:tips];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:second];
}

- (void)LoadHUD:(NSString *)tips delay:(NSTimeInterval)second {

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:tips];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:second];
}


- (void)alwaysShow {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD show];
    
}

- (void)dismiss {

    [SVProgressHUD dismiss];
}


@end
