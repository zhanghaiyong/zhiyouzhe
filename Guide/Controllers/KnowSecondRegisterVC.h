//
//  KnowFirstRegisterVC.h
//  Guide
//
//  Created by ksm on 16/4/8.
//  Copyright © 2016年 ksm. All rights reserved.
//

typedef void(^setPhotoBlock)(NSArray *photos);

#import <UIKit/UIKit.h>

@interface KnowSecondRegisterVC : BaseViewController

@property (nonatomic,copy)setPhotoBlock block;

- (void)returnPhotos:(setPhotoBlock)block;

@end
