//
//  LCTopWindowViewController.h
//  03-iOS9的UIWindow
//
//  Created by xiaomage on 15/9/23.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#define LCHideStatusBar [LCTopWindowViewController sharedInstance].statusBarHidden = YES;
#define LCShowStatusBar [LCTopWindowViewController sharedInstance].statusBarHidden = NO;
#define LCBlackStatusBar [LCTopWindowViewController sharedInstance].statusBarStyle = UIStatusBarStyleDefault;
#define LCWhiteStatusBar [LCTopWindowViewController sharedInstance].statusBarStyle = UIStatusBarStyleLightContent;

@interface LCTopWindowViewController : UIViewController
+ (instancetype)sharedInstance;

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) BOOL statusBarHidden;
@end
