//
//  UINavigationController+ZC.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UINavigationController+ZC.h"

@implementation UINavigationController (ZC)

- (void)popToViewControllerLike:(Class)likeClass animated:(BOOL)animated {
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
        } else {
            [self popViewControllerAnimated:animated];
        }
    }
}

@end
