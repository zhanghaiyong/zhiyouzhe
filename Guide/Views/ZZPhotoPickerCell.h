//
//  ZZPhotoPickerCell.h
//  ZZFramework
//
//  Created by Yuan on 15/7/7.
//  Copyright (c) 2015年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
@class ZZPhotoPickerCell;

@protocol ZZPhotoPickerCellDelegate <NSObject>

- (void)isSelectImage:(ZZPhotoPickerCell *)cell;

@end


@interface ZZPhotoPickerCell : UICollectionViewCell

@property(strong,nonatomic) UIImageView *photo;
@property(strong,nonatomic) UIButton *selectBtn;
@property(assign,nonatomic) id<ZZPhotoPickerCellDelegate> delegate;

-(void)loadPhotoData:(PHAsset *)assetItem;
-(void)selectBtnStage:(NSMutableArray *)selectArray existence:(PHAsset *)assetItem;
@end
