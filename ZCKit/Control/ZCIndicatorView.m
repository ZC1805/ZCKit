//
//  ZCIndicatorView.m
//  ZCKit
//
//  Created by admin on 2018/10/18.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCIndicatorView.h"
#import "UIView+ZC.h"
#import "ZCMacro.h"

@interface ZCIndicatorView ()

@property (nonatomic, strong) CAShapeLayer *animationLayer;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation ZCIndicatorView

- (instancetype)initWithFrame:(CGRect)frame diameter:(CGFloat)diameter {
    if (self = [super initWithFrame:frame]) {
        _diameter = diameter;
        _tintColor = kZCBlack80;
        self.backgroundColor = kZCRGB(0xFF0000);
        [self indicatorSize:self.zc_size];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [self initWithFrame:frame diameter:(frame.size.width / 9.0)]) {
    } return self;
}

- (void)setDiameter:(CGFloat)diameter {
    _diameter = diameter;
    [self layoutSubviews];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self resetIndicator:self.zc_size];
}

- (void)resetIndicator:(CGSize)size {
    if (!self.animationLayer || !self.gradientLayer) return;
    self.animationLayer.bounds = CGRectMake(0, 0, self.diameter, self.diameter);
    self.animationLayer.position = CGPointMake(size.width / 2.0, size.height - self.diameter - 2.0);
    self.animationLayer.cornerRadius = self.diameter / 2.0;
    self.animationLayer.shadowColor = self.tintColor.CGColor;
    self.animationLayer.shadowOffset = CGSizeMake(self.diameter / 5.0, 0);
    self.animationLayer.shadowRadius = self.diameter / 3.0;
    
    self.gradientLayer.frame = CGRectMake(0, 0, self.diameter, self.diameter);
    self.gradientLayer.position = CGPointMake(self.diameter / 2.0, self.diameter / 2.0);
    self.gradientLayer.cornerRadius = self.diameter / 2.0;
    self.gradientLayer.borderColor = self.tintColor.CGColor;
    self.gradientLayer.colors = @[(id)kZCA(self.tintColor, 0.25).CGColor, (id)self.tintColor.CGColor, (id)kZCA(self.tintColor, 0.01).CGColor];
}

- (void)indicatorSize:(CGSize)size {
    self.clipsToBounds = YES;
    self.animationLayer = [[CAShapeLayer alloc] init];
    self.animationLayer.bounds = CGRectMake(0, 0, self.diameter, self.diameter);
    self.animationLayer.position = CGPointMake(size.width / 2.0, size.height - self.diameter - 2.0);
    self.animationLayer.cornerRadius = self.diameter / 2.0;
    self.animationLayer.shadowColor = self.tintColor.CGColor;
    self.animationLayer.shadowOffset = CGSizeMake(self.diameter / 5.0, 0);
    self.animationLayer.shadowRadius = self.diameter / 3.0;
    self.animationLayer.shadowOpacity = 1.0;
    self.animationLayer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    
    self.gradientLayer = [[CAGradientLayer alloc] init];
    self.gradientLayer.colors = @[(id)kZCA(self.tintColor, 0.25).CGColor, (id)self.tintColor.CGColor, (id)kZCA(self.tintColor, 0.01).CGColor];
    self.gradientLayer.frame = CGRectMake(0, 0, self.diameter, self.diameter);
    self.gradientLayer.position = CGPointMake(self.diameter / 2.0, self.diameter / 2.0);
    self.gradientLayer.cornerRadius = self.diameter / 2.0;
    self.gradientLayer.borderColor = self.tintColor.CGColor;
    self.gradientLayer.borderWidth = 0.5;
    self.gradientLayer.locations = @[@(0), @(0.4), @(1.0)];
    self.gradientLayer.startPoint = CGPointMake(0.5, 1.0);
    self.gradientLayer.endPoint = CGPointMake(0.5, 0);
    [self.animationLayer addSublayer:self.gradientLayer];
    
    CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    transformAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01, 0.01, 0.01)];
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @(1.0);
    opacityAnim.toValue = @(-0.12);
    
    CAAnimationGroup *animGroup = [[CAAnimationGroup alloc] init];
    animGroup.animations = @[transformAnim, opacityAnim];
    animGroup.duration = 1.0;
    animGroup.repeatCount = HUGE;
    [self.animationLayer addAnimation:animGroup forKey:nil];
    
    CAReplicatorLayer *replicatorLayer = [[CAReplicatorLayer alloc] init];
    replicatorLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    replicatorLayer.position = CGPointMake(size.width / 2.0, size.height / 2.0);
    replicatorLayer.instanceCount = 16;
    replicatorLayer.instanceDelay = 0.0625;
    CGFloat angle = (2 * M_PI) / 16.0;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1.0);
    [replicatorLayer addSublayer:self.animationLayer];
    [self.layer addSublayer:replicatorLayer];
}

- (void)pause {
    CFTimeInterval pauseTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.timeOffset = pauseTime;
    self.layer.speed = 0;
}

- (void)resume {
    CFTimeInterval pauseTime = self.layer.timeOffset;
    CFTimeInterval timeSincePause = CACurrentMediaTime() - pauseTime;
    self.layer.timeOffset = 0;
    self.layer.beginTime = timeSincePause;
    self.layer.speed = 1;
}

@end
