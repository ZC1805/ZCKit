//
//  ZCNavigationController.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCNavigationController.h"
#import "UIViewController+ZC.h"
#import "ZCViewController.h"
#import "ZCQueueHandler.h"
#import "ZCImageView.h"
#import "UIView+ZC.h"
#import "ZCMacro.h"

NSNotificationName const ZCViewControllerWillBeTouchPopNotification = @"ZCViewControllerWillBeTouchPopNotification";

@interface ZCNavigationController () <UIGestureRecognizerDelegate, UINavigationBarDelegate>

@property (nonatomic, assign) BOOL isPushToPresent;

@property (nonatomic, assign) BOOL isPopAnimating;

@property (nonatomic, weak) UIViewController *visibleChildVc;

@property (nonatomic, weak) UIViewController *willPopTopViewController;

@property (nonatomic, weak) UIViewController *iPopGesPopFromVc;

@property (nonatomic, weak) UIViewController *iPopGesPopToVc;

@property (nonatomic, assign) CGFloat iPopGesPopFromAlpha;

@property (nonatomic, assign) CGFloat iPopGesPopToAlpha;

@property (nonatomic, assign) BOOL iPopGesPopAnimate;

@property (nonatomic, strong) UIImage *iPopGesPopFromImage;

@property (nonatomic, strong) ZCImageView *iPopGesPopTopImageView;

@property (nonatomic, strong) NSArray *iGesTempViewControllers;

@property (nonatomic, assign) BOOL iGesPopDelay;

@end

@implementation ZCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPopAnimating = NO;
    self.view.backgroundColor = kZCWhite;
    self.interactivePopGestureRecognizer.enabled = YES;
    if (self.navigationBar.delegate != self) self.navigationBar.delegate = self;
    if (self.interactivePopGestureRecognizer.delegate != self) self.interactivePopGestureRecognizer.delegate = self;
    [self.interactivePopGestureRecognizer addTarget:self action:@selector(onPopGesEvent:)];
}

