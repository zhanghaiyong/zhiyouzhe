//
//  ScenicLayout.m
//  Guide
//
//  Created by ksm on 16/4/11.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "ScenicLayout.h"

@implementation ScenicLayout

-(id)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
        self.itemSize = CGSizeMake((SCREEN_WIDTH-4)/3, 50);//每个item的大小，可使用代理对每个item不同设置
        self.minimumLineSpacing = 1;        //每行的间距
        self.minimumInteritemSpacing = 0;    //每行内部item cell间距
//        self.footerReferenceSize=CGSizeMake(0, 30);
//        self.headerReferenceSize=CGSizeMake(SCREEN_WIDTH, 40);//页眉和页脚大小
        self.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);//item cell内部四周的边界（top，left，bottom，right）
        
        
    }
    return self;
}

@end
