//
//  SelectScenicViewController.m
//  Guide
//
//  Created by ksm on 16/4/11.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "SeverTimeViewController.h"
#import "CalendarModel.h"
#import "SZCalendarPicker.h"
#import "explianView.h"
@interface SeverTimeViewController ()
@property (nonatomic,strong)NSMutableArray *saveDates;
@property (nonatomic,strong)NSMutableArray *DeleteDates;

@end

@interface SeverTimeViewController () {
    
    AccountModel     *account;
    explianView *explain;
    
}
@end

@implementation SeverTimeViewController


-(NSMutableArray *)saveDates {
    
    if (_saveDates == nil) {
        
        NSMutableArray *saveDates = [NSMutableArray array];
        _saveDates = saveDates;
    }
    return _saveDates;
}

-(NSMutableArray *)DeleteDates {
    
    if (_DeleteDates == nil) {
        
        NSMutableArray *DeleteDates = [NSMutableArray array];
        _DeleteDates = DeleteDates;
    }
    return _DeleteDates;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"服务时间";
    
    [self setNavigationLeft:@"icon_back_iphone"];
    account = [AccountModel account];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn sizeToFit];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [saveBtn setTitleColor:lever1Color forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn sizeToFit];
    [leftBtn setImage:[UIImage imageNamed:@"icon_back_iphone"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self loadSeverTime];
    
    explain = [[[NSBundle mainBundle]loadNibNamed:@"explianView" owner:self options:nil]lastObject];
    explain.frame = CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT, 200, 80);
    [[UIApplication sharedApplication].keyWindow addSubview:explain];
    
    
    [UIView animateWithDuration:1 animations:^{
        
        explain.frame = CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT-90, 200, 80);
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [explain removeFromSuperview];
    explain = nil;
}

- (void)loadSeverTime {

    [[HUDConfig shareHUD]alwaysShow];
    NSDictionary *params = @{@"zhiliaoId":account.id,@"token":account.token};
    [KSMNetworkRequest postRequest:KGetCalendar params:params success:^(id responseObj) {
//        [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
        FxLog(@"%@",responseObj);
        if (![responseObj isKindOfClass:[NSNull class]]) {
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                NSArray *array = [responseObj objectForKey:@"data"];
                NSArray *modelArray = [CalendarModel mj_objectArrayWithKeyValuesArray:array];
                
                SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
                calendarPicker.today = [NSDate date];
                calendarPicker.date = calendarPicker.today;
                calendarPicker.CalendarModels = modelArray;
                calendarPicker.frame = CGRectMake(0, 64, self.view.frame.size.width, SCREEN_HEIGHT);
                calendarPicker.receive = ^(NSString *dateStr,BOOL isTap){
                    
                    if (isTap == YES) {
                        
                        [self.saveDates addObject:dateStr];
                        
                    }else {
                    
                        [self.saveDates removeObject:dateStr];
                    }
                };
                
                calendarPicker.noReceive = ^(NSString *dateStr,BOOL isTap){
                    
                    if (isTap == YES) {
                        
                        [self.DeleteDates addObject:dateStr];
                        
                    }else {
                        
                        [self.DeleteDates removeObject:dateStr];
                    }
                };
                
           }
        }
        [[HUDConfig shareHUD] dismiss];
    } failure:^(NSError *error) {
        
        [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
        
    } type:0];
}

- (void)saveAction {


    [self saveDate];
    [self deleteDate];
}

//设置成不接单日
- (void)saveDate {

    if (self.saveDates.count > 0) {
        
        
        [[HUDConfig shareHUD]alwaysShow];
        FxLog(@"saveDate  = %@",self.saveDates);
        NSString *dateString = [self.saveDates componentsJoinedByString:@","];
        NSDictionary *params = @{@"zhiliaoId":account.id,@"token":account.token,@"dates":dateString};
        [KSMNetworkRequest postRequest:KNotOderTake params:params success:^(id responseObj) {
            [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
            FxLog(@"saveDate ＝ %@",responseObj);
            if (![responseObj isKindOfClass:[NSNull class]]) {
                if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        } failure:^(NSError *error) {
            
            [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
            
        } type:0];
    }
}

//设置成可接单日
- (void)deleteDate {

    if (self.DeleteDates.count > 0) {
        
        [[HUDConfig shareHUD]alwaysShow];
        FxLog(@"deleteDate  = %@",self.DeleteDates);
        NSString *dateString = [self.DeleteDates componentsJoinedByString:@","];
        NSDictionary *params = @{@"zhiliaoId":account.id,@"token":account.token,@"dates":dateString};
        [KSMNetworkRequest postRequest:KorderTake params:params success:^(id responseObj) {
            
            [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
            FxLog(@"deleteDate ＝ %@",responseObj);
            
            if (![responseObj isKindOfClass:[NSNull class]]) {
                
                if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        } failure:^(NSError *error) {
            
            [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
            
        } type:0];
    }
}

- (void)back {

    [self.navigationController popViewControllerAnimated:YES];

}



@end
