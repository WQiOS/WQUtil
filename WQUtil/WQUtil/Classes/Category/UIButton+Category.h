//
//  UIButton+Category.h
//  AFNetworking
//
//  Created by 王强 on 2018/6/6.
//

#import <UIKit/UIKit.h>

typedef void (^ClickActionBlock) (id obj);

@interface UIButton (Category)

//MARK: - 设置点击时间间隔
@property (nonatomic, assign) NSTimeInterval timeInterval;

+ (UIButton *)initButton:(CGRect)rect btnImage:(UIImage *)image btnTitle:(NSString *)str;

+ (UIButton *)initButton:(CGRect) rect btnNorImage:(UIImage *)image btnPressBtn:(UIImage *)press btnTitle:(NSString *)str;

+ (UIButton *)initButton:(CGRect)rect btnImage:(UIImage *)image btnTitle:(NSString *)str titleColor:(UIColor *)color titleFont:(float)font;

+ (UIButton *)initButton:(CGRect)rect btnNorImage:(UIImage *)norImage btnHighlightImage:(UIImage *)highlightImage btnTitle:(NSString *)str titleColor:(UIColor *)color titleFont:(float)font;

+ (UIButton *)initButton:(CGRect)rect btnNorImage:(UIImage *)norImage btnDisableBtn:(UIImage *)disableImage btnTitle:(NSString *)str titleNorColor:(UIColor *)color1 titleSelectColor:(UIColor *)color2 titleFont:(float)font;

/**
 UIButton添加Block点击事件

 @param clickBlock   点击后返回
 @param event        点击的种类
 */
- (void)addBlock:(ClickActionBlock)clickBlock for:(UIControlEvents)event;

@end
