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
    NSMutableArray *likeLabelArr;
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
    if (account.skillLabel.length != 0) {
        
        NSArray *likeLabel = [NSArray arrayWithArray:[account.skillLabel componentsSeparatedByString:@","]];
        NSIndexPath *index1 = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:index1];
        
         for (int j = 0; j<likeLabel.count; j++) {
             
            for (int i = 0; i<10; i++) {
                UIButton *btn = [cell1.contentView viewWithTag:i+100];
                if ([btn.currentTitle isEqualToString:likeLabel[j]]) {
                    
                    btn.selected = YES;
                }
            }
        }
        
        
        NSArray *domLabel = [NSArray arrayWithArray:[account.selfdomLabel componentsSeparatedByString:@","]];
        NSIndexPath *index2 = [NSIndexPath indexPathForRow:1 inSection:0];
        UITableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:index2];
        
        for (int j = 0; j<domLabel.count; j++) {
            
            for (int i = 0; i<19; i++) {
                UIButton *btn = [cell2.contentView viewWithTag:i+100];
                if ([btn.currentTitle isEqualToString:domLabel[j]]) {
                
                    btn.selected = YES;
            
                }
            }
            
        }
        
        NSArray *travelLabel = [NSArray arrayWithArray:[account.travelLabel componentsSeparatedByString:@","]];
        NSIndexPath *index3 = [NSIndexPath indexPathForRow:2 inSection:0];
        UITableViewCell *cell3 = [self.tableView cellForRowAtIndexPath:index3];
        
        for (int j = 0; j<travelLabel.count; j++) {
            
            for (int i = 0; i<8; i++) {
                UIButton *btn = [cell3.contentView viewWithTag:i+100];
                if ([btn.currentTitle isEqualToString:travelLabel[j]]) {
                    
                    btn.selected = YES;
                    
                }
            }
        }
        
    }
    
}

- (void)viewDidLoad {

    [super viewDidLoad];
    specificArr = [NSMutableArray array];
    travelArr = [NSMutableArray array];
    likeLabelArr = [NSMutableArray array];
    
    [likeLabelArr addObjectsFromArray:[account.skillLabel componentsSeparatedByString:@","]];
    [specificArr addObjectsFromArray:[account.selfdomLabel componentsSeparatedByString:@","]];
    [travelArr addObjectsFromArray:[account.travelLabel componentsSeparatedByString:@","]];
    
    [self setNavigationLeft:@"icon_back_iphone"];
    self.title = @"我的标签";
}

//贴上个性标签
- (void)method1:(NSString *)text {

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    CGFloat x =  (CGFloat)(0 + (arc4random() % ((int)(SCREEN_WIDTH-80) - 0 + 1)));
    CGFloat y =  (CGFloat)(65 + (arc4random() % (190 - 65 + 1)));
    
    UIButton *labelBtn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, 69, 22)];
    [labelBtn setTitle:text forState:UIControlStateNormal];
    [labelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [labelBtn addTarget:self action:@selector(specificAction:) forControlEvents:UIControlEventTouchUpInside];
    [labelBtn setBackgroundImage:[UIImage imageNamed:@"矩形-10"] forState:UIControlStateNormal];
    [labelBtn setBackgroundImage:[UIImage imageNamed:@"11111"] forState:UIControlStateSelected];
    labelBtn.selected = YES;
    labelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:labelBtn];
}

//旅游标签
- (void)method2:(NSString *)text {

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    CGFloat x =  (CGFloat)(0 + (arc4random() % ((int)(SCREEN_WIDTH-80) - 0 + 1)));
    CGFloat y =  (CGFloat)(65 + (arc4random() % (190 - 65 + 1)));
    
    UIButton *labelBtn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, 69, 22)];
    [labelBtn setTitle:text forState:UIControlStateNormal];
    [labelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [labelBtn addTarget:self action:@selector(specificAction:) forControlEvents:UIControlEventTouchUpInside];
    [labelBtn setBackgroundImage:[UIImage imageNamed:@"矩形-10"] forState:UIControlStateNormal];
    [labelBtn setBackgroundImage:[UIImage imageNamed:@"11111"] forState:UIControlStateSelected];
    labelBtn.selected = YES;
    labelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:labelBtn];
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.location == 5) {
        return NO;
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField.text.length > 0) {

        editLabel = YES;
        
        if (textField == self.specificLabel) {
            
            [self method1:textField.text];
            [specificArr addObject:textField.text];
            
        }else {
        
            [self method2:textField.text];
            [travelArr addObject:textField.text];
        }
        
    }
    
    return YES;
}

