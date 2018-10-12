//
//  UIView+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIView+ZC.h"

@implementation UIView (ZC)

- (CGFloat)visibleAlpha {
    if ([self isKindOfClass:[UIWindow class]]) {
        if (self.hidden) return 0;
        return self.alpha;
    }
    if (!self.window) return 0;
    CGFloat alpha = 1;
    UIView *v = self;
    while (v) {
        if (v.hidden) {
            alpha = 0; break;
        }
        alpha *= v.alpha;
        v = v.superview;
    }
    return alpha;
}

- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color {
    if (self = [self initWithFrame:frame]) {
        self.backgroundColor = color;
    }
    return self;
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (NSArray *)containAllSubviews {
    NSMutableArray *vis = [NSMutableArray array];
    for (UIView *sub in self.subviews) {
        [vis addObject:sub];
        if (sub.subviews.count) {
            [vis addObjectsFromArray:[sub containAllSubviews]];
        }
    }
    return vis;
}

- (UIView *)findFirstResponder {
    if ([self isFirstResponder]) return self;
    for (UIView *view in self.subviews) {
        UIView *firstResponder = [view findFirstResponder];
        if (firstResponder) return firstResponder;
    }
    return nil;
}

- (BOOL)containSubView:(UIView *)subView {
    for (UIView *view in [self subviews]) {
        if ([view isEqual:subView]) {
            return YES;
        } else if ([view containSubView:subView]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containSubViewOfClassType:(Class)aClass {
    for (UIView *view in [self subviews]) {
        if ([view isMemberOfClass:aClass]) {
            return YES;
        } else if ([view containSubViewOfClassType:aClass]) {
            return YES;
        }
    }
    return NO;
}

- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self snapshotImage];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (void)setShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)setCorner:(NSInteger)radius color:(UIColor *)color width:(CGFloat)width {
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (void)setCorner:(UIRectCorner)corner radius:(CGSize)radius {
    CGRect rect = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:radius];
    CAShapeLayer *masklayer = [[CAShapeLayer alloc] init];
    masklayer.frame = self.bounds;
    masklayer.path = path.CGPath;
    self.layer.mask = masklayer;
}

- (CGPoint)convertPointToScrren:(CGPoint)point {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (!window) return point;
    return [self convertPoint:point toView:window];
}

#pragma mark - layout
- (void)setTop:(CGFloat)top {
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setLeft:(CGFloat)left {
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setRight:(CGFloat)right {
    CGRect rect = self.frame;
    rect.origin.x = right - rect.size.width;
    self.frame = rect;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect rect = self.frame;
    rect.origin.y = bottom - rect.size.height;
    self.frame = rect;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setSize:(CGSize)size{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint point = self.center;
    point.x = centerX;
    self.center = point;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint point = self.center;
    point.y = centerY;
    self.center = point;
}

- (CGFloat)centerY{
    return self.center.y;
}

@end

