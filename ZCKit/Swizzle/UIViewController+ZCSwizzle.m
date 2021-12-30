//
//  UIViewController+ZCSwizzle.m
//  ZCKit
//
//  Created by admin on 2018/10/22.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIViewController+ZCSwizzle.h"
#import "UINavigationController+ZCSwizzle.h"
#import "UIViewController+ZC.h"
#import "ZCViewController.h"
#import "ZCSwizzleHeader.h"
#import "ZCKitBridge.h"
#import "UIView+ZC.h"
#import "ZCMacro.h"

@implementation UIViewController (ZCSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL sel1 = @selector(initWithNibName:bundle:);
        SEL sel1x = @selector(swizzle_initWithNibName:bundle:);
        SEL sel2 = @selector(viewDidLoad);
        SEL sel2x = @selector(swizzle_viewDidLoad);
        SEL sel3 = @selector(viewWillAppear:);
        SEL sel3x = @selector(swizzle_viewWillAppear:);
        SEL sel4 = @selector(viewDidLayoutSubviews);
        SEL sel4x = @selector(swizzle_viewDidLayoutSubviews);
        SEL sel5 = @selector(viewWillDisappear:);
        SEL sel5x = @selector(swizzle_viewWillDisappear:);
        zc_swizzle_exchange_selector(UIViewController.class, sel1, sel1x);
        zc_swizzle_exchange_selector(UIViewController.class, sel2, sel2x);
        zc_swizzle_exchange_selector(UIViewController.class, sel3, sel3x);
        zc_swizzle_exchange_selector(UIViewController.class, sel4, sel4x);
        zc_swizzle_exchange_selector(UIViewController.class, sel5, sel5x);
    });
}

- (instancetype)swizzle_initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    id instance = [self swizzle_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (instance) self.hidesBottomBarWhenPushed = YES; //如果希望值为NO的话，需要在init之后设置hidesBottomBarWhenPushed为NO;
    if (instance) self.modalPresentationStyle = UIModalPresentationFullScreen; //不显示层叠样式
    return instance;
}

- (void)swizzle_viewDidLoad {
    if (self.navigationController && self.parentViewController == self.navigationController) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = item;
    }
    [self swizzle_viewDidLoad];
}

- (void)swizzle_viewWillAppear:(BOOL)animated {
    if (ZCKitBridge.isPrintLog) {
        if ([self isKindOfClass:UIViewController.class] && ![self isKindOfClass:UINavigationController.class]) {
            if (ZCKitBridge.isPrintLog) NSLog(@"\nZCKit: --------- %@ --------- appear\n", NSStringFromClass(self.class));
        }
    }
    if (self.navigationController && self.parentViewController == self.navigationController) {
        if ([self swizzle_isHiddenNavigationBar]) {
            self.navigationController.navigationBar.subviews.firstObject.alpha = 1.0;
            [self.navigationController setValue:@(NO) forKey:@"isNormalBar"];
        } else {
            if ([self swizzle_isUseClearBar]) {
                UIImage *imageBar = [[UIImage alloc] init];
                UIImage *imageShadow = [[UIImage alloc] init];
                if (@available(iOS 13.0, *)) { //导航过渡需要的
                    imageBar = [UIImage imageNamed:ZCKitBridge.naviBarImageOrColor];
                    if (!imageBar) imageBar = [UIImage imageWithColor:kZCS(ZCKitBridge.naviBarImageOrColor)];
                    imageShadow = [UIImage imageWithColor:kZCSplit size:CGSizeMake(kZSWid, kZSPixel)];
                }
                self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
                [self.navigationController.navigationBar setBackgroundImage:imageBar forBarMetrics:UIBarMetricsDefault];
                [self.navigationController.navigationBar setShadowImage:imageShadow];
                [self.navigationController.navigationBar setShadow:kZCClear offset:CGSizeZero radius:1];
                [self.navigationController setValue:@(NO) forKey:@"isNormalBar"];
            } else if ([self swizzle_isShieldBarShadow]) {
                UIImage *imageBar = [UIImage imageNamed:ZCKitBridge.naviBarImageOrColor];
                if (!imageBar) imageBar = [UIImage imageWithColor:kZCS(ZCKitBridge.naviBarImageOrColor)];
                self.navigationController.navigationBar.subviews.firstObject.alpha = 1.0;
                [self.navigationController.navigationBar setBackgroundImage:imageBar forBarMetrics:UIBarMetricsDefault];
                [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
                [self.navigationController.navigationBar setShadow:kZCClear offset:CGSizeZero radius:1];
                [self.navigationController setValue:@(NO) forKey:@"isNormalBar"];
            } else if ([self swizzle_isUseCustomBar]) {
                UIColor *shadowColor = [self swizzle_isUseNaviBarShadowColor] ? kZCSplit : kZCClear;
                self.navigationController.navigationBar.subviews.firstObject.alpha = 1.0;
                [self.navigationController.navigationBar setShadow:shadowColor offset:CGSizeZero radius:1];
                [self.navigationController setValue:@(NO) forKey:@"isNormalBar"];
            } else {
                if (!self.navigationController.isNormalBar) {
                    UIImage *imageBar = [UIImage imageNamed:ZCKitBridge.naviBarImageOrColor];
                    if (!imageBar) imageBar = [UIImage imageWithColor:kZCS(ZCKitBridge.naviBarImageOrColor)];
                    UIImage *imageShadow = [UIImage imageWithColor:kZCSplit size:CGSizeMake(kZSWid, kZSPixel)];
                    UIColor *shadowColor = [self swizzle_isUseNaviBarShadowColor] ? kZCSplit : kZCClear;
                    self.navigationController.navigationBar.subviews.firstObject.alpha = 1.0;
                    [self.navigationController.navigationBar setBackgroundImage:imageBar forBarMetrics:UIBarMetricsDefault];
                    [self.navigationController.navigationBar setShadowImage:imageShadow];
                    [self.navigationController.navigationBar setShadow:shadowColor offset:CGSizeZero radius:1];
                    if (@available(iOS 14.0, *)) {} else { //iOS14以上不用在此刷新下这地方
                    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:NO];
                    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:NO];}
                    [self.navigationController setValue:@(![self swizzle_isUseNaviBarShadowColor]) forKey:@"isNormalBar"];
                }
            }
            if ([self swizzle_isUseTranslucentBar] || [self swizzle_isUseClearBar]) {
                self.navigationController.navigationBar.barTintColor = nil;
                self.navigationController.navigationBar.translucent = YES;
                self.extendedLayoutIncludesOpaqueBars = NO;
            } else {
                self.navigationController.navigationBar.barTintColor = nil;
                self.navigationController.navigationBar.translucent = NO;
                self.extendedLayoutIncludesOpaqueBars = YES;
            }
        }
    }
    [self swizzle_viewWillAppear:animated];
    for (UIView *view in self.view.containAllSubviews) {
        if ([view respondsToSelector:@selector(onControllerViewWillAppear)]) {
            [(id<ZCViewLayoutProtocol>)view onControllerViewWillAppear];
        }
    }
}