- (IBAction)likeLabelAction:(id)sender {
    
    editLabel = YES;
    
    UIButton *button = (UIButton *)sender;
    
    if (button.selected) {
        
        button.selected = NO;
        [likeLabelArr removeObject:button.currentTitle];
        
    }else {
        
        button.selected = YES;
        [likeLabelArr addObject:button.currentTitle];
    }
}

- (IBAction)specificAction:(id)sender {
    
    editLabel = YES;
    
    UIButton *button = (UIButton *)sender;
    
    if (button.selected) {
        
        button.selected = NO;
        [specificArr removeObject:button.currentTitle];
        
    }else {
    
        button.selected = YES;
        [specificArr addObject:button.currentTitle];
    }
}

- (IBAction)travelLabelAction:(id)sender {
    
    editLabel = YES;
    
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        
        button.selected = NO;
        button.backgroundColor = RGBA(50, 185, 184, 1);
        [travelArr removeObject:button.currentTitle];
        
    }else {
        
        button.selected = YES;
        button.backgroundColor = MainColor;
        [travelArr addObject:button.currentTitle];
    }
}

//贴上个性标签
- (IBAction)stickSpecificLabel:(id)sender {
    
    if (self.specificLabel.text.length > 0) {
    
        editLabel = YES;
        
        
        [self method1:self.specificLabel.text];
        [specificArr addObject:self.specificLabel.text];
    }
    
}

//贴上旅游标签
- (IBAction)stickTravelLabel:(id)sender {
    
    if (self.TravelLabel.text.length > 0) {
        
        editLabel = YES;

        [self method2:self.TravelLabel.text];
        [travelArr addObject:self.TravelLabel.text];
    }
}

- (IBAction)finishAction:(id)sender {
    
    if (likeLabelArr.count == 0) {
        
        [[HUDConfig shareHUD]Tips:@"请选择您喜欢的标签" delay:DELAY];
        return;
    }
    
    if (specificArr.count == 0) {
        
        [[HUDConfig shareHUD]Tips:@"请选择您的个性标签" delay:DELAY];
        return;
    }
    
    if (travelArr.count == 0) {
        
        [[HUDConfig shareHUD]Tips:@"请选择您的旅游标签" delay:DELAY];
        return;
    }
    
    if (editLabel == YES) {
        
        self.params.skillLabel   = [likeLabelArr componentsJoinedByString:@","];
        self.params.selfdomLabel = [specificArr componentsJoinedByString:@","];
        self.params.travelLabel  = [travelArr componentsJoinedByString:@","];
        NSLog(@"%@",self.params.mj_keyValues);
        
        [KSMNetworkRequest postRequest:KInfoEdit params:self.params.mj_keyValues success:^(id responseObj) {
            
            [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
            NSLog(@"%@",responseObj);
            
            if (![responseObj isKindOfClass:[NSNull class]]) {
                
                if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                    
                    NSDictionary *dic = [responseObj objectForKey:@"data"];
                    account.skillLabel = [dic objectForKey:@"skillLabel"];
                    account.selfdomLabel = [dic objectForKey:@"selfdomLabel"];
                    account.travelLabel = [dic objectForKey:@"travelLabel"];
                    //保存model
                    [AccountModel saveAccount:account];
                    
                    
                    UITabBarController *TabBar = [PageInfo pageControllers];
                    [self presentViewController:TabBar animated:YES completion:nil];
                    
                }
            }
            
            
        } failure:^(NSError *error) {
            
            [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
            
        } type:2];
        
    }else {
    
        UITabBarController *TabBar = [PageInfo pageControllers];
        [self presentViewController:TabBar animated:YES completion:nil];
    }
    
    

    
}

@end
