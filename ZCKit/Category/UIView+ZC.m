//
//  UIView+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIView+ZC.h"
#import "ZCBlankControl.h"
#import <objc/runtime.h>
#import "NSArray+ZC.h"
#import "ZCMacro.h"

@implementation UIView (ZC)

#pragma mark - Override
- (UIUserInterfaceStyle)overrideUserInterfaceStyle API_AVAILABLE(ios(13.0)){
    return UIUserInterfaceStyleLight;
}

#pragma mark - Prty
- (CGFloat)visibleAlpha {
    if ([self isKindOfClass:UIWindow.class]) {
        if (self.hidden) return 0;
        return self.alpha;
    }
    if (!self.window) return 0;
    CGFloat alpha = 1.0;
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

- (UIViewController *)currentViewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:UIViewController.class]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)setFlagStr:(NSString *)flagStr {
    objc_setAssociatedObject(self, @selector(flagStr), flagStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)flagStr {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFlagDic:(NSDictionary *)flagDic {
    objc_setAssociatedObject(self, @selector(flagDic), flagDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)flagDic {
    return objc_getAssociatedObject(self, _cmd);
}

- (ZCBlankControl *)blankCoverView {
    ZCBlankControl *blankCoverView = objc_getAssociatedObject(self, _cmd);
    if (!blankCoverView) {
        blankCoverView = [[ZCBlankControl alloc] initWithFrame:CGRectMake(0, 0, self.zc_width, self.zc_height)];
        objc_setAssociatedObject(self, _cmd, blankCoverView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        blankCoverView.backgroundColor = self.backgroundColor;
        [self addSubview:blankCoverView];
    }
    return blankCoverView;
}

#pragma mark - Func
- (void)removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (NSArray *)containAllSubviews {
    NSMutableArray *container = [NSMutableArray array];
    [self addSubviewsToContainer:container];
    return container;
} 
- (void)addSubviewsToContainer:(NSMutableArray *)container {
    if (self.subviews.count) {
        for (UIView *subview in self.subviews) {
            [container addObject:subview];
            [subview addSubviewsToContainer:container];
        }
    }
}

- (CGRect)minContainerRect {
    CGFloat left = self.zc_width, right = 0, top = self.zc_height, bottom = 0;
    for (UIView *subview in self.subviews) {
        top = MIN(top, subview.zc_top);
        left = MIN(left, subview.zc_left);
        right = MAX(right, subview.zc_right);
        bottom = MAX(bottom, subview.zc_bottom);
    }
    if (right < left || bottom < top) return CGRectZero;
    return CGRectMake(left, top, right - left, bottom - top);
}

- (BOOL)isDisplayInScreen {
    CGRect screenRect = kZSScreen;
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) return NO;
    if (self.hidden) return NO;
    if (self.superview == nil) return NO;
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) return NO;
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) return NO;
    return TRUE;
}

- (UIView *)findFirstResponder {
    if ([self isFirstResponder]) return self;
    for (UIView *view in self.subviews) {
        UIView *firstResponder = [view findFirstResponder];
        if (firstResponder) return firstResponder;
    }
    return nil;
}

- (UIView *)findSubviewLike:(Class)likeClass {
    NSMutableArray *finalSubs = [NSMutableArray array];
    NSArray *tempSubs = [NSArray arrayWithObject:self];
    for (int i = 0; i < 30; i ++) {
        NSMutableArray *allSubs = [NSMutableArray array];
        for (UIView *view in tempSubs) {
            if (view.subviews == nil || view.subviews.count == 0) continue;
            NSEnumerator *enumerator = [view.subviews reverseObjectEnumerator];
            [allSubs addObjectsFromArray:[enumerator allObjects]];
        }
        if (allSubs.count == 0) break;
        [finalSubs insertObjects:allSubs atIndex:0];
        tempSubs = allSubs;
    }
    UIView *final = nil;
    for (UIView *view in finalSubs) {
        if ([view isMemberOfClass:likeClass]) {
            final = view; break;
        }
    }
    return final;
}

- (UIView *)findSubviewTag:(NSInteger)aimTag {
    NSMutableArray *finalSubs = [NSMutableArray array];
    NSArray *tempSubs = [NSArray arrayWithObject:self];
    for (int i = 0; i < 30; i ++) {
        NSMutableArray *allSubs = [NSMutableArray array];
        for (UIView *view in tempSubs) {
            if (view.subviews == nil || view.subviews.count == 0) continue;
            NSEnumerator *enumerator = [view.subviews reverseObjectEnumerator];
            [allSubs addObjectsFromArray:[enumerator allObjects]];
        }
        if (allSubs.count == 0) break;
        [finalSubs insertObjects:allSubs atIndex:0];
        tempSubs = allSubs;
    }
    UIView *final = nil;
    for (UIView *view in finalSubs) {
        if (view.tag == aimTag) {
            final = view; break;
        }
    }
    return final;
}

- (BOOL)containSubView:(UIView *)subView {
    for (UIView *view in self.subviews) {
        if ([view isEqual:subView]) {
            return YES;
        } else if ([view containSubView:subView]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containSubViewOfClassType:(Class)aClass {
    for (UIView *view in self.subviews) {
        if ([view isMemberOfClass:aClass]) {
            return YES;
        } else if ([view containSubViewOfClassType:aClass]) {
            return YES;
        }
    }
    return NO;
}

- (UIImage *)clipToSubAreaImage:(CGRect)subArea {
    UIGraphicsBeginImageContextWithOptions(self.zc_size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(subArea);
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)clipToImage {
    if (CGSizeEqualToSize(self.zc_size, CGSizeZero)) return nil;
    UIGraphicsBeginImageContextWithOptions(self.zc_size, self.opaque, 0);
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (CGPoint)convertPointToScrren:(CGPoint)point {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (!window) return point;
    return [self convertPoint:point toView:window];
}

- (void)setShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius {
    if (!color) return;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)setCorner:(CGFloat)radius color:(UIColor *)color width:(CGFloat)width {
    self.layer.masksToBounds = YES;
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

- (void)setGradientColors:(NSArray <UIColor *>*)colors isHor:(BOOL)isHor {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    NSMutableArray *CGColors = [NSMutableArray array];
    for (UIColor *color in colors) { [CGColors addObject:(__bridge id)[color CGColor]]; }
    gradientLayer.colors = CGColors.copy;
    if (isHor) {
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    } else {
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    }
    NSMutableArray *locs = [NSMutableArray array];
    if (CGColors.count == 1) {
        [locs addObject:[NSNumber numberWithFloat:1.0]];
    } else {
        for (int i = 0; i < CGColors.count; i ++) {
            [locs addObject:[NSNumber numberWithFloat:i * (1.0 / (CGColors.count - 1))]];
        }
    }
    gradientLayer.locations = locs.copy;
    gradientLayer.name = @"gradientLayer_bk_img";
    gradientLayer.frame = self.bounds;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.backgroundColor = [UIColor colorWithPatternImage:img];
}

#pragma mark - Line
- (NSValue *)holderLineViewInsets {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIView *)holderLineTopView {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIView *)setTopLineInsets:(UIEdgeInsets)insets color:(UIColor *)color {
    UIView *line = self.holderLineTopView;
    if (line) {
        if (UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
            [line removeFromSuperview]; line = nil;
            objc_setAssociatedObject(self, @selector(holderLineTopView), line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        if (!UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
            line = [[UIView alloc] initWithFrame:CGRectZero];
            objc_setAssociatedObject(self, @selector(holderLineTopView), line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self addSubview:line];
        }
    }
    if (line) {
        line.backgroundColor = color;
        line.frame = CGRectMake(insets.left, insets.top, self.zc_width - insets.left - insets.right, insets.bottom);
        NSValue *value = [NSValue valueWithUIEdgeInsets:insets];
        objc_setAssociatedObject(line, @selector(holderLineViewInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return line;
}

- (UIView *)holderLineLeftView {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIView *)setLeftLineInsets:(UIEdgeInsets)insets color:(UIColor *)color {
    UIView *line = self.holderLineLeftView;
    if (line) {
        if (UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
            [line removeFromSuperview]; line = nil;
            objc_setAssociatedObject(self, @selector(holderLineLeftView), line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        if (!UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
            line = [[UIView alloc] initWithFrame:CGRectZero];
            objc_setAssociatedObject(self, @selector(holderLineLeftView), line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self addSubview:line];
        }
    }
    if (line) {
        line.backgroundColor = color;
        line.frame = CGRectMake(insets.left, insets.top, insets.right, self.zc_height - insets.top - insets.bottom);
        NSValue *value = [NSValue valueWithUIEdgeInsets:insets];
        objc_setAssociatedObject(line, @selector(holderLineViewInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return line;
}

- (UIView *)holderLineBottomView {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIView *)setBottomLineInsets:(UIEdgeInsets)insets color:(UIColor *)color {
    UIView *line = self.holderLineBottomView;
    if (line) {
        if (UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
            [line removeFromSuperview]; line = nil;
            objc_setAssociatedObject(self, @selector(holderLineBottomView), line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        if (!UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
            line = [[UIView alloc] initWithFrame:CGRectZero];
            objc_setAssociatedObject(self, @selector(holderLineBottomView), line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self addSubview:line];
        }
    }
    if (line) {
        line.backgroundColor = color;
        line.frame = CGRectMake(insets.left, self.zc_height - insets.bottom - insets.top,
                                self.zc_width - insets.left - insets.right, insets.top);
        NSValue *value = [NSValue valueWithUIEdgeInsets:insets];
        objc_setAssociatedObject(line, @selector(holderLineViewInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return line;
}

- (UIView *)holderLineRightView {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIView *)setRightLineInsets:(UIEdgeInsets)insets color:(UIColor *)color {
    UIView *line = self.holderLineRightView;
    if (line) {
        if (UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
            [line removeFromSuperview]; line = nil;
            objc_setAssociatedObject(self, @selector(holderLineRightView), line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    } else {
        if (!UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
            line = [[UIView alloc] initWithFrame:CGRectZero];
            objc_setAssociatedObject(self, @selector(holderLineRightView), line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self addSubview:line];
        }
    }
    if (line) {
        line.backgroundColor = color;
        line.frame = CGRectMake(self.zc_width - insets.left - insets.right, insets.top,
                                insets.left, self.zc_height - insets.top - insets.bottom);
        NSValue *value = [NSValue valueWithUIEdgeInsets:insets];
        objc_setAssociatedObject(line, @selector(holderLineViewInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return line;
}

#pragma mark - Layout
- (void)setZc_top:(CGFloat)top {
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (CGFloat)zc_top {
    return self.frame.origin.y;
}

- (void)setZc_left:(CGFloat)left {
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

- (CGFloat)zc_left {
    return self.frame.origin.x;
}

- (void)setZc_width:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)zc_width {
    return self.frame.size.width;
}

- (void)setZc_height:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)zc_height {
    return self.frame.size.height;
}

- (void)setZc_right:(CGFloat)right {
    CGRect rect = self.frame;
    rect.origin.x = right - rect.size.width;
    self.frame = rect;
}

- (CGFloat)zc_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setZc_bottom:(CGFloat)bottom {
    CGRect rect = self.frame;
    rect.origin.y = bottom - rect.size.height;
    self.frame = rect;
}

- (CGFloat)zc_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setZc_edge:(UIEdgeInsets)zc_edge {
    if (self.superview && !CGSizeEqualToSize(CGSizeZero, self.superview.zc_size)) {
        CGSize super_size = self.superview.zc_size;
        self.frame = CGRectMake(zc_edge.left, zc_edge.top, super_size.width - zc_edge.left - zc_edge.right, super_size.height - zc_edge.top - zc_edge.bottom);
    } else {
        NSAssert(0, @"ZCKit: super view is invalid");
    }
}

- (UIEdgeInsets)zc_edge {
    if (self.superview) {
        CGRect rect = self.frame;
        CGSize super_size = self.superview.zc_size;
        return UIEdgeInsetsMake(rect.origin.y, rect.origin.x, super_size.height - rect.origin.y - rect.size.height, super_size.width - rect.origin.x - rect.size.width);
    } else {
        NSAssert(0, @"ZCKit: super view is invalid");
        return UIEdgeInsetsZero;
    }
}

- (void)setZc_edgeRight:(CGFloat)zc_edgeRight {
    if (self.superview && !CGSizeEqualToSize(CGSizeZero, self.superview.zc_size)) {
        CGRect rect = self.frame;
        rect.origin.x = self.superview.frame.size.width - zc_edgeRight - rect.size.width;
        self.frame = rect;
    } else {
        NSAssert(0, @"ZCKit: super view is invalid");
    }
}

- (CGFloat)zc_edgeRight {
    if (self.superview) {
        return self.superview.frame.size.width - self.frame.origin.x - self.frame.size.width;
    } else {
        NSAssert(0, @"ZCKit: super view is invalid");
        return 0;
    }
}

- (void)setZc_edgeBottom:(CGFloat)zc_edgeBottom {
    if (self.superview && !CGSizeEqualToSize(CGSizeZero, self.superview.zc_size)) {
        CGRect rect = self.frame;
        rect.origin.y = self.superview.frame.size.height - zc_edgeBottom - rect.size.height;
        self.frame = rect;
    } else {
        NSAssert(0, @"ZCKit: super view is invalid");
    }
}

- (CGFloat)zc_edgeBottom {
    if (self.superview) {
        return self.superview.frame.size.height - self.frame.origin.y - self.frame.size.height;
    } else {
        NSAssert(0, @"ZCKit: super view is invalid");
        return 0;
    }
}

- (void)setZc_size:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (CGSize)zc_size {
    return self.frame.size;
}

- (void)setZc_origin:(CGPoint)origin {
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (CGPoint)zc_origin {
    return self.frame.origin;
}

- (void)setZc_centerX:(CGFloat)centerX {
    CGPoint point = self.center;
    point.x = centerX;
    self.center = point;
}

- (CGFloat)zc_centerX {
    return self.center.x;
}

- (void)setZc_centerY:(CGFloat)centerY {
    CGPoint point = self.center;
    point.y = centerY;
    self.center = point;
}

- (CGFloat)zc_centerY {
    return self.center.y;
}

@end
