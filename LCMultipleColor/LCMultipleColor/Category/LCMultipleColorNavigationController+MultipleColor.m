

#import "LCMultipleColorNavigationController+MultipleColor.h"
#import <objc/runtime.h>
#import <objc/message.h>


#define MJRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define MJRefreshMsgTarget(target) (__bridge void *)(target)



@interface _lcFullScreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate,UINavigationControllerDelegate,LCMultipleColorNavigationControllerProgressDelegate>

@property (nonatomic, strong) LCMultipleColorNavigationController *navigationController;
@property (nonatomic, strong) LCMultipleColorViewController *showViewController;
@property (nonatomic, strong) LCMultipleColorViewController *viewController;

// 用于懒加载计算文字的rgb差值, 用于颜色渐变的时候设置
@property (strong, nonatomic) NSArray *deltaRGB;
@property (strong, nonatomic) NSArray *selectedColorRgb;
@property (strong, nonatomic) NSArray *normalColorRgb;

@end

@implementation _lcFullScreenPopGestureRecognizerDelegate

#pragma mark - 颜色数组相关，用于标题渐变色

- (NSArray *)normalColorRgb {
    if (!_normalColorRgb) {
        
        NSArray *normalColorRgb = [self getColorRgb:self.showViewController.navigationBarColor];
        NSAssert(normalColorRgb, @"设置普通状态的文字颜色时 请使用RGB空间的颜色值");
        _normalColorRgb = normalColorRgb;
    }
    return  _normalColorRgb;
}

- (NSArray *)selectedColorRgb {
    if (!_selectedColorRgb) {
        NSArray *selectedColorRgb = [self getColorRgb:self.viewController.navigationBarColor];
        NSAssert(selectedColorRgb, @"设置选中状态的文字颜色时 请使用RGB空间的颜色值");
        _selectedColorRgb = selectedColorRgb;
    }
    return  _selectedColorRgb;
}

- (NSArray *)deltaRGB {
    if (_deltaRGB == nil) {
        NSArray *normalColorRgb = self.normalColorRgb;
        NSArray *selectedColorRgb = self.selectedColorRgb;
        
        NSArray *delta;
        if (normalColorRgb && selectedColorRgb) {
            CGFloat deltaR = [normalColorRgb[0] floatValue] - [selectedColorRgb[0] floatValue];
            CGFloat deltaG = [normalColorRgb[1] floatValue] - [selectedColorRgb[1] floatValue];
            CGFloat deltaB = [normalColorRgb[2] floatValue] - [selectedColorRgb[2] floatValue];
            delta = [NSArray arrayWithObjects:@(deltaR), @(deltaG), @(deltaB), nil];
            _deltaRGB = delta;
        }
    }
    return _deltaRGB;
}

- (NSArray *)getColorRgb:(UIColor *)color {
    CGFloat numOfcomponents = CGColorGetNumberOfComponents(color.CGColor);
    NSArray *rgbComponents;
    if (numOfcomponents == 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        rgbComponents = [NSArray arrayWithObjects:@(components[0]), @(components[1]), @(components[2]), nil];
    }
    return rgbComponents;
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    
    
    self.viewController = self.navigationController.viewControllers.lastObject;
    
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    // Ignore when the active view controller doesn't allow interactive pop.
    LCMultipleColorViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.lc_interactivePopDisabled) {
        return NO;
    }
    
    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowedInitialDistance = topViewController.lc_interactivePopMaxAllowedInitialDistanceToLeftEdge;
    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance) {
        return NO;
    }
    
    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return YES;
}

