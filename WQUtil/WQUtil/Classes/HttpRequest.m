//
//  HttpRequest.m
//  Lift-Wuye
//
//  Created by zhangmin on 2017/9/20.
//  Copyright © 2017年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "HttpRequest.h"
#import "HttpManager.h"


@interface HttpRequest()


@end


@implementation HttpRequest

- (instancetype)init {
    if (self = [super init]) {
        self.requestMethod = POST;
        self.requestType = Normal;
        self.parameters = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)sendRequest
{
    [self requestWillStart];
    if (self.isWeb) {
        [[HttpManager DefaultWebManager] sendRequst:self];
    }
    else {
        [[HttpManager DefaultManager] sendRequst:self];
    }
}

-(void)cancelRequest
{
    [self.sessionTask cancel];
}

-(void)setHeaderValue:(NSString *)obj Key:(NSString *)key
{
    if (self.isWeb) {
        [[HttpManager DefaultWebManager].requestSerializer setValue:obj forHTTPHeaderField:key];
    }
    else {
        [[HttpManager DefaultManager].requestSerializer setValue:obj forHTTPHeaderField:key];
    }
}

-(void)handleResponse:(id)responseObject Error:(HttpError *)error
{
    [self requestDidEnd];
    if (error) {
        
        self.error = error;
        if(self.delegate && [self.delegate respondsToSelector:@selector(requestDidFail:)]){
            [self.delegate requestDidFail:error];
            return;
        }
        if (self.failBlock) {
            self.failBlock(error);
        }
        
    }
    
    if (responseObject) {
        
        self.responseObj = responseObject;
        if(self.delegate && [self.delegate respondsToSelector:@selector(requestDidSuccess:)]){
            [self.delegate requestDidSuccess:responseObject];
            return;
        }
        if (self.successBlock) {
            self.successBlock(responseObject);
        }
    }
}


- (void)handleProgress:(NSProgress *)progress{
    
    if (progress) {
     
        self.progressObj = progress;
        if(self.delegate && [self.delegate respondsToSelector:@selector(requestWhenRefreshProgress:)]){
            [self.delegate requestWhenRefreshProgress:progress];
            return;
        }
        if (self.progressBlock) {
            self.progressBlock(progress);
        }
    }
}


- (__kindof HttpRequest *(^)(id<HttpRequestDelegate> delegate))setDelegate {
    return ^HttpRequest* (id<HttpRequestDelegate> delegate) {
        self.delegate = delegate;
        return self;
    };
}

-(__kindof HttpRequest *(^)(Success))success
{

    return ^HttpRequest* (Success successblock) {
        self.successBlock = successblock;
        return self;
    };
}

-(__kindof HttpRequest *(^)(Fail))fail
{
    return ^HttpRequest* (Fail failBlock) {
        self.failBlock = failBlock;
        return self;
    };
}


- (__kindof HttpRequest * (^)(Progress))progress{
    return ^HttpRequest* (Progress progressBlock) {
        self.progressBlock = progressBlock;
        return self;
    };
}


-(void)requestWillStart
{
    
}


-(void)requestDidEnd
{

}


@end
