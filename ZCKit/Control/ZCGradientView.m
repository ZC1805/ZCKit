//
//  ZCGradientView.m
//  ZCKit
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import "ZCGradientView.h"
#import "ZCMacro.h"

@interface ZCGradientView ()

@property (nonatomic, strong) CAGradientLayer *dBKGradient;

@property (nonatomic, strong) NSArray <UIColor *>*bk1Colors;

@end

@implementation ZCGradientView

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_dBKGradient) {
        _dBKGradient.frame = self.bounds;
    }
}

- (CAGradientLayer *)dBKGradient {
    if (!_dBKGradient) {
        _dBKGradient = [CAGradientLayer layer];
        _dBKGradient.colors = @[(id)(kZCClear.CGColor), (id)(kZCClear.CGColor)];
        _dBKGradient.startPoint = CGPointMake(0.5, 0);
        _dBKGradient.endPoint = CGPointMake(0.5, 1);
    }
    return _dBKGradient;
}

- (void)resetAlphaGradientColors:(NSArray<UIColor *>*)colors isAxial:(BOOL)isAxial startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint location:(NSArray<NSNumber *> *)locations {
    self.bk1Colors = colors.copy;
    NSMutableArray *CGColors = [NSMutableArray array];
    for (UIColor *color in colors) { [CGColors addObject:(id)(color.CGColor)]; }
    self.dBKGradient.startPoint = startPoint;
    self.dBKGradient.endPoint = endPoint;
    self.dBKGradient.colors = CGColors;
    self.dBKGradient.type = isAxial ? kCAGradientLayerAxial : kCAGradientLayerRadial;
    if (locations && locations.count && locations.count == colors.count) {
        self.dBKGradient.locations = locations;
    } else {
        self.dBKGradient.locations = nil;
    }
    if (![self.layer.sublayers containsObject:self.dBKGradient]) {
        [self.layer insertSublayer:self.dBKGradient atIndex:0];
    }
}

- (void)resetBKColor:(UIColor *)BKColor shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius
        cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    if ((self.bk1Colors == nil || self.bk1Colors.count < 2) && BKColor) self.dBKGradient.colors = @[(id)(BKColor.CGColor), (id)(BKColor.CGColor)];
    if (shadowColor) {
        self.dBKGradient.masksToBounds = NO;
        self.dBKGradient.shadowColor = shadowColor.CGColor;
        self.dBKGradient.shadowRadius = shadowRadius;
        self.dBKGradient.shadowOffset = shadowOffset;
        self.dBKGradient.shadowOpacity = 1.0;
        self.dBKGradient.shouldRasterize = YES;
        self.dBKGradient.rasterizationScale = [UIScreen mainScreen].scale;
    }
    self.dBKGradient.masksToBounds = YES;
    self.dBKGradient.cornerRadius = cornerRadius;
    self.dBKGradient.borderWidth = borderWidth;
    self.dBKGradient.borderColor = borderColor.CGColor;
    self.dBKGradient.masksToBounds = NO;
    if (![self.layer.sublayers containsObject:self.dBKGradient]) {
        [self.layer insertSublayer:self.dBKGradient atIndex:0];
    }
}

@end
