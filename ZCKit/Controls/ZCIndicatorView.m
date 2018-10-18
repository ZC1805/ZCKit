//
//  ZCIndicatorView.m
//  ZCKit
//
//  Created by admin on 2018/10/18.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCIndicatorView.h"

@implementation ZCIndicatorView

- (instancetype)initWithFrame:(CGRect)frame diameter:(CGFloat)diameter color:(UIColor *)color {
    if (self = [super initWithFrame:frame]) {
        [self obtainWaitIndicatorSize:frame.size diameter:diameter color:color]; 
    }
    return self;
}

- (void)obtainWaitIndicatorSize:(CGSize)size diameter:(CGFloat)diameter color:(UIColor *)color {
    if (!color) color = [UIColor whiteColor];
    self.clipsToBounds = YES;
    CAShapeLayer *animationLayer = [[CAShapeLayer alloc] init];
    animationLayer.bounds = CGRectMake(0, 0, diameter, diameter);
    animationLayer.position = CGPointMake(size.width / 2.0, size.height - diameter - 2.0);
    animationLayer.cornerRadius = diameter / 2.0;
    animationLayer.shadowColor  = color.CGColor;
    animationLayer.shadowOffset = CGSizeMake(diameter / 5.0, 0);
    animationLayer.shadowRadius = diameter / 3.0;
    animationLayer.shadowOpacity = 1.0;
    animationLayer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors = @[(id)[color colorWithAlphaComponent:0.25].CGColor, (id)color.CGColor, (id)[color colorWithAlphaComponent:0.01].CGColor];
    gradientLayer.frame = CGRectMake(0, 0, diameter, diameter);
    gradientLayer.position = CGPointMake(diameter / 2.0, diameter / 2.0);
    gradientLayer.cornerRadius = diameter / 2.0;
    gradientLayer.borderColor = color.CGColor;
    gradientLayer.borderWidth = 0.5;
    gradientLayer.locations = @[@(0), @(0.4), @(1.0)];
    gradientLayer.startPoint = CGPointMake(0.5, 1.0);
    gradientLayer.endPoint = CGPointMake(0.5, 0);
    [animationLayer addSublayer:gradientLayer];
    
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
    [animationLayer addAnimation:animGroup forKey:nil];
    
    CAReplicatorLayer *replicatorLayer = [[CAReplicatorLayer alloc] init];
    replicatorLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    replicatorLayer.position = CGPointMake(size.width / 2.0, size.height / 2.0);
    replicatorLayer.instanceCount = 16;
    replicatorLayer.instanceDelay = 0.0625;
    CGFloat angle = (2 * M_PI) / 16.0;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1.0);
    [replicatorLayer addSublayer:animationLayer];
    [self.layer addSublayer:replicatorLayer];
}

- (void)pause {
    CFTimeInterval pauseTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil]; //将当前时间转layer时间，即将parentTime转localtime
    self.layer.timeOffset = pauseTime; //设置layer的timeOffset在，继续操作也会使用到
    self.layer.speed = 0; //localtime与parenttime的比例为0，意味着localtime暂停了
}

- (void)resume {
    CFTimeInterval pauseTime = self.layer.timeOffset; //时间转换
    CFTimeInterval timeSincePause = CACurrentMediaTime() - pauseTime; //计算暂停时间
    self.layer.timeOffset = 0; //取消
    self.layer.beginTime = timeSincePause; //localTime相对于parentTime世界的beginTime
    self.layer.speed = 1; //继续
}

@end