#pragma mark - Private
- (void)onPopGesEvent:(UIGestureRecognizer *)gesture {
    if (gesture == self.interactivePopGestureRecognizer) {
        if (gesture.state == UIGestureRecognizerStateEnded) {
            [self viewControllerIsPopGes:YES viewController:self.willPopTopViewController];
        }
    }
    if (@available(iOS 13.0, *)) { //导航颜色过渡
        if (gesture == self.interactivePopGestureRecognizer) {
            if (gesture.state == UIGestureRecognizerStateBegan) {
                self.iPopGesPopToVc = self.topViewController;
                self.iPopGesPopToAlpha = -1;
                ZCViewControllerCustomPageSet *fromVccustomPageSet = nil;
                if ([self.iPopGesPopFromVc isKindOfClass:NSClassFromString(@"ZCViewController")]) {
                    fromVccustomPageSet = [self.iPopGesPopFromVc valueForKey:@"customPageSet"];
                }
                ZCViewControllerCustomPageSet *toVccustomPageSet = nil;
                if ([self.iPopGesPopToVc isKindOfClass:NSClassFromString(@"ZCViewController")]) {
                    toVccustomPageSet = [self.iPopGesPopToVc valueForKey:@"customPageSet"];
                }
                if (fromVccustomPageSet && toVccustomPageSet && !fromVccustomPageSet.isPageHiddenNavigationBar && !toVccustomPageSet.isPageHiddenNavigationBar) {
                    BOOL isClearFrom = fromVccustomPageSet.isNaviUseClearBar;
                    BOOL isClearTo = toVccustomPageSet.isNaviUseClearBar;
                    BOOL isCustomFrom = fromVccustomPageSet.naviUseCustomBackgroundName.length;
                    BOOL isCustomTo = toVccustomPageSet.naviUseCustomBackgroundName.length;
                    if ((isCustomFrom && !isClearTo) || (isCustomTo && !isClearFrom)) {
                        UIView *barBKView = self.navigationBar.subviews.firstObject;
                        if (barBKView && !self.iPopGesPopTopImageView) {
                            self.iPopGesPopTopImageView = [[ZCImageView alloc] initWithFrame:barBKView.frame image:nil];
                            self.iPopGesPopTopImageView.contentMode = barBKView.contentMode;
                            self.iPopGesPopTopImageView.userInteractionEnabled = YES;
                        }
                        if (self.iPopGesPopTopImageView && self.iPopGesPopFromImage) {
                            self.iPopGesPopTopImageView.image = self.iPopGesPopFromImage;
                            self.iPopGesPopTopImageView.alpha = self.iPopGesPopFromAlpha;
                        }
                        [self.iPopGesPopTopImageView removeFromSuperview];
                        if (barBKView && self.iPopGesPopTopImageView && ![self.iPopGesPopTopImageView isDescendantOfView:self.navigationBar]) {
                            [self.navigationBar insertSubview:self.iPopGesPopTopImageView aboveSubview:barBKView];
                        }
                    }
                }
            } else if (gesture.state == UIGestureRecognizerStateChanged) {
                UIView *barBKView = self.navigationBar.subviews.firstObject;
                if (self.iPopGesPopToAlpha == -1) self.iPopGesPopToAlpha = barBKView.alpha;
                if (self.iPopGesPopFromVc && self.iPopGesPopToVc) {
                    ZCViewControllerCustomPageSet *fromVccustomPageSet = nil;
                    if ([self.iPopGesPopFromVc isKindOfClass:NSClassFromString(@"ZCViewController")]) {
                        fromVccustomPageSet = [self.iPopGesPopFromVc valueForKey:@"customPageSet"];
                    }
                    ZCViewControllerCustomPageSet *toVccustomPageSet = nil;
                    if ([self.iPopGesPopToVc isKindOfClass:NSClassFromString(@"ZCViewController")]) {
                        toVccustomPageSet = [self.iPopGesPopToVc valueForKey:@"customPageSet"];
                    }
                    if (fromVccustomPageSet && toVccustomPageSet && !fromVccustomPageSet.isPageHiddenNavigationBar && !toVccustomPageSet.isPageHiddenNavigationBar) {
                        BOOL isClearFrom = fromVccustomPageSet.isNaviUseClearBar;
                        BOOL isClearTo = toVccustomPageSet.isNaviUseClearBar;
                        BOOL isCustomFrom = fromVccustomPageSet.naviUseCustomBackgroundName.length;
                        BOOL isCustomTo = toVccustomPageSet.naviUseCustomBackgroundName.length;
                        if ((isCustomFrom && !isClearTo) || (isCustomTo && !isClearFrom)) {
                            CGFloat clearAlpha = [(UIScreenEdgePanGestureRecognizer *)gesture translationInView:gesture.view].x / gesture.view.zc_width;
                            barBKView.alpha = clearAlpha * self.iPopGesPopToAlpha;
                            self.iPopGesPopTopImageView.alpha = (1.0 - clearAlpha) * self.iPopGesPopFromAlpha;
                        } else if (isClearFrom && !isClearTo && gesture.view) {
                            CGFloat clearAlpha = [(UIScreenEdgePanGestureRecognizer *)gesture translationInView:gesture.view].x / gesture.view.zc_width;
                            barBKView.alpha = clearAlpha * self.iPopGesPopToAlpha;
                        } else if (!isClearFrom && isClearTo && gesture.view) {
                            CGFloat clearAlpha = [(UIScreenEdgePanGestureRecognizer *)gesture translationInView:gesture.view].x / gesture.view.zc_width;
                            barBKView.alpha = (1.0 - clearAlpha) * self.iPopGesPopFromAlpha;
                        }
                    }
                }
            } else if (gesture.state == UIGestureRecognizerStateEnded) {
                UIView *barBKView = self.navigationBar.subviews.firstObject;
                if (self.iPopGesPopToAlpha == -1) self.iPopGesPopToAlpha = barBKView.alpha;
                if (self.iPopGesPopFromVc && self.iPopGesPopToVc) {
                    ZCViewControllerCustomPageSet *fromVccustomPageSet = nil;
                    if ([self.iPopGesPopFromVc isKindOfClass:NSClassFromString(@"ZCViewController")]) {
                        fromVccustomPageSet = [self.iPopGesPopFromVc valueForKey:@"customPageSet"];
                    }
                    ZCViewControllerCustomPageSet *toVccustomPageSet = nil;
                    if ([self.iPopGesPopToVc isKindOfClass:NSClassFromString(@"ZCViewController")]) {
                        toVccustomPageSet = [self.iPopGesPopToVc valueForKey:@"customPageSet"];
                    }
                    if (fromVccustomPageSet && toVccustomPageSet && !fromVccustomPageSet.isPageHiddenNavigationBar && !toVccustomPageSet.isPageHiddenNavigationBar) {
                        BOOL isClearFrom = fromVccustomPageSet.isNaviUseClearBar;
                        BOOL isClearTo = toVccustomPageSet.isNaviUseClearBar;
                        BOOL isCustomFrom = fromVccustomPageSet.naviUseCustomBackgroundName.length;
                        BOOL isCustomTo = toVccustomPageSet.naviUseCustomBackgroundName.length;
                        if ((isCustomFrom && !isClearTo) || (isCustomTo && !isClearFrom)) {
                            self.iPopGesPopAnimate = YES;
                            CGFloat clearAlpha = [(UIScreenEdgePanGestureRecognizer *)gesture translationInView:gesture.view].x / gesture.view.zc_width;
                            [UIView animateWithDuration:0.36 animations:^{
                                barBKView.alpha = clearAlpha > 0.49 ? self.iPopGesPopToAlpha : 0;
                                self.iPopGesPopTopImageView.alpha = clearAlpha > 0.49 ? 0 : self.iPopGesPopFromAlpha;
                            } completion:^(BOOL finished) {
                                barBKView.alpha = clearAlpha > 0.49 ? self.iPopGesPopToAlpha : self.iPopGesPopFromAlpha;
                                self.iPopGesPopTopImageView.alpha = clearAlpha > 0.49 ? self.iPopGesPopToAlpha : self.iPopGesPopFromAlpha;
                                [self.iPopGesPopTopImageView removeFromSuperview];
                                self.iPopGesPopAnimate = NO;
                            }];
                        } else if (isClearFrom && !isClearTo && gesture.view) {
                            self.iPopGesPopAnimate = YES;
                            CGFloat clearAlpha = [(UIScreenEdgePanGestureRecognizer *)gesture translationInView:gesture.view].x / gesture.view.zc_width;
                            [UIView animateWithDuration:0.36 animations:^{
                                barBKView.alpha = clearAlpha > 0.49 ? self.iPopGesPopToAlpha : 0;
                            } completion:^(BOOL finished) {
                                barBKView.alpha = clearAlpha > 0.49 ? self.iPopGesPopToAlpha : self.iPopGesPopFromAlpha;
                                [self.iPopGesPopTopImageView removeFromSuperview];
                                self.iPopGesPopAnimate = NO;
                            }];
                        } else if (!isClearFrom && isClearTo && gesture.view) {
                            self.iPopGesPopAnimate = YES;
                            CGFloat clearAlpha = [(UIScreenEdgePanGestureRecognizer *)gesture translationInView:gesture.view].x / gesture.view.zc_width;
                            [UIView animateWithDuration:0.36 animations:^{
                                barBKView.alpha = clearAlpha > 0.49 ? 0 : self.iPopGesPopFromAlpha;
                            } completion:^(BOOL finished) {
                                barBKView.alpha = clearAlpha > 0.49 ? self.iPopGesPopToAlpha : self.iPopGesPopFromAlpha;
                                [self.iPopGesPopTopImageView removeFromSuperview];
                                self.iPopGesPopAnimate = NO;
                            }];
                        } else {
                            [self.iPopGesPopTopImageView removeFromSuperview];
                        }
                    }
                }
            }
        }
    }
    if (gesture == self.interactivePopGestureRecognizer) {
        if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {
            if (self.iGesTempViewControllers) {
                self.iGesPopDelay = YES;
                main_delay(0.51, ^{ //确保viewControllers已经改变完成
                    [self gestureRecognizerHandleFinish:gesture];
                    self.iGesPopDelay = NO;
                });
            }
        }
    }
}

