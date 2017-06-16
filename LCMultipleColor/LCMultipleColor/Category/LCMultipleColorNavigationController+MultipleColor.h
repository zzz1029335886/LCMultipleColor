//
//  LCWebViewNavigationController+MultipleColor.h
//  LCMultipleColor
//
//  Created by 凌创科技 on 2017/6/16.
//  Copyright © 2017年 凌创科技. All rights reserved.
//

#import "LCMultipleColorNavigationController.h"
#import "LCMultipleColorViewController.h"

@protocol LCMultipleColorNavigationControllerProgressDelegate <NSObject>
@optional
- (void)navigationBarProgress:(CGFloat)progess end:(BOOL)end;
- (void)navigationBarProgressSetOperation:(UINavigationControllerOperation)operation;

@end

@interface LCMultipleColorNavigationController (MultipleColor)
/// The gesture recognizer that actually handles interactive pop.
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *lc_fullscreenPopGestureRecognizer;

@property (nonatomic, assign) id internalTarget;

@property (nonatomic, assign) id<LCMultipleColorNavigationControllerProgressDelegate> popProgressDeletage;

/// A view controller is able to control navigation bar's appearance by itself,
/// rather than a global way, checking "lc_prefersNavigationBarHidden" property.
/// Default to YES, disable it if you don't want so.
@property (nonatomic, assign) BOOL lc_viewControllerBasedNavigationBarAppearanceEnabled;

@property (nonatomic, weak) UIView *navigationView;

@end

/// Allows any view controller to disable interactive pop gesture, which might
/// be necessary when the view controller itself handles pan gesture in some
/// cases.
@interface LCMultipleColorViewController (MultipleColor)

/// Whether the interactive pop gesture is disabled when contained in a navigation
/// stack.
@property (nonatomic, assign) BOOL lc_interactivePopDisabled;

/// Indicate this view controller prefers its navigation bar hidden or not,
/// checked when view controller based navigation bar's appearance is enabled.
/// Default to NO, bars are more likely to show.
@property (nonatomic, assign) BOOL lc_prefersNavigationBarHidden;

/// Max allowed initial distance to left edge when you begin the interactive pop
/// gesture. 0 by default, which means it will ignore this limit.
@property (nonatomic, assign) CGFloat lc_interactivePopMaxAllowedInitialDistanceToLeftEdge;


@property (nonatomic, strong) UIColor *navigationBarColor;

@end
