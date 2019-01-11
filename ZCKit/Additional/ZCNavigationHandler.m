//
//  ZCNavigationHandler.m
//  ZCKit
//
//  Created by admin on 2019/1/11.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import "ZCNavigationHandler.h"
#import "UIView+ZC.h"
#import "ZCGlobal.h"

#pragma mark - Class - ZCNavigationRecord
@interface ZCNavigationRecord : NSObject

@property (nonatomic, strong) UIImage *bkImage;

@property (nonatomic, strong) UIImage *sdImage;

@property (nonatomic, strong) UIColor *barColor;

@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, weak) UIViewController *controller;

@end

@implementation ZCNavigationRecord

@end



#pragma mark - Protocol - ZCNavigationAnimatorDelegate
@class ZCNavigationAnimator;

@protocol ZCNavigationAnimatorDelegate <NSObject>

- (void)animationImplement:(UINavigationControllerOperation)opearation;

- (void)animationWillStart:(UINavigationControllerOperation)opearation;

- (void)animationDidEndFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC;

@end



#pragma mark - Class - ZCNavigationAnimator
@interface ZCNavigationAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationControllerOperation opearation;

@property (nonatomic, weak) id <UIViewControllerContextTransitioning> context;

@property (nonatomic, weak) id <ZCNavigationAnimatorDelegate> delegate;

@property (nonatomic, strong) UIColor *interactiveColor;

@end

@implementation ZCNavigationAnimator

- (instancetype)initWithDelegate:(id<ZCNavigationAnimatorDelegate>)delegate {
    if (self = [super init]) {
        _interactiveColor = [UIColor grayColor];
        _delegate = delegate;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.context = transitionContext;
    switch (self.opearation) {
        case UINavigationControllerOperationPop:
            [self popAnimation:transitionContext];
            break;
        case UINavigationControllerOperationPush:
            [self pushAnimation:transitionContext];
            break;
        default: break;
    }
}

#pragma mark - AnimatedTransitioning IMP
- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect frame = fromController.view.frame; //使用xib可能会出现view的size不对的情况
    if ((toController.edgesForExtendedLayout & UIRectEdgeTop) == 0) {
        UINavigationController *navController = fromController.navigationController;
        frame = CGRectOffset(navController.view.frame, 0, navController.navigationBar.bottom);
    }
    if ((toController.edgesForExtendedLayout & UIRectEdgeBottom) == 0) {
        UITabBarController *tabController = fromController.tabBarController;
        CGRect slice = CGRectZero, remainder = CGRectZero;
        CGRectDivide(frame, &slice, &remainder, tabController.tabBar.height, CGRectMaxYEdge);
        frame = remainder;
    }
    toController.view.frame = frame;
    
    [self backAnimationWillStart];
    UIView *container = [transitionContext containerView];
    [container addSubview:fromController.view];
    [container addSubview:toController.view];
    CGFloat width = container.width;
    toController.view.left = width;
    CGFloat initialAlpha = fromController.view.alpha;
    UIColor *containerColor = container.backgroundColor;
    container.backgroundColor = self.interactiveColor;
    CGFloat duration = [self transitionDuration:transitionContext];
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseOut;
    if (transitionContext.interactive) options = UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self backAnimationImplement];
        fromController.view.alpha = initialAlpha - 0.12;
        fromController.view.right = width * 0.5;
        toController.view.right = width;
    } completion:^(BOOL finished) {
        container.backgroundColor = containerColor;
        BOOL cancel = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!cancel];
        [self backAnimationEndFrom:fromController to:toController];
    }];
}

- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect frame = fromController.view.frame; //使用xib可能会出现view的size不对的情况
    if ((toController.edgesForExtendedLayout & UIRectEdgeTop) == 0) {
        UINavigationController *navController = fromController.navigationController;
        frame = CGRectOffset(navController.view.frame, 0, navController.navigationBar.bottom);
    }
    if ((toController.edgesForExtendedLayout & UIRectEdgeBottom) == 0) {
        UITabBarController *tabController = fromController.tabBarController;
        CGRect slice = CGRectZero, remainder = CGRectZero;
        CGRectDivide(frame, &slice, &remainder, tabController.tabBar.height, CGRectMaxYEdge);
        frame = remainder;
    }
    toController.view.frame = frame;
    
    [self backAnimationWillStart];
    UIView *container = [transitionContext containerView];
    [container addSubview:toController.view];
    [container addSubview:fromController.view];
    CGFloat width = container.width;
    toController.view.right = width * 0.5;
    CGFloat initialAlpha = toController.view.alpha;
    UIColor *containerColor = container.backgroundColor;
    container.backgroundColor = self.interactiveColor;
    CGFloat duration = [self transitionDuration:transitionContext];
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseOut;
    if (transitionContext.interactive) options = UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self backAnimationImplement];
        toController.view.alpha = initialAlpha + 0.12;
        fromController.view.left = width;
        toController.view.right = width;
    } completion:^(BOOL finished) {
        container.backgroundColor = containerColor;
        BOOL cancel = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!cancel];
        [self backAnimationEndFrom:fromController to:toController];
    }];
}

