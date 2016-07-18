//
//  ReleaseTraverViewController.m
//  Guide
//
//  Created by ksm on 16/4/22.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "ReleaseTraverViewController.h"
#import "ZZPhotoController.h"
#import "MWPhotoBrowser.h"
#import "AddTravelNoteParams.h"
#import "PostImageTool.h"
#import "TravelNote.h"

@interface ReleaseTraverViewController ()<MWPhotoBrowserDelegate,UITextViewDelegate>
{

    UIButton *saveBtn;
    AccountModel *account;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollerContentSizeHeight;
@property (weak, nonatomic) IBOutlet UITextView *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *image1;
@property (weak, nonatomic) IBOutlet UIButton *image2;
@property (weak, nonatomic) IBOutlet UIButton *image3;
@property (weak, nonatomic) IBOutlet UIButton *image4;
@property (weak, nonatomic) IBOutlet UIButton *image5;
@property (weak, nonatomic) IBOutlet UIButton *image6;
@property (weak, nonatomic) IBOutlet UIButton *image7;
@property (weak, nonatomic) IBOutlet UIButton *image8;
@property (weak, nonatomic) IBOutlet UIButton *image9;
@property (weak, nonatomic) IBOutlet UIView *scrollView;

@property (nonatomic,strong)NSMutableArray *selectedPhotos;
@property (nonatomic,strong)AddTravelNoteParams *params;
@end

@implementation ReleaseTraverViewController
-(AddTravelNoteParams *)params {
    
    if (_params == nil) {
        
        AddTravelNoteParams *params = [[AddTravelNoteParams alloc]init];
        params.zid = account.id;
        params.ztoken = account.token;
        _params = params;
    }
    
    return _params;
}


-(NSMutableArray *)selectedPhotos {
    
    if (_selectedPhotos == nil) {
        
        NSMutableArray *selectedPhotos = [NSMutableArray array];
        _selectedPhotos = selectedPhotos;
    }
    return _selectedPhotos;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"发布游记";
    account = [AccountModel account];
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn sizeToFit];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    saveBtn.userInteractionEnabled = NO;
    [saveBtn setTitleColor:lever2Color forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn sizeToFit];
    [leftBtn setImage:[UIImage imageNamed:@"icon_back_iphone"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollerContentSizeHeight.constant = SCREEN_HEIGHT;
    [_contentLabel becomeFirstResponder];
    _image3.hidden = YES;
    _image4.hidden = YES;
    _image5.hidden = YES;
    _image6.hidden = YES;
    _image7.hidden = YES;
    _image8.hidden = YES;
    _image9.hidden = YES;

}

- (IBAction)SelectPhoto:(id)sender {
    
    //当前点击的对象
    UIButton *button = (UIButton *)sender;
    
    NSLog(@"%@",button.currentBackgroundImage);
    if (button.selected == YES || button.currentBackgroundImage == nil) {
    
        ZZPhotoController *photoController = [[ZZPhotoController alloc]init];
        photoController.selectPhotoOfMax = 9 - self.selectedPhotos.count;
        [photoController showIn:self result:^(id responseObject){
            NSArray *array = (NSArray *)responseObject;
            
            if (array.count > 0) {
                button.selected = NO;
            }
            
            for (int i = 0; i<array.count; i++) {
                
                UIButton *btn = [_scrollView viewWithTag:100+i+self.selectedPhotos.count];
                btn.hidden = NO;
                UIImage *newImage = [Uitils imageWithImage:array[i] scaledToSize:CGSizeMake(120, 120)];
                [btn setBackgroundImage:newImage forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor clearColor];
                
            }
            
            [self.selectedPhotos addObjectsFromArray:array];
            if (self.selectedPhotos.count < 9) {
                UIButton *addBtn = [_scrollView viewWithTag:100+self.selectedPhotos.count];
                addBtn.hidden = NO;
                addBtn.backgroundColor = [UIColor clearColor];
                addBtn.selected = YES;
                [addBtn setBackgroundImage:[UIImage imageNamed:@"icon_add_poto_iphone"] forState:UIControlStateNormal];
            }
        }];
        
    }else {
        
        NSMutableArray *showPhotos = [NSMutableArray array];
        for (int i = 0; i<self.selectedPhotos.count; i++) {
            
            MWPhoto *p = [[MWPhoto alloc]initWithImage:self.selectedPhotos[i]];
            [showPhotos addObject:p];
        }
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc]initWithPhotos:showPhotos];
        browser.delegate = self;
        browser.displayActionButton = YES; // 分享按钮
        browser.displayNavArrows = NO; // 是否在工具栏显示左和右导航箭头 (defaults to NO)
        browser.alwaysShowControls = NO ; // 一直显示导航栏
        [browser setCurrentPhotoIndex:button.tag-100];
        [self.navigationController pushViewController:browser animated:YES];
    }

}


