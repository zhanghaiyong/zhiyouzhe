//
//  PostImageTool.h
//  Guide
//
//  Created by ksm on 16/5/5.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostImageTool : NSObject

+(PostImageTool *)shareTool;
/**
 *  上传单张图片
 *
 *  @param image        需要上传的图片
 *  @param imageKey     图片对应的key
 *  @param successBlock 上传成功的回调
 *  @param failureBlock 上传失败的回调
 */
- (void)QiniuPostImage:(UIImage *)image imageKey:(NSString *)imageKey Success:(void(^)())successBlock failure:(void(^)(NSError *error))failureBlock;

/**
 *  上传多张图片
 *
 *  @param data         需要上传的图片 ps：通过字典来传多张图片，value为图片，key为图片对应的key
 *  @param successBlock 上传成功的回调
 *  @param failureBlock 上传失败的回调
 */
- (void)QiniuPostImages:(NSDictionary *)data Success:(void(^)())successBlock failure:(void(^)(NSError *error))failureBlock;

@end
