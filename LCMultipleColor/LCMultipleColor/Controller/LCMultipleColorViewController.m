//
//  LCMultipleColorViewController.m
//  LCMultipleColor
//
//  Created by 凌创科技 on 2017/6/16.
//  Copyright © 2017年 凌创科技. All rights reserved.
//

#import "LCMultipleColorViewController.h"
#import "LCTopWindowViewController.h"
#import "LCMultipleColorNavigationController+MultipleColor.h"

@interface LCMultipleColorViewController ()

@end

@implementation LCMultipleColorViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.config = [[LCMultipleColorConfig alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)setWhiteTitleColor:(BOOL)whiteTitleColor{
    
    
    
    // 设置标题属性
    NSMutableDictionary *titleTextAttrs = [NSMutableDictionary dictionary];
    titleTextAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:19];
    
    // 设置按钮属性
    NSMutableDictionary *itemTextAttrs = [NSMutableDictionary dictionary];
    
    if (whiteTitleColor) {
        LCWhiteStatusBar
        if(self.lc_prefersNavigationBarHidden){
            //如果导航栏隐藏，不改变字体颜色
            return;
        }
        titleTextAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
        itemTextAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
        
    }else{
        LCBlackStatusBar
        if(self.lc_prefersNavigationBarHidden){
            //如果导航栏隐藏，不改变字体颜色
            return;
        }
        titleTextAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
        itemTextAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
        
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleTextAttrs];
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:itemTextAttrs forState:UIControlStateNormal];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if([self.navigationController isKindOfClass:[LCMultipleColorNavigationController class]]){
        LCMultipleColorNavigationController *controller = (LCMultipleColorNavigationController *)self.navigationController;
        if(controller.firstViewAppera){
            controller.statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
            controller.barItemTextAttributes = [[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateNormal];
        }
    }
    
    
    [self setWhiteTitleColor:self.config.navigationBarWhiteTitle];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self setWhiteTitleColor:self.config.navigationBarWhiteTitle];
    
}

- (void)setConfig:(LCMultipleColorConfig *)config{
    _config = config;
    
    if(config.navigationBarHidden){
        self.lc_prefersNavigationBarHidden = YES;
    }else{
        UIColor *color = [self colorWithHexCode:self.config.navigationBarColorString];
        self.navigationBarColor = color;
    }
    
    
}

- (UIColor *)colorWithHexCode:(NSString *)hexCode
{
    if (!hexCode.length) {
        return nil;
    }
    NSString *cleanString = [hexCode stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


@end
