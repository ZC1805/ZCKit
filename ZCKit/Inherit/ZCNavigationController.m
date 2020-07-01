//
//  ZCNavigationController.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCNavigationController.h"
#import "UIViewController+ZC.h"
#import "ZCQueueHandler.h"
#import "ZCMacro.h"

NSNotificationName const ZCViewControllerWillBeTouchPopNotification = @"ZCViewControllerWillBeTouchPopNotification";

@interface ZCNavigationController () <UIGestureRecognizerDelegate, UINavigationBarDelegate>

@property (nonatomic, assign) BOOL isPushToPresent;

@property (nonatomic, assign) BOOL isPopAnimating;

@property (nonatomic, weak) UIViewController *visibleChildVc;

@property (nonatomic, weak) UIViewController *willPopTopViewController;

//@property (nonatomic, weak) id<UIGestureRecognizerDelegate> delegateOrg;

@end

@implementation ZCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPopAnimating = NO;
    self.interactivePopGestureRecognizer.enabled = YES;
    if (self.navigationBar.delegate != self) self.navigationBar.delegate = self;
    if (self.interactivePopGestureRecognizer.delegate != self) self.interactivePopGestureRecognizer.delegate = self;
    [self.interactivePopGestureRecognizer addTarget:self action:@selector(onPopGesEvent:)];
    
//    if (self.interactivePopGestureRecognizer.delegate != self) {
//        self.delegateOrg = self.interactivePopGestureRecognizer.delegate;
//        self.interactivePopGestureRecognizer.delegate = self;
//        [self.interactivePopGestureRecognizer addTarget:self action:@selector(onInteractivePopStart:)];
//    }
}

#pragma mark - Private
- (void)onPopGesEvent:(UIGestureRecognizer *)gesture {
    if (gesture == self.interactivePopGestureRecognizer && gesture.state == UIGestureRecognizerStateEnded) {
        [self viewControllerIsPopGes:YES viewController:self.willPopTopViewController];
    }
}

- (void)viewControllerIsPopGes:(BOOL)isPopGes viewController:(UIViewController *)viewController {
    if (viewController && [viewController isKindOfClass:[ZCViewController class]]) {
        [viewController setValue:@(isPopGes) forKey:@"isPopGes"];
    }
}

#pragma mark - Override
- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    for (UIViewController *viewColr in self.viewControllers) {
        [self viewControllerIsPopGes:NO viewController:viewColr];
    }
    [super setViewControllers:viewControllers];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    for (UIViewController *viewColr in self.viewControllers) {
        [self viewControllerIsPopGes:NO viewController:viewColr];
    }
    [super setViewControllers:viewControllers animated:animated];
}

#pragma mark - Override
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController && self.topViewController && [self.topViewController isKindOfClass:[ZCViewController class]]) {
        ZCViewController *fromVc = (ZCViewController *)self.topViewController;
        void(^willPush)(UIViewController *toVc) = (void(^)(UIViewController *toVc))[fromVc valueForKey:@"willPush"];
        if (willPush) willPush(viewController);
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    self.willPopTopViewController = self.topViewController;
    [self viewControllerIsPopGes:NO viewController:self.topViewController];
    UIViewController *viewController = nil;
    if (self.viewControllers.count > 1) {
        viewController = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
    }
    if (viewController && self.topViewController && [self.topViewController isKindOfClass:[ZCViewController class]]) {
        ZCViewController *fromVc = (ZCViewController *)self.topViewController;
        void(^willPop)(UIViewController *toVc) = (void(^)(UIViewController *toVc))[fromVc valueForKey:@"willPop"];
        if (willPop) willPop(viewController);
    }
    return [super popViewControllerAnimated:animated];
}

