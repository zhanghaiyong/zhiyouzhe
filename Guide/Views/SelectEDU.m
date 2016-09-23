//
//  SelectEDU.m
//  Guide
//
//  Created by ksm on 16/4/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "SelectEDU.h"

@implementation SelectEDU
{
    NSArray *dataArray;
    NSString *selectedEduString;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.4];
         dataArray = [[NSArray alloc]initWithObjects:@"小学",@"初中",@"高中",@"中专",@"大专",@"本科",@"硕士",@"博士",@"博士后", nil];
        selectedEduString = dataArray[0];
    }
    return self;
}

- (IBAction)cancleAction:(id)sender {
    
    [self removeFromSuperview];
}

- (IBAction)sureAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(selectedEDU:)]) {
        
        [self.delegate selectedEDU:selectedEduString];
        
        [self removeFromSuperview];
    }
}

#pragma mark -
#pragma mark Picker Date Source Methods
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return dataArray.count;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [dataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    selectedEduString = dataArray[row];
    
    FxLog(@"%@",dataArray[row]);
}

@end
