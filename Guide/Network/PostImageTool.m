//
//  PostImageTool.m
//  Guide
//
//  Created by ksm on 16/5/5.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import "PostImageTool.h"
#import <QiniuSDK.h>
#import "KSMNetworkRequest.h"
@implementation PostImageTool

+(PostImageTool *)shareTool {

    static PostImageTool *tool = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        tool = [[PostImageTool alloc]init];
    });
    return tool;
}


- (NSData *)dataWithImage:(UIImage *)image {
    
    NSData *uploadData = UIImageJPEGRepresentation(image, 1);
    
    //这里对大图片做了压缩，不需要的话下面直接传uploadData就好
    NSData *cutdownData = nil;
    if (uploadData.length < 9999) {
        cutdownData = UIImageJPEGRepresentation(image, 1.0);
    } else if (uploadData.length < 99999) {
        cutdownData = UIImageJPEGRepresentation(image, 0.6);
    } else {
        cutdownData = UIImageJPEGRepresentation(image, 0.3);
    }
    return cutdownData;
}

- (void)QiniuPostImage:(UIImage *)image imageKey:(NSString *)imageKey Success:(void(^)())successBlock failure:(void(^)(NSError *error))failureBlock {
    
    [KSMNetworkRequest getRequest:KGetToken params:@{@"fileId":imageKey} success:^(id responseObj) {
    
       NSString *token = [[NSString alloc]initWithData:responseObj encoding:NSUTF8StringEncoding];
    
        KSMLog(@"token = %@ imageKey = %@ image = %@",token,imageKey,image);
        NSData *imageData = [self dataWithImage:image];
//        NSLog(@"imageData = %@",imageData);
        
        QNUploadManager *upManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
        [upManager putData:imageData
                   key:imageKey token:token
                   complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      
                      if (!info.error) {
                          
                          successBlock();
                      }
//                      KSMLog(@"NSDictionary = %@", info);
                  } option:nil];
        
    } failure:^(NSError *error) {
    
        failureBlock(error);
    } type:1];
}

- (void)QiniuPostImages:(NSDictionary *)data Success:(void(^)())successBlock failure:(void(^)(NSError *error))failureBlock {

    //keys为image
    //values为key
    NSArray *keys = [[NSArray alloc]initWithArray:data.allKeys];
    NSArray *values = [[NSArray alloc]initWithArray:data.allValues];
    
    //1.获得全局的并发队列
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (int i = 0; i<keys.count; i++) {
        
        dispatch_async(queue, ^{
            
            [self QiniuPostImage:values[i] imageKey:keys[i] Success:^{
                
                if (i==keys.count-1) {
                    successBlock();
                }
               
            } failure:^(NSError *error) {
                
                failureBlock(error);
            }];
            
        });
    }
}

@end
