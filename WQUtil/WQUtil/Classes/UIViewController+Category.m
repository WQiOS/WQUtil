//
//  UIViewController+Category.m
//  AFNetworking
//
//  Created by zhangmin on 2017/12/20.
//

#import "UIViewController+Category.h"
#import <UIKit/UIKit.h>

@implementation UIViewController (Alert)

- (void)showAlertWithStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)actionTitles action:(void (^)(NSUInteger))actions {
    [self showAlertWithStyle:style title:title message:message actionTitles:actionTitles actionTitleStyles:nil action:actions];
}

- (void)showAlertWithStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)actionTitles actionTitleStyles:(NSArray<NSNumber *> *)actionTitleStyles action:(void (^)(NSUInteger))actions {    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    for (int i = 0; i < actionTitles.count; i++) {
        UIAlertAction  *action = nil;
        if (actionTitleStyles.count == actionTitles.count) {
            action = [UIAlertAction actionWithTitle:actionTitles[i] style:actionTitleStyles[i].integerValue handler:^(UIAlertAction * _Nonnull action) {
                if (actions) {
                    actions(i);
                }
            }];
        } else if (actionTitleStyles == nil) {
            action = [UIAlertAction actionWithTitle:actionTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (actions) {
                    actions(i);
                }
            }];
        } else {
            NSAssert(false, @"actionTitleStyles 的大小应该和 actionTitles 一致");
        }
        [controller addAction:action];
    }
    [self performSelectorOnMainThread:@selector(presentController:) withObject:controller waitUntilDone:NO];
}

-(void)presentController:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:^{
    }];
}
     
@end
