//
//  UIViewController+ZC.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIViewController+ZC.h"

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

@end
