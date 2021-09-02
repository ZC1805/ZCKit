//
//  ZCMaskView.m
//  ZCKit
//
//  Created by admin on 2018/10/23.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCMaskView.h"
#import "ZCMacro.h"

#pragma mark - ~ ZCFocusView ~
@implementation ZCFocusView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    BOOL responder = YES;
    if (self.isCanResponse) {
        CGPoint focus = [[touches anyObject] locationInView:self];
        responder = self.isCanResponse(focus);
    }
    if (responder) {
        if (self.responseAction) self.responseAction();
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

@end


#pragma mark - ~ ZCMaskView ~
@interface ZCMaskView ()

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, assign) BOOL isAnimate;

@property (nonatomic, assign) BOOL isAutoHide;

@property (nonatomic, assign) BOOL isGreyMask;

@property (nonatomic, assign) float maskAlpha;

@property (nonatomic, copy) void(^willHideBlock)(BOOL isByAutoHide);

@property (nonatomic, copy) void(^didHideBlock)(BOOL isByAutoHide);

@property (nonatomic, copy) void (^showAnimate)(UIView *displayView);

@property (nonatomic, copy) void (^hideAnimate)(UIView *displayView);

@property (nonatomic, weak) UIView *displayView;

@end

@implementation ZCMaskView

+ (instancetype)sharedView {
    static ZCMaskView *mask = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mask = [[ZCMaskView alloc] initWithFrame:CGRectZero];
        mask.maskAlpha = 0.5;
    });
    return mask;
}

+ (float)maskAlpha {
    return ZCMaskView.sharedView.maskAlpha;
}

+ (void)setMaskAlpha:(float)maskAlpha {
    ZCMaskView.sharedView.maskAlpha = maskAlpha;
}

+ (void)display:(UIView *)subview didHide:(nullable void (^)(BOOL))didHide {
    [self display:subview autoHide:NO clearMask:NO showAnimate:nil hideAnimate:nil willHide:nil didHide:didHide];
}

+ (void)display:(UIView *)subview autoHide:(BOOL)autoHide clearMask:(BOOL)clearMask willHide:(nullable void (^)(BOOL))willHide didHide:(nullable void (^)(BOOL))didHide {
    [self display:subview autoHide:autoHide clearMask:clearMask showAnimate:nil hideAnimate:nil willHide:willHide didHide:didHide];
}

+ (void)display:(UIView *)displayView autoHide:(BOOL)autoHide clearMask:(BOOL)clearMask showAnimate:(void (^)(UIView * _Nonnull))showAnimate
    hideAnimate:(void (^)(UIView * _Nonnull))hideAnimate willHide:(nullable void (^)(BOOL))willHide didHide:(nullable void (^)(BOOL))didHide {
    if (!displayView || ![UIApplication sharedApplication].delegate.window) return;
    ZCMaskView *mask = ZCMaskView.sharedView;
    __weak typeof(mask) weakMask = mask;
    if (mask.isAnimate) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [mask hideIsAuto:YES finish:^{
                weakMask.isAutoHide = autoHide;
                weakMask.isGreyMask = !clearMask;
                weakMask.willHideBlock = willHide;
                weakMask.didHideBlock = didHide;
                weakMask.showAnimate = showAnimate;
                weakMask.hideAnimate = hideAnimate;
                weakMask.displayView = displayView;
                weakMask.frame = kZSScreen;
                UIView *maskView = [[UIView alloc] initWithFrame:kZSScreen];
                [[UIApplication sharedApplication].delegate.window addSubview:maskView];
                [maskView addSubview:weakMask];
                [weakMask addSubview:displayView];
                [weakMask show];
            }];
        });
    } else {
        [mask hideIsAuto:YES finish:^{
            weakMask.isAutoHide = autoHide;
            weakMask.isGreyMask = !clearMask;
            weakMask.willHideBlock = willHide;
            weakMask.didHideBlock = didHide;
            weakMask.showAnimate = showAnimate;
            weakMask.hideAnimate = hideAnimate;
            weakMask.displayView = displayView;
            weakMask.frame = kZSScreen;
            UIView *maskView = [[UIView alloc] initWithFrame:kZSScreen];
            [[UIApplication sharedApplication].delegate.window addSubview:maskView];
            [maskView addSubview:weakMask];
            [weakMask addSubview:displayView];
            [weakMask show];
        }];
    }
}

+ (void)dismissSubview {
    [self autoDismiss:NO];
}

+ (void)autoDismiss:(BOOL)isByAutoHide {
    ZCMaskView *mask = ZCMaskView.sharedView;
    if (mask.willHideBlock) {mask.willHideBlock(isByAutoHide);}
    [mask hideIsAuto:isByAutoHide finish:nil];
}

- (void)show {
    self.isShow = YES;
    self.isAnimate = YES;
    self.alpha = self.showAnimate ? 1 : 0;
    self.superview.backgroundColor = [kZCBlack colorWithAlphaComponent:0];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (self.showAnimate) {
            self.showAnimate(self.displayView);
        } else {
            self.alpha = 1;
        }
        self.superview.backgroundColor = [kZCBlack colorWithAlphaComponent:self.isGreyMask ? self.maskAlpha : 0];
    } completion:^(BOOL finished) {
        self.isAnimate = NO;
    }];
}

