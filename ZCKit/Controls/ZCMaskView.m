//
//  ZCMaskView.m
//  ZCKit
//
//  Created by admin on 2018/10/23.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCMaskView.h"
#import "ZCGlobal.h"

#pragma mark - ~~~~~~~~~~ ZCFocusView ~~~~~~~~~~
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


#pragma mark - ~~~~~~~~~~ ZCMaskView ~~~~~~~~~~
@interface ZCMaskView ()

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, assign) BOOL isAnimate;

@property (nonatomic, assign) BOOL isAutoHide;

@property (nonatomic, assign) BOOL isGreyMask;

@property (nonatomic, assign) float maskAlpha;

@property (nonatomic, copy) void(^hideAction)(void);

@end

@implementation ZCMaskView

+ (instancetype)instance {
    static ZCMaskView *mask = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mask = [[ZCMaskView alloc] initWithFrame:CGRectZero];
        mask.maskAlpha = 0.3;
    });
    return mask;
}

+ (float)maskAlpha {
    return [ZCMaskView instance].maskAlpha;
}

+ (void)setMaskAlpha:(float)maskAlpha {
    [ZCMaskView instance].maskAlpha = maskAlpha;
}

+ (void)display:(UIView *)subview hideAction:(void (^)(void))hideAction {
    [self display:subview autoHide:YES clearMask:NO hideAction:hideAction];
}

+ (void)display:(UIView *)subview autoHide:(BOOL)autoHide clearMask:(BOOL)clearMask hideAction:(void (^)(void))hideAction {
    if (!subview || ![UIApplication sharedApplication].delegate.window) return;
    ZCMaskView *mask = [ZCMaskView instance];
    __weak typeof(mask) weakMask = mask;
    if (mask.isAnimate) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [mask hide:^{
                weakMask.isAutoHide = autoHide;
                weakMask.isGreyMask = !clearMask;
                weakMask.hideAction = hideAction;
                weakMask.frame = [UIScreen mainScreen].bounds;
                UIView *maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                [[UIApplication sharedApplication].delegate.window addSubview:maskView];
                [maskView addSubview:weakMask];
                [weakMask addSubview:subview];
                [weakMask show];
            }];
        });
    } else {
        [mask hide:^{
            weakMask.isAutoHide = autoHide;
            weakMask.isGreyMask = !clearMask;
            weakMask.hideAction = hideAction;
            weakMask.frame = [UIScreen mainScreen].bounds;
            UIView *maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [[UIApplication sharedApplication].delegate.window addSubview:maskView];
            [maskView addSubview:weakMask];
            [weakMask addSubview:subview];
            [weakMask show];
        }];
    }
}

+ (void)dismissSubview {
    ZCMaskView *mask = [ZCMaskView instance];
    if (mask.hideAction) {
        mask.hideAction();
        mask.hideAction = nil;
    }
    [mask hide:nil];
}

- (void)show {
    self.isShow = YES;
    self.isAnimate = YES;
    self.alpha = 0;
    self.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        self.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.isGreyMask ? self.maskAlpha : 0];
    } completion:^(BOOL finished) {
        self.isAnimate = NO;
    }];
}

- (void)hide:(void(^)(void))finish {
    if (self.isShow) {
        self.isAnimate = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
            self.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        } completion:^(BOOL finished) {
            [self hideFinish];
            if (finish) finish();
        }];
    } else {
        [self hideFinish];
        if (finish) finish();
    }
}

- (void)hideFinish {
    [self.superview removeFromSuperview];
    [self removeFromSuperview];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.hideAction) self.hideAction = nil;
    self.isShow = NO;
    self.isAnimate = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isAutoHide && self.isAnimate == NO) {
        if (self.subviews.firstObject) {
            UITouch *touch = [touches anyObject];
            CGPoint point = [touch locationInView:self];
            CGRect rect = self.subviews.firstObject.frame;
            if (CGRectContainsPoint(rect, point) == NO) [ZCMaskView dismissSubview];
        } else {
            [ZCMaskView dismissSubview];
        }
    }
}

@end


#pragma mark - ~~~~~~~~~~ ZCMaskViewController ~~~~~~~~~~
@interface ZCMaskViewController : UIViewController

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIWindow *maskWindow;

@property (nonatomic, strong) ZCFocusView *maskView;

@property (nonatomic, strong) UIVisualEffectView *visualView;

@property (nonatomic, assign) NSTimeInterval animationTime;

@end

@implementation ZCMaskViewController

+ (instancetype)instance {
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
    self.view.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    self.visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
    self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.maskView = [[ZCFocusView alloc] initWithFrame:CGRectZero];
    self.maskView.backgroundColor = [UIColor clearColor];
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
        _maskWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
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
    self.maskView.backgroundColor = clear ? [UIColor clearColor] : [UIColor blackColor];
    self.maskView.isCanResponse = ^BOOL(CGPoint focus) {return !CGRectContainsPoint(view.frame, focus);};
    self.maskView.responseAction = action;
    [self.contentView addSubview:view];
    [self.view setNeedsLayout];
    self.visualView.alpha = 0;
    self.maskView.alpha = 0;
    [UIView animateWithDuration:self.animationTime animations:^{
        self.visualView.alpha = 1.0;
        self.maskView.alpha = 0.3;
    } completion:nil];
}

- (void)dismissSubview {
    [UIView animateWithDuration:self.animationTime animations:^{
        self.visualView.alpha = 0;
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeSubviews];
    }];
}

@end


#pragma mark - ~~~~~~~~~~ ZCWindowView ~~~~~~~~~~
@implementation ZCWindowView

+ (void)display:(UIView *)subview time:(NSTimeInterval)time blur:(BOOL)blur clear:(BOOL)clear action:(void (^)(void))action {
    [[ZCMaskViewController instance] visibleSubview:subview time:time blur:blur clear:clear action:action];
}

+ (void)dismissSubview {
    [[ZCMaskViewController instance] dismissSubview];
}

@end
