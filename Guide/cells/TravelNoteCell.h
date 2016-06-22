//
//  TravelNoteCell.h
//  Guide
//
//  Created by ksm on 16/4/15.
//  Copyright © 2016年 ksm. All rights reserved.
//

typedef void(^TravelNoteCellBlock)(NSArray *imageVs,NSInteger flag);
typedef void(^NoteBlock)(NSInteger cellTag);

#import <UIKit/UIKit.h>
#import "TravelNote.h"

@interface TravelNoteCell : UITableViewCell

@property (nonatomic,strong)TravelNote *model;
@property (nonatomic,copy)NoteBlock callBack;
@property (nonatomic,copy)TravelNoteCellBlock browserBlock;

- (void)deleteCell:(NoteBlock)block;

- (void)browserImages:(TravelNoteCellBlock)block;

@end
