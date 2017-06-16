//
//  LCMultipleColorViewControllerConfig.m
//  LCMultipleColor
//
//  Created by 凌创科技 on 2017/6/16.
//  Copyright © 2017年 凌创科技. All rights reserved.
//

#import "LCMultipleColorConfig.h"

@implementation LCMultipleColorConfig
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithColorString:(NSString *)colorString hidden:(BOOL)hidden whiteTitle:(BOOL)whiteTitle;
{
    self = [super init];
    if (self) {
        self.navigationBarColorString = colorString;
        self.navigationBarHidden = hidden;
        self.navigationBarWhiteTitle = whiteTitle;
    }
    return self;
}


@end
