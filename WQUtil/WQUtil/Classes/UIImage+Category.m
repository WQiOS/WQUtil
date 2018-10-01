//
//  UIImage+Category.m
//  AFNetworking
//
//  Created by 周夏赛 on 2017/12/7.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)imageCircleWithColor:(UIColor *)color {
    return [self imageCircleWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageCircleWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddArc(context, size.width/2, size.width/2, size.height/2, 0, 2*M_PI, 0);
    CGContextDrawPath(context,kCGPathFill);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)compressImage:(UIImage *)sourceImage targetWidth:(CGFloat)targetWidth{

    UIImage *newImage = nil;

    if (sourceImage == nil) {
        return nil;
    }

    CGSize imageSize = sourceImage.size;
    CGSize targetSize = CGSizeMake(targetWidth, imageSize.height / (imageSize.width / targetWidth));

    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetSize.width;
    CGFloat scaledHeight = targetSize.height;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

    if(CGSizeEqualToSize(imageSize, targetSize) == NO){

        CGFloat widthFactor = targetSize.width / imageSize.width;
        CGFloat heightFactor = targetSize.height / imageSize.height;

        scaleFactor = (widthFactor > heightFactor) ? widthFactor : heightFactor;
        scaledWidth = imageSize.width * scaleFactor;
        scaledHeight = imageSize.height * scaleFactor;

        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetSize.height - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetSize.width - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight);
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//MARK: - 图片大小
- (CGFloat)imageOfSize {
    NSData *data= UIImageJPEGRepresentation(self, 1.0);
    CGFloat allSize = data.length/1024.0/1024.0;
    return allSize;
}

//MARK: - 图片压缩的方法
- (NSData *)compressImageToMaxImageSize:(CGFloat)maxImageSize {
    CGFloat compression = 0.70f;
    CGFloat imageAllSize = [self imageOfSize];
    if (imageAllSize > 8) {
        compression = 0.20f;
    } else if (imageAllSize > 5) {
        compression = 0.25f;
    } else if (imageAllSize > 2) {
        compression = 0.30f;
    } else if (imageAllSize > 1) {
        compression = 0.35f;
    }
    NSData *imageData = UIImageJPEGRepresentation(self, compression);
    CGFloat afterCompressSize = imageData.length / 1024.0 / 1024.0;
    if (!maxImageSize || maxImageSize > 2) {
        maxImageSize = 1.0;
    }
    if (afterCompressSize >= maxImageSize) {
        UIImage *image = [UIImage imageWithData:imageData];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        return imageData;
    }else{
        return imageData;
    }
}

@end