#pragma mark MWPhotoBrowserDelegate
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser deletePhoto:(NSUInteger)index {
    
    NSLog(@"%ld",index);
    [self.selectedPhotos removeObjectAtIndex:index];
    [self refreshPhoto:index];
    
}

- (void)refreshPhoto:(NSUInteger)index {
    
    for (int i = 0; i<9; i++) {
        UIButton *button = [_scrollView viewWithTag:100+i];
        
        if (i< self.selectedPhotos.count) {
            
            UIImage *newImage = [Uitils imageWithImage:self.selectedPhotos[i] scaledToSize:CGSizeMake(120, 120)];
            [button setBackgroundImage:newImage forState:UIControlStateNormal];
            button.selected = NO;
            
        }else {
        
            button.hidden = YES;
        }
    }
    
    UIButton *addBtn = [_scrollView viewWithTag:self.selectedPhotos.count+100];
    addBtn.hidden = NO;
    addBtn.backgroundColor = [UIColor clearColor];
    addBtn.selected = YES;
    [addBtn setBackgroundImage:[UIImage imageNamed:@"icon_add_poto_iphone"] forState:UIControlStateNormal];
}

- (void)saveAction {
    
    if (_contentLabel.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请说点什么吧"];
        return;
    }

    if (self.selectedPhotos.count > 0) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSMutableArray      *imagekeys = [NSMutableArray array];
        for (int i = 0; i<self.selectedPhotos.count; i++) {
            NSString *key = [NSString stringWithFormat:@"%@%@%d",account.id,[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]],i];
            [dic setValue:self.selectedPhotos[i] forKey:key];
            [imagekeys addObject:key];
        }
        
        [[HUDConfig shareHUD] alwaysShow];
        
        [[PostImageTool shareTool]QiniuPostImages:dic Success:^{
            NSString *imageString = [imagekeys componentsJoinedByString:@","];
            self.params.photoUrl = imageString;
            self.params.content = _contentLabel.text;
            
            NSLog(@"%@",self.params.mj_keyValues);
            [KSMNetworkRequest postRequest:KAddTravelNotes params:self.params.mj_keyValues success:^(id responseObj) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"%@",dic);
                [[HUDConfig shareHUD] Tips:[dic objectForKey:@"msg"] delay:DELAY];
                
                if (![dic isKindOfClass:[NSNull class]]) {
                    
                    if ([[dic objectForKey:@"status"] isEqualToString:@"success"]) {
                        TravelNote *model = [TravelNote mj_objectWithKeyValues:[dic objectForKey:@"data"]];
                        self.callBack(model);
                        [self.navigationController popViewControllerAnimated:YES];   
                    }
                }
            } failure:^(NSError *error) {
                [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
                
            } type:1];
            
        } failure:^(NSError *error) {
            
            [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
        }];
    }
}

- (void)addNewTravelNote:(ReleaseCallBlock)block {

    _callBack = block;
}


- (void)back{
    
    //通过保存按钮的交互来盘点是否修改了信息，提示信息，是直接退出，还是继续编辑
    if (saveBtn.userInteractionEnabled == YES) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"还未保存，是否退出" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"继续上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {

    saveBtn.userInteractionEnabled = YES;
    [saveBtn setTitleColor:lever1Color forState:UIControlStateNormal];
}


@end
