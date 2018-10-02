//
//  BatchRequest.m
//  Lift-Wuye
//
//  Created by zhangmin on 2017/9/20.
//  Copyright © 2017年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "BatchRequest.h"

@interface BatchRequest()

@property (nonatomic,strong) NSMutableArray<HttpRequest*> *apiRequests;

@end

@implementation BatchRequest

-(NSMutableArray *)apiRequests
{
    if (!_apiRequests) {
        _apiRequests = [NSMutableArray new];
        
    }
    return _apiRequests;
}

-(instancetype)initWithRequests:(NSArray<HttpRequest *> *)requests
{
    self = [super init];
    if (self) {
        [self addRequests:requests];
    }
    return self;
}

-(void)addRequests:(NSArray<HttpRequest *> *)requests
{
    [self.apiRequests addObjectsFromArray:requests];
}


-(void)start
{
    NSUInteger count = self.apiRequests.count;
    if (!count) {
        return;
    }
    
    dispatch_group_t group = dispatch_group_create();
    
    
    [self.apiRequests enumerateObjectsUsingBlock:^(HttpRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.success(^(id obj){
            
            dispatch_group_leave(group);
    
        }).fail(^(HttpError *error){
            
            if ([self.delegate respondsToSelector:@selector(requestDidFaliured:)]) {
                [self.delegate requestDidFaliured:obj];
            }
            dispatch_group_leave(group);
        });
        
        dispatch_group_enter(group);
        [obj sendRequest];
        
        
    }];
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestDidAllFinished:)]) {
            [self.delegate requestDidAllFinished:[self.apiRequests copy]];
        }
        
        
    });
    
}

-(void)cancel
{
    
}

@end
