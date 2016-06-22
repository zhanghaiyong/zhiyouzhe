//
//  TravelNoteCell.m
//  Guide
//
//  Created by ksm on 16/4/15.
//  Copyright © 2016年 ksm. All rights reserved.
//

#define imageW ((SCREEN_WIDTH-30-2-60)/3)

#import "TravelNoteCell.h"


@interface TravelNoteCell ()

/**
 *  肖像
 */
@property (nonatomic,weak)UIImageView *avator;
/**
 *  昵称
 */
//@property (nonatomic,weak)UILabel     *nick;
/**
 *  性别
 */
//@property (nonatomic,weak)UIButton    *sex;
/**
 *  内容
 */
@property (nonatomic,weak)UILabel     *content;
/**
 *  照片数组
 */
@property (nonatomic,strong)NSArray   *imageArr;
/**
 *  地点
 */
//@property (nonatomic,weak)UILabel     *place;
/**
 *  时间
 */
@property (nonatomic,weak)UILabel     *time;
/**
 *  删除
 */
@property (nonatomic,weak)UIButton    *delete;

@end


@implementation TravelNoteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {

    UIImageView *avator = [[UIImageView alloc]init];
    avator.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:avator];
    avator.layer.cornerRadius = 30;
    avator.layer.masksToBounds = YES;
    avator.layer.borderColor = MainColor.CGColor;
    avator.layer.borderWidth = 1;
    _avator = avator;
    
//    UILabel *nick = [[UILabel alloc]init];
//    nick.font = lever2Font;
//    nick.textColor = lever1Color;
//    [self.contentView addSubview:nick];
//    _nick = nick;
    
//    UIButton *sex = [[UIButton alloc]init];
//    [self.contentView addSubview:sex];
//    _sex = sex;
    
    UILabel *content = [[UILabel alloc]init];
    content.font = lever2Font;
    content.textColor = lever2Color;
    content.numberOfLines = 0;
    [self.contentView addSubview:content];
    _content = content;
    
//    UILabel *place = [[UILabel alloc]init];
//    place.font = lever2Font;
//    place.textColor = lever2Color;
//    [self.contentView addSubview:place];
//    _place = place;
    
    UILabel *time = [[UILabel alloc]init];
    time.font = lever2Font;
    time.textColor = lever2Color;
    [self.contentView addSubview:time];
    _time = time;
    
    UIButton *delete = [[UIButton alloc]init];
    delete.titleLabel.font = lever2Font;
    [delete setTitleColor:RGB(41,158,244) forState:UIControlStateNormal];
    [self.contentView addSubview:delete];
    [delete setAction:^{
        
        self.callBack(self.tag);
    }];
    _delete = delete;
    
}

-(void)setModel:(TravelNote *)model {
    
    _model = model;
    _avator.frame = CGRectMake(10, 10, 60, 60);
    [Uitils cacheImage:[AccountModel account].headiconUrl withImageV:_avator withPlaceholder:@"icon_head_default_iphone" completed:^(UIImage *image) {
        
    }];
    
    
//    CGRect nickFrame = [model.nick boundingRectWithSize:CGSizeMake(MAXFLOAT, 25) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:lever2Font} context:nil];
//    _nick.frame = CGRectMake(_avator.right+10, 10, nickFrame.size.width, 25);
//    _nick.text = model.nick;
    
    
//    _sex.frame = CGRectMake(_nick.right, (25-14)/2+10, 9, 14);
    
    CGRect contentFrame = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30-_avator.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:lever2Font} context:nil];
    _content.frame = CGRectMake(_avator.right+10, 10, contentFrame.size.width, contentFrame.size.height);
    _content.text = model.content;
    
    CGFloat imagesH = [self setImages:[model.photoUrl componentsSeparatedByString:@","]];
    
//    _place.frame = CGRectMake(_avator.right+10, _content.bottom+imagesH+5, self.width, 25);
//    _place.text = model.place;
    
    CGRect timeFrame = [[[model.addTime dateWithFormate:@"yyyy-MM-dd HH:mm:ss"] toTimeDescription] boundingRectWithSize:CGSizeMake(MAXFLOAT, 25) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:lever2Font} context:nil];
    _time.frame = CGRectMake(_avator.right+10, _content.bottom+imagesH+10, timeFrame.size.width, 25);
    _time.text = [[model.addTime dateWithFormate:@"yyyy-MM-dd HH:mm:ss"] toTimeDescription];
    
    _delete.frame = CGRectMake(_time.right, _content.bottom+imagesH+10, 60, 25);
    [_delete setTitle:@"删除" forState:UIControlStateNormal];
    NSLog(@"imagesH = %f",imagesH);
    
    
    CGRect frame = self.frame;
    frame.size.height = _delete.bottom+10;
    
    self.frame = frame;
}


- (CGFloat)setImages:(NSArray *)array {

    CGFloat height;
    
    if (array.count == 1) {
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.frame = CGRectMake(_avator.right+10,_content.bottom + 5, imageW*2, imageW*2-30);
        height = imageW*2-30;
        imageV.tag = 100;
        imageV.contentMode = UIViewContentModeScaleToFill;
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageV:)];
        [imageV addGestureRecognizer:tap];
        [Uitils cacheImage:array[0] withImageV:imageV withPlaceholder:@"icon_add_poto_iphone" completed:^(UIImage *image) {
        }];
        [self.contentView addSubview:imageV];
        
    }else {
    
        BOOL stop = NO;

        for (int i =0; i<3; i++) {

        if (stop) {
            break;
        }

        height += (imageW+1);
            
        for (int j = 0; j<3; j++) {
            
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(_avator.right+10+j*(imageW+1),_content.bottom + 5 + i*(imageW+1), imageW, imageW)];
            imageV.userInteractionEnabled = YES;
            imageV.contentMode = UIViewContentModeScaleToFill;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageV:)];
            [imageV addGestureRecognizer:tap];
            imageV.tag = i*3+j+100;
            [Uitils cacheImage:array[i*3+j] withImageV:imageV withPlaceholder:@"icon_add_poto_iphone" completed:^(UIImage *image) {
            }];
            [self.contentView addSubview:imageV];
            
            if (i*3+j == array.count-1) {
                NSLog(@"%d,%d",i,j);
                stop = YES;
                break;
            }

            
        }

        }
    }
    
    return height;
}

- (void)tapImageV:(UITapGestureRecognizer *)gesture {

    UIImageView *tapImV = (UIImageView *)gesture.view;

    NSLog(@"xcvdzfg");
    NSArray *array = [_model.photoUrl componentsSeparatedByString:@","];
    
    self.browserBlock(array,tapImV.tag);
}

- (void)browserImages:(TravelNoteCellBlock)block {

    _browserBlock = block;
}

- (void)deleteCell:(NoteBlock)block {

    _callBack = block;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
