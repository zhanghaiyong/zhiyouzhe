//
//  ReleaseTraverViewController.h
//  Guide
//
//  Created by ksm on 16/4/22.
//  Copyright © 2016年 ksm. All rights reserved.
//

typedef void(^ReleaseCallBlock)(id model);

#import "BaseViewController.h"
#import "TravelNote.h"

@interface ReleaseTraverViewController : BaseViewController


@property (nonatomic,copy)ReleaseCallBlock callBack;

- (void)addNewTravelNote:(ReleaseCallBlock)block;
@end
