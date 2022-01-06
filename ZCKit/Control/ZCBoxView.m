//
//  ZCBoxView.m
//  ZCKit
//
//  Created by admin on 2018/10/23.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCBoxView.h"
#import "ZCMacro.h"

@interface ZCBoxView ()

@property (nonatomic, assign) BOOL isAnimate;

@property (nonatomic, assign) BOOL isAutoHide;

@property (nonatomic, assign) BOOL isGreyCover;

@property (nonatomic, copy) void(^willHideBlock)(BOOL isByAutoHide);

@property (nonatomic, copy) void(^didHideBlock)(BOOL isByAutoHide);

@property (nonatomic, copy) void (^showAnimate)(UIView *displayView);

@property (nonatomic, copy) void (^hideAnimate)(UIView *displayView);

@property (nonatomic, weak) UIView *displayView;

@property (nonatomic, weak) UIView *aboveView;

@property (nonatomic, assign) float coverAlpha;

@property (nonatomic, assign) NSTimeInterval animateTime;

@end

@implementation ZCBoxView

+ (void)display:(UIView *)displayView above:(UIView *)aboveView didHide:(nullable void (^)(BOOL))didHide {
    [self display:displayView above:aboveView autoHide:NO clearCover:NO showAnimate:nil hideAnimate:nil willHide:nil didHide:didHide];
}

+ (void)display:(UIView *)displayView above:(UIView *)aboveView autoHide:(BOOL)autoHide clearCover:(BOOL)clearCover willHide:(nullable void (^)(BOOL))willHide didHide:(nullable void (^)(BOOL))didHide {
    [self display:displayView above:aboveView autoHide:autoHide clearCover:clearCover showAnimate:nil hideAnimate:nil willHide:willHide didHide:didHide];
}

+ (void)display:(UIView *)displayView above:(UIView *)aboveView autoHide:(BOOL)autoHide clearCover:(BOOL)clearCover
    showAnimate:(void (^)(UIView * _Nonnull))showAnimate hideAnimate:(void (^)(UIView * _Nonnull))hideAnimate
       willHide:(nullable void (^)(BOOL))willHide didHide:(nullable void (^)(BOOL))didHide {
    if (!displayView || !aboveView) return;
    ZCBoxView *boxView = [[ZCBoxView alloc] initWithFrame:aboveView.bounds];
    boxView.isAutoHide = autoHide;
    boxView.isGreyCover = !clearCover;
    boxView.willHideBlock = willHide;
    boxView.didHideBlock = didHide;
    boxView.showAnimate = showAnimate;
    boxView.hideAnimate = hideAnimate;
    boxView.displayView = displayView;
    boxView.aboveView = aboveView;
    UIView *coverView = [[UIView alloc] initWithFrame:aboveView.bounds];
    [aboveView addSubview:coverView];
    [coverView addSubview:boxView];
    [boxView addSubview:displayView];
    [boxView onShow];
}

+ (void)dismiss:(UIView *)displayView {
    ZCBoxView *boxView = (ZCBoxView *)displayView.superview;
    if (boxView && [boxView isKindOfClass:ZCBoxView.class]) {
        [boxView autoDismiss:NO];
    }
}

#pragma mark - Instance
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.animateTime = 0.32;
        self.coverAlpha = 0.52;
    } return self;
}

- (void)autoDismiss:(BOOL)isByAutoHide {
    if (self.willHideBlock) {self.willHideBlock(isByAutoHide);}
    [self onHideIsAuto:isByAutoHide];
}

- (void)onShow {
    self.isAnimate = YES;
    self.alpha = self.showAnimate ? 1.0 : 0;
    CATransform3D originTransform = self.displayView.layer.transform;
    CATransform3D startTransform = CATransform3DScale(originTransform, 0.2, 0.2, 0.2);
    self.displayView.layer.transform = self.showAnimate ? originTransform : startTransform;
    self.superview.backgroundColor = kZCA(kZCBlack, 0);
    UIViewAnimationOptions ops = (UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseInOut);
    [UIView animateWithDuration:self.animateTime delay:0 options:ops animations:^{
        if (self.showAnimate) {
            self.showAnimate(self.displayView);
        } else {
            self.alpha = 1.0;
            self.displayView.layer.transform = CATransform3DScale(startTransform, 5.0, 5.0, 5.0);
        } self.superview.backgroundColor = kZCA(kZCBlack, self.isGreyCover ? self.coverAlpha : 0);
    } completion:^(BOOL finished) {
        self.displayView.layer.transform = originTransform;
        self.isAnimate = NO;
    }];
}

- (void)onHideIsAuto:(BOOL)isByAutoHide {
    self.isAnimate = YES;
    CATransform3D originTransform = self.displayView.layer.transform;
    self.displayView.layer.transform = originTransform;
    UIViewAnimationOptions ops1 = (UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseInOut);
    [UIView animateWithDuration:self.animateTime delay:0 options:ops1 animations:^{
        if (self.hideAnimate) {
            self.hideAnimate(self.displayView);
        } else {
            self.displayView.layer.transform = CATransform3DScale(originTransform, 1.08, 1.08, 1.08);
        } self.superview.backgroundColor = kZCA(kZCBlack, 0);
    } completion:^(BOOL finished) {
        if (self.hideAnimate) {
            self.displayView.layer.transform = originTransform;
            self.isAnimate = NO;
            [self onFinishByAutoHide:isByAutoHide];
        }
    }];
    if (!self.hideAnimate) {
        UIViewAnimationOptions ops2 = (UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut);
        [UIView animateWithDuration:(self.animateTime + 0.08) delay:0 options:ops2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.displayView.layer.transform = originTransform;
            self.isAnimate = NO;
            [self onFinishByAutoHide:isByAutoHide];
        }];
    }
}

- (void)onFinishByAutoHide:(BOOL)isByAutoHide {
    [self.superview removeFromSuperview];
    [self removeFromSuperview];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.willHideBlock) self.willHideBlock = nil;
    if (self.showAnimate) self.showAnimate = nil;
    if (self.hideAnimate) self.hideAnimate = nil;
    if (self.displayView) self.displayView = nil;
    if (self.aboveView) self.aboveView = nil;
    if (self.didHideBlock) {self.didHideBlock(isByAutoHide);}
    if (self.didHideBlock) self.didHideBlock = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isAutoHide && self.isAnimate == NO) {
        if (self.subviews.firstObject) {
            UITouch *touch = [touches anyObject];
            CGPoint point = [touch locationInView:self];
            CGRect rect = self.subviews.firstObject.frame;
            if (CGRectContainsPoint(rect, point) == NO) {
                [self autoDismiss:YES];
            }
        } else {
            [self autoDismiss:YES];
        }
    }
}

@end
