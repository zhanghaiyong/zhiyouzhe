//
//  LabelViewController.m
//  Guide
//
//  Created by ksm on 16/8/16.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "LabelViewController.h"
#import "InfoParams.h"
#import "PageInfo.h" 
@interface LabelViewController ()<UITextFieldDelegate>
{

    NSMutableArray *specificArr;
    NSMutableArray *travelArr;
    AccountModel *account;
    BOOL editLabel;
}
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UITextField *specificLabel;
@property (weak, nonatomic) IBOutlet UITextField *TravelLabel;
@property (nonatomic,strong)InfoParams *params;
@end

@implementation LabelViewController

-(InfoParams *)params {
    
    if (_params == nil) {
        
        InfoParams *params = [[InfoParams alloc]init];
        _params = params;
    }
    
    return _params;
}

- (void)awakeFromNib {

    account = [AccountModel account];
    if (account.selfdomLabel.length != 0 || account.selfdomLabel.length != 0) {
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
        
        NSArray *selfdoms = [NSArray arrayWithArray:[account.selfdomLabel componentsSeparatedByString:@","]];
         for (int j = 0; j<selfdoms.count; j++) {

            UIButton *btn = [cell.contentView viewWithTag:j+100];
             btn.hidden = NO;
             [btn setTitle:selfdoms[j] forState:UIControlStateNormal];
        }
        
        
        NSArray *travels = [NSArray arrayWithArray:[account.travelLabel componentsSeparatedByString:@","]];
        for (int i = 0; i<travels.count; i++) {
            
            UIButton *btn = [cell.contentView viewWithTag:i+105];
            btn.hidden = NO;
            [btn setTitle:travels[i] forState:UIControlStateNormal];
        }
    }
}

- (void)viewDidLoad {

    [super viewDidLoad];
    specificArr = [NSMutableArray array];
    travelArr = [NSMutableArray array];
    
    [specificArr addObjectsFromArray:[account.selfdomLabel componentsSeparatedByString:@","]];
    [self refreshSpecific];
    
    
    [travelArr addObjectsFromArray:[account.travelLabel componentsSeparatedByString:@","]];
    [self refreshTravel];
    
    [self setNavigationLeft:@"icon_back_iphone"];
    self.title = @"我的标签";
    
    [self.specificLabel addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    
    [self.TravelLabel addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
}

- (void)refreshSpecific {

    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
    for (int i=0; i<5; i++) {
        
        UIButton *btn = [cell.contentView viewWithTag:i+100];
        btn.hidden = YES;
    }
    for (int j = 0; j<specificArr.count; j++) {
        
        UIButton *btn = [cell.contentView viewWithTag:j+100];
        btn.hidden = NO;
        [btn setTitle:specificArr[j] forState:UIControlStateNormal];
    }
}

- (void)refreshTravel {

    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
    for (int i=0; i<5; i++) {
        
        UIButton *btn = [cell.contentView viewWithTag:i+105];
        btn.hidden = YES;
    }
    for (int i = 0; i<travelArr.count; i++) {
        
        UIButton *btn = [cell.contentView viewWithTag:i+105];
        btn.hidden = NO;
        [btn setTitle:travelArr[i] forState:UIControlStateNormal];
    }
}


#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@" "] || [string isEqualToString:@"\n"]) {
        return NO;
    }
    
    NSString *tempString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (tempString.length > 5) {
        
        [[HUDConfig shareHUD]Tips:@"长度不能超过5" delay:DELAY];
        return NO;
    }
    
    return YES;
}

- (void)valueChanged:(UITextField *)textField {
    
    if (textField == self.specificLabel) {
        
        if (textField.text.length > 5) {
            [[HUDConfig shareHUD]Tips:@"长度不能超过5" delay:DELAY];
            self.specificLabel.text = [self.specificLabel.text substringToIndex:5];
        }
    }
    
    if (textField == self.TravelLabel) {
        if (textField.text.length > 5) {
            [[HUDConfig shareHUD]Tips:@"长度不能超过50" delay:DELAY];
            self.TravelLabel.text = [self.TravelLabel.text substringToIndex:5];
        }
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField.text.length > 0) {

        editLabel = YES;
        
        if (textField == self.specificLabel) {
            
            
            if (specificArr.count >=5) {
                [[HUDConfig shareHUD]Tips:@"最多添加5个标签" delay:DELAY];

            }else {
            
                [specificArr addObject:textField.text];
                [self refreshSpecific];
            }
            
        }else {
            
            if (travelArr.count >=5) {
                [[HUDConfig shareHUD]Tips:@"最多添加5个标签" delay:DELAY];
                
            }else {

                [travelArr addObject:textField.text];
                [self refreshTravel];
            }
        }
        
    }
    
    return YES;
}

- (IBAction)likeLabelAction:(id)sender {
    
    editLabel = YES;
    UIButton *button = (UIButton *)sender;

    
    if (button.tag < 105) {
        
        [specificArr removeObject:button.currentTitle];
        [self refreshSpecific];
        
    }else {
    
        [travelArr removeObject:button.currentTitle];
        [self refreshTravel];
    }
    
}

