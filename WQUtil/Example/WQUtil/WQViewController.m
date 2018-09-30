//
//  WQViewController.m
//  WQUtil
//
//  Created by wq1570375769 on 09/30/2018.
//  Copyright (c) 2018 wq1570375769. All rights reserved.
//

#import "WQViewController.h"
#import "UIViewController+Category.h"
#import "UIFont+Category.h"
#import "UIButton+Category.h"

@interface WQViewController ()

@end

@implementation WQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100 ,100,100 , 100);
    [button setTitle:@"点我哈" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blueColor]];
    button.titleLabel.font = [UIFont regularPingFangFontOfSize:18];
    button.layer.borderColor = [UIColor yellowColor].CGColor;
    button.layer.borderWidth = 4;
    __weak __typeof(self)weakSelf = self;
    [button addBlock:^(id obj) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf showAlertWithStyle:UIAlertControllerStyleAlert title:@"警告" message:@"哈哈哈" actionTitles:@[@"确认",@"取消"] action:^(NSUInteger index) {

        }];
    } for:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
