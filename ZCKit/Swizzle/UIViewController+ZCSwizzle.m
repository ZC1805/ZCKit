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
        zc_swizzle_exchange_selector([UIViewController class], sel1, sel1x);
        zc_swizzle_exchange_selector([UIViewController class], sel2, sel2x);
        zc_swizzle_exchange_selector([UIViewController class], sel3, sel3x);
        zc_swizzle_exchange_selector([UIViewController class], sel4, sel4x);
    });
}

- (instancetype)swizzle_initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    id instance = [self swizzle_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (instance) self.hidesBottomBarWhenPushed = YES; //如果希望值为NO的话，需要在init之后设置hidesBottomBarWhenPushed为NO;
    return instance;
}

- (void)swizzle_viewDidLoad {
    if (self.navigationController) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;
    }
    [self swizzle_viewDidLoad];
}

- (void)swizzle_viewWillAppear:(BOOL)animated {
    if (ZCKitBridge.isPrintLog) {
        if ([self isKindOfClass:[UIViewController class]] && ![self isKindOfClass:[UINavigationController class]]) {
            if (ZCKitBridge.isPrintLog) NSLog(@"\nZCKit: --------- %@ --------- appear\n", NSStringFromClass([self class]));
        }
    }
    if (self.navigationController && self.parentViewController == self.navigationController) {
        if ([self swizzle_isUseClearBar]) {
            [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
            [self.navigationController setValue:@(NO) forKey:@"isNormalBar"];
        } else if ([self swizzle_isShieldBarShadow]) {
            UIImage *imageBar = ZCIN(ZCKitBridge.naviBarImageOrColor);
            if (!imageBar) imageBar = [UIImage imageWithColor:ZCCS(ZCKitBridge.naviBarImageOrColor)];
            [self.navigationController.navigationBar setBackgroundImage:imageBar forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
            [self.navigationController setValue:@(NO) forKey:@"isNormalBar"];
        } else if ([self swizzle_isUseCustomBar]) {
            [self.navigationController setValue:@(NO) forKey:@"isNormalBar"];
        } else {
            if (!self.navigationController.isNormalBar) {
                UIImage *imageBar = ZCIN(ZCKitBridge.naviBarImageOrColor);
                if (!imageBar) imageBar = [UIImage imageWithColor:ZCCS(ZCKitBridge.naviBarImageOrColor)];
                UIImage *imageShadow = [UIImage imageWithColor:ZCBlackC8 size:CGSizeMake(ZSSepHei, ZSSepHei)];
                [self.navigationController.navigationBar setBackgroundImage:imageBar forBarMetrics:UIBarMetricsDefault];
                [self.navigationController.navigationBar setShadowImage:imageShadow];
                [self.navigationController setValue:@(YES) forKey:@"isNormalBar"];
            }
        }
        if ([self swizzle_isUseTranslucentBar] || [self swizzle_isUseClearBar]) {
            self.navigationController.navigationBar.translucent = YES;
            self.extendedLayoutIncludesOpaqueBars = NO;
        } else {
            self.navigationController.navigationBar.translucent = NO;
            self.extendedLayoutIncludesOpaqueBars = YES;
        }
    }
    [self swizzle_viewWillAppear:animated];
}

- (void)swizzle_viewDidLayoutSubviews {
    [self swizzle_viewDidLayoutSubviews];
    for (UIView *view in self.view.containAllSubviews) {
        if ([view respondsToSelector:@selector(onControllerDidLayout)]) {
            [(id<ZCViewLayoutProtocol>)view onControllerDidLayout];
        }
    }
}

#pragma mark - private
- (BOOL)swizzle_isUseCustomBar {
    SEL sel = @selector(isUseCustomBar);
    if ([self respondsToSelector:sel]) {
        zc_suppress_leak_warning([self performSelector:sel]); return YES;
    }
    return NO;
}

- (BOOL)swizzle_isUseClearBar {
    BOOL use = NO; SEL sel = @selector(isUseClearBar);
    if ([self respondsToSelector:sel]) {
        zc_suppress_leak_warning(use = (BOOL)[self performSelector:sel]);
    }
    return use;
}

- (BOOL)swizzle_isShieldBarShadow {
    BOOL use = NO; SEL sel = @selector(isShieldBarShadow);
    if ([self respondsToSelector:sel]) {
        zc_suppress_leak_warning(use = (BOOL)[self performSelector:sel]);
    }
    return use;
}

- (BOOL)swizzle_isUseTranslucentBar {
    BOOL use = NO; SEL sel = @selector(isUseTranslucentBar);
    if ([self respondsToSelector:sel]) {
        zc_suppress_leak_warning(use = (BOOL)[self performSelector:sel]);
    }
    return use;
}

@end
