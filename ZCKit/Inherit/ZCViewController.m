//
//  ZCViewController.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCViewController.h"
#import "UIViewController+ZC.h"
#import "ZCKitBridge.h"
#import "UIView+ZC.h"
#import "ZCMacro.h"

NSNotificationName const ZCViewControllerDidBeGesPopNotification = @"ZCViewControllerDidBeGesPopNotification";

#pragma mark - ~ ZCViewControllerCustomPageSet ~
@implementation ZCViewControllerCustomPageSet

@end


#pragma mark - ~ ZCViewController ~
@interface ZCViewController ()

@property (nonatomic, assign) BOOL isPushToPresent;

@property (nonatomic, weak) UIViewController *visibleChildVc;

@property (nonatomic, copy) void(^willPushBlock)(UIViewController *toVc);

@property (nonatomic, copy) void(^willPopBlock)(UIViewController *toVc);

@property (nonatomic, weak) UIViewController *willPushToVc;

@property (nonatomic, weak) UIViewController *willPopToVc;

@property (nonatomic, assign) BOOL isWillPush;

@property (nonatomic, assign) BOOL isPopGes;

@property (nonatomic, assign) BOOL isParentNaviContainer;

@property (nonatomic, strong) ZCViewControllerCustomPageSet *customPageSet;

@end

@implementation ZCViewController

@synthesize iniProps = _iniProps;

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self initSetFunc];
    } return self;
}

- (instancetype)initWithIniProps:(NSDictionary<NSString *, id> *)iniProps {
    if (self = [super initWithNibName:nil bundle:nil]) {
        if (iniProps.count) { [self setValuesForKeysWithDictionary:iniProps]; }
        if (!iniProps) { iniProps = @{}; }
        _iniProps = iniProps.copy;
        [self initSetFunc];
    } return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initSetFunc];
    } return self;
}

- (void)initSetFunc {
    self.customPageSet = [[ZCViewControllerCustomPageSet alloc] init];
    if ([self respondsToSelector:@selector(onPageCustomInitSet:)]) {
        [(id<ZCViewControllerPageBackProtocol>)self onPageCustomInitSet:self.customPageSet];
    }
}

- (NSDictionary<NSString *, id> *)iniProps {
    if (!_iniProps) { _iniProps = @{}; }
    return _iniProps;
}

#pragma mark - Back
- (BOOL)isCanMSideBack {
    return YES;
}

- (int)currentPageStyle { 
    return 6;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.currentPageStyle & 1) {
        return UIStatusBarStyleLightContent;
    } else {
        if (@available(iOS 13.0, *)) { return UIStatusBarStyleDarkContent; }
        else { return UIStatusBarStyleDefault; }
    }
}