- (void)viewControllerIsPopGes:(BOOL)isPopGes viewController:(UIViewController *)viewController {
    if (viewController && [viewController isKindOfClass:ZCViewController.class]) {
        [viewController setValue:@(isPopGes) forKey:@"isPopGes"];
    }
}

#pragma mark - Override
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

#pragma mark - Override
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController && self.topViewController && [self.topViewController isKindOfClass:ZCViewController.class]) {
        ZCViewController *fromVc = (ZCViewController *)self.topViewController;
        void(^willPushBlock)(UIViewController *toVc) = (void(^)(UIViewController *toVc))[fromVc valueForKey:@"willPushBlock"];
        if (willPushBlock) willPushBlock(viewController);
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
    if (viewController && self.topViewController && [self.topViewController isKindOfClass:ZCViewController.class]) {
        ZCViewController *fromVc = (ZCViewController *)self.topViewController;
        void(^willPopBlock)(UIViewController *toVc) = (void(^)(UIViewController *toVc))[fromVc valueForKey:@"willPopBlock"];
        if (willPopBlock) willPopBlock(viewController);
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
    if (viewController && self.topViewController && [self.topViewController isKindOfClass:ZCViewController.class]) {
        ZCViewController *fromVc = (ZCViewController *)self.topViewController;
        void(^willPopBlock)(UIViewController *toVc) = (void(^)(UIViewController *toVc))[fromVc valueForKey:@"willPopBlock"];
        if (willPopBlock) willPopBlock(viewController);
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
    if (isCanPass && self.topViewController && [self.topViewController isKindOfClass:ZCViewController.class]) {
        ZCViewController *fromVc = (ZCViewController *)self.topViewController;
        void(^willPopBlock)(UIViewController *toVc) = (void(^)(UIViewController *toVc))[fromVc valueForKey:@"willPopBlock"];
        if (willPopBlock) willPopBlock(viewController);
    }
    return [super popToViewController:viewController animated:animated];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.interactivePopGestureRecognizer == gestureRecognizer) {
        UIViewController *topVc = self.topViewController;
        self.iPopGesPopFromVc = self.topViewController;
        self.iPopGesPopFromAlpha = self.navigationBar.subviews.firstObject.alpha;
        if (@available(iOS 15.0, *)) { self.iPopGesPopFromImage = self.navigationBar.standardAppearance.backgroundImage;
        } else { self.iPopGesPopFromImage = [self.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault]; }
        if (self.iPopGesPopAnimate || self.iGesPopDelay) return NO;
        if (self.viewControllers.count <= 1) return NO;
        if ([topVc respondsToSelector:@selector(onPageCustomTapBackAction)] && ![topVc respondsToSelector:@selector(onPageCustomPanBackAction)]) return NO;
        BOOL isCan = NO;
        if ([topVc isKindOfClass:NSClassFromString(@"ZCViewController")]) {
            ZCViewControllerCustomPageSet *customPageSet = [topVc valueForKey:@"customPageSet"];
            isCan = customPageSet.isPageShieldInteractivePop;
        }
        if (!isCan && gestureRecognizer.state == UIGestureRecognizerStatePossible && [topVc respondsToSelector:@selector(onPageCustomPanBackAction)]) { //可以手动返回
            UIViewController *aimVc = [(id<ZCViewControllerPageBackProtocol>)topVc onPageCustomPanBackAction];
            if (aimVc && [self.viewControllers containsObject:aimVc]) {
                NSInteger aimIndex = [self.viewControllers indexOfObject:aimVc];
                if (aimIndex < self.viewControllers.count - 2) {
                    self.iGesTempViewControllers = self.viewControllers;
                    NSArray *aimViewControllers = [self.viewControllers subarrayWithRange:NSMakeRange(0, self.viewControllers.count - 2)];
                    self.viewControllers = [aimViewControllers arrayByAddingObject:self.viewControllers.lastObject];
                }
            }
        }
        return !isCan;
    }
    return YES;
}

- (void)gestureRecognizerHandleFinish:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.viewControllers containsObject:self.iGesTempViewControllers.lastObject]) {
        self.viewControllers = self.iGesTempViewControllers; //侧滑取消重置到之前
    }
    self.iGesTempViewControllers = nil;
}

