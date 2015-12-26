//
//  CodeScrollTest.m
//  customUIScrollView
//
//  Created by apple on 15/12/19.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CodeScrollTestViewController.h"
#import "UIAutoScrollView.h"

@interface CodeScrollTestViewController ()
@property (nonatomic,strong) UIAutoScrollView* tmpScrollView;
@end

@implementation CodeScrollTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"code类型测试";
    
    self.view.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-self.navigationController.navigationBar.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height);//注意，这里必须设置下view的frame，原因是这时候view的高度已经超出了手机屏幕。超出了navigationBar和statusBar的高度. 如果不这样设置后面的代码设置UIAutoScrollView的frame等于view的frame的时候，会造成UIAutoScrollView超出手机屏幕，这样在UIAutoScrollView内部计算的时候会出bug.
    
    UIAutoScrollView* myScrollView=[[UIAutoScrollView alloc] initWithFrame:self.view.frame];
    myScrollView.backgroundColor=[UIColor grayColor];
    myScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 700);
    
    self.tmpScrollView=myScrollView;
    [self.view addSubview:myScrollView];
    
    NSLog(@"self.View.Height:%.f, myScrollView.height:%.f",self.view.frame.size.height,myScrollView.frame.size.height);
    
    UITextField* textFieldOne=[[UITextField alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
    textFieldOne.backgroundColor=[UIColor yellowColor];
    [myScrollView addSubview:textFieldOne];
    
    UITextField* textFieldTwo=[[UITextField alloc] initWithFrame:CGRectMake(10, 530, 300, 50)];
    textFieldTwo.backgroundColor=[UIColor redColor];
    [myScrollView addSubview:textFieldTwo];
    
    UITextField* textFieldThree=[[UITextField alloc] initWithFrame:CGRectMake(10, 400, 300, 30)];
    textFieldThree.backgroundColor=[UIColor redColor];
    [myScrollView addSubview:textFieldThree];
    
    [myScrollView addAutoScrollAbility];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
