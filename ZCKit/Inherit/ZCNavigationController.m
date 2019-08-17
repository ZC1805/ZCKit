//
//  ZCNavigationController.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCNavigationController.h"
#import "UIViewController+ZC.h"
#import "ZCQueueHandler.h"
#import "ZCMacro.h"

NSNotificationName const ZCViewControllerWillBeTouchPopNotification = @"ZCViewControllerWillBeTouchPopNotification";

@interface ZCNavigationController () <UIGestureRecognizerDelegate, UINavigationBarDelegate>

@property (nonatomic, assign) BOOL isPushToPresent;

@property (nonatomic, assign) BOOL isPopAnimating;

@property (nonatomic, weak) UIViewController *visibleChildVc;

@property (nonatomic, weak) UIViewController *willPopTopViewController;

@end

@implementation ZCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPopAnimating = NO;
    self.interactivePopGestureRecognizer.enabled = YES;
    if (self.navigationBar.delegate != self) self.navigationBar.delegate = self;
    if (self.interactivePopGestureRecognizer.delegate != self) self.interactivePopGestureRecognizer.delegate = self;
    [self.interactivePopGestureRecognizer addTarget:self action:@selector(onPopGesEvent:)];
}

///!!!:旋转 & 自定义导航返回箭头 & 通知跳转(前台时候显示红点) & 自定义present动画 && dismiss动画 && 全屏手势返回
- (void)setIsShowRootControllerBackIndicator:(BOOL)isShowRootControllerBackIndicator {
    _isShowRootControllerBackIndicator = isShowRootControllerBackIndicator;
    if (_isShowRootControllerBackIndicator && self.viewControllers.count) {

    }
}

#pragma mark - private
- (void)onPopGesEvent:(UIGestureRecognizer *)gesture {
    if (gesture == self.interactivePopGestureRecognizer && gesture.state == UIGestureRecognizerStateEnded) {
        [self viewControllerIsPopGes:YES viewController:self.willPopTopViewController];
    }
}

- (void)viewControllerIsPopGes:(BOOL)isPopGes viewController:(UIViewController *)viewController {
    if (viewController && [viewController isKindOfClass:[ZCViewController class]]) {
        [viewController setValue:@(isPopGes) forKey:@"isPopGes"];
    }
}

#pragma mark - override
- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    for (UIViewController *viewColr in self.viewControllers) {
        [self viewControllerIsPopGes:NO viewController:viewColr];
    }
    [super setViewControllers:viewControllers];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    for (UIViewController *viewColr in self.viewControllers) {
        [self viewControllerIsPopGes:NO viewController:viewColr];
    }
    [super setViewControllers:viewControllers animated:animated];
}

#pragma mark - override
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController && self.topViewController && [self.topViewController isKindOfClass:[ZCViewController class]]) {
        ZCViewController *fromVc = (ZCViewController *)self.topViewController;
        void(^willPush)(UIViewController *toVc) = (void(^)(UIViewController *toVc))[fromVc valueForKey:@"willPush"];
        if (willPush) willPush(viewController);
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    self.willPopTopViewController = self.topViewController;
    [self viewControllerIsPopGes:NO viewController:self.topViewController];
    UIViewController *viewController = nil;
    if (self.viewControllers.count > 1) {
        viewController = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
    }
    if (viewController && self.topViewController && [self.topViewController isKindOfClass:[ZCViewController class]]) {
        ZCViewController *fromVc = (ZCViewController *)self.topViewController;
        void(^willPop)(UIViewController *toVc) = (void(^)(UIViewController *toVc))[fromVc valueForKey:@"willPop"];
        if (willPop) willPop(viewController);
    }
    return [super popViewControllerAnimated:animated];
}

- (NSArray <__kindof UIViewController *>*)popToRootViewControllerAnimated:(BOOL)animated {
    self.willPopTopViewController = self.topViewController;
    [self viewControllerIsPopGes:NO viewController:self.topViewController];
    UIViewController *viewController = nil;
    if (self.viewControllers.count > 1) {
        viewController = [self.viewControllers objectAtIndex:0];
    }
    if (viewController && self.topViewController && [self.topViewController isKindOfClass:[ZCViewController class]]) {
        ZCViewController *fromVc = (ZCViewController *)self.topViewController;
        void(^willPop)(UIViewController *toVc) = (void(^)(UIViewController *toVc))[fromVc valueForKey:@"willPop"];
        if (willPop) willPop(viewController);
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray <__kindof UIViewController *>*)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.willPopTopViewController = self.topViewController;
    [self viewControllerIsPopGes:NO viewController:self.topViewController];
    BOOL isCanPass = NO;
    if (viewController && self.viewControllers.count > 1 && [self.viewControllers containsObject:viewController]) {
        if (viewController != self.topViewController) {
            isCanPass = YES;
        }
    }
    if (isCanPass && self.topViewController && [self.topViewController isKindOfClass:[ZCViewController class]]) {
        ZCViewController *fromVc = (ZCViewController *)self.topViewController;
        void(^willPop)(UIViewController *toVc) = (void(^)(UIViewController *toVc))[fromVc valueForKey:@"willPop"];
        if (willPop) willPop(viewController);
    }
    return [super popToViewController:viewController animated:animated];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.interactivePopGestureRecognizer == gestureRecognizer) {
        if (self.viewControllers.count <= 1) return NO;
        if ([self.topViewController respondsToSelector:@selector(onCustomBackAction)]) return NO;
        BOOL use = NO; SEL sel = @selector(isShieldInteractivePop);
        if ([self.topViewController respondsToSelector:sel]) {
            zc_suppress_leak_warning(use = (BOOL)[self.topViewController performSelector:sel]);
        }
        return !use;
    }
    return YES;
}

