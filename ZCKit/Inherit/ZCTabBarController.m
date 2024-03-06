//
//  ZCTabBarController.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCTabBarController.h"
#import "UIViewController+ZC.h"
#import "ZCMacro.h"

@interface ZCTabBarController ()

@property (nonatomic, assign) BOOL isPushToPresent;

@property (nonatomic, weak) UIViewController *visibleChildVc;

@end

@implementation ZCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kZCWhite;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.frame = kZSScreen;
}

#pragma mark - Override
- (BOOL)prefersStatusBarHidden {
    if (self.selectedViewController) {
        return [self.selectedViewController prefersStatusBarHidden];
    } else {
        return [super prefersStatusBarHidden];
    }
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    if (self.selectedViewController) {
        return self.selectedViewController;
    } else if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForStatusBarHidden];
    } else {
        return [super childViewControllerForStatusBarHidden];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.selectedViewController) {
        return [self.selectedViewController preferredStatusBarStyle];
    } else {
        return [super preferredStatusBarStyle];
    }
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    if (self.selectedViewController) {
        return self.selectedViewController;
    } else if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForStatusBarStyle];
    } else {
        return [super childViewControllerForStatusBarStyle];
    }
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if (self.selectedViewController) {
        return [self.selectedViewController preferredStatusBarUpdateAnimation];
    } else {
        return [super preferredStatusBarUpdateAnimation];
    }
}

- (BOOL)shouldAutorotate {
    if (self.selectedViewController) {
        return [self.selectedViewController shouldAutorotate];
    } else {
        return [super shouldAutorotate];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.selectedViewController) {
        return [self.selectedViewController supportedInterfaceOrientations];
    } else {
        return [super supportedInterfaceOrientations];
    }
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures {
    if (self.selectedViewController) {
        return [self.selectedViewController preferredScreenEdgesDeferringSystemGestures];
    } else {
        return [super preferredScreenEdgesDeferringSystemGestures];
    }
}

- (UIViewController *)childViewControllerForScreenEdgesDeferringSystemGestures {
    if (self.selectedViewController) {
        return self.selectedViewController;
    } else if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForScreenEdgesDeferringSystemGestures];
    } else {
        return [super childViewControllerForScreenEdgesDeferringSystemGestures];
    }
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    if (self.selectedViewController) {
        return [self.selectedViewController prefersHomeIndicatorAutoHidden];
    } else {
        return [super prefersHomeIndicatorAutoHidden];
    }
}

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden {
    if (self.selectedViewController) {
        return self.selectedViewController;
    } else if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForHomeIndicatorAutoHidden];
    } else {
        return [super childViewControllerForHomeIndicatorAutoHidden];
    }
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
