//
//  ZCViewController.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCViewController.h"
#import "UIViewController+ZC.h"

NSNotificationName const ZCViewControllerDidBeGesPopNotification = @"ZCViewControllerDidBeGesPopNotification";

@interface ZCViewController ()

@property (nonatomic, assign) BOOL isPushToPresent;

@property (nonatomic, assign) CGFloat slipNaciBackAlpha;

@property (nonatomic, weak) UIViewController *visibleChildVc;

@property (nonatomic, copy) void(^willPush)(UIViewController *toVc);

@property (nonatomic, copy) void(^willPop)(UIViewController *toVc);

@property (nonatomic, weak) UIViewController *willPushToVc;

@property (nonatomic, weak) UIViewController *willPopToVc;

@property (nonatomic, assign) BOOL isWillPush;

@property (nonatomic, assign) BOOL isPopGes;

@property (nonatomic, assign) BOOL isParentNaviContainer;

@end

@implementation ZCViewController

#pragma mark - ZCViewControllerBackProtocol
- (BOOL)isHiddenNavigationBar {
    return NO;
}

#pragma mark - System
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) wkself = self;
    self.willPop = ^(UIViewController *toVc) { wkself.willPopToVc = toVc; wkself.isWillPush = NO; };
    self.willPush = ^(UIViewController *toVc) { wkself.willPushToVc = toVc; wkself.isWillPush = YES; };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window) self.view = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    if (@available(iOS 11.0, *)) [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    if (@available(iOS 11.0, *)) [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    if (!self.presentedViewController && self.navigationController && [self respondsToSelector:@selector(isHiddenNavigationBar)]) {
        [self.navigationController setNavigationBarHidden:[self isHiddenNavigationBar] animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    if (@available(iOS 11.0, *)) [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    if (@available(iOS 11.0, *)) [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    if (!self.presentedViewController && self.navigationController && [self respondsToSelector:@selector(isHiddenNavigationBar)]) {
        BOOL isWillBarHide = NO;
        if (self.isWillPush) {
            if (self.willPushToVc && [self.willPushToVc respondsToSelector:@selector(isHiddenNavigationBar)]) {
                isWillBarHide = [(id<ZCViewControllerBackProtocol>)self.willPushToVc isHiddenNavigationBar];
            }
        } else {
            if (self.willPopToVc && [self.willPopToVc respondsToSelector:@selector(isHiddenNavigationBar)]) {
                isWillBarHide = [(id<ZCViewControllerBackProtocol>)self.willPopToVc isHiddenNavigationBar];
            }
        }
        if ([self isHiddenNavigationBar] != isWillBarHide) {
            [self.navigationController setNavigationBarHidden:isWillBarHide animated:animated];
        }
    }
}

#pragma mark - Override
- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent { //对于AddChildViewController，需要手动实现这两个方法
    [super didMoveToParentViewController:parent];
    if (!parent && self.isParentNaviContainer && self.isPopGes) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ZCViewControllerDidBeGesPopNotification object:self];
    }
    if (parent && [parent isKindOfClass:NSClassFromString(@"ZCNavigationController")]) {
        self.isParentNaviContainer = YES;
    } else {
        self.isParentNaviContainer = NO;
    }
}

#pragma mark - Override
- (BOOL)prefersStatusBarHidden {
    return [super prefersStatusBarHidden]; //NO
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForStatusBarHidden];
    }
    return [super childViewControllerForStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault; //return [super preferredStatusBarStyle];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForStatusBarStyle];
    }
    return [super childViewControllerForStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return [super preferredStatusBarUpdateAnimation]; //UIStatusBarAnimationFade
}

- (BOOL)shouldAutorotate {
    return [super shouldAutorotate]; //YES
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [super supportedInterfaceOrientations]; //current user set
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures {
    return [super preferredScreenEdgesDeferringSystemGestures]; //UIRectEdgeNone(返回UIRectEdgeAll可半透明底部HomeIndicator)
}

- (UIViewController *)childViewControllerForScreenEdgesDeferringSystemGestures {
    if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForScreenEdgesDeferringSystemGestures];
    }
    return [super childViewControllerForScreenEdgesDeferringSystemGestures];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return [super prefersHomeIndicatorAutoHidden]; //NO
}

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden {
    if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForHomeIndicatorAutoHidden];
    }
    return [super childViewControllerForHomeIndicatorAutoHidden];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if (self.isUsePushStyleToPresent) { //待实现
        [super dismissViewControllerAnimated:flag completion:completion];
    } else {
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (self.presentedViewController) {
        [self.presentFromViewController presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        if ([viewControllerToPresent respondsToSelector:@selector(isUsePushStyleToPresent)] &&
            [(id<ZCViewControllerPrivateProtocol>)viewControllerToPresent isUsePushStyleToPresent]) { //待实现
            [super presentViewController:viewControllerToPresent animated:flag completion:completion];
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