#pragma mark - UINavigationBarDelegate
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    BOOL shouldPop = YES; //非手动pop不走此代理
    NSUInteger vcsCount = self.viewControllers.count;
    NSUInteger itemsCount = navigationBar.items.count;
    if (self.isPopAnimating) {
        if (vcsCount < itemsCount) {
            self.isPopAnimating = NO;
            return YES;
        } else {
            return NO;
        }
    }
    
    self.isPopAnimating = YES;
    if (vcsCount < itemsCount) { //非系统手动pop不走此
        self.isPopAnimating = NO;
        return YES;
    }
    UIViewController *vc = self.topViewController;
    if ([vc respondsToSelector:@selector(isCanResponseTouchPop)]) {
        shouldPop = [(id<ZCViewControllerBackProtocol>)vc isCanResponseTouchPop];
    }
    
    if (shouldPop) {
        main_imp(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ZCViewControllerWillBeTouchPopNotification object:self.topViewController];
            if ([vc respondsToSelector:@selector(onCustomBackAction)]) {
                [(id<ZCViewControllerBackProtocol>)vc onCustomBackAction];
            } else {
                [self popViewControllerAnimated:YES];
            }
        });
    } else {
        [self setNavigationBarHidden:YES];
        [self setNavigationBarHidden:NO];
    }
    main_delay(0.3, ^{self.isPopAnimating = NO;});
    return shouldPop;
}

#pragma mark - override
- (BOOL)prefersStatusBarHidden {
    if (self.topViewController) {
        return [self.topViewController prefersStatusBarHidden];
    } else {
        return [super prefersStatusBarHidden];
    }
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    if (self.topViewController) {
        return self.topViewController;
    } else if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForStatusBarHidden];
    } else {
        return [super childViewControllerForStatusBarHidden];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.topViewController) {
        return [self.topViewController preferredStatusBarStyle];
    } else {
        return [super preferredStatusBarStyle];
    }
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    if (self.topViewController) {
        return self.topViewController;
    } else if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForStatusBarStyle];
    } else {
        return [super childViewControllerForStatusBarStyle];
    }
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if (self.topViewController) {
        return [self.topViewController preferredStatusBarUpdateAnimation];
    } else {
        return [super preferredStatusBarUpdateAnimation];
    }
}

- (BOOL)shouldAutorotate {
    if (self.topViewController) {
        return [self.topViewController shouldAutorotate];
    } else {
        return [super shouldAutorotate];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.topViewController) {
        return [self.topViewController supportedInterfaceOrientations];
    } else {
        return [super supportedInterfaceOrientations];
    }
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures {
    if (self.topViewController) {
        return [self.topViewController preferredScreenEdgesDeferringSystemGestures];
    } else {
        return [super preferredScreenEdgesDeferringSystemGestures];
    }
}

- (UIViewController *)childViewControllerForScreenEdgesDeferringSystemGestures {
    if (self.topViewController) {
        return self.topViewController;
    } else if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForScreenEdgesDeferringSystemGestures];
    } else {
        return [super childViewControllerForScreenEdgesDeferringSystemGestures];
    }
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    if (self.topViewController) {
        return [self.topViewController prefersHomeIndicatorAutoHidden];
    } else {
        return [super prefersHomeIndicatorAutoHidden];
    }
}

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden {
    if (self.topViewController) {
        return self.topViewController;
    } else if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForHomeIndicatorAutoHidden];
    } else {
        return [super childViewControllerForHomeIndicatorAutoHidden];
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if (self.isUsePushStyleToPresent) {
        CATransition *transition = [CATransition animation];
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.duration = 0.375;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.layer addAnimation:transition forKey:nil];
        [super dismissViewControllerAnimated:NO completion:completion];
    } else {
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (self.presentedViewController) {
        [self.presentFromViewController presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        if ([viewControllerToPresent respondsToSelector:@selector(isUsePushStyleToPresent)] &&
            [(id<ZCViewControllerPrivateProtocol>)viewControllerToPresent isUsePushStyleToPresent]) {
            CATransition *transition = [CATransition animation];
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            transition.duration = 0.375;
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.layer addAnimation:transition forKey:nil];
            [super presentViewController:viewControllerToPresent animated:NO completion:completion];
        } else {
            [super presentViewController:viewControllerToPresent animated:flag completion:completion];
        }
    }
}

#pragma mark - ZCViewControllerPrivateProtocol
- (void)setIsUsePushStyleToPresent:(BOOL)isUsePushStyleToPresent {
    self.isPushToPresent = isUsePushStyleToPresent;
}

- (BOOL)isUsePushStyleToPresent {
    return self.isPushToPresent;
}

- (void)setVisibleChildViewController:(UIViewController *)visibleChildViewController {
    self.visibleChildVc = visibleChildViewController;
}

- (UIViewController *)visibleChildViewController {
    return self.visibleChildVc;
}

@end
