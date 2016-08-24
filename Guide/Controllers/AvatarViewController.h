//
//  AvatarViewController.h
//  Guide
//
//  Created by ksm on 16/8/18.
//  Copyright © 2016年 ksm. All rights reserved.
//

typedef void(^avatarCVBlock)(UIImage *avatar);

#import "BaseViewController.h"

@interface AvatarViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *BigAvatar;

@property (nonatomic,copy)avatarCVBlock block;

- (void)returnAvatar:(avatarCVBlock)block;

@end
