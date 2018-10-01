//
//  HttpRequest.h
//  Lift-Wuye
//
//  Created by zhangmin on 2017/9/20.
//  Copyright © 2017年 浙江再灵科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpError.h"
#import <AFNetworking/AFNetworking.h>


NS_ASSUME_NONNULL_BEGIN


/**
 *  Handler处理成功时调用的Block
 */
typedef void (^Success)(id response);

/**
 *  Handler处理失败时调用的Block
 */
typedef void (^Fail)(HttpError *error);

/**
 * Handler处理进度时调用的Block
 */
typedef void (^Progress)(NSProgress * _Nullable progress);


/**
 *  Handler处理上传multipart/form-data时调用的Block
 *
 */
typedef void (^AFConstructingBlock)(id<AFMultipartFormData> _Nullable formData);


@protocol HttpRequestDelegate <NSObject>

- (void)requestDidSuccess:(id)response;

- (void)requestDidFail:(HttpError *)error;

- (void)requestWhenRefreshProgress:(NSProgress * _Nullable)progress;

@end



typedef NS_ENUM(NSUInteger , RequestMethod) {
    GET,
    POST,
    PUT,
    DETELE,
};

typedef NS_ENUM(NSUInteger, RequestType) {
    Normal,
    Upload,
    download,
};

@interface HttpRequest : NSObject

@property (nonatomic,assign) BOOL isWeb;

@property (nonatomic,strong) NSString *url;

@property (nonatomic,strong) NSMutableDictionary *parameters;

@property (nonatomic,strong) NSURLSessionTask *sessionTask;

@property (nonatomic,assign) RequestMethod requestMethod;

@property (nonatomic,assign) RequestType requestType;


@property (nonatomic,strong) id responseObj;
@property (nonatomic,strong) HttpError *error;
@property (nonatomic, strong) NSProgress *progressObj;


@property (nonatomic, copy) Success successBlock;
@property (nonatomic, copy) Fail failBlock;
@property (nonatomic, copy) Progress progressBlock;
@property (nonatomic, weak) id<HttpRequestDelegate> delegate;

//上传文件MultipartFormData
@property (nonatomic, copy) AFConstructingBlock constructingBodyBlock;
//下载文件地址
@property (nonatomic, strong) NSString *downloadPath;


- (__kindof HttpRequest *(^)(id<HttpRequestDelegate> delegate))setDelegate;

- (__kindof HttpRequest *(^)(Success))success;
- (__kindof HttpRequest *(^)(Fail))fail;
- (__kindof HttpRequest *(^)(Progress))progress;

-(void)sendRequest;

-(void)cancelRequest;

-(void)requestWillStart;

-(void)requestDidEnd;


-(void)setHeaderValue:(NSString *)obj Key:(NSString *)key;

-(void)handleResponse:(id _Nullable)responseObject Error:(HttpError  * _Nullable)error;

-(void)handleProgress:(NSProgress *)progress;

@end

NS_ASSUME_NONNULL_END

