//
//  BaseViewController.m
//  Helijia
//
//  Created by iOnRoad on 14-6-28.
//  Copyright (c) 2014年 AFu. All rights reserved.
//

#import "BaseViewController.h"

// 屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define kAppDelegate (AppDelegate*)[[UIApplication sharedApplication] delegate]
#define kAppWindow [[[UIApplication sharedApplication] delegate] window]
#define LoadImage(imgName) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgName ofType:nil]]

#define iOS_V7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)   //是否iOS7系统

static BaseViewController *currentController;

@interface BaseViewController ()

@end

@implementation BaseViewController


- (UIView *)sharedView {
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigationBarSetting];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)navigationBarSetting{
    //设置NavBar白色字体
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //设置NavBar背景
    if (iOS_V7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
        self.navigationController.navigationBar.translucent = NO;
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        
        [self.navigationController.navigationBar setBackgroundImage:LoadImage(@"anniu_dibu.png") forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
#pragma mark - UI 负责UI相关逻辑

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
