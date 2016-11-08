//
//  MyViewController.m
//  customUIScrollViewsss
//
//  Created by apple on 15/12/18.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "CodeScrollTestViewController.h"
#import "MyViewController.h"
#import "ManagerKeyBoard.h"

@interface MyViewController ()
@property (nonatomic,strong) ManagerKeyBoard* managerKeyBoard;
@end

@implementation MyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"xib类型测试";
    
    self.managerKeyBoard=[[ManagerKeyBoard alloc] init];
    [self.managerKeyBoard registerView:self.view];
}

- (IBAction)goCodeScroll:(id)sender
{
    CodeScrollTestViewController* controller = [[CodeScrollTestViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
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
