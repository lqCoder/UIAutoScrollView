//
//  UIScrollView.h
//  customUIScrollView
//
//  Created by li qiao on 15/12/19.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView(LqAutoScroll)
-(void)addAutoScrollAbility;//如果是xib的方式使用这个类，不需要调用这个方法，我在awakeFromNib方法里调用了。 用代码的方式初化这个类时需要调用
@end
