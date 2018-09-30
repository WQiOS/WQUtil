//
//  HttpManager.m
//  Lift-Wuye
//
//  Created by zhangmin on 2017/9/20.
//  Copyright © 2017年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "HttpManager.h"
#import "HttpRequest.h"
#import "NSDictionary+value.h"
#import <YYModel/YYModel.h>

#ifdef DEBUG

#define HLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);

#else

#define HLog(format, ...)

#endif

@implementation HttpManager

+ (instancetype)DefaultManager {
    static HttpManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 1000)];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",@"text/javascript",@"application/x-javascript",@"text/plain",nil];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    });
    return manager;
}

+ (instancetype)DefaultWebManager {
    static HttpManager * webManager = nil;
    static dispatch_once_t onceTokenWeb;
    dispatch_once(&onceTokenWeb, ^{
        webManager = [self manager];
        webManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        webManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",@"text/javascript",@"application/x-javascript",@"text/plain",nil];
        
        //    [webManager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    });
    
    return webManager;
}

- (AFSecurityPolicy *)customSecurityPolicy {
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"certificate" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:path];
    NSSet *set = [NSSet setWithArray:@[certData]];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [securityPolicy setPinnedCertificates:set];
    
    return securityPolicy;
    
}

- (void)sendRequst:(HttpRequest*)request {
    NSString *method = [self requestMethodName:request];
    
    switch (request.requestType) {
        case Normal:
        {
            request.sessionTask = [self dataTaskWithRequest:request method:method];
            break;
        }
        case Upload:
        {
            request.sessionTask = [self uploadTaskWithRequest:request method:method];
            break;
        }
        case download:
        {
            request.sessionTask = [self downloadTaskWithRequest:request method:method];
            break;
        }
    }
    
    if (request.sessionTask) {
        [request.sessionTask resume];
    }
}

- (NSURLSessionTask *)dataTaskWithRequest:(HttpRequest *)request method:(NSString *)method {
    
    NSError * __autoreleasing requestSerializationError = nil;
    NSMutableURLRequest *urlRequest = [self.requestSerializer requestWithMethod:method URLString:request.url parameters:request.parameters error:&requestSerializationError];
    if (requestSerializationError) {
        [self handleRequest:request Fail:requestSerializationError];
        return nil;
    }
    
    return [self dataTaskWithRequest:urlRequest uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [self handleRequest:request Fail:error];
        }else{
            [self handleRequest:request Success:responseObject];
        }
    }];
}

- (NSURLSessionTask *)uploadTaskWithRequest:(HttpRequest *)request method:(NSString *)method {
    NSAssert(request.constructingBodyBlock, @"上传文件constructingBodyBlock不能为空");
    
    NSError * __autoreleasing requestSerializationError = nil;
    NSMutableURLRequest *urlRequest = [self.requestSerializer multipartFormRequestWithMethod:method URLString:request.url parameters:request.parameters constructingBodyWithBlock:request.constructingBodyBlock error:&requestSerializationError];
    
    if (requestSerializationError) {
        [self handleRequest:request Fail:requestSerializationError];
        return nil;
    }
    
    return [self dataTaskWithRequest:urlRequest uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        [self handleRequest:request Progress:uploadProgress];
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [self handleRequest:request Fail:error];
        }else{
            [self handleRequest:request Success:responseObject];
        }
    }];
}

- (NSURLSessionTask *)downloadTaskWithRequest:(HttpRequest *)request  method:(NSString *)method {
    NSAssert(request.downloadPath && request.downloadPath.length > 0, @"下载文件的目标路径downloadPath不能为空");
    
    NSError * __autoreleasing requestSerializationError = nil;
    NSMutableURLRequest *urlRequest = [self.requestSerializer requestWithMethod:method URLString:request.url parameters:request.parameters error:&requestSerializationError];
    if (requestSerializationError) {
        [self handleRequest:request Fail:requestSerializationError];
        return nil;
    }
    
    NSString *downloadPath = request.downloadPath;
    NSString *downloadTargetPath;
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:downloadPath isDirectory:&isDirectory]) {
        isDirectory = NO;
    }
    
    if (isDirectory) {
        NSString *fileName = [urlRequest.URL lastPathComponent];
        downloadTargetPath = [NSString pathWithComponents:@[downloadPath, fileName]];
    } else {
        downloadTargetPath = downloadPath;
    }
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadTargetPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:downloadTargetPath error:nil];
    }
    
    return [self downloadTaskWithRequest:urlRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        [self handleRequest:request Progress:downloadProgress];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [self handleRequest:request Success:filePath];
    }];
}


- (void)handleRequest:(HttpRequest*)request Success:(id)responseObject {
#ifdef DEBUG
    HLog(@"请求成功——url地址：%@\n请求参数：%@\n请求结果：%@",request.url,[request.parameters yy_modelDescription],[responseObject yy_modelDescription]);
#endif
    [request handleResponse:responseObject Error:nil];
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 701) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReLoginAgainForTokenIsOverTime" object:nil];
        }
    }
}

- (void)handleRequest:(HttpRequest*)request Fail:(NSError *)error {
#ifdef DEBUG
    HLog(@"请求失败——url地址：%@\n请求参数：%@\n失败结果：%@",request.url,[request.parameters yy_modelDescription],error);
#endif
    if([error.localizedDescription hasPrefix:@"未能读取数据"] || error.code == 3840)
    {
        HttpError *err = [[HttpError alloc]initWithCode:701 Message:@"返回的数据不是个json"];
        [request handleResponse:nil Error:err];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReLoginAgainForTokenIsOverTime" object:nil];
    }else{
        HttpError *err = [[HttpError alloc]initWithCode:error.code Message:error.localizedDescription];
        [request handleResponse:nil Error:err];
    }
}

- (void)handleRequest:(HttpRequest*)request Progress:(NSProgress * _Nonnull)progress {
    [request handleProgress:progress];
}

- (NSString *)requestMethodName:(HttpRequest *)request {
    switch (request.requestMethod) {
        case GET:
            return @"GET";
        case POST:
            return @"POST";
        case DETELE:
            return @"DETELE";
        case PUT:
            return @"PUT";
    }
}

@end
