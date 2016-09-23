//
//  KSMNetworkRequest.m
//
//  Created by ksm on 15/11/10.
//  Copyright © 2015年 GreatGate. All rights reserved.
//

#import "KSMNetworkRequest.h"
#import "AFNetworking.h"

@implementation KSMNetworkRequest

+ (void)getRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler type:(NSInteger)type{
    
    //网络不可用
    if (![self checkNetworkStatus]) {
        successHandler(nil);
        failureHandler(nil);
        return;
    }

//    AFHTTPRequestOperationManager *manager = [self getRequstManager];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 请求超时设定
    session.requestSerializer.timeoutInterval = 20;
//
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer.timeoutInterval = 20;
    
    if (type == 1) {
        session.requestSerializer = [AFJSONRequestSerializer serializer];//请求
        session.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
        [session.requestSerializer setValue:@"Connection" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
        
    }else {
    
        //传入json格式数据，不写则普通post
        session.requestSerializer = [AFJSONRequestSerializer serializer];
        session.responseSerializer = [AFJSONResponseSerializer serializer];
        [session.requestSerializer setValue:@"Connection" forHTTPHeaderField:@"application/json;charset=UTF-8"];
    }

    [session GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successHandler(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        KSMLog(@"------请求失败-------%@",error);
        failureHandler(error);
    }];

    
//    [session GET:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        
//        NSLog(@"statusCode = %ld",(long)operation.response.statusCode);
//        successHandler(responseObject);
//
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        KSMLog(@"------请求失败-------%@",error);
//        failureHandler(error);
//    }];
}


+ (void)postRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler type:(NSInteger)type{
    
    if (![self checkNetworkStatus]) {
        successHandler(nil);
        failureHandler(nil);
        return;
    }
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 请求超时设定
    session.requestSerializer.timeoutInterval = 20;
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer.timeoutInterval = 20;
    
    //上传照片name
    if (type == 1) {
        session.responseSerializer = [AFHTTPResponseSerializer serializer];

    
        //传入json格式数据，不写则普通post
        session.requestSerializer = [AFHTTPRequestSerializer serializer];
//
//        //默认返回JSON类型（可以不写）
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        //设置返回类型
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        
    //1.上传第一部分资料 2.上传身份证认证
    }else if (type == 2) {
        
        //直接转成字典，不需要解析了
        session.requestSerializer = [AFJSONRequestSerializer serializer];//请求
        session.responseSerializer = [AFJSONResponseSerializer serializer];//响应
        //1.登录－2.token登录 3.获取城市列表
    }else {
        
        [session.requestSerializer setValue:@"Connection" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
    }
    
    
    [session POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successHandler(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        KSMLog(@"------请求失败-------%@",error);
        failureHandler(error);
    }];
//    // 请求超时设定
//    session.requestSerializer.timeoutInterval = 60;
//    [session POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"statusCode = %ld",(long)operation.response.statusCode);
//        successHandler(responseObject);
//        
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        
//        KSMLog(@"------请求失败-------%@",error);
//        failureHandler(error);
//    }];
}

//+ (void)putRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler {
//    
//    if (![self checkNetworkStatus]) {
//        successHandler(nil);
//        failureHandler(nil);
//        return;
//    }
//    
//    AFHTTPRequestOperationManager *manager = [self getRequstManager];
//    
//    [manager PUT:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        
//        successHandler(responseObject);
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        KSMLog(@"------请求失败-------%@",error);
//        failureHandler(error);
//    }];
//}
//
//+ (void)deleteRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler {
//    
//    if (![self checkNetworkStatus]) {
//        successHandler(nil);
//        failureHandler(nil);
//        return;
//    }
//
//    AFHTTPRequestOperationManager *manager = [self getRequstManager];
//    
//    [manager DELETE:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        
//        successHandler(responseObject);
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        KSMLog(@"------请求失败-------%@",error);
//        failureHandler(error);
//    }];
//}
//
///**
// 下载文件，监听下载进度
// */
//+ (void)downloadRequest:(NSString *)url successAndProgress:(progressBlock)progressHandler complete:(responseBlock)completionHandler {
//    
//    if (![self checkNetworkStatus]) {
//        progressHandler(0, 0, 0);
//        completionHandler(nil, nil);
//        return;
//    }
//    
//    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    NSProgress *kProgress = nil;
//    
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&kProgress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        
//        NSURL *documentUrl = [[NSFileManager defaultManager] URLForDirectory :NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        
//        return [documentUrl URLByAppendingPathComponent:[response suggestedFilename]];
//        
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error){
//        if (error) {
//            KSMLog(@"------下载失败-------%@",error);
//        }
//        completionHandler(response, error);
//    }];
//    
//    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
//        
//        progressHandler(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
//        
//    }];
//    [downloadTask resume];
//}
//
//
//
///**
// *  发送一个POST请求
// *  @param fileConfig 文件相关参数模型
// *  @param success 请求成功后的回调
// *  @param failure 请求失败后的回调
// *  无上传进度监听
// */
//+ (void)updateRequest:(NSString *)url params:(NSDictionary *)params fileConfig:(XLFileConfig *)fileConfig success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler {
//    
//    if (![self checkNetworkStatus]) {
//        successHandler(nil);
//        failureHandler(nil);
//        return;
//    }
//
//    AFHTTPRequestOperationManager *manager = [self getRequstManager];
//    
//    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//        [formData appendPartWithFileData:fileConfig.fileData name:fileConfig.name fileName:fileConfig.fileName mimeType:fileConfig.mimeType];
//        
//    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        
//        successHandler(responseObject);
//        
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        KSMLog(@"------上传失败-------%@",error);
//        failureHandler(error);
//    }];
//}
//
//
///**
// 上传文件，监听上传进度
// */
//+ (void)updateRequest:(NSString *)url params:(NSDictionary *)params fileConfig:(XLFileConfig *)fileConfig successAndProgress:(progressBlock)progressHandler complete:(responseBlock)completionHandler {
//
//    if (![self checkNetworkStatus]) {
//        progressHandler(0, 0, 0);
//        completionHandler(nil, nil);
//        return;
//    }
//    
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//        [formData appendPartWithFileData:fileConfig.fileData name:fileConfig.name fileName:fileConfig.fileName mimeType:fileConfig.mimeType];
//        
//    } error:nil];
//    
//    //获取上传进度
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        
//        progressHandler(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
//        
//    }];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        completionHandler(responseObject, nil);
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        
//        completionHandler(nil, error);
//        if (error) {
//            KSMLog(@"------上传失败-------%@",error);
//        }
//    }];
//    
//    [operation start];
//}
//
//+ (AFHTTPRequestOperationManager *)getRequstManager {
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
////    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
//    [manager.requestSerializer setValue:@"Connection" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
//    // 请求超时设定
//    manager.requestSerializer.timeoutInterval = 10;
////    manager.securityPolicy.allowInvalidCertificates = YES;
//    
//    return manager;
//}
//

/**
 监控网络状态
 */
+ (BOOL)checkNetworkStatus {
    
    __block BOOL isNetworkUse = YES;
    
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown) {
            isNetworkUse = YES;
        } else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            isNetworkUse = YES;
        } else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            isNetworkUse = YES;
        } else if (status == AFNetworkReachabilityStatusNotReachable){
            // 网络异常操作
            isNetworkUse = NO;
            KSMLog(@"网络异常,请检查网络是否可用！");
        }
    }];
    [reachabilityManager startMonitoring];
    return isNetworkUse;
}

@end





/**
 *  用来封装上传文件数据的模型类
 */
@implementation XLFileConfig

+ (instancetype)fileConfigWithfileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    return [[self alloc] initWithfileData:fileData name:name fileName:fileName mimeType:mimeType];
}

- (instancetype)initWithfileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    if (self = [super init]) {
    
        _fileData = fileData;
        _name = name;
        _fileName = fileName;
        _mimeType = mimeType;
    }
    return self;
}

@end

