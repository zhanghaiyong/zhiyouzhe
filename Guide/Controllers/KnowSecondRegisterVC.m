//  KnowFirstRegisterVC.m
//  Guide
//
//  Created by ksm on 16/4/8.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "KnowSecondRegisterVC.h"
//#import "ZZPhotoController.h"
#import "MWPhotoBrowser.h"
#import "PostImageTool.h"
#import "PhotoNamesParams.h"
#import "KnowThreeRegisterVC.h"
#import "PageInfo.h"
#import "UIImage+HYExt.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define ORIGINAL_MAX_WIDTH 640.0f
@interface KnowSecondRegisterVC ()
{

    AccountModel *account;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageV1;
@property (weak, nonatomic) IBOutlet UIImageView *imageV2;
@property (weak, nonatomic) IBOutlet UIImageView *imageV3;
@property (weak, nonatomic) IBOutlet UIImageView *imageV4;
@property (weak, nonatomic) IBOutlet UIImageView *imageV5;
@property (weak, nonatomic) IBOutlet UIImageView *imageV6;
@property (weak, nonatomic) IBOutlet UIImageView *imageV7;
@property (weak, nonatomic) IBOutlet UIImageView *imageV8;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@property (nonatomic,strong)NSMutableArray *selectedPhotos;
@property (nonatomic,strong)PhotoNamesParams *params;

@end

@interface KnowSecondRegisterVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate,MWPhotoBrowserDelegate>
{

    UIButton *saveBtn;
    UIImageView *touchImage;
    NSInteger index;
}
@end

@implementation KnowSecondRegisterVC


-(PhotoNamesParams *)params {

    if (_params == nil) {
        
        PhotoNamesParams *params = [[PhotoNamesParams alloc]init];
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
    
    account = [AccountModel account];
    [self setNavigationLeft:@"icon_back_iphone"];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhotos:)];
    [_imageV1 addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhotos:)];
    [_imageV2 addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhotos:)];
    [_imageV3 addGestureRecognizer:tap3];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhotos:)];
    [_imageV4 addGestureRecognizer:tap4];
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhotos:)];
    [_imageV5 addGestureRecognizer:tap5];
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhotos:)];
    [_imageV6 addGestureRecognizer:tap6];
    UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhotos:)];
    [_imageV7 addGestureRecognizer:tap7];
    UITapGestureRecognizer *tap8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhotos:)];
    [_imageV8 addGestureRecognizer:tap8];
    
//    if (self.isEdit) {
    
        self.title = @"我的相册";
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
        _nextButton.hidden = YES;
        
        if (account.photoPaths.length != 0) {
            NSString *path = [NSString stringWithFormat:@"%@",account.photoPaths];
            NSArray *photos = [path componentsSeparatedByString:@","];
            __block  int j=0;
            for (int i = 0; i<photos.count; i++) {
                UIImageView *imageV = [self.view viewWithTag:100+i];
                imageV.highlighted = YES;
                    
                    [Uitils cacheImage:photos[i] withImageV:imageV withPlaceholder:@"icon_add_poto_iphone" completed:^(UIImage *image) {
                        
                        imageV.layer.borderColor = MainColor.CGColor;
                        imageV.layer.borderWidth = 1;
                        if (j<photos.count) {

                                [self.selectedPhotos addObject:image];
                                j++;
                       
                            
                        }
                        
                        
                        NSLog(@"dfs = %ld  %ld",self.selectedPhotos.count,photos.count);
                    }];
                
            }
        }
        
//    }else {
//        self.title = @"上传照片";
//        [self.navigationItem setHidesBackButton:TRUE animated:NO];
//    }
//    
}

- (void)takePhotos:(UITapGestureRecognizer *)gesture {
//    UIImageView *touchImage = (UIImageView *)gesture.view;
    touchImage = (UIImageView *)gesture.view;
    index = touchImage.tag;
    //当前点击的对象
//    UIImageView *touchImage = (UIImageView *)gesture.view;
//     空白图片
    if (!touchImage.highlighted) {
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"从相册中选取", nil];
        [choiceSheet showInView:self.view];
        saveBtn.userInteractionEnabled = YES;
        [saveBtn setTitleColor:lever1Color forState:UIControlStateNormal];

//        ZZPhotoController *photoController = [[ZZPhotoController alloc]init];
//        photoController.selectPhotoOfMax = 8 - self.selectedPhotos.count;
//        [photoController showIn:self result:^(id responseObject){
//        NSArray *array = (NSArray *)responseObject;
//        
//        for (int i = 0; i<array.count; i++) {
//            
//            UIImageView *imageView = [self.view viewWithTag:100+i+self.selectedPhotos.count];
//            UIImage *newImage = [Uitils imageWithImage:array[i] scaledToSize:CGSizeMake(120, 120)];
//            imageView.image = newImage;
//            imageView.highlighted = YES;
//        }
//            
//            [self.selectedPhotos addObjectsFromArray:array];
//            
//        }];
//        上面有图片
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
        [browser setCurrentPhotoIndex:touchImage.tag-100];
        [self.navigationController pushViewController:browser animated:YES];
    }
    
}

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
//    touchImage.image = editedImage;
    [self.selectedPhotos addObject:editedImage];
    saveBtn.userInteractionEnabled = YES;
    [saveBtn setTitleColor:lever1Color forState:UIControlStateNormal];
    UIImageView *imageView = [self.view viewWithTag:index];
    imageView.highlighted = YES;
    [self updatePhoto];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}
