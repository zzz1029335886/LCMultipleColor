//
//  LCMultipleColorNavigationController.h
//  LCMultipleColor
//
//  Created by 凌创科技 on 2017/6/16.
//  Copyright © 2017年 凌创科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCMultipleColorNavigationController : UINavigationController
@property (nonatomic,assign)UIStatusBarStyle statusBarStyle;
@property (nonatomic,strong)NSDictionary *barItemTextAttributes;
@property (nonatomic,assign)BOOL firstViewAppera;

@end