- (void)hideIsAuto:(BOOL)isByAutoHide finish:(void(^)(void))finishBlock {
    if (self.isShow) {
        self.isAnimate = YES;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            if (self.hideAnimate) {
                self.hideAnimate(self.displayView);
            } else {
                self.alpha = 0;
            }
            self.superview.backgroundColor = [kZCBlack colorWithAlphaComponent:0];
        } completion:^(BOOL finished) {
            [self finish:finishBlock byAutoHide:isByAutoHide];
        }];
    } else {
        [self finish:finishBlock byAutoHide:isByAutoHide];
    }
}

- (void)finish:(void(^)(void))finishBlock byAutoHide:(BOOL)isByAutoHide {
    [self.superview removeFromSuperview];
    [self removeFromSuperview];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.willHideBlock) self.willHideBlock = nil;
    if (self.showAnimate) self.showAnimate = nil;
    if (self.hideAnimate) self.hideAnimate = nil;
    if (self.displayView) self.displayView = nil;
    self.isAnimate = NO;
    self.isShow = NO;
    if (finishBlock == nil && self.didHideBlock) {self.didHideBlock(isByAutoHide);}
    if (self.didHideBlock) self.didHideBlock = nil;
    if (finishBlock) finishBlock();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isAutoHide && self.isAnimate == NO) {
        if (self.subviews.firstObject) {
            UITouch *touch = [touches anyObject];
            CGPoint point = [touch locationInView:self];
            CGRect rect = self.subviews.firstObject.frame;
            if (CGRectContainsPoint(rect, point) == NO) [ZCMaskView autoDismiss:YES];
        } else {
            [ZCMaskView autoDismiss:YES];
        }
    }
}

@end


#pragma mark - ~ ZCMaskViewController ~
@interface ZCMaskViewController : UIViewController

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIWindow *maskWindow;

@property (nonatomic, strong) ZCFocusView *maskView;

@property (nonatomic, strong) UIVisualEffectView *visualView;

@property (nonatomic, assign) NSTimeInterval animationTime;

@end

@implementation ZCMaskViewController

+ (instancetype)sharedController {
    static ZCMaskViewController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZCMaskViewController alloc] init];
    });
    return instance;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[ZCGlobal currentController] preferredStatusBarStyle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.animationTime = 0;
    self.view.backgroundColor = kZCClear;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    self.visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
    self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.contentView.backgroundColor = kZCClear;
    self.maskView = [[ZCFocusView alloc] initWithFrame:CGRectZero];
    self.maskView.backgroundColor = kZCClear;
    [self.view addSubview:self.visualView];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.maskView];
}

- (void)dealloc {
    self.maskWindow.rootViewController = nil;
    self.maskWindow.hidden = YES;
    self.maskWindow = nil;
}

- (UIWindow *)maskWindow {
    if (!_maskWindow) {
        _maskWindow = [[UIWindow alloc] initWithFrame:kZSScreen];
        _maskWindow.windowLevel = UIWindowLevelAlert + 1.0;
        _maskWindow.rootViewController = self;
    }
    return _maskWindow;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.visualView.frame = self.view.bounds;
    self.contentView.frame = self.view.bounds;
    self.maskView.frame = self.view.bounds;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)removeSubviews {
    self.animationTime = 0;
    self.maskView.alpha = 0;
    self.maskView.isCanResponse = nil;
    self.maskView.responseAction = nil;
    for (UIView *subview in self.contentView.subviews) {if (subview != self.maskView) [subview removeFromSuperview];}
    self.visualView.hidden = YES;
    self.visualView.alpha = 0;
    self.maskWindow.hidden = YES;
}

- (void)visibleSubview:(UIView *)view time:(NSTimeInterval)time blur:(BOOL)blur clear:(BOOL)clear action:(void (^)(void))action {
    [self removeSubviews];
    if (!view) return;
    self.maskWindow.hidden = NO;
    self.animationTime = time;
    self.visualView.hidden = !blur;
    self.maskView.backgroundColor = clear ? kZCClear : kZCBlack;
    self.maskView.isCanResponse = ^BOOL(CGPoint focus) {return !CGRectContainsPoint(view.frame, focus);};
    self.maskView.responseAction = action;
    [self.contentView addSubview:view];
    [self.view setNeedsLayout];
    self.visualView.alpha = 0;
    self.maskView.alpha = 0;
    [UIView animateWithDuration:self.animationTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.visualView.alpha = 1;
        self.maskView.alpha = ZCMaskView.maskAlpha;
    } completion:nil];
}

- (void)dismissSubview {
    [UIView animateWithDuration:self.animationTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.visualView.alpha = 0;
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeSubviews];
    }];
}

@end


#pragma mark - ~ ZCWindowView ~
@implementation ZCWindowView

+ (void)display:(UIView *)subview time:(NSTimeInterval)time blur:(BOOL)blur clear:(BOOL)clear action:(void (^)(void))action {
    [[ZCMaskViewController sharedController] visibleSubview:subview time:time blur:blur clear:clear action:action];
}

+ (void)dismissSubview {
    [[ZCMaskViewController sharedController] dismissSubview];
}

@end
