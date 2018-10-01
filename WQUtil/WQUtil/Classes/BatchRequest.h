//
//  BatchRequest.h
//  Lift-Wuye
//
//  Created by zhangmin on 2017/9/20.
//  Copyright © 2017年 浙江再灵科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"

@protocol BatchRequestDelegate <NSObject>

-(void)requestDidAllFinished:(NSArray<HttpRequest*> *)requests;
-(void)requestDidFaliured:(HttpRequest *)requests;

@end

@interface BatchRequest : NSObject

@property (nonatomic,weak) id<BatchRequestDelegate> delegate;

-(instancetype)initWithRequests:(NSArray<HttpRequest *> *)requests;

-(void)addRequests:(NSArray<HttpRequest *> *)requests;

-(void)start;

-(void)cancel;

@end
