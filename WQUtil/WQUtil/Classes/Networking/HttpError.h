//
//  HttpError.h
//  Lift-Wuye
//
//  Created by zhangmin on 2017/9/25.
//  Copyright © 2017年 浙江再灵科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpError : NSObject

@property (nonatomic,assign) NSInteger code;
@property (nonatomic,strong) NSString *message;

-(instancetype)initWithCode:(NSInteger)code Message:(NSString*)message;

@end
