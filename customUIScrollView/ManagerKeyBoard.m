//
//  ManagerKeyBoard.m
//  renrentong
//
//  Created by mac on 16/10/10.
//  Copyright © 2016年 com.lanxum. All rights reserved.
//

#import "ManagerKeyBoard.h"

@interface ManagerKeyBoard()
@property(nonatomic,strong) UIImageView* keyBoardIcon;      //取消键盘响应图片
@property (nonatomic,assign) float keyboardHeight;
@property (nonatomic,weak) UIView* parentView;

@end

// 屏幕宽度
#define         kScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define         kScreenHeight [UIScreen mainScreen].bounds.size.height
#define         kAppWindow [[[UIApplication sharedApplication] delegate] window]


@implementation ManagerKeyBoard
-(void)dealloc{
    [self.keyBoardIcon removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)registerView:(UIView*)view{
    self.parentView=view;
    
    //增加键盘图片
    [self addKeyboardIconImageView];
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//增加键盘图片
-(void)addKeyboardIconImageView{
    self.keyBoardIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"keyBoardIcon"]];
    self.keyBoardIcon.frame=CGRectMake(kScreenWidth-self.keyBoardIcon.frame.size.width, kScreenHeight, self.keyBoardIcon.frame.size.width, self.keyBoardIcon.frame.size.height);
    [kAppWindow addSubview:self.keyBoardIcon];
    self.keyBoardIcon.userInteractionEnabled=YES;
    
    UITapGestureRecognizer* keyBoarTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    [self.keyBoardIcon addGestureRecognizer:keyBoarTap];
}

-(void)closeKeyBoard{
    [self.parentView endEditing:YES];
}

//键盘隐藏通知
- (void)keyboardWillHidden:(NSNotification *)aNotification{
    CGRect rect=CGRectMake(kScreenWidth-self.keyBoardIcon.image.size.width,
                           kScreenHeight,
                           self.keyBoardIcon.image.size.width,
                           self.keyBoardIcon.image.size.height);
    
    NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [self keyBoardAnimation:rect duration:duration.floatValue curve:curve.intValue];
}

-(BOOL)judgeViewInScreen{//判断被注册的这个View是否显示在当前的屏幕上
    if (self.parentView == nil) {
        return FALSE;
    }
    
    if (self.parentView.superview == nil) {
        return FALSE;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect rect = [self.parentView convertRect:self.parentView.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  FALSE;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    return YES;
}

//键盘显示通知
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if (![self judgeViewInScreen]) {
        return;
    }
    [self changeKeyboardIconFrame:aNotification];
    [kAppWindow bringSubviewToFront:self.keyBoardIcon];
}

//键盘高度改变通知
- (void)keyboardFrameChanged:(NSNotification *)aNotification{
    if (![self judgeViewInScreen]) {
        return;
    }
    [self changeKeyboardIconFrame:aNotification];
    [kAppWindow bringSubviewToFront:self.keyBoardIcon];
}

//改变键盘图标的高度
- (void)changeKeyboardIconFrame:(NSNotification *)aNotification{
    NSDictionary *userInfo  =  [aNotification userInfo];
    NSValue *aValue  =  [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect  =  [aValue CGRectValue];
    self.keyboardHeight  =  keyboardRect.size.height;
    
    NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect rect=CGRectMake(kScreenWidth-self.keyBoardIcon.image.size.width,
                           kScreenHeight-self.keyboardHeight-self.keyBoardIcon.image.size.height,
                           self.keyBoardIcon.image.size.width,
                           self.keyBoardIcon.image.size.height);
    [self keyBoardAnimation:rect duration:duration.floatValue curve:curve.intValue];
}

//隐藏键盘动画
- (void)keyBoardAnimation:(CGRect)containerFrame duration:(float)duration curve:(int)curve
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    UIViewAnimationCurve cu = UIViewAnimationCurveEaseInOut;
    switch (curve) {
        case 0:
            cu = UIViewAnimationCurveEaseInOut;
            break;
        case 1:
            cu = UIViewAnimationCurveEaseIn;
            break;
        case 2:
            cu = UIViewAnimationCurveEaseOut;
            break;
        case 3:
            cu = UIViewAnimationCurveLinear;
            break;
    }
    [UIView setAnimationCurve:cu];
    self.keyBoardIcon.frame = containerFrame;
    [UIView commitAnimations];
}


@end
