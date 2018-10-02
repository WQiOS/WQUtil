//
//  UIColor+Category.m
//  AFNetworking
//
//  Created by 周夏赛 on 2017/12/14.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)

///十六进制0x******
+ (instancetype)colorWithARGB:(NSInteger)argb {
    return [UIColor colorWithRed:((float)((argb & 0xFF0000) >> 16))/255.0 green:((float)((argb & 0xFF00) >> 8))/255.0 blue:((float)(argb & 0xFF))/255.0 alpha:((float)((argb & 0xFF000000) >> 24))/255.0];
}
///RGB:十六进制  a:0~1
+ (instancetype)colorWithRGB:(NSInteger)rgb alpha:(float)alpha {
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:alpha];
}

///rgb:0~255, a:0~1
+ (instancetype)colorWithR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b A:(float)a {
    return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a];
}

@end
