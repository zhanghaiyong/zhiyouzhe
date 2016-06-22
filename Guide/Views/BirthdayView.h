//
//  BirthdayView.h
//  Guide
//
//  Created by ksm on 16/4/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BirthdayViewDelegate <NSObject>

- (void)selectedBirthday:(NSString *)birthdayString;

@end

@interface BirthdayView : UIView

@property (nonatomic,assign)id<BirthdayViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
