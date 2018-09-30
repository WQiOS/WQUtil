//
//  UIImage+Category.h
//  AFNetworking
//
//  Created by 周夏赛 on 2017/12/7.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageCircleWithColor:(UIColor *)color;
+ (UIImage *)imageCircleWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)compressImage:(UIImage *)sourceImage targetWidth:(CGFloat)targetWidth;

//MARK: - 图片大小
- (CGFloat)imageOfSize;

//MARK: - 图片压缩的方法 (maxFileSize：默认1.0，单位：M)
- (NSData *)compressImageToMaxImageSize:(CGFloat)maxImageSize;

@end
