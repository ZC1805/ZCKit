//
//  UINavigationController+ZC.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UINavigationController+ZC.h"
#import <objc/runtime.h>

@implementation UINavigationController (ZC)

- (void)popToViewControllerLike:(Class)likeClass isOtherwiseRoot:(BOOL)isOtherwiseRoot animated:(BOOL)animated {
    if (self.viewControllers.count > 1) {
        UIViewController *finalvc = nil;
        NSEnumerator *or = self.viewControllers.reverseObjectEnumerator;
        for (UIViewController *viewController in or.allObjects) {
            if (viewController != self.topViewController && [viewController isKindOfClass:likeClass]) {
                finalvc = viewController; break;
            }
        }
        if (finalvc) {
            [self popToViewController:finalvc animated:animated];
        } else if (isOtherwiseRoot) {
            [self popToRootViewControllerAnimated:animated];
        } else {
            [self popViewControllerAnimated:animated];
        }
    }
}

- (UIViewController *)containViewControllerLike:(Class)likeClass {
    UIViewController *finalvc = nil;
    if (self.viewControllers.count > 1) {
        NSEnumerator *or = self.viewControllers.reverseObjectEnumerator;
        for (UIViewController *viewController in or.allObjects) {
            if (viewController != self.topViewController && [viewController isKindOfClass:likeClass]) {
                finalvc = viewController; break;
            }
        }
    }
    return finalvc;
}

@end