- (void)updatePhoto {
    for (int i = 0; i<8; i++) {
        UIImageView *imageView = [self.view viewWithTag:100+i];
        imageView.image = [UIImage imageNamed:@"icon_add_poto_iphone"];
        imageView.highlighted = NO;
    }
    for (int i=0; i<self.selectedPhotos.count; i++) {
        UIImageView *imageV = [self.view viewWithTag:100+i];
        imageV.highlighted = YES;
        imageV.image = self.selectedPhotos[i];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}



#pragma mark MWPhotoBrowserDelegate
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser deletePhoto:(NSUInteger)index {

    NSLog(@"%ld",index);
    if (!saveBtn.userInteractionEnabled) {
        saveBtn.userInteractionEnabled = YES;
        [saveBtn setTitleColor:lever1Color forState:UIControlStateNormal];
    }
    [self.selectedPhotos removeObjectAtIndex:index];
    [self refreshPhoto:index];
    
    
}

- (void)refreshPhoto:(NSUInteger)index {

    for (int i = 0; i<8; i++) {
        UIImageView *imageView = [self.view viewWithTag:100+i];
        imageView.image = [UIImage imageNamed:@"icon_add_poto_iphone"];
        imageView.highlighted = NO;
    }
    
    
    for (int i = 0; i<self.selectedPhotos.count; i++) {
        
        NSLog(@"%ld",self.selectedPhotos.count);
        UIImageView *imageView = [self.view viewWithTag:100+i];
        UIImage *newImage = [Uitils imageWithImage:self.selectedPhotos[i] scaledToSize:CGSizeMake(120, 120)];
        imageView.image = newImage;
        imageView.highlighted = YES;
    }
}


- (void)saveAction {

    [self postData];
}

- (IBAction)nextAction:(id)sender {

    [self postData];
}

- (void)postData {
    NSArray *array = self.view.subviews;
    for (UIView *view in array) {
        if ([view isKindOfClass:[UIImageView class]]) {
            NSLog(@"view is%@",view);
        }
    }
    
    if (self.selectedPhotos.count < 6) {
        [[HUDConfig shareHUD] Tips:@"请上传至少6张照片" delay:DELAY];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableArray      *imagekeys = [NSMutableArray array];
    for (int i = 0; i<self.selectedPhotos.count; i++) {
        NSString *key = [NSString stringWithFormat:@"%@photo%d",account.id,i];
        [dic setValue:self.selectedPhotos[i] forKey:key];
        [imagekeys addObject:key];
    }
    
    [[HUDConfig shareHUD] alwaysShow];
    
    [[PostImageTool shareTool]QiniuPostImages:dic Success:^{
        NSString *imageString = [imagekeys componentsJoinedByString:@","];
        self.params.piclist = imageString;
        NSLog(@"%@",self.params.mj_keyValues);
        [KSMNetworkRequest postRequest:KPhotosName params:self.params.mj_keyValues success:^(id responseObj) {

            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"dic %@",dic);
            [[HUDConfig shareHUD] Tips:[dic objectForKey:@"msg"] delay:DELAY];
            
            if (![dic isKindOfClass:[NSNull class]]) {
                if ([[dic objectForKey:@"status"] isEqualToString:@"success"]) {
                    account.photoPaths = imageString;
                    NSLog(@"imageString is %@",imageString);
                    [AccountModel saveAccount:account];
                    [[HUDConfig shareHUD] SuccessHUD:@"上传成功" delay:DELAY];
                    
                    self.block(self.selectedPhotos);
                    [self.navigationController popViewControllerAnimated:YES];
                    
//                    //没有身份认证
//                    if (account.realName.length == 0) {
//                        
//                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//                        KnowThreeRegisterVC *KnowThree = [story instantiateViewControllerWithIdentifier:@"KnowThreeRegisterVC"];
//                        [self.navigationController pushViewController:KnowThree animated:YES];
//                        return;
//                    }   
//                    UITabBarController *TabBar = [PageInfo pageControllers];
//                    [self presentViewController:TabBar animated:YES completion:nil];
            }
            }

        } failure:^(NSError *error) {
            
            [[HUDConfig shareHUD] ErrorHUD:error.localizedDescription delay:DELAY];
            
        } type:1];
        
    } failure:^(NSError *error) {
        
    }];
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

- (void)returnPhotos:(setPhotoBlock)block {

    _block = block;
}

@end
