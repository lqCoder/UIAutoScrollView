//
//  BaseViewController.h
//  Helijia
//
//  Created by iOnRoad on 14-6-28.
//  Copyright (c) 2014年 AFu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdBannerEntity;

@interface BaseViewController : UIViewController

@property(nonatomic, weak, readonly, getter = getRootNavigationController) UINavigationController *rootNavigationController;
/*
 * hide root navigation controller's bar or not
 */
@property(nonatomic, assign) BOOL hideApplicationNavgationBar;

#pragma mark - 键盘相关

- (void)registerKeyboardEvent; //注册键盘事件
- (float)getCurrentKeyboardHeight; //获取键盘高度

- (void)keyboardWillShow:(NSNotification *)aNotification; //键盘显示通知
- (void)keyboardWillHidden:(NSNotification *)aNotification; //键盘显示通知

+ (BaseViewController *)getCurrentViewController; //获得当前的Controller
- (void)popViewController; //特殊情况需要子类重写

@end