#pragma mark - CallBack
- (void)backAnimationImplement {
    if ([self.delegate respondsToSelector:@selector(animationImplement:)]) {
        [self.delegate animationImplement:self.opearation];
    }
}

- (void)backAnimationWillStart {
    if ([self.delegate respondsToSelector:@selector(animationWillStart:)]) {
        [self.delegate animationWillStart:self.opearation];
    }
}

- (void)backAnimationEndFrom:(UIViewController *)from to:(UIViewController *)to {
    if ([self.delegate respondsToSelector:@selector(animationDidEndFromVC:toVC:)]) {
        [self.delegate animationDidEndFromVC:from toVC:to];
    }
}

@end



#pragma mark - Class - ZCNavigationHandler
@interface ZCNavigationHandler() <UINavigationControllerDelegate, UIGestureRecognizerDelegate, ZCNavigationAnimatorDelegate>

@property (nonatomic, strong) NSMutableDictionary <NSString *, ZCNavigationRecord *>*barRecords;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interaction;

@property (nonatomic, weak  ) UINavigationController *navigation;

@property (nonatomic, weak  ) UITabBarController *tabbarController;

@property (nonatomic, strong) ZCNavigationAnimator *animator;

@property (nonatomic, strong) UIPanGestureRecognizer *recognizer;

@property (nonatomic, strong) CAGradientLayer *gradient;

@property (nonatomic, strong) CABasicAnimation *animation;

@property (nonatomic, strong) CATransition *transition;

@property (nonatomic, assign) CGFloat referenceOffsetx;

@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation ZCNavigationHandler

//#warning - 横屏导航的返回箭头位置问 交互时两个控制器的颜色变化 tabbar问题 basetableview refresh 问题 naviBar设置背景图d手动pop导航颜色不渐变问题 pop完成导航闪一下的问题
- (instancetype)initWithNavigation:(UINavigationController *)navigation {
    if (self = [super init]) {
        _navigation = navigation;
        _navigation.delegate = self;
        _navigation.interactivePopGestureRecognizer.enabled = NO;
        _animator = [[ZCNavigationAnimator alloc] initWithDelegate:self];
        _recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGes:)];
        _recognizer.delaysTouchesBegan = NO;
        _recognizer.delegate = self;
        _referenceOffsetx = 0;
        _isShieldInteractivePopGesture = NO;
        _isInteractivePopGestureFullScreen = NO;
        _barRecords = [NSMutableDictionary dictionary];
        [_navigation.view addGestureRecognizer:_recognizer];
    }
    return self;
}

#pragma mark - Action
- (void)onPanGes:(UIPanGestureRecognizer *)recognizer {
    UIView *carrier = recognizer.view;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.referenceOffsetx = 0;
            CGPoint point = [recognizer locationInView:carrier];
            [self interactiveBegan:(self.isCanPopBack && point.x < carrier.width)];
        } break;
        case UIGestureRecognizerStateChanged:{
            CGPoint point = [recognizer translationInView:carrier];
            if (point.x < self.referenceOffsetx) self.referenceOffsetx = point.x;
            if (self.referenceOffsetx < 0) point.x = point.x - self.referenceOffsetx;
            [self interactivePercent:(point.x / carrier.width)];
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            CGPoint point = [recognizer translationInView:carrier];
            if (point.x < self.referenceOffsetx) self.referenceOffsetx = point.x;
            if (self.referenceOffsetx < 0) point.x = point.x - self.referenceOffsetx;
            [self interactiveSuccess:(point.x > carrier.width * 0.5)];
        } break;
        default:{
            [self interactiveSuccess:NO];
        } break;
    }
}