- (NSArray <__kindof UIViewController *>*)popToRootViewControllerAnimated:(BOOL)animated {
    self.willPopTopViewController = self.topViewController;
    [self viewControllerIsPopGes:NO viewController:self.topViewController];
    UIViewController *viewController = nil;
    if (self.viewControllers.count > 1) {
        viewController = [self.viewControllers objectAtIndex:0];
    }
    if (viewController && self.topViewController && [self.topViewController isKindOfClass:[ZCViewController class]]) {
        ZCViewController *fromVc = (ZCViewController *)self.topViewController;
        void(^willPop)(UIViewController *toVc) = (void(^)(UIViewController *toVc))[fromVc valueForKey:@"willPop"];
        if (willPop) willPop(viewController);
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray <__kindof UIViewController *>*)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.willPopTopViewController = self.topViewController;
    [self viewControllerIsPopGes:NO viewController:self.topViewController];
    BOOL isCanPass = NO;
    if (viewController && self.viewControllers.count > 1 && [self.viewControllers containsObject:viewController]) {
        if (viewController != self.topViewController) {
            isCanPass = YES;
        }
    }
    if (isCanPass && self.topViewController && [self.topViewController isKindOfClass:[ZCViewController class]]) {
        ZCViewController *fromVc = (ZCViewController *)self.topViewController;
        void(^willPop)(UIViewController *toVc) = (void(^)(UIViewController *toVc))[fromVc valueForKey:@"willPop"];
        if (willPop) willPop(viewController);
    }
    return [super popToViewController:viewController animated:animated];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.interactivePopGestureRecognizer == gestureRecognizer) {
        if (self.viewControllers.count <= 1) return NO;
        if ([self.topViewController respondsToSelector:@selector(onCustomBackAction)]) return NO;
        BOOL use = NO; SEL sel = @selector(isShieldInteractivePop);
        if ([self.topViewController respondsToSelector:sel]) {
            zc_suppress_leak_warning(use = (BOOL)[self.topViewController performSelector:sel]);
        }
        return !use;
    }
    return YES;
}