- (void)swizzle_viewWillDisappear:(BOOL)animated {
    [self swizzle_viewWillDisappear:animated];
    for (UIView *view in self.view.containAllSubviews) {
        if ([view respondsToSelector:@selector(onControllerViewWillDisappear)]) {
            [(id<ZCViewLayoutProtocol>)view onControllerViewWillDisappear];
        }
    }
}

- (void)swizzle_viewDidLayoutSubviews {
    [self swizzle_viewDidLayoutSubviews];
    for (UIView *view in self.view.containAllSubviews) {
        if ([view respondsToSelector:@selector(onControllerDidLayout)]) {
            [(id<ZCViewLayoutProtocol>)view onControllerDidLayout];
        }
    }
}

#pragma mark - Private
- (BOOL)swizzle_isUseCustomBar {
    SEL sel = @selector(isUseCustomBar);
    if ([self respondsToSelector:sel]) {
        kZSuppressLeakWarn([self performSelector:sel]); return YES;
    }
    return NO;
}

- (BOOL)swizzle_isUseClearBar {
    BOOL use = NO; SEL sel = @selector(isUseClearBar);
    if ([self respondsToSelector:sel]) {
        kZSuppressLeakWarn(use = (BOOL)[self performSelector:sel]);
    }
    return use;
}

- (BOOL)swizzle_isShieldBarShadow {
    BOOL use = NO; SEL sel = @selector(isShieldBarShadow);
    if ([self respondsToSelector:sel]) {
        kZSuppressLeakWarn(use = (BOOL)[self performSelector:sel]);
    }
    return use;
}

- (BOOL)swizzle_isUseTranslucentBar {
    BOOL use = NO; SEL sel = @selector(isUseTranslucentBar);
    if ([self respondsToSelector:sel]) {
        kZSuppressLeakWarn(use = (BOOL)[self performSelector:sel]);
    }
    return use;
}

- (BOOL)swizzle_isUseNaviBarShadowColor {
    BOOL use = NO; SEL sel = @selector(isUseNaviBarShadowColor);
    if ([self respondsToSelector:sel]) {
        kZSuppressLeakWarn(use = (BOOL)[self performSelector:sel]);
    }
    return use;
}

- (BOOL)swizzle_isHiddenNavigationBar {
    BOOL use = NO; SEL sel = @selector(isHiddenNavigationBar);
    if ([self respondsToSelector:sel]) {
        kZSuppressLeakWarn(use = (BOOL)[self performSelector:sel]);
    }
    return use;
}

@end
