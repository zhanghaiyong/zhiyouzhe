//
//  SelectEDU.h
//  Guide
//
//  Created by ksm on 16/4/12.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectEDUDelegate <NSObject>

- (void)selectedEDU:(NSString *)eduString;

@end

@interface SelectEDU : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,assign)id<selectEDUDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@end
