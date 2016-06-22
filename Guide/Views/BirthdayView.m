//
//  BirthdayView.m
//  Guide
//
//  Created by ksm on 16/4/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "BirthdayView.h"

@implementation BirthdayView
{

    NSString *selectedDate;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.4];
        
        selectedDate = [[NSDate date] toYM2String];
        
    }
    return self;
}

-(void)awakeFromNib {

    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.maximumDate = [NSDate date];
}

-(void)dateChanged:(id)sender
{
    UIDatePicker *control = (UIDatePicker*)sender;
    
    selectedDate = [control.date toYM2String];

    
    
    //把当前控件设置的时间赋给date
    BASE_INFO_FUN(control.date);
    
}


- (IBAction)cancleAction:(id)sender {
    
    [self removeFromSuperview];
}

- (IBAction)sureAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(selectedBirthday:)]) {
        
        NSString *select = [selectedDate substringToIndex:4];
        NSString *now = [[[NSDate date] toYM2String] substringToIndex:4];
        NSLog(@"%@  %@",select,now);
        
        NSString *age = [NSString stringWithFormat:@"%ld",[now integerValue]-[select integerValue]];
        
        
        [self.delegate selectedBirthday:age];
        [self removeFromSuperview];
    }
}


@end
