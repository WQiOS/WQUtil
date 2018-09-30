//
//  HttpError.m
//  Lift-Wuye
//
//  Created by zhangmin on 2017/9/25.
//  Copyright © 2017年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "HttpError.h"

@implementation HttpError

-(instancetype)initWithCode:(NSInteger)code Message:(NSString*)message
{
    self = [super init];
    if (self) {
        self.code = code;
        self.message = message;
    }
    return self;
}

@end
