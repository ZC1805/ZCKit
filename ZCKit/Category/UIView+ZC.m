//
//  UIView+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIView+ZC.h"
#import <objc/runtime.h>
#import "UITableViewCell+ZC.h"
#import "NSArray+ZC.h"

@implementation UIView (ZC)

#pragma mark - Override
- (UIUserInterfaceStyle)overrideUserInterfaceStyle API_AVAILABLE(ios(13.0)){
    return UIUserInterfaceStyleLight;
}

#pragma mark - Prty
- (CGFloat)visibleAlpha {
    if ([self isKindOfClass:[UIWindow class]]) {
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

- (UITableViewCell *)currentCell {
    for (UIView *view = self; view; view = view.superview) {
        if ([view isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)view;
        }
    }
    return nil;
}

- (NSIndexPath *)currentCellIndexPath {
    UITableViewCell *cell = [self currentCell];
    if (cell) {
        UITableView *table = [cell currentTableView];
        if (table) {
            return [table indexPathForCell:cell];
        }
    }
    return nil;
}

- (UIViewController *)currentViewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)setFlagStr:(NSString *)flagStr {
    if (!flagStr && !self.flagStr) return;
    objc_setAssociatedObject(self, @selector(flagStr), flagStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)flagStr {
    return objc_getAssociatedObject(self, _cmd);
}

- (ZCBlankControl *)blankCoverView {
    ZCBlankControl *blankCoverView = objc_getAssociatedObject(self, _cmd);
    if (!blankCoverView) {
        blankCoverView = [[ZCBlankControl alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) color:self.backgroundColor];
        objc_setAssociatedObject(self, _cmd, blankCoverView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:blankCoverView];
    }
    return blankCoverView;
}

#pragma mark - Func
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
    CGFloat left = self.width, right = 0, top = self.height, bottom = 0;
    for (UIView *subview in self.subviews) {
        top = MIN(top, subview.top);
        left = MIN(left, subview.left);
        right = MAX(right, subview.right);
        bottom = MAX(bottom, subview.bottom);
    }
    if (right < left || bottom < top) return CGRectZero;
    return CGRectMake(left, top, right - left, bottom - top);
}

- (BOOL)isDisplayInScreen {
    CGRect screenRect = [UIScreen mainScreen].bounds;
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

- (CGPoint)convertPointToScrren:(CGPoint)point {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (!window) return point;
    return [self convertPoint:point toView:window];
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
        line.frame = CGRectMake(insets.left, insets.top, self.width - insets.left - insets.right, insets.bottom);
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
        line.frame = CGRectMake(insets.left, insets.top, insets.right, self.height - insets.top - insets.bottom);
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
        line.frame = CGRectMake(insets.left, self.height - insets.bottom - insets.top,
                                self.width - insets.left - insets.right, insets.top);
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
        line.frame = CGRectMake(self.width - insets.left - insets.right, insets.top,
                                insets.left, self.height - insets.top - insets.bottom);
        NSValue *value = [NSValue valueWithUIEdgeInsets:insets];
        objc_setAssociatedObject(line, @selector(holderLineViewInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return line;
}

#pragma mark - Layout
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

- (void)setWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)height {
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

- (void)setSize:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (CGSize)size {
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

- (void)setCenterX:(CGFloat)centerX {
    CGPoint point = self.center;
    point.x = centerX;
    self.center = point;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint point = self.center;
    point.y = centerY;
    self.center = point;
}

- (CGFloat)centerY {
    return self.center.y;
}

@end