- (IBAction)specificAction:(id)sender {
    
    editLabel = YES;
    
    UIButton *button = (UIButton *)sender;
    
    if (button.selected) {
        
        button.selected = NO;
        [specificArr removeObject:button.currentTitle];
        
    }else {
    
        if (specificArr.count >=5) {
            [[HUDConfig shareHUD]Tips:@"最多添加5个标签" delay:DELAY];
            return;
        }
        
        for (NSString *str in specificArr) {
            
            if ([str isEqualToString:button.currentTitle]) {
                
                [[HUDConfig shareHUD]Tips:@"不能选择相同的标签" delay:DELAY];
                return;
            }
        }
        
        button.selected = YES;
        [specificArr addObject:button.currentTitle];
    }
    
    NSLog(@"%@",specificArr);
    
    
    [self refreshSpecific];
    
}

- (IBAction)travelLabelAction:(id)sender {
    
    editLabel = YES;
    
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        
        button.selected = NO;
        [travelArr removeObject:button.currentTitle];
        
    }else {
        
        if (travelArr.count >=5) {
            [[HUDConfig shareHUD]Tips:@"最多添加5个标签" delay:DELAY];
            return;
        }
        
        for (NSString *str in travelArr) {
            
            if ([str isEqualToString:button.currentTitle]) {
                
                [[HUDConfig shareHUD]Tips:@"不能选择相同的标签" delay:DELAY];
                return;
            }
        }
        
        button.selected = YES;
        [travelArr addObject:button.currentTitle];
    }
    
    [self refreshTravel];
}

//贴上个性标签
- (IBAction)stickSpecificLabel:(id)sender {
    
    if (self.specificLabel.text.length > 0) {
        
        if (specificArr.count >=5) {
            [[HUDConfig shareHUD]Tips:@"最多添加5个标签" delay:DELAY];
            return;
        }
    
        for (NSString *str in specificArr) {
            
            if ([str isEqualToString:self.specificLabel.text]) {
                
                [[HUDConfig shareHUD]Tips:@"不能贴上相同的标签" delay:DELAY];
                return;
            }
        }
        
        editLabel = YES;
        [specificArr addObject:self.specificLabel.text];
    }
    
    [self refreshSpecific];
}

//贴上旅游标签
- (IBAction)stickTravelLabel:(id)sender {
    
    
    if (self.TravelLabel.text.length > 0) {
        
        if (travelArr.count >=5) {
            [[HUDConfig shareHUD]Tips:@"最多添加5个标签" delay:DELAY];
            return;
        }
        
        for (NSString *str in travelArr) {
            
            if ([str isEqualToString:self.TravelLabel.text]) {
                
                [[HUDConfig shareHUD]Tips:@"不能贴上相同的标签" delay:DELAY];
                return;
            }
        }

        editLabel = YES;
        [travelArr addObject:self.TravelLabel.text];
    }
    
    [self refreshTravel];
}

- (IBAction)finishAction:(id)sender {
    
    if (specificArr.count == 0) {
        
        [[HUDConfig shareHUD]Tips:@"请选择您的个性标签" delay:DELAY];
        return;
    }
    
    if (travelArr.count == 0) {
        
        [[HUDConfig shareHUD]Tips:@"请选择您的旅游标签" delay:DELAY];
        return;
    }
    
    if (editLabel == YES) {
        
        [[HUDConfig shareHUD]alwaysShow];
        
        self.params.selfdomLabel = [specificArr componentsJoinedByString:@","];
        self.params.travelLabel  = [travelArr componentsJoinedByString:@","];
        
        FxLog(@"%@",self.params.mj_keyValues);
        
        [KSMNetworkRequest postRequest:KInfoEdit params:self.params.mj_keyValues success:^(id responseObj) {
            
        FxLog(@"%@",responseObj);
            
            if (![responseObj isKindOfClass:[NSNull class]]) {
                
                if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                    
                    NSDictionary *dic = [responseObj objectForKey:@"data"];
                    
                    account.selfdomLabel = [dic objectForKey:@"selfdomLabel"];
                    account.travelLabel = [dic objectForKey:@"travelLabel"];
                    //保存model
                    [AccountModel saveAccount:account];
                    
                    UITabBarController *TabBar = [PageInfo pageControllers];
                    [self presentViewController:TabBar animated:YES completion:nil];
                }else {
                
                    [[HUDConfig shareHUD]Tips:@"失败" delay:DELAY];
                }
            }
            
            [[HUDConfig shareHUD]dismiss];
            
        } failure:^(NSError *error) {
            
            [[HUDConfig shareHUD]Tips:@"失败" delay:DELAY];
            
        } type:2];
        
    }else {
    
        UITabBarController *TabBar = [PageInfo pageControllers];
        [self presentViewController:TabBar animated:YES completion:nil];
    }
}

@end
