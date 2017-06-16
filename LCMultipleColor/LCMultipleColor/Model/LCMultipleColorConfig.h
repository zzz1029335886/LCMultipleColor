//
//  LCMultipleColorViewControllerConfig.h
//  LCMultipleColor
//
//  Created by 凌创科技 on 2017/6/16.
//  Copyright © 2017年 凌创科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCMultipleColorConfig : NSObject
/**
 导航栏颜色
 */
@property (nonatomic,strong)NSString *navigationBarColorString;

/**
 导航栏隐藏
 */
@property (nonatomic,assign)BOOL navigationBarHidden;

/**
 白色标题
 */
@property (nonatomic, assign)BOOL navigationBarWhiteTitle;

- (instancetype)initWithColorString:(NSString *)colorString hidden:(BOOL)hidden whiteTitle:(BOOL)whiteTitle;

@end