// called when the recognition of one of gestureRecognizer or otherGestureRecognizer would be blocked by the other
// return YES to allow both to recognilc simultaneously. the default implementation returns NO (by default no two gestures can be recognilcd simultaneously)
//
// note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognilcSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
{
    NSLog(@"2");
    
    return YES;
    
}
// called once per attempt to recognilc, so failure requirements can be determined lazily and may be set up between recognizers across view hierarchies
// return YES to set up a dynamic failure requirement between gestureRecognizer and otherGestureRecognizer
//
// note: returning YES is guaranteed to set up the failure requirement. returning NO does not guarantee that there will not be a failure requirement as the other gesture's counterpart delegate or subclass methods may return YES
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0);
{
    NSLog(@"3");
    
    return NO;
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0);
{
    NSLog(@"4");
    
    return YES;
    
}
// called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
{
    _flag = NO;
    
    return YES;
    
}
// called before pressesBegan:withEvent: is called on the gesture recognizer for a new press. return NO to prevent the gesture recognizer from seeing this press
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press;
{
    NSLog(@"6");
    
    return YES;
    
}

- (void)navigationController:(LCMultipleColorNavigationController *)navigationController willShowViewController:(LCMultipleColorViewController *)viewController animated:(BOOL)animated;
{
    NSLog(@"6.5");
    
    self.showViewController = viewController;
    
}

#pragma mark - lcNavigationBarProgressDelegate

- (void)navigationBarProgress:(CGFloat)progress end:(BOOL)end{
    
    if (self.viewController == self.showViewController) {
        return;
    }
    
    if(![self.viewController isKindOfClass:NSClassFromString(@"LCMultipleColorViewController")]){
        return;
    }
    
    if(self.viewController.lc_prefersNavigationBarHidden){
        self.navigationController.navigationView.backgroundColor = self.showViewController.navigationBarColor;
        return;
    }
    
    if(self.showViewController.lc_prefersNavigationBarHidden){
        self.navigationController.navigationView.backgroundColor = self.viewController.navigationBarColor;
        
        return;
    }
    
    
    progress = MIN(1, progress * 2);
    progress = MAX(0, progress);
    NSLog(@"%.2lf",progress);
    
    UIColor *color = [UIColor colorWithRed:[self.selectedColorRgb[0] floatValue] + [self.deltaRGB[0] floatValue] * progress green:[self.selectedColorRgb[1] floatValue] + [self.deltaRGB[1] floatValue] * progress blue:[self.selectedColorRgb[2] floatValue] + [self.deltaRGB[2] floatValue] * progress alpha:1.0];
    
    if (end) {
        NSLog(@"end");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * progress * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!_flag && self.navigationController.viewControllers.lastObject == self.viewController) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.navigationController.navigationView.backgroundColor = self.viewController.navigationBarColor;
                }];
            }
        });
        
        
    }else{
        self.navigationController.navigationView.backgroundColor = color;
    }
    //    self.viewController.view.backgroundColor = color;
    
}
- (void)navigationBarProgressSetOperation:(UINavigationControllerOperation)operation;
{
    
}
static bool _flag = NO;

- (void)navigationController:(LCMultipleColorNavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
    self.deltaRGB = nil;
    self.normalColorRgb = nil;
    self.selectedColorRgb = nil;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.navigationController.navigationView.backgroundColor = self.showViewController.navigationBarColor;
        
    }];
    NSLog(@"8");
    
}


- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(LCMultipleColorNavigationController *)navigationController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;
{
    NSLog(@"9");
    
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(LCMultipleColorNavigationController *)navigationController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;
{
    NSLog(@"10");
    
    return UIInterfaceOrientationUnknown;
    
}
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(LCMultipleColorNavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0);
{
    NSLog(@"11");
    
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(LCMultipleColorNavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(LCMultipleColorViewController *)fromVC
                                                           toViewController:(LCMultipleColorViewController *)toVC  NS_AVAILABLE_IOS(7_0);
{
    self.showViewController = toVC;
    self.viewController = fromVC;
    _flag = NO;
    
    if(!toVC.config.navigationBarHidden){
        self.navigationController.navigationView.backgroundColor = self.showViewController.navigationBarColor;
    }
    
    NSLog(@"12");
    
    return nil;
}

@end

typedef void (^_lcViewControllerWillAppearInjectBlock)(LCMultipleColorViewController *viewController, BOOL animated);

@interface LCMultipleColorViewController (lcFullscreenPopGesturePrivate)

@property (nonatomic, copy) _lcViewControllerWillAppearInjectBlock lc_willAppearInjectBlock;

@end

@implementation LCMultipleColorViewController (lcFullscreenPopGesturePrivate)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(lc_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)lc_viewWillAppear:(BOOL)animated
{
    // Forward to primary implementation.
    [self lc_viewWillAppear:animated];
    
    if (self.lc_willAppearInjectBlock) {
        self.lc_willAppearInjectBlock(self, animated);
    }
}

- (_lcViewControllerWillAppearInjectBlock)lc_willAppearInjectBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLc_willAppearInjectBlock:(_lcViewControllerWillAppearInjectBlock)block
{
    objc_setAssociatedObject(self, @selector(lc_willAppearInjectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation LCMultipleColorNavigationController (MultipleColor)

+ (void)load
{
    // Inject "-pushViewController:animated:"
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self addPushMethod];
        
        
        
        //        [self addPopMethod];
        //        [self addNavigationTransition];
    });
}

+ (void)addPushMethod
{
    SEL originalSelector = @selector(pushViewController:animated:);
    SEL swizzledSelector = @selector(lc_pushViewController:animated:);
    [self addMethodWithOriginalSelector:originalSelector swizzledSelector:swizzledSelector];
}

+ (void)addPopMethod
{
    SEL originalSelector = @selector(popViewControllerAnimated:);
    SEL swizzledSelector = @selector(lc_popViewControllerAnimated:);
    [self addMethodWithOriginalSelector:originalSelector swizzledSelector:swizzledSelector];
}

+ (void)addNavigationTransition
{
    SEL originalSelector = NSSelectorFromString(@"navigationTransitionView:didEndTransition:fromView:toView:");
    SEL swizzledSelector = @selector(lc_navigationTransitionView:didEndTransition:fromView:toView:);
    [self addMethodWithOriginalSelector:originalSelector swizzledSelector:swizzledSelector];
}

+ (void)addMethodWithOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)lc_pushViewController:(LCMultipleColorViewController *)viewController animated:(BOOL)animated
{
    
    
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.lc_fullscreenPopGestureRecognizer]) {
        
        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.lc_fullscreenPopGestureRecognizer];
        
        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        self.internalTarget = internalTarget;
        
        self.delegate = self.lc_popGestureRecognizerDelegate;
        self.popProgressDeletage = self.lc_popGestureRecognizerDelegate;
        
        self.lc_fullscreenPopGestureRecognizer.delegate = self.lc_popGestureRecognizerDelegate;
        [self.lc_fullscreenPopGestureRecognizer addTarget:self action:@selector(handleNavigationTransition:)];
        
        // Disable the onboard gesture recognizer.
        self.interactivePopGestureRecognizer.enabled = NO;
        
        if ([self.popProgressDeletage respondsToSelector:@selector(navigationBarProgress:end:)]) {
            [self.popProgressDeletage navigationBarProgress:0.0 end:YES];
        }
    }
    
    // Handle perferred navigation bar appearance.
    [self lc_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    
    // Forward to primary implementation.
    if (![self.viewControllers containsObject:viewController]) {
        [self lc_pushViewController:viewController animated:animated];
    }
}

- (UIViewController *)lc_popViewControllerAnimated:(BOOL)animated
{
    return [self popViewControllerAnimated:animated];
}

- (void)lc_navigationTransitionView:(id)arg1 didEndTransition:(int)arg2 fromView:(id)arg3 toView:(id)arg4 {
    //    SEL internalAction = NSSelectorFromString(@"navigationTransitionView:didEndTransition:fromView:toView:");
    //    objc_msgSend(self,internalAction,arg1,arg2,arg3,arg4);
    
    
}

- (void)handleNavigationTransition:(UIPanGestureRecognizer *)recognizer {
    
    SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
    objc_msgSend(self.internalTarget,internalAction,recognizer);
    
    
    CGFloat progress = [recognizer translationInView:recognizer.view].x / recognizer.view.bounds.size.width;
    
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        
        
        if ([self.popProgressDeletage respondsToSelector:@selector(navigationBarProgress:end:)]) {
            [self.popProgressDeletage navigationBarProgress:progress end:YES];
        }
    }else{
        
        
        if ([self.popProgressDeletage respondsToSelector:@selector(navigationBarProgress:end:)]) {
            [self.popProgressDeletage navigationBarProgress:progress end:NO];
        }
    }
    
}

