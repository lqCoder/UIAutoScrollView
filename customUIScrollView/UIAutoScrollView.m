//
//  MyScrollView.m
//  Created by li qiao  on 15/12/18.
//  Copyright © 2015年 apple. All rights reserved.
//  如有问题可发邮件  275143680@qq.com

//1.注意如我在CodeScrollTestViewController用这个类的时候，用code代码调用UIAutoScrollView，必须设置UIAutoScrollView的contentSize。 在加完UIAutoScrollView的所有子控件的后，最后再调用下addAutoScrollAbility方法，这个顺序不能变。
//2.注意如在xib中使用时，把先在xib中拖入一个UIScrollView，然后再把它的class属性设置为 UIAutoScrollView

#import "UIAutoScrollView.h"
@interface UIAutoScrollView ()
@property (nonatomic, assign) CGSize srcContentSize;
@property (nonatomic, assign) CGFloat maxContentSizeHeight;
@end

#define kKeyBoardHeight 285 //这个值是键盘在中文下最大的高度高一点

@implementation UIAutoScrollView
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [self addAutoScrollAbility];
}

- (void)addAutoScrollAbility////如果是xib的方式使用这个类，不需要调用这个addAutoScrollAbility方法，我在awakeFromNib方法里调用了。 用代码的方式初化这个类时需要调用。  注意这个方法最好只调用一次
{
    [[NSNotificationCenter defaultCenter] removeObserver:self]; //防止外部多次调用这个方法，注册多次通知
    self.srcContentSize = self.contentSize;
    UITapGestureRecognizer* selfTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTapMethod)];
    [self addGestureRecognizer:selfTap]; //加这个是为了点击UISCrollView的时候关闭键盘，可视情况去掉

    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [self countContentMaxHeight:self];
    self.maxContentSizeHeight = self.maxContentSizeHeight + kKeyBoardHeight + 20; //这个+20可以看情况去掉，只是保留下面有个间距
}

- (void)countContentMaxHeight:(UIView*)parentView
{ //计算最大的ContentSize的高度
    for (UIView* view in parentView.subviews) {
        if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
            CGRect convertRect = [view convertRect:view.bounds toView:self];
            CGFloat y = convertRect.size.height + convertRect.origin.y;
            if (y > self.maxContentSizeHeight) {
                self.maxContentSizeHeight = y;
            }
        }
        if (view.subviews.count > 0) {
            [self countContentMaxHeight:view];
        }
    }
}

- (void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    if (self.srcContentSize.height < 1) {
        self.srcContentSize = contentSize;
    }
}

- (void)selfTapMethod
{
    [self endEditing:YES];
}

- (void)keyboardWillHidden:(NSNotification*)aNotification
{
    self.contentSize = self.srcContentSize;
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    [self ergodicAllSubViews:self];
}

- (void)ergodicAllSubViews:(UIView*)parentViews
{
    for (UIView* view in parentViews.subviews) {
        if (view.isFirstResponder) {
            CGRect convertRect = [view convertRect:view.bounds toView:self];
            CGFloat marginBottom = self.frame.size.height - (convertRect.origin.y + convertRect.size.height - self.contentOffset.y);

            if (self.contentSize.height < self.maxContentSizeHeight) {
                self.contentSize = CGSizeMake(self.contentSize.width, self.maxContentSizeHeight);
            }
            if (marginBottom < kKeyBoardHeight) {
                CGFloat marginBottom = self.frame.size.height - (convertRect.origin.y + convertRect.size.height);
                CGFloat originY = kKeyBoardHeight - marginBottom;
                [self setContentOffset:CGPointMake(self.frame.origin.x, originY) animated:YES];
            }
            return;
        }
        if (view.subviews.count > 0) {
            [self ergodicAllSubViews:view];
        }
    }
}

@end