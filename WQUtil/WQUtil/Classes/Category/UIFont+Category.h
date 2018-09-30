//
//  UIFont+Category.h
//  AFNetworking
//
//  Created by 周夏赛 on 2017/12/14.
//

#import <UIKit/UIKit.h>

@interface UIFont (Category)

//MARK: - PingFangSC-Regular
+ (instancetype)regularPingFangFontOfSize:(CGFloat)size;

//MARK: - PingFangSC-Medium
+ (instancetype)boldPingFangFontOfSize:(CGFloat)size;

//MARK: - PingFangSC-Semibold
+ (instancetype)semiboldPingFangFontOfSize:(CGFloat)size;

//MARK: - PingFangSC-Thin
+ (instancetype)thinPingFangFontOfSize:(CGFloat)size;

//MARK: - PingFangSC-Light
+ (instancetype)lightPingFangFontOfSize:(CGFloat)size;

//MARK: - PingFangSC-Ultralight
+ (instancetype)ultralightPingFangFontOfSize:(CGFloat)size;

@end