///!!!:透明到不透明的滑动过度&onCustomBackAction和另一个方法和起来控制跨控制器滑动 && push前设置属性判断是否可push
//- (void)onInteractivePopStart:(UIScreenEdgePanGestureRecognizer *)recognizer {
////    NSLog(@"- %f", [gestureRecognizer translationInView:gestureRecognizer.view].x);
////    self.navigationBar.subviews[0].alpha = 1 - [gestureRecognizer translationInView:gestureRecognizer.view].x / 414;
//    
//    if (![recognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class]) return;
//    if (!recognizer.view || !CGSizeEqualToSize(recognizer.view.size, CGSizeMake(ZSWid, ZSHei))) return;
//    
//    UIView *bearView = self.navigationBar.subviews.firstObject;
//    
//    
//    switch (recognizer.state) {
//        case UIGestureRecognizerStateBegan:{
////            self.referenceOffsetx = 0;
////            CGPoint point = [recognizer locationInView:carrier];
////            [self interactiveBegan:(self.isCanPopBack && point.x < carrier.width)];
//        } break;
//        case UIGestureRecognizerStateChanged:{
//            bearView.alpha = 1 - [recognizer translationInView:recognizer.view].x / 414;
////            CGPoint point = [recognizer translationInView:carrier];
////            if (point.x < self.referenceOffsetx) self.referenceOffsetx = point.x;
////            if (self.referenceOffsetx < 0) point.x = point.x - self.referenceOffsetx;
////            [self interactivePercent:(point.x / carrier.width)];
//        } break;
//        case UIGestureRecognizerStateEnded:
//        case UIGestureRecognizerStateCancelled:{
////            CGPoint point = [recognizer translationInView:carrier];
////            if (point.x < self.referenceOffsetx) self.referenceOffsetx = point.x;
////            if (self.referenceOffsetx < 0) point.x = point.x - self.referenceOffsetx;
////            [self interactiveSuccess:(point.x > carrier.width * 0.5)];
//        } break;
//        default:{
////            [self interactiveSuccess:NO];
//        } break;
//    }
//    
//    
//    
//    
////    UIView *carrier = recognizer.view;
////    switch (recognizer.state) {
////        case UIGestureRecognizerStateBegan:{
////            self.referenceOffsetx = 0;
////            CGPoint point = [recognizer locationInView:carrier];
////            [self interactiveBegan:(self.isCanPopBack && point.x < carrier.width)];
////        } break;
////        case UIGestureRecognizerStateChanged:{
////            CGPoint point = [recognizer translationInView:carrier];
////            if (point.x < self.referenceOffsetx) self.referenceOffsetx = point.x;
////            if (self.referenceOffsetx < 0) point.x = point.x - self.referenceOffsetx;
////            [self interactivePercent:(point.x / carrier.width)];
////        } break;
////        case UIGestureRecognizerStateEnded:
////        case UIGestureRecognizerStateCancelled:{
////            CGPoint point = [recognizer translationInView:carrier];
////            if (point.x < self.referenceOffsetx) self.referenceOffsetx = point.x;
////            if (self.referenceOffsetx < 0) point.x = point.x - self.referenceOffsetx;
////            [self interactiveSuccess:(point.x > carrier.width * 0.5)];
////        } break;
////        default:{
////            [self interactiveSuccess:NO];
////        } break;
////    }
////    
////    - (void)interactiveSuccess:(BOOL)success {
////        if (success) {
////            self.interaction.completionSpeed = 1 - self.interaction.percentComplete;
////            [self updateGradientAnimation:success];
////            [self.interaction finishInteractiveTransition];
////        } else {
////            self.interaction.completionSpeed = self.interaction.percentComplete;
////            [self updateGradientAnimation:success];
////            [self.interaction cancelInteractiveTransition];
////        }
////        self.interaction = nil;
////    }
////    typedef NS_ENUM(NSInteger, UIGestureRecognizerState)
////    {
////        // 尚未识别是何种手势操作（但可能已经触发了触摸事件），默认状态：
////        UIGestureRecognizerStatePossible,
////        // 手势已经开始，此时已经被识别，但是这个过程中可能发生变化，手势操作尚未完成：
////        UIGestureRecognizerStateBegan,
////        // 手势状态发生改变：
////        UIGestureRecognizerStateChanged,
////        // 手势识别操作完成（此时已经松开手指）：
////         UIGestureRecognizerStateEnded,
////        // 手势被取消，恢复到默认状态：
////        UIGestureRecognizerStateCancelled,
////        // 手势识别失败，恢复到默认状态：
////        UIGestureRecognizerStateFailed,
////        // 手势识别完成，同“UIGestureRecognizerStateEnded”：
////        UIGestureRecognizerStateRecognized = UIGestureRecognizerStateEnded
////    };
//}
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if (self.delegateOrg && [self.delegateOrg respondsToSelector:@selector(gestureRecognizerShouldBegin:)]) {
//        return [self.delegateOrg gestureRecognizerShouldBegin:gestureRecognizer];
//    }
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if (self.delegateOrg && [self.delegateOrg respondsToSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
//        return [self.delegateOrg gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
//    }
//    return NO;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if (self.delegateOrg && [self.delegateOrg respondsToSelector:@selector(gestureRecognizer:shouldRequireFailureOfGestureRecognizer:)]) {
//        return [self.delegateOrg gestureRecognizer:gestureRecognizer shouldRequireFailureOfGestureRecognizer:otherGestureRecognizer];
//    }
//    return NO;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if (self.delegateOrg && [self.delegateOrg respondsToSelector:@selector(gestureRecognizer:shouldBeRequiredToFailByGestureRecognizer:)]) {
//        return [self.delegateOrg gestureRecognizer:gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:otherGestureRecognizer];
//    }
//    return NO;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    if (self.delegateOrg && [self.delegateOrg respondsToSelector:@selector(gestureRecognizer:shouldReceiveTouch:)]) {
//        return [self.delegateOrg gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
//    }
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
//    if (self.delegateOrg && [self.delegateOrg respondsToSelector:@selector(gestureRecognizer:shouldReceivePress:)]) {
//        return [self.delegateOrg gestureRecognizer:gestureRecognizer shouldReceivePress:press];
//    }
//    return YES;
//}

#pragma mark - UINavigationBarDelegate
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    __block BOOL shouldPop = YES; //非系统手动pop不走此代理
    NSUInteger vcsCount = self.viewControllers.count;
    NSUInteger itemsCount = navigationBar.items.count;
    if (self.isPopAnimating) {
        if (vcsCount < itemsCount) {
            self.isPopAnimating = NO; return YES;
        } else {
            return NO;
        }
    }
    
    self.isPopAnimating = YES;
    if (vcsCount < itemsCount) { //非系统手动pop不走此
        self.isPopAnimating = NO; return YES;
    }
    UIViewController *vc = self.topViewController;
    if ([vc respondsToSelector:@selector(isCanResponseTouchPop)]) {
        shouldPop = [(id<ZCViewControllerBackProtocol>)vc isCanResponseTouchPop];
    }
    
    if (shouldPop) {
        main_imp(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ZCViewControllerWillBeTouchPopNotification object:self.topViewController];
            if ([vc respondsToSelector:@selector(onCustomBackAction)]) {
                [(id<ZCViewControllerBackProtocol>)vc onCustomBackAction];
                if (@available(iOS 13.0, *)) {
                    shouldPop = NO;
                }
            } else {
                if (@available(iOS 13.0, *)) {
                    
                } else {
                    [self popViewControllerAnimated:YES];
                }
            }
        });
    } else {
        [self setNavigationBarHidden:YES];
        [self setNavigationBarHidden:NO];
    }
    main_delay(0.3, ^{self.isPopAnimating = NO;});
    return shouldPop;
}