#pragma mark - Interactive
- (void)interactiveBegan:(BOOL)allow {
    if (allow) { //手势不能直接跨控制器pop，只能pop到上一层，主要是考虑取消pop引发的问题
        self.interaction = [[UIPercentDrivenInteractiveTransition alloc] init];
        self.interaction.completionCurve = UIViewAnimationCurveEaseOut;
        [self.navigation popViewControllerAnimated:YES];
    }
}

- (void)interactivePercent:(CGFloat)percent {
    [self.interaction updateInteractiveTransition:percent];
    [self updateInteractiveGradient:percent];
}

- (void)interactiveSuccess:(BOOL)success {
    if (success) {
        self.interaction.completionSpeed = 1 - self.interaction.percentComplete;
        [self updateGradientAnimation:success];
        [self.interaction finishInteractiveTransition];
    } else {
        self.interaction.completionSpeed = self.interaction.percentComplete;
        [self updateGradientAnimation:success];
        [self.interaction cancelInteractiveTransition];
    }
    self.interaction = nil;
}

- (void)updateInteractiveTabbar:(CGFloat)move {
    self.tabbarController = self.navigation.tabBarController;
    self.tabbarController.tabBar.right = self.tabbarController.tabBar.width * move;
}

- (void)updateInteractiveGradient:(CGFloat)move {
    if (_gradient) {
        _gradient.opacity = (0.8 - move) * 1.3;
    }
}

- (void)updateGradientAnimation:(BOOL)success {
    if (self.animator.context.isInteractive) {
        self.animation.fromValue = @((0.8 - self.interaction.percentComplete) * 1.3);
        self.animation.duration = self.interaction.duration;
    } else {
        self.animation.fromValue = success ? @(1) : @(0);
        self.animation.duration = [self.animator transitionDuration:self.animator.context];
    }
    if (success) {
        self.animation.toValue = @(0);
    } else {
        self.animation.toValue = @(1);
    }
    if (_gradient) {
        [_gradient addAnimation:self.animation forKey:nil];
    }
}

- (void)updateNavigationTransition {
    self.transition.duration = [self.animator transitionDuration:self.animator.context];
    [self.navigation.navigationBar.layer addAnimation:self.transition forKey:nil];
}

#pragma mark - ZCNavigationAnimatorDelegate
- (void)animationImplement:(UINavigationControllerOperation)opearation {
    
}

- (void)animationWillStart:(UINavigationControllerOperation)opearation {
    self.isAnimating = YES;
    if (!self.animator.context.isInteractive) {
        BOOL success = opearation == UINavigationControllerOperationPop;
        [self updateGradientAnimation:success];
        [self updateNavigationTransition];
    }
}

- (void)animationDidEndFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC {
    self.isAnimating = NO;
    [self updateInteractiveGradient:1];
    if (self.animator.context.transitionWasCancelled) {
        [self insertBarState:fromVC];
    }
}

#pragma mark - UINavigationControllerDelegate
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController {
    return self.interaction;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) { //此方法在toVC，viewDidLoad前执行，所以在此可以记录记录到push时bar最后的状态
        [self recordBarState:fromVC];
        [self recordBarState:toVC]; //并不是实际记录，由于pop时控制器已经从数组中移除，此操作可以使得records中有index
    } else if (operation == UINavigationControllerOperationPop) {
        [self recordBarState:fromVC]; //实际记录，记录pop取消时候状态，index为上面记录的index
        [self insertBarState:toVC];
    } else {
        NSAssert(0, @"error-> navigation operation mistake");
    }
    self.animator.opearation = operation;
    if (self.gradient.superlayer) {
        [self.gradient removeFromSuperlayer];
    }
    if (operation == UINavigationControllerOperationPop) {
        [fromVC.view.layer addSublayer:self.gradient];
    } else {
        [toVC.view.layer addSublayer:self.gradient];
    }
    return self.animator;
}

- (void)recordBarState:(UIViewController *)controller {
    UINavigationBar *bar = self.navigation.navigationBar;
    ZCNavigationRecord *state = [[ZCNavigationRecord alloc] init];
    state.bkImage = [bar backgroundImageForBarMetrics:UIBarMetricsDefault];
    state.sdImage = [bar shadowImage];
    state.barColor = bar.barTintColor;
    state.tintColor = bar.tintColor;
    state.controller = controller;
    NSInteger index = [self.navigation.viewControllers indexOfObject:controller];
    //pop时已经从数组移除fromvc，由于跨级pop不会取消，所以此处暂时不必遍历recodes来匹配controller来寻找index，直接取count
    if (index == NSNotFound) index = self.navigation.viewControllers.count;
    NSString *key = [NSString stringWithFormat:@"%ld", index];
    [self.barRecords setObject:state forKey:key];
}

