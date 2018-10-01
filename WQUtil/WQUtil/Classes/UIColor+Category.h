//
//  UIColor+Category.h
//  AFNetworking
//
//  Created by 周夏赛 on 2017/12/14.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)

///十六进制透明度+颜色，0xFF123456
+ (instancetype)colorWithARGB:(NSInteger)argb;
///十六进制颜色，0x123456  0~1 透明度
+ (instancetype)colorWithRGB:(NSInteger)rgb alpha:(float)alpha;
///十进制颜色，0~255 0~1 透明度
+ (instancetype)colorWithR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b A:(float)a;

@end
