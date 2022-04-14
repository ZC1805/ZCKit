//
//  UIViewController+ZXXXX.m
//  ZCTest
//
//  Created by zjy on 2022/4/13.
//

#import "UIViewController+ZXXXX.h"

@implementation UIViewController (ZXXXX)

#pragma mark - Func
- (NSString *)hierarchicalRoute {
    return [self routeVCNameForRank:0];
}

- (NSString *)routeVCNameForRank:(int)level {
    UIViewController *aimVc = nil; BOOL isContainer = YES;
    if ([self isKindOfClass:UITabBarController.class]) {
        if (level) aimVc = ((UITabBarController *)self).selectedViewController;
    } else if ([self isKindOfClass:UINavigationController.class]) {
        if (level) aimVc = ((UINavigationController *)self).topViewController;
    } else if ([self isKindOfClass:UISplitViewController.class]) {
        if (level) aimVc = ((UISplitViewController *)self).viewControllers.lastObject;
    //} else if (self.childViewControllers.count && [self respondsToSelector:@selector(visibleChildViewController)]) {
        //if (level && [(id<ZCViewControllerPrivateProtocol>)self visibleChildViewController]) {
        //    aimVc = [(id<ZCViewControllerPrivateProtocol>)self visibleChildViewController];
        //}
        
        ///MARK: xxx
    } else {
        isContainer = NO;
        if (aimVc == nil && self.navigationController && (self.parentViewController == self.navigationController) && self.navigationController.viewControllers.count > 1) {
            NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
            if (index != NSNotFound && index > 0) {
                index = index - 1;
                aimVc = [self.navigationController.viewControllers objectAtIndex:index];
            }
        } else if (aimVc == nil && self.splitViewController && (self.parentViewController == self.splitViewController) && self.splitViewController.viewControllers.count > 1) {
            NSInteger index = [self.splitViewController.viewControllers indexOfObject:self];
            if (index != NSNotFound && index > 0) {
                index = index - 1;
                aimVc = [self.splitViewController.viewControllers objectAtIndex:index];
            }
        }
        if (aimVc == nil && self.presentingViewController) {
            aimVc = self.presentingViewController;
        }
    }
    if (level < 20) {
        NSString *aimStr = [aimVc routeVCNameForRank:(level + 1)];
        NSString *claStr = [NSString stringWithFormat:@"/%@", NSStringFromClass(self.class)];
        if ([claStr hasPrefix:@"/UIViewController"] || [claStr hasPrefix:@"/ZCViewController"] || [claStr hasPrefix:@"/TSViewController"]) claStr = @"";
        if (![claStr hasPrefix:@"/TS"] && ![claStr hasPrefix:@"/TY"]) claStr = @"";
        if (isContainer) claStr = @"";
        if (aimStr.length) {
            return [NSString stringWithFormat:@"%@%@", aimStr, claStr];
        } else {
            return [NSString stringWithFormat:@"%@", claStr];
        }
    }
    return @"";
}

- (void)backToUpControllerAnimated:(BOOL)animated { //最多向下找两层
    if ([self isKindOfClass:UINavigationController.class]) {
        if (self.parentViewController) { //在此默认上层为UITabbarController，请手动完成
            NSAssert(0, @"ZCKit: this need manual completion");
        } else {
            [self dismissViewControllerAnimated:animated completion:nil];
        }
    } else if ([self isKindOfClass:UITabBarController.class]) {
        if (self.parentViewController) { //在此默认上层为UINavigationController，请手动完成
            NSAssert(0, @"ZCKit: this need manual completion");
        } else {
            [self dismissViewControllerAnimated:animated completion:nil];
        }
    } else if ([self isKindOfClass:UISplitViewController.class]) {
        if (self.parentViewController) { //在此默认上层为UINavigationController，请手动完成
            NSAssert(0, @"ZCKit: this need manual completion");
        } else {
            [self dismissViewControllerAnimated:animated completion:nil];
        }
    } else {
        if (self.navigationController) {
            UIViewController *vc = self;
            UINavigationController *nvc = self.navigationController;
            if (vc.parentViewController != nvc) { //在此默认是UITabbarController
                vc = vc.parentViewController;
                if (!vc.parentViewController || vc.parentViewController != nvc) {
                    NSAssert(0, @"ZCKit: this need manual completion");
                }
            }
            if (nvc.viewControllers.count > 1) {
                if (nvc.viewControllers.lastObject == vc) {
                    [nvc popViewControllerAnimated:animated];
                } else if (nvc.viewControllers.firstObject == vc) {
                    if (nvc.parentViewController) {
                        NSAssert(0, @"ZCKit: this need manual completion");
                    } else {
                        [nvc dismissViewControllerAnimated:animated completion:nil];
                    }
                } else {
                    NSInteger index = [nvc.viewControllers indexOfObject:vc];
                    if (index > 0 && index < (nvc.viewControllers.count - 1)) {
                        [nvc popToViewController:nvc.viewControllers[index - 1] animated:animated];
                    } else {
                        NSAssert(0, @"ZCKit: this need manual completion");
                    }
                }
            } else if (nvc.viewControllers.count == 1) {
                if (nvc.viewControllers.firstObject != vc || nvc.parentViewController) {
                    NSAssert(0, @"ZCKit: this need manual completion");
                } else {
                    [nvc dismissViewControllerAnimated:animated completion:nil];
                }
            } else {
                NSAssert(0, @"ZCKit: this need manual completion");
            }
        } else if (self.parentViewController) { //在此默认是UITabbarController
            if (self.parentViewController.parentViewController) {
                NSAssert(0, @"ZCKit: this need manual completion");
            } else {
                [self.parentViewController dismissViewControllerAnimated:animated completion:nil];
            }
        } else {
            [self dismissViewControllerAnimated:animated completion:nil];
        }
    }
}

@end
