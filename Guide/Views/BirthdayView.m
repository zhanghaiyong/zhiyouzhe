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
    NSString *star;
    NSString *selectedDate;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.4];
        
        selectedDate = [[NSDate date] toYM2String];
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM"];
        NSInteger currentMonth=[[formatter stringFromDate:[NSDate date]]integerValue];
        [formatter setDateFormat:@"dd"];
        NSInteger currentDay=[[formatter stringFromDate:[NSDate date]] integerValue];
        star = [self calculateConstellationWithMonth:currentMonth day:currentDay];
        
    }
    return self;
}

-(void)awakeFromNib {

    [super awakeFromNib];
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.maximumDate = [NSDate date];
}

-(void)dateChanged:(id)sender
{
    UIDatePicker *control = (UIDatePicker*)sender;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:control.date]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:control.date] integerValue];
    star = [self calculateConstellationWithMonth:currentMonth day:currentDay];
    
    selectedDate = [control.date toYM2String];
    
    //把当前控件设置的时间赋给date
    BASE_INFO_FUN(control.date);
    
}


- (IBAction)cancleAction:(id)sender {
    
    [self removeFromSuperview];
}

- (IBAction)sureAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(selectedBirthday:star:)]) {
        
        NSString *select = [selectedDate substringToIndex:4];
        NSString *now = [[[NSDate date] toYM2String] substringToIndex:4];
        FxLog(@"%@  %@",select,star);
        
        NSString *age = [NSString stringWithFormat:@"%ld",[now integerValue]-[select integerValue]];
        
        [self.delegate selectedBirthday:age star:star];
//        [self removeFromSuperview];
    }
}

/**
 *  根据生日计算星座
 *
 *  @param month 月份
 *  @param day   日期
 *
 *  @return 星座名称
 */
- (NSString *)calculateConstellationWithMonth:(NSInteger)month day:(NSInteger)day {
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    if (month<1 || month>12 || day<1 || day>31){
        return @"错误日期格式!";
    }
    
    if(month==2 && day>29)
    {
        return @"错误日期格式!!";
    }else if(month==4 || month==6 || month==9 || month==11) {
        if (day>30) {
            return @"错误日期格式!!!";
        }
    }
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    
    return [NSString stringWithFormat:@"%@座",result];
}


@end
