//
//  UIViewController+ZC.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIViewController+ZC.h"
#import <objc/runtime.h>
#import "ZCMacro.h"

@interface UIViewController ()

@property (nonatomic, copy) NSString *backMarkStr; //记录属性

@end

@implementation UIViewController (ZC)

#pragma mark - Override
- (UIUserInterfaceStyle)overrideUserInterfaceStyle API_AVAILABLE(ios(13.0)){
    return UIUserInterfaceStyleLight;
}

#pragma mark - Misc
- (UIViewController *)presentFromViewController {
    if (self.presentedViewController) {
        return [self.presentedViewController presentFromViewController];
    } else {
        return self;
    }
}

- (void)dismissAllViewControllerAnimated:(BOOL)animated completion:(void(^)(void))completion {
    if (self.presentedViewController && self.presentedViewController.presentedViewController) {
        [self dismissViewControllerAnimated:NO completion:nil];
        [self dismissAllViewControllerAnimated:animated completion:completion];
    } else if (self.presentedViewController) {
        [self dismissViewControllerAnimated:animated completion:completion];
    }
}

- (BOOL)isViewInDisplay {
    return (self.isViewLoaded && self.view.window);
}

#pragma mark - Back
- (void)setBackMarkStr:(NSString * _Nullable)backMarkStr {
    backMarkStr = kZStrNonnil(backMarkStr);
    objc_setAssociatedObject(self, @selector(backMarkStr), backMarkStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)backMarkStr {
    NSString *backMarkStr = objc_getAssociatedObject(self, _cmd);
    return kZStrNonnil(backMarkStr);
}

- (void)resetHideSystemNaviBarType:(int)slideBack {
    if ((slideBack == 0 || slideBack == 1) && [self isHasShowCusBox]) {
        self.backMarkStr = kZStrFormat(@"%d", slideBack);
    } else {
        self.backMarkStr = @"";
        BOOL isCanMSideBack = slideBack == 1;
        if (slideBack >= 10) { isCanMSideBack = (slideBack - 10) == 1; }
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = isCanMSideBack;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)resetCheckHideSystemNaviBarType:(int)slideBack {
    if ((slideBack == 0 || slideBack == 1) && [self isHasShowCusBox]) {
        self.backMarkStr = kZStrFormat(@"%d", slideBack);
    } else {
        self.backMarkStr = @"";
        BOOL isCanMSideBack = slideBack == 1;
        if (slideBack >= 10) { isCanMSideBack = (slideBack - 10) == 1; }
        BOOL isHasBack = self.navigationController.viewControllers.count > 1;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = isCanMSideBack && isHasBack;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (BOOL)isHasShowCusBox {
    BOOL isHas = NO;
    UIViewController *vc = self;
    if (!isHas && vc.view && ![vc isKindOfClass:UINavigationController.class]) {
        isHas = [self isHasCusBoxView:vc.view.subviews isFinal:NO];
    }
    if (!isHas && vc.tabBarController.view && ![vc isKindOfClass:UINavigationController.class]) {
        isHas = [self isHasCusBoxView:vc.tabBarController.view.subviews isFinal:NO];
    }
    return isHas;
}

- (BOOL)isHasCusBoxView:(NSArray <UIView *>*)subviews isFinal:(BOOL)isFinal {
    BOOL isHasBox = NO;
    if (subviews && subviews.count) {
        for (UIView *itemView in subviews) {
            if ([itemView isKindOfClass:NSClassFromString(@"ZCBoxView")]) {
                isHasBox = YES; break;
            }
            if (!isFinal && [itemView isKindOfClass:UIView.class] && [self isHasCusBoxView:itemView.subviews isFinal:YES]) {
                isHasBox = YES; break;
            }
        }
    } return isHasBox;
}

@end
