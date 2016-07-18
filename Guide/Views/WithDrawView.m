//
//  WithDrawView.m
//  Guide
//
//  Created by ksm on 16/4/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "WithDrawView.h"

@implementation WithDrawView



- (IBAction)cancleAction:(id)sender {
    
    [self removeFromSuperview];
}

- (IBAction)sureAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(comfirmBtnClick)]) {
        [self.delegate comfirmBtnClick];
    }
    
    if (_accountTF.text.length ==0) {
        [[HUDConfig shareHUD] Tips:@"支付宝号码不能为空" delay:DELAY];
        return;
    }
    if (_accountTF.text.length ==0) {
        [[HUDConfig shareHUD] Tips:@"提现金额不能为空" delay:DELAY];
        return;
    }
    
    [self removeFromSuperview];
}
@end
