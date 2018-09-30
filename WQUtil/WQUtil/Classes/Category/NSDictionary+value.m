//
//  NSDictionary+value.m
//  YunTiReg
//
//  Created by 周夏赛 on 2016/10/14.
//  Copyright © 2016年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "NSDictionary+value.h"

@implementation NSDictionary (value)

- (NSString *)stringForKey:(NSString *)key {
    id temp = [self objectForKey:key];
    if ([temp isKindOfClass:[NSString class]]) {
        return temp;
    }
    else if ([temp isKindOfClass:[NSNumber class]]) {
        return [temp stringValue];
    }
    return nil;
}

- (NSNumber *)numForKey:(NSString *)key {
    id temp = [self objectForKey:key];
    if ([temp isKindOfClass:[NSString class]]) {
        return [NSNumber numberWithDouble:[temp doubleValue]];
    }
    else if ([temp isKindOfClass:[NSNumber class]]) {
        return temp;
    }
    return nil;
}

- (NSArray *)arrayForKey:(NSString *)key {
    id temp = [self objectForKey:key];
    if ([temp isKindOfClass:[NSArray class]]) {
        return temp;
    } else if ([temp isKindOfClass:[NSMutableArray class]]) {
        return [temp copy];
    }
    return nil;
}

- (NSMutableArray *)mutableArrayForKey:(NSString *)key {
    id temp = [self objectForKey:key];
    if ([temp isKindOfClass:[NSMutableArray class]]) {
        return temp;
    } else if ([temp isKindOfClass:[NSArray class]]) {
        return [temp mutableCopy];
    }
    return nil;
}

- (NSDictionary *)dictionaryForKey:(NSString *)key {
    id temp = [self objectForKey:key];
    if ([temp isKindOfClass:[NSDictionary class]]) {
        return temp;
    } else if ([temp isKindOfClass:[NSMutableDictionary class]]) {
        return [temp copy];
    }
    return nil;
}

- (NSMutableDictionary *)mutableDictionaryForKey:(NSString *)key {
    id temp = [self objectForKey:key];
    if ([temp isKindOfClass:[NSMutableDictionary class]]) {
        return temp;
    } else if ([temp isKindOfClass:[NSDictionary class]]) {
        return [temp mutableCopy];
    }
    return nil;
}

- (NSDate *)dateForKey:(NSString *)key {
    id temp = [self objectForKey:key];
    if ([temp isKindOfClass:[NSDate class]]) {
        return temp;
    }
    return nil;
}

//MARK: -将参数字典转换成字符串
- (NSString *)cacheKeyForYYCache {
    if(!self) return nil;
    // 将参数字典转换成字符串
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    return paraString;
}

@end
