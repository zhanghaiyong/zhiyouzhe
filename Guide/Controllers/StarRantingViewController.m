//
//  StarRantingViewController.m
//  Guide
//
//  Created by ksm on 16/4/13.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "StarRantingViewController.h"
#import "LDXScore.h"
@interface StarRantingViewController ()
{

    AccountModel *account;
}
@property (weak, nonatomic) IBOutlet LDXScore *scoreView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation StarRantingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"综合评星";
    [self setNavigationLeft:@"icon_back_iphone"];
    account = [AccountModel account];
    
    NSDictionary *params = @{@"zid":account.id,@"ztoken":account.token};
    [KSMNetworkRequest getRequest:KLevel params:params success:^(id responseObj) {
        
        FxLog(@"level = %@",responseObj);
        
        if ([[responseObj objectForKey:@"status"] isEqualToString:@"success"]) {
            
            self.scoreView.show_star = [[responseObj objectForKey:@"data"] integerValue];
            self.scoreLabel.text = [NSString stringWithFormat:@"%@星",[responseObj objectForKey:@"data"]];
        }
        
    } failure:^(NSError *error) {
        
    } type:0];
    
}



@end
