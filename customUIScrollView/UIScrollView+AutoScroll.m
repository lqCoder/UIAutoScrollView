//
//  UIScrollView.m
//  customUIScrollView
//
//  Created by li qiao  on 15/12/19.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UIScrollView+AutoScroll.h"
#import <objc/runtime.h>
@interface UIScrollView()
@property (nonatomic, assign) CGSize srcContentSize;
@property (nonatomic, assign) BOOL isLoadContentSize;
@property (nonatomic, assign) CGFloat maxContentSizeHeight;
@end

#define kScrollViewContentOffsetKey @"contentOffset"
#define kKeyBoardHeight 285 //这个值是键盘在中文下最大的高度高一点

@implementation UIScrollView(LqAutoScroll)

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

static char LqSrcContentSize;
static char LqSrcIsLoadContentSize;
static char LqMaxContentSizeHeight;

//-(void)setSrcContentSize:(CGSize)srcContentSize{
//    [self willChangeValueForKey:@"LqSrcContentSize"];
//    objc_setAssociatedObject(self, &LqSrcContentSize,
//                             srcContentSize,
//                             OBJC_ASSOCIATION_ASSIGN);
//    [self didChangeValueForKey:@"LqSrcContentSize"];
//}

-(void)addAutoScrollAbility{
    self.isLoadContentSize = NO;
    self.srcContentSize = self.contentSize;
    UITapGestureRecognizer* selfTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTapMethod)];
    [self addGestureRecognizer:selfTap]; //加这个是为了点击UISCrollView的时候关闭键盘，可视情况去掉
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [self addObserver:self forKeyPath:kScrollViewContentOffsetKey options:NSKeyValueObservingOptionNew context:nil];
    
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

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary<NSString*, id>*)change context:(void*)context
{
    if ([kScrollViewContentOffsetKey isEqualToString:keyPath]) {
        if (!self.isLoadContentSize) {
            if (self.contentSize.height > 0) {
                self.isLoadContentSize = YES;
                self.srcContentSize = self.contentSize; //记录初始化时候 contSize的数值
            }
        }
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
