//
//  NSDictionary+value.h
//  YunTiReg
//
//  Created by 周夏赛 on 2016/10/14.
//  Copyright © 2016年 浙江再灵科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (value)

- (NSString *)stringForKey:(NSString *)key;

- (NSNumber *)numForKey:(NSString *)key;

- (NSArray *)arrayForKey:(NSString *)key;

- (NSMutableArray *)mutableArrayForKey:(NSString *)key;

- (NSDictionary *)dictionaryForKey:(NSString *)key;

- (NSMutableDictionary *)mutableDictionaryForKey:(NSString *)key;

- (NSDate *)dateForKey:(NSString *)key;

//MARK: - 将参数字典转换成字符串
- (NSString *)cacheKeyForYYCache;

@end
