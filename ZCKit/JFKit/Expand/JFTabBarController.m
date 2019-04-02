//
//  JFTabBarController.m
//  gobe
//
//  Created by zjy on 2019/3/18.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFTabBarController.h"

@interface JFTabBarController () <UIGestureRecognizerDelegate>

@end

@implementation JFTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initStatusBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.frame = [UIScreen mainScreen].bounds;  // 会话界面发送拍摄的视频，拍摄结束后点击发送后可能顶部会有红条，导致的界面错位。
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    [super setViewControllers:viewControllers];
    for (UIViewController *childController in viewControllers) {
        if ([childController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)childController interactivePopGestureRecognizer].delegate = self;
        }
    }
}

- (void)addChildViewController:(UIViewController *)childController {
    [super addChildViewController:childController];
    if ([childController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)childController interactivePopGestureRecognizer].delegate = self;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {  // 注意子控制器也设置代理为自己从而覆盖不执行
    UINavigationController *vc = self.selectedViewController;
    if ([vc isKindOfClass:[UINavigationController class]] && vc.interactivePopGestureRecognizer == gestureRecognizer) {
        if (vc.childViewControllers.count <= 1) return NO;
        return ![ZCGlobal isShieldInteractivePop:vc.topViewController];
    }
    return YES;
}

#pragma mark - StatusBar
- (void)initStatusBar {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    #pragma clang diagnostic pop
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Rotate
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

@end