- (BOOL)prefersStatusBarHidden {
    if (self.currentPageStyle & 4) {
        return NO;
    } else {
        return YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor(@"#FFFFFF");
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.automaticallyAdjustsScrollViewInsets = NO;
    #pragma clang diagnostic pop
    self.edgesForExtendedLayout = UIRectEdgeAll;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetHideSystemNaviBarType:1];
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.automaticallyAdjustsScrollViewInsets = NO;
    #pragma clang diagnostic pop
    self.edgesForExtendedLayout = UIRectEdgeAll;
    if (self.currentPageStyle & 1) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        if (@available(iOS 13.0, *)) { [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent; }
        else { [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault; }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self resetCheckHideSystemNaviBarType:([self isCanMSideBack] ? 1 : 0)];
}

#pragma mark - System
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) wkself = self;
    self.willPopBlock = ^(UIViewController *toVc) { wkself.willPopToVc = toVc; wkself.isWillPush = NO; };
    self.willPushBlock = ^(UIViewController *toVc) { wkself.willPushToVc = toVc; wkself.isWillPush = YES; };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window) self.view = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self onResetNaviBarUserInterface];
    [self setNeedsStatusBarAppearanceUpdate];
    if (@available(iOS 11.0, *)) [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    if (@available(iOS 11.0, *)) [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    if (!self.presentedViewController && self.navigationController) {
        [self.navigationController setNavigationBarHidden:self.customPageSet.isPageHiddenNavigationBar animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    if (@available(iOS 11.0, *)) [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    if (@available(iOS 11.0, *)) [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    if (!self.presentedViewController && self.navigationController) {
        BOOL isWillBarHide = NO;
        if (self.isWillPush) {
            if (self.willPushToVc && [self.willPushToVc isKindOfClass:NSClassFromString(@"ZCViewController")]) {
                ZCViewControllerCustomPageSet *customPageSet = [self.willPushToVc valueForKey:@"customPageSet"];
                isWillBarHide = customPageSet.isPageHiddenNavigationBar;
            }
        } else {
            if (self.willPopToVc && [self.willPopToVc isKindOfClass:NSClassFromString(@"ZCViewController")]) {
                ZCViewControllerCustomPageSet *customPageSet = [self.willPopToVc valueForKey:@"customPageSet"];
                isWillBarHide = customPageSet.isPageHiddenNavigationBar;
            }
        }
        if (self.customPageSet.isPageHiddenNavigationBar != isWillBarHide) {
            [self.navigationController setNavigationBarHidden:isWillBarHide animated:animated];
        }
    }
}

#pragma mark - NaviBarUI
- (void)onResetNaviBarUserInterface {
    if (!self.presentedViewController && self.navigationController) {
        NSString *backName = ZCKitBridge.naviBarImageOrColor;
        if (self.customPageSet.naviUseCustomBackgroundName.length) backName = self.customPageSet.naviUseCustomBackgroundName;
        UIImage *backImage = [UIImage imageNamed:backName];
        if (!backImage) backImage = [UIImage imageWithColor:kZCS(backName)];
        
        UIImage *shadowImage = [UIImage imageWithColor:kZCSplit size:CGSizeMake(kZSWid, kZSPixel)];
        if (self.customPageSet.isNaviUseShieldBarLine) shadowImage = [UIImage imageWithColor:kZCClear size:CGSizeMake(kZSWid, kZSPixel)];
        
        UIColor *shadowColor = (!self.customPageSet.isNaviUseShieldBarLine && self.customPageSet.isNaviUseBarShadowColor) ? kZCSplit : kZCClear;
        CGFloat alpha = self.customPageSet.isNaviUseClearBar ? 0 : 1;
        [self resetiOS15BackImage:backImage shadowImage:shadowImage shadowColor:shadowColor alpha:alpha];
        
        if (@available(iOS 14.0, *)) {} else {
            [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:NO];
            [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:NO];
        }
    }
}

- (void)resetiOS15BackImage:(UIImage *)backImage shadowImage:(UIImage *)shadowImage shadowColor:(UIColor *)shadowColor alpha:(CGFloat)alpha {
    UIImage *arrowImage = ZCKitBridge.naviBackImage;
    if (self.customPageSet.naviUseCustomBackArrowImage) { arrowImage = self.customPageSet.naviUseCustomBackArrowImage; }
    if (arrowImage) arrowImage = [arrowImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc] init];
        appperance.backgroundEffect = nil;
        appperance.backgroundImage = backImage;
        appperance.backgroundColor = nil;
        appperance.shadowImage = shadowImage;
        [appperance setBackIndicatorImage:arrowImage transitionMaskImage:arrowImage];
        self.navigationController.navigationBar.standardAppearance = appperance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
    } else {
        self.navigationController.navigationBar.backIndicatorImage = arrowImage;
        self.navigationController.navigationBar.backIndicatorTransitionMaskImage = arrowImage;
        [self.navigationController.navigationBar setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:shadowImage];
    }
    self.navigationController.navigationBar.subviews.firstObject.alpha = alpha;
    self.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self.navigationController.navigationBar setShadow:shadowColor offset:CGSizeZero radius:1];
}

#pragma mark - Override
- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
}

- (void)didMoveToParentViewController:(UIViewController *)parent { ///!!!: 对于AddChildViewController，需要手动实现这两个方法
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
    return [super prefersStatusBarHidden];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForStatusBarHidden];
    }
    return [super childViewControllerForStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [super preferredStatusBarStyle];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForStatusBarStyle];
    }
    return [super childViewControllerForStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return [super preferredStatusBarUpdateAnimation];
}

- (BOOL)shouldAutorotate {
    return [super shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [super supportedInterfaceOrientations];
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures {
    return [super preferredScreenEdgesDeferringSystemGestures];
}

- (UIViewController *)childViewControllerForScreenEdgesDeferringSystemGestures {
    if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForScreenEdgesDeferringSystemGestures];
    }
    return [super childViewControllerForScreenEdgesDeferringSystemGestures];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return [super prefersHomeIndicatorAutoHidden];
}

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden {
    if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForHomeIndicatorAutoHidden];
    }
    return [super childViewControllerForHomeIndicatorAutoHidden];
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
