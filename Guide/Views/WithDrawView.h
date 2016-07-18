//
//  WithDrawView.h
//  Guide
//
//  Created by ksm on 16/4/14.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol withDrawViewDelegate <NSObject>

-(void) comfirmBtnClick;

@end

@interface WithDrawView : UIView

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;

@property (nonatomic, assign) id <withDrawViewDelegate> delegate;
@end
