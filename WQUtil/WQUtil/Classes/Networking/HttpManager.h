//
//  HttpManager.h
//  Lift-Wuye
//
//  Created by zhangmin on 2017/9/20.
//  Copyright © 2017年 浙江再灵科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
@class HttpRequest;

@interface HttpManager : AFHTTPSessionManager

+(instancetype)DefaultManager;

+(instancetype)DefaultWebManager;

- (void)sendRequst:(HttpRequest*)request;

@end
