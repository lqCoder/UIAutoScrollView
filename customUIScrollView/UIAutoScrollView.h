//
//  MyScrollView.h
//  customUIScrollView
//  代码地址：https://github.com/lqCoder/UIAutoScrollView
//  Created by li qiao  on 15/12/18.
//  Copyright © 2015年 apple. All rights reserved.
//  如有问题可发邮件  275143680@qq.com

#import <UIKit/UIKit.h>

@interface UIAutoScrollView : UIScrollView

/**
 1.注意如我在CodeScrollTestViewController用这个类的时候，用code代码调用UIAutoScrollView，必须设置UIAutoScrollView的contentSize。 在加完UIAutoScrollView的所有子控件的后，最后再调用下addAutoScrollAbility方法，这个顺序不能变。
 2.注意如在xib中使用时，先在xib中拖入一个UIScrollView，然后再把它的class属性设置为 UIAutoScrollView
 3.如果是xib的方式使用这个类，不需要调用这个addAutoScrollAbility方法，我在awakeFromNib方法里调用了。 用代码的方式初化这个类时需要调用。这个方法最好只调用一次
 */
- (void)addAutoScrollAbility;

@end
