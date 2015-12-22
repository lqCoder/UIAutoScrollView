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

@property(nonatomic, strong) UIImageView *keyBoardIcon; //取消键盘响应图片
@property(nonatomic, assign) float keyboardHeight;
@property(nonatomic, assign) BOOL isRegistedKeywordEvent;

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hideApplicationNavgationBar = YES;
    }
    return self;
}

- (UIView *)sharedView {
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"VC name is  %@ \n",self);
    
    [self navigationBarSetting];
    // Do any additional setup after loading the view.
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(popViewController)];
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    currentController = self;

    if (self.isRegistedKeywordEvent) {
        //增加键盘图片
        [self addKeyboardIconImageView];
        //注册键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isRegistedKeywordEvent) {
        [self resignKeyboardEvent]; //取消键盘通知
        [self.view endEditing:YES];
    }
    
    //self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)navigationBarSetting{
    //设置NavBar白色字体
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //设置NavBar背景
    if (iOS_V7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
        self.navigationController.navigationBar.translucent = NO;
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        
        [self.navigationController.navigationBar setBackgroundImage:LoadImage(@"anniu_dibu.png") forBarMetrics:UIBarMetricsDefault];
    }
    //设置NavBar返回按钮,
    //先隐藏原有的backBtn和返回字体，否则第一次运行时会出现...省略号
    [self.navigationItem setHidesBackButton:YES animated:NO];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = backBarItem;
    //在设置自定义的返回按钮
    UIViewController *rootViewController  = [self.navigationController.viewControllers objectAtIndex:0];
    if(rootViewController && [rootViewController class] !=[self class]){
        UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 40, 40);
        //[backButton setShowsTouchWhenHighlighted:YES];
        [backButton addTarget:self
                       action:@selector(popViewController)
             forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[UIImage imageNamed:@"anniu_back.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        if(iOS_V7){
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                               target:nil action:nil];
            negativeSpacer.width = - 15;
            self.navigationItem.leftBarButtonItems = @[negativeSpacer,backNavigationItem];
        }else{
            self.navigationItem.leftBarButtonItems = @[backNavigationItem];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UI 负责UI相关逻辑


- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 键盘相关

//注册键盘事件
- (void)registerKeyboardEvent {
    self.isRegistedKeywordEvent = YES;
}

//移除键盘通知
- (void)resignKeyboardEvent {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

    [self.keyBoardIcon removeFromSuperview];
    self.keyBoardIcon = nil;
}

//获取简单当前高度
- (float)getCurrentKeyboardHeight {
    return self.keyboardHeight;
}

//增加键盘图片
- (void)addKeyboardIconImageView {
    //增加键盘图片
    _keyBoardIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - _keyBoardIcon.image.size.width, ScreenHeight, self.keyBoardIcon.image.size.width, self.keyBoardIcon.image.size.height)];
    _keyBoardIcon.image = LoadImage(@"C09.png");
    [kAppWindow addSubview:_keyBoardIcon];
    self.keyBoardIcon.userInteractionEnabled = YES;

    UITapGestureRecognizer *keyBoarTap = [[UITapGestureRecognizer alloc] initWithTarget:kAppWindow action:@selector(endEditing:)];
    [self.keyBoardIcon addGestureRecognizer:keyBoarTap];
}

//键盘隐藏通知
- (void)keyboardWillHidden:(NSNotification *)aNotification {
    CGRect rect = CGRectMake(ScreenWidth - self.keyBoardIcon.image.size.width, ScreenHeight, self.keyBoardIcon.image.size.width, self.keyBoardIcon.image.size.height);

    NSNumber * duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber * curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [self keyBoardAnimation:rect duration:duration.floatValue curve:curve.intValue];
}

//键盘显示通知
- (void)keyboardWillShow:(NSNotification *)aNotification {
    [kAppWindow bringSubviewToFront:self.keyBoardIcon];
    [self changeKeyboardIconFrame:aNotification];
}

//键盘高度改变通知
- (void)keyboardFrameChanged:(NSNotification *)aNotification {
    [self changeKeyboardIconFrame:aNotification];
}

//改变键盘图标的高度
- (void)changeKeyboardIconFrame:(NSNotification *)aNotification {
    NSDictionary * userInfo = [aNotification userInfo];
    NSValue * aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.keyboardHeight = keyboardRect.size.height;

    NSNumber * duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber * curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

    CGRect rect = CGRectMake(ScreenWidth - self.keyBoardIcon.image.size.width, ScreenHeight - self.keyboardHeight - self.keyBoardIcon.image.size.height, self.keyBoardIcon.image.size.width, self.keyBoardIcon.image.size.height);
    [self keyBoardAnimation:rect duration:duration.floatValue curve:curve.intValue];
}

//隐藏键盘动画
- (void)keyBoardAnimation:(CGRect)containerFrame duration:(float)duration curve:(int)curve {
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

#pragma mark -

+ (BaseViewController *)getCurrentViewController {
    return currentController;
}

@end