#pragma mark - UINavigationBarDelegate
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    __block BOOL shouldPop = YES; ///!!!: 非系统手动pop不走此代理
    NSUInteger vcsCount = self.viewControllers.count;
    NSUInteger itemsCount = navigationBar.items.count;
    if (self.isPopAnimating) {
        if (vcsCount < itemsCount) {
            self.isPopAnimating = NO; return YES;
        } else {
            return NO;
        }
    }
    
    self.isPopAnimating = YES;
    if (vcsCount < itemsCount) { ///!!!: 非系统手动pop不走此
        self.isPopAnimating = NO; return YES;
    }
    UIViewController *vc = self.topViewController;
    if (shouldPop) {
        main_imp(^{
            if ([vc respondsToSelector:@selector(onPageCustomTapBackAction)]) {
                [(id<ZCViewControllerPageBackProtocol>)vc onPageCustomTapBackAction];
                if (@available(iOS 13.0, *)) {
                    shouldPop = NO;
                }
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZCViewControllerWillBeTouchPopNotification object:vc];
                if (@available(iOS 13.0, *)) {
                    
                } else {
                    [self popViewControllerAnimated:YES];
                }
            }
        });
    } else {
        [self setNavigationBarHidden:YES];
        [self setNavigationBarHidden:NO];
    }
    main_delay(0.3, ^{ self.isPopAnimating = NO; });
    return shouldPop;
}

#pragma mark - Override
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
        ///!!!: 待实现
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
            ///!!!: 待实现
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
