//
//  UIViewController+Category.h
//  AFNetworking
//
//  Created by zhangmin on 2017/12/20.
//

#import <UIKit/UIKit.h>

typedef void(^ActionSheetBlock)(NSUInteger index);
typedef void(^AlertConfirmBlock)(void);
typedef void(^AlertCancelBlock)(void);

@interface UIViewController (Alert)

//MARK: -  弹窗视图
- (void)showAlertWithStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)actionTitles action:(void (^)(NSUInteger index))actions;

//MARK: -  弹窗视图（actionTitleStyles 为 UIAlertActionStyle 枚举值，nil则为默认 UIAlertActionStyleDefault）
- (void)showAlertWithStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)actionTitles actionTitleStyles:(NSArray<NSNumber *> *)actionTitleStyles action:(void (^)(NSUInteger index))actions;

@end