- (void)insertBarState:(UIViewController *)controller {
    UINavigationBar *bar = self.navigation.navigationBar;
    NSInteger index = [self.navigation.viewControllers indexOfObject:controller];
    NSString *key = [NSString stringWithFormat:@"%ld", index];
    ZCNavigationRecord *state = [self.barRecords objectForKey:key];
    if (state && state.controller && state.controller == controller) {
        [bar setTintColor:state.tintColor];
        [bar setBarTintColor:state.barColor];
        [bar setShadowImage:state.sdImage];
        [bar setBackgroundImage:state.bkImage forBarMetrics:UIBarMetricsDefault];
    } else {
        NSAssert(0, @"info-> navigation bar record is change or fail");
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == _recognizer) {
        if (self.isForbidInteractive) return NO;
        UIView *carrier = gestureRecognizer.view;
        CGPoint point = [gestureRecognizer locationInView:carrier];
        if ([self isTouchInBar:point view:carrier]) return NO;
        if (self.isInteractivePopGestureFullScreen) return YES;
        if (point.x < 44.0) return YES;
    }
    return NO;
}

#pragma mark - Private
- (BOOL)isCanPopBack {
    if (self.navigation && self.navigation.viewControllers.count > 1) return YES; //根视图不能滑动返回
    return NO;
}

- (BOOL)isTouchInBar:(CGPoint)point view:(UIView *)view { //点在导航栏不可以滑动返回
    if (!self.isCanPopBack) return YES;
    if (!self.navigation.navigationBarHidden && !self.navigation.navigationBar.hidden) {
        if (![ZCGlobal isUseClearBar:self.navigation.topViewController]) {
            CGPoint coordinate = [view convertPoint:point toView:self.navigation.navigationBar];
            if (coordinate.y < self.navigation.navigationBar.height) return YES;
        }
    }
    return NO;
}

- (BOOL)isForbidInteractive {
    if (!self.isCanPopBack) return YES;
    if (self.isAnimating || [ZCGlobal isLandscape]) return YES; //横屏不可以滑动返回
    return [ZCGlobal isShieldInteractivePop:self.navigation.topViewController]; //设置了不能滑动返回
}

#pragma mark - Getter
- (CAGradientLayer *)gradient {
    if (!_gradient) {
        _gradient = [CAGradientLayer layer];
        _gradient.startPoint = CGPointMake(1.0, 0.5);
        _gradient.endPoint = CGPointMake(0.0, 0.5);
        CGColorRef color0 = [[UIColor colorWithWhite:0.12 alpha:0.12] CGColor];
        CGColorRef color1 = [[UIColor colorWithWhite:0.05 alpha:0.05] CGColor];
        CGColorRef color2 = [[UIColor clearColor] CGColor];
        _gradient.colors = [NSArray arrayWithObjects:(__bridge id)color0, (__bridge id)color1, (__bridge id)color2, nil];
        _gradient.locations = @[@(0.0), @(0.3), @(1.0)];
    }
    if (_gradient.frame.size.height != self.navigation.view.height) {
        _gradient.frame = CGRectMake(-10.0, 0.0, 10.0, self.navigation.view.height);
    }
    return _gradient;
}

- (CABasicAnimation *)animation {
    if (!_animation) {
        _animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        _animation.removedOnCompletion = YES;
    }
    return _animation;
}

- (CATransition *)transition {
    if (!_transition) {
        _transition = [CATransition animation];
        _transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        _transition.removedOnCompletion = YES;
        _transition.type = kCATransitionFade;
    }
    return _transition;
}

- (UIPanGestureRecognizer *)interactiveCustomPopPanGesture {
    return _recognizer;
}

#pragma mark - Setter
- (void)setIsShieldInteractivePopGesture:(BOOL)isShieldInteractivePopGesture {
    _isShieldInteractivePopGesture = isShieldInteractivePopGesture;
    _recognizer.enabled = !isShieldInteractivePopGesture;
}

@end
