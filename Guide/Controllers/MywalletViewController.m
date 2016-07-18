//
//  WalletViewController.m
//  Guide
//
//  Created by ksm on 16/4/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "MywalletViewController.h"
#import "WithDrawView.h"
#import "IncomeDetailViewController.h"

//@interface MywalletViewController ()<withDrawViewDelegate>



//@end

@interface MywalletViewController ()<withDrawViewDelegate>
{
     AccountModel *account;
     NSString *walletId;
     NSString *money;
}
@property (nonatomic,strong)WithDrawView *withDraw;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation MywalletViewController

-(WithDrawView *)withDraw {

    if (_withDraw == nil) {
        WithDrawView *withDraw = [[[NSBundle mainBundle] loadNibNamed:@"WithDrawView" owner:self options:nil] lastObject];
        withDraw.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        withDraw.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.4];
        withDraw.delegate = self;
        _withDraw = withDraw;
    }
    return _withDraw;
}

-(void) comfirmBtnClick {
    [self applyForCash];
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.hidesBottomBarWhenPushed = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    account = [AccountModel account];

    self.title = @"我的钱包";
    [self setNavigationLeft:@"icon_back_iphone"];
    
    [self setNavigationRightTitle:@"收支明细"];
    
    
    [self getWallet];
}


- (IBAction)showWithDrawView:(id)sender {
    
    if ([money intValue]==0) {
        [[HUDConfig shareHUD]Tips:@"你没有金额可用于提现" delay:DELAY];
        return;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self.withDraw];
}


- (void)doRight:(UIButton *)sender {

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Know" bundle:nil];
    IncomeDetailViewController *incomeDetail = [storyBoard instantiateViewControllerWithIdentifier:@"IncomeDetailViewController"];
    [self.navigationController pushViewController:incomeDetail animated:YES];
}

-(void)getWallet {
    [[HUDConfig shareHUD]alwaysShow];
    
    [KSMNetworkRequest postRequest:KGEtWallet params:@{@"zid":account.id,@"ztoken":account.token} success:^(id responseObj) {
        
        [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
        
        BASE_INFO_FUN(responseObj);
        if (![responseObj isKindOfClass:[NSNull class]]) {
            
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                
                _moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[[[responseObj objectForKey:@"data"] objectForKey:@"balanceAmount"] floatValue]];
                walletId = [NSString stringWithFormat:@"%@",[[responseObj objectForKey:@"data"] objectForKey:@"id"]];
                money = [NSString stringWithFormat:@"%@",[[responseObj objectForKey:@"data"] objectForKey:@"balanceAmount"]];
//                [account setWalletId:[NSString stringWithFormat:@"%@",[[responseObj objectForKey:@"data"] objectForKey:@"id"]]];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[NSString stringWithFormat:@"%@",[[responseObj objectForKey:@"data"] objectForKey:@"id"]] forKey:@"WalletId"];
                self.withDraw.moneyTF.placeholder =[NSString stringWithFormat:@"可提现金额%.2f元",[[[responseObj objectForKey:@"data"] objectForKey:@"balanceAmount"] floatValue]];
            }
        }
    } failure:^(NSError *error) {
        
        [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
        
    } type:0];
}
//申请提现
-(void) applyForCash {
    
    if ([self.withDraw.moneyTF.text intValue]>[money intValue]) {
        [[HUDConfig shareHUD]Tips:@"提现金额错误" delay:DELAY];
        return;
    }
    
    [[HUDConfig shareHUD]alwaysShow];
    
    [KSMNetworkRequest postRequest:KApplyForCash params:@{@"zid":account.id,@"ztoken":account.token,@"walletId":walletId,@"earningsMoney":[NSNumber numberWithInt:[_withDraw.moneyTF.text intValue]],@"alipayId":_withDraw.accountTF.text} success:^(id responseObj) {
        
        [[HUDConfig shareHUD]Tips:[responseObj objectForKey:@"msg"] delay:DELAY];
        BASE_INFO_FUN(responseObj);
        if (![responseObj isKindOfClass:[NSNull class]]) {
            
            if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
                float a = [_moneyLabel.text floatValue];
                float b = [_withDraw.moneyTF.text floatValue];
                _moneyLabel.text = [NSString stringWithFormat:@"%.2f元",a-b];
                
                
            }
        }
    } failure:^(NSError *error) {
        
        [[HUDConfig shareHUD]ErrorHUD:error.localizedDescription delay:DELAY];
        
    } type:0];
}
@end
