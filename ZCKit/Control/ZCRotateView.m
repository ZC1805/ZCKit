//
//  ZCRotateView.m
//  ZCKit
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import "ZCRotateView.h"
#import "ZCMacro.h"

@interface ZCRotateView ()

@property (nonatomic, strong) CAShapeLayer *indefiniteAnimatedLayer;

@end

@implementation ZCRotateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _strokeRadius = 15.0;
        _strokeThickness = 3.5;
        _strokeColor = kZCRGB(0xFF0000);
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self layoutAnimatedLayer];
    } else {
        [_indefiniteAnimatedLayer removeFromSuperlayer];
        _indefiniteAnimatedLayer = nil;
    }
}

- (void)layoutAnimatedLayer {
    CALayer *layer = self.indefiniteAnimatedLayer;
    [self.layer addSublayer:layer];
    layer.position = CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(layer.bounds) / 2.0,
                                 CGRectGetHeight(self.bounds) - CGRectGetHeight(layer.bounds) / 2.0);
}

- (CAShapeLayer*)indefiniteAnimatedLayer {
    if (!_indefiniteAnimatedLayer) {
        CGPoint arcCenter = CGPointMake(self.strokeRadius + self.strokeThickness / 2.0 + 5,
                                        self.strokeRadius + self.strokeThickness / 2.0 + 5);
        CGRect rect = CGRectMake(0.0, 0.0, arcCenter.x * 2, arcCenter.y * 2);
        UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:self.strokeRadius
                                                                startAngle:(M_PI * 3 / 2.0)
                                                                  endAngle:(M_PI / 2.0 + M_PI * 5) clockwise:YES];
        _indefiniteAnimatedLayer = [CAShapeLayer layer];
        _indefiniteAnimatedLayer.contentsScale = [[UIScreen mainScreen] scale];
        _indefiniteAnimatedLayer.frame = rect;
        _indefiniteAnimatedLayer.fillColor = kZCClear.CGColor;
        _indefiniteAnimatedLayer.strokeColor = self.strokeColor.CGColor;
        _indefiniteAnimatedLayer.lineWidth = self.strokeThickness;
        _indefiniteAnimatedLayer.lineCap = kCALineCapRound;
        _indefiniteAnimatedLayer.lineJoin = kCALineJoinBevel;
        _indefiniteAnimatedLayer.path = smoothedPath.CGPath;
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.contents = (id)[[ZCGlobal ZCImageName:@"zc_image_angle_mask"] CGImage];
        maskLayer.frame = _indefiniteAnimatedLayer.bounds;
        _indefiniteAnimatedLayer.mask = maskLayer;
        
        NSTimeInterval animationDuration = 1;
        CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.fromValue = 0;
        animation.toValue = [NSNumber numberWithFloat:(M_PI * 2)];
        animation.duration = animationDuration;
        animation.timingFunction = linearCurve;
        animation.removedOnCompletion = NO;
        animation.repeatCount = INFINITY;
        animation.fillMode = kCAFillModeForwards;
        animation.autoreverses = NO;
        [_indefiniteAnimatedLayer.mask addAnimation:animation forKey:@"rotate"];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = INFINITY;
        animationGroup.removedOnCompletion = NO;
        animationGroup.timingFunction = linearCurve;
        
        CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeStartAnimation.fromValue = @0.015;
        strokeStartAnimation.toValue = @0.515;
        
        CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeEndAnimation.fromValue = @0.485;
        strokeEndAnimation.toValue = @0.985;
        
        animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
        [_indefiniteAnimatedLayer addAnimation:animationGroup forKey:@"rotate.1"];
    }
    return _indefiniteAnimatedLayer;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (self.superview) {
        [self layoutAnimatedLayer];
    }
}

- (void)setStrokeRadius:(CGFloat)strokeRadius {
    _strokeRadius = strokeRadius;
    [_indefiniteAnimatedLayer removeFromSuperlayer];
    _indefiniteAnimatedLayer = nil;
    if (self.superview) {
        [self layoutAnimatedLayer];
    }
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    _indefiniteAnimatedLayer.strokeColor = strokeColor.CGColor;
}

- (void)setStrokeThickness:(CGFloat)strokeThickness {
    _strokeThickness = strokeThickness;
    _indefiniteAnimatedLayer.lineWidth = _strokeThickness;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake((self.strokeRadius + self.strokeThickness / 2.0 + 5) * 2, (self.strokeRadius + self.strokeThickness / 2.0 + 5) * 2);
}

@end
