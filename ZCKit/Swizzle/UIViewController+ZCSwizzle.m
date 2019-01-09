//
//  UIViewController+ZCSwizzle.m
//  ZCKit
//
//  Created by admin on 2018/10/22.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIViewController+ZCSwizzle.h"
#import "UINavigationController+ZCSwizzle.h"
#import "ZCSwizzleHeader.h"
#import "UIResponder+ZC.h"
#import "ZCKitBridge.h"
#import "UIColor+ZC.h"
#import "UIImage+ZC.h"
#import "UIView+ZC.h"
#import "ZCMacro.h"
#import <objc/runtime.h>

@implementation UIViewController (ZCSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zc_swizzle_exchange_selector([UIViewController class], @selector(initWithNibName:bundle:), @selector(swizzle_initWithNibName:bundle:));
        zc_swizzle_exchange_selector([UIViewController class], @selector(viewDidLoad), @selector(swizzle_viewDidLoad));
        zc_swizzle_exchange_selector([UIViewController class], @selector(viewWillAppear:), @selector(swizzle_viewWillAppear:));
        zc_swizzle_exchange_selector([UIViewController class], @selector(viewDidAppear:), @selector(swizzle_viewDidAppear:));
        zc_swizzle_exchange_selector([UIViewController class], @selector(viewWillDisappear:), @selector(swizzle_viewWillDisappear:));
    });
}

//如果希望vchidesBottomBarWhenPushed为NO的话，请在[vc init]方法之后调用vc.hidesBottomBarWhenPushed = NO;
- (instancetype)swizzle_initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    id instance = [self swizzle_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (instance) self.hidesBottomBarWhenPushed = YES;
    return instance;
}

- (void)swizzle_viewDidLoad {
    if (self.navigationController) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;
    }
    [self swizzle_viewDidLoad];
}

- (void)swizzle_viewWillAppear:(BOOL)animated {
    [self swizzle_viewWillAppear:animated];
    if (ZCKitBridge.isPrintLog) {
        if ([self isKindOfClass:[UIViewController class]] && ![self isKindOfClass:[UINavigationController class]]) {
            NSLog(@"\n--------- %@ ------ appear\n", NSStringFromClass([self class]));
        }
    }
    if (self.navigationController && self.parentViewController == self.navigationController) {
        if ([self swizzle_isUseClearBar]) {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            self.navigationController.isNormalBar = NO;
        } else if ([self swizzle_isShieldBarShadow]) {
            UIImage *imageBar = [UIImage imageNamed:ZCKitBridge.naviBarImageOrColor];
            if (!imageBar) imageBar = [UIImage imageWithColor:[UIColor colorFromHexString:ZCKitBridge.naviBarImageOrColor]];
            [self.navigationController.navigationBar setBackgroundImage:imageBar forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            self.navigationController.isNormalBar = NO;
        } else if ([self swizzle_isUseCustomBar]) {
            self.navigationController.isNormalBar = NO;
        } else {
            if (!self.navigationController.isNormalBar) {
                UIImage *imageBar = [UIImage imageNamed:ZCKitBridge.naviBarImageOrColor];
                if (!imageBar) imageBar = [UIImage imageWithColor:[UIColor colorFromHexString:ZCKitBridge.naviBarImageOrColor]];
                UIImage *imageShadow = [UIImage imageWithColor:[UIColor colorFromHexString:@"0xe5e5e5"]];
                [self.navigationController.navigationBar setBackgroundImage:imageBar forBarMetrics:UIBarMetricsDefault];
                [self.navigationController.navigationBar setShadowImage:imageShadow];
                self.navigationController.isNormalBar = YES;
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
}

static char ZCFirstResponderViewAddress;
- (void)swizzle_viewDidAppear:(BOOL)animated {
    [self swizzle_viewDidAppear:animated];
    UIView *view = objc_getAssociatedObject(self, &ZCFirstResponderViewAddress);
    [view becomeFirstResponder];
}

- (void)swizzle_viewWillDisappear:(BOOL)animated {
    [self swizzle_viewWillDisappear:animated];
    UIView *view = (UIView *)[UIResponder currentFirstResponder];
    if ([view isKindOfClass:[UIView class]] && view.viewController == self) {
        objc_setAssociatedObject(self, &ZCFirstResponderViewAddress, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [view resignFirstResponder];
    } else {
        objc_setAssociatedObject(self, &ZCFirstResponderViewAddress, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

#pragma mark - Private
- (BOOL)swizzle_isUseClearBar {
    BOOL use = NO;
    SEL sel = NSSelectorFromString(@"isUseClearBar");
    if ([self respondsToSelector:sel]) {
        zc_suppress_leak_warning(use = (BOOL)[self performSelector:sel]);
    }
    return use;
}

- (BOOL)swizzle_isUseCustomBar {
    BOOL use = NO;
    SEL sel = NSSelectorFromString(@"isUseCustomBar");
    if ([self respondsToSelector:sel]) {
        zc_suppress_leak_warning(use = (BOOL)[self performSelector:sel]);
    }
    return use;
}

- (BOOL)swizzle_isShieldBarShadow {
    BOOL use = NO;
    SEL sel = NSSelectorFromString(@"isShieldBarShadow");
    if ([self respondsToSelector:sel]) {
        zc_suppress_leak_warning(use = (BOOL)[self performSelector:sel]);
    }
    return use;
}

- (BOOL)swizzle_isUseTranslucentBar {
    BOOL use = NO;
    SEL sel = NSSelectorFromString(@"isUseTranslucentBar");
    if ([self respondsToSelector:sel]) {
        zc_suppress_leak_warning(use = (BOOL)[self performSelector:sel]);
    }
    return use;
}

@end
