//
//  LCMultipleColorNavigationController.m
//  kryb
//
//  Created by 凌创科技 on 2017/6/14.
//  Copyright © 2017年 凌创科技. All rights reserved.
//

#import "LCMultipleColorNavigationController.h"
#import "LCTopWindowViewController.h"
#import "LCMultipleColorViewController.h"

@interface LCMultipleColorNavigationController ()

@end

@implementation LCMultipleColorNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationBar{
    // 取出appearance对象
    UINavigationBar *navBar = self.navigationBar;
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.firstViewAppera = NO;
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        NSString *name = @"btn_back_white";
        if([viewController isKindOfClass:[LCMultipleColorViewController class]]){
            LCMultipleColorViewController *controller = (LCMultipleColorViewController *)viewController;
            if(!controller.config.navigationBarWhiteTitle){
                name = @"btn_back_black";
            }
        }
        viewController.navigationItem.leftBarButtonItem = [self itemWithIcon:name target:self action:@selector(back)];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    self.firstViewAppera = NO;
    return [super popViewControllerAnimated:animated];
}

- (void)back
{
    [self.view endEditing:YES];
    [self popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.firstViewAppera = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(self.statusBarStyle == UIStatusBarStyleDefault){
        LCBlackStatusBar
    }else{
        LCWhiteStatusBar
    }
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:self.barItemTextAttributes forState:UIControlStateNormal];
}


- (UIBarButtonItem *)itemWithIcon:(NSString *)icon target:(id)target action:(SEL)action;
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    button.imageView.frame = CGRectMake(10.0, 10.0, 24.0, 24.0);
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