#pragma mark - Override
- (BOOL)prefersStatusBarHidden {
    if (self.topViewController) {
        return [self.topViewController prefersStatusBarHidden];
    } else {
        return [super prefersStatusBarHidden];
    }
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    if (self.topViewController) {
        return self.topViewController;
    } else if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForStatusBarHidden];
    } else {
        return [super childViewControllerForStatusBarHidden];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.topViewController) {
        return [self.topViewController preferredStatusBarStyle];
    } else {
        return [super preferredStatusBarStyle];
    }
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    if (self.topViewController) {
        return self.topViewController;
    } else if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForStatusBarStyle];
    } else {
        return [super childViewControllerForStatusBarStyle];
    }
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if (self.topViewController) {
        return [self.topViewController preferredStatusBarUpdateAnimation];
    } else {
        return [super preferredStatusBarUpdateAnimation];
    }
}

- (BOOL)shouldAutorotate {
    if (self.topViewController) {
        return [self.topViewController shouldAutorotate];
    } else {
        return [super shouldAutorotate];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.topViewController) {
        return [self.topViewController supportedInterfaceOrientations];
    } else {
        return [super supportedInterfaceOrientations];
    }
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures {
    if (self.topViewController) {
        return [self.topViewController preferredScreenEdgesDeferringSystemGestures];
    } else {
        return [super preferredScreenEdgesDeferringSystemGestures];
    }
}

- (UIViewController *)childViewControllerForScreenEdgesDeferringSystemGestures {
    if (self.topViewController) {
        return self.topViewController;
    } else if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForScreenEdgesDeferringSystemGestures];
    } else {
        return [super childViewControllerForScreenEdgesDeferringSystemGestures];
    }
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    if (self.topViewController) {
        return [self.topViewController prefersHomeIndicatorAutoHidden];
    } else {
        return [super prefersHomeIndicatorAutoHidden];
    }
}

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden {
    if (self.topViewController) {
        return self.topViewController;
    } else if (self.childViewControllers.count && self.visibleChildViewController) {
        return [self.visibleChildViewController childViewControllerForHomeIndicatorAutoHidden];
    } else {
        return [super childViewControllerForHomeIndicatorAutoHidden];
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if (self.isUsePushStyleToPresent) { //待实现
        [super dismissViewControllerAnimated:flag completion:completion];
    } else {
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (self.presentedViewController) {
        [self.presentFromViewController presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        if ([viewControllerToPresent respondsToSelector:@selector(isUsePushStyleToPresent)] &&
            [(id<ZCViewControllerPrivateProtocol>)viewControllerToPresent isUsePushStyleToPresent]) { //待实现
            [super presentViewController:viewControllerToPresent animated:flag completion:completion];
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