- (void)lc_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(LCMultipleColorViewController *)appearingViewController
{
    if (!self.lc_viewControllerBasedNavigationBarAppearanceEnabled) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    _lcViewControllerWillAppearInjectBlock block = ^(LCMultipleColorViewController *viewController, BOOL animated) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf setNavigationBarHidden:viewController.lc_prefersNavigationBarHidden animated:animated];
        }
    };
    
    // Setup will appear inject block to appearing view controller.
    // Setup disappearing view controller as well, because not every view controller is added into
    // stack by pushing, maybe by "-setViewControllers:".
    appearingViewController.lc_willAppearInjectBlock = block;
    LCMultipleColorViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.lc_willAppearInjectBlock) {
        disappearingViewController.lc_willAppearInjectBlock = block;
    }
}

- (_lcFullScreenPopGestureRecognizerDelegate *)lc_popGestureRecognizerDelegate
{
    _lcFullScreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    
    if (!delegate) {
        delegate = [[_lcFullScreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIPanGestureRecognizer *)lc_fullscreenPopGestureRecognizer
{
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

- (BOOL)lc_viewControllerBasedNavigationBarAppearanceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    self.lc_viewControllerBasedNavigationBarAppearanceEnabled = YES;
    return YES;
}

- (void)setLc_viewControllerBasedNavigationBarAppearanceEnabled:(BOOL)enabled
{
    SEL key = @selector(lc_viewControllerBasedNavigationBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)internalTarget{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setInternalTarget:(id)internalTarget{
    SEL key = @selector(internalTarget);
    objc_setAssociatedObject(self, key, internalTarget, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)popProgressDeletage{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPopProgressDeletage:(id)popProgressDeletage{
    SEL key = @selector(popProgressDeletage);
    objc_setAssociatedObject(self, key, popProgressDeletage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)navigationView{
    UIView *view = objc_getAssociatedObject(self, _cmd);
    if (!view) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.navigationBar.frame.size.width, 65.0)];
        [self.navigationBar.subviews.firstObject.subviews.firstObject addSubview:view];
        [self.navigationBar.subviews.firstObject.subviews.firstObject bringSubviewToFront:view];
        self.navigationView = view;
    }
    return view;
}

- (void)setNavigationView:(UIView *)navigationView{
    SEL key = @selector(navigationView);
    objc_setAssociatedObject(self, key, navigationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation LCMultipleColorViewController (MultipleColor)

- (BOOL)lc_interactivePopDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setLc_interactivePopDisabled:(BOOL)disabled
{
    objc_setAssociatedObject(self, @selector(lc_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)lc_prefersNavigationBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setLc_prefersNavigationBarHidden:(BOOL)hidden
{
    
    objc_setAssociatedObject(self, @selector(lc_prefersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)navigationBarColor{
    UIColor *color = objc_getAssociatedObject(self, _cmd);
    if (!color) {
        color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    }
    return color;
}

- (void)setNavigationBarColor:(UIColor *)navigationBarColor{
    SEL key = @selector(navigationBarColor);
    objc_setAssociatedObject(self, key, navigationBarColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    LCMultipleColorNavigationController *navigationController = (LCMultipleColorNavigationController *)self.navigationController;
    navigationController.navigationView.backgroundColor = navigationBarColor;
}

- (CGFloat)lc_interactivePopMaxAllowedInitialDistanceToLeftEdge
{
#if CGFLOAT_IS_DOUBLE
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
#else
    return [objc_getAssociatedObject(self, _cmd) floatValue];
#endif
}

- (void)setLc_interactivePopMaxAllowedInitialDistanceToLeftEdge:(CGFloat)distance
{
    SEL key = @selector(lc_interactivePopMaxAllowedInitialDistanceToLeftEdge);
    objc_setAssociatedObject(self, key, @(MAX(0, distance)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
