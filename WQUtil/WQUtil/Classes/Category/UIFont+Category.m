//
//  UIFont+Category.m
//  AFNetworking
//
//  Created by 周夏赛 on 2017/12/14.
//

#import "UIFont+Category.h"

@implementation UIFont (Category)

+ (instancetype)regularPingFangFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}

+ (instancetype)boldPingFangFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
}

+ (instancetype)semiboldPingFangFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
}

+ (instancetype)thinPingFangFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Thin" size:size];
}

+ (instancetype)lightPingFangFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Light" size:size];
}

+ (instancetype)ultralightPingFangFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Ultralight" size:size];
}


@end
