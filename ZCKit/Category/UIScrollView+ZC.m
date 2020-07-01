//
//  UIScrollView+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIScrollView+ZC.h"
#import <objc/runtime.h>
#import "UIView+ZC.h"
#import "ZCMacro.h"

@implementation UIScrollView (ZC)

#pragma mark - Usually
- (void)setOffsetX:(CGFloat)offsetX {
    CGPoint offset = self.contentOffset;
    offset.x = offsetX;
    self.contentOffset = offset;
}

- (CGFloat)offsetX {
    return self.contentOffset.x;
}

- (void)setOffsetY:(CGFloat)offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = offsetY;
    self.contentOffset = offset;
}

- (CGFloat)offsetY {
    return self.contentOffset.y;
}

- (void)setSizeWidth:(CGFloat)sizeWidth {
    CGSize contentSize = self.contentSize;
    contentSize.width = sizeWidth;
    self.contentSize = contentSize;
}

- (CGFloat)sizeWidth {
    return self.contentSize.width;
}

- (void)setSizeHeight:(CGFloat)sizeHeight {
    CGSize contentSize = self.contentSize;
    contentSize.height = sizeHeight;
    self.contentSize = contentSize;
}

- (CGFloat)sizeHeight {
    return self.contentSize.height;
}

- (void)setInsetTop:(CGFloat)insetTop {
    UIEdgeInsets inset = self.contentInset;
    inset.top = insetTop;
    self.contentInset = inset;
}

- (CGFloat)insetTop {
    return self.contentInset.top;
}

- (void)setInsetLeft:(CGFloat)insetLeft {
    UIEdgeInsets inset = self.contentInset;
    inset.left = insetLeft;
    self.contentInset = inset;
}

- (CGFloat)insetLeft {
    return self.contentInset.left;
}

- (void)setInsetBottom:(CGFloat)insetBottom {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = insetBottom;
    self.contentInset = inset;
}

- (CGFloat)insetBottom {
    return self.contentInset.bottom;
}

- (void)setInsetRight:(CGFloat)insetRight {
    UIEdgeInsets inset = self.contentInset;
    inset.right = insetRight;
    self.contentInset = inset;
}

- (CGFloat)insetRight {
    return self.contentInset.right;
}

- (void)setVisualOffsetX:(CGFloat)visualOffsetX {
    CGPoint offset = self.visualOffset;
    offset.y = visualOffsetX;
    self.visualOffset = offset;
}

- (CGFloat)visualOffsetX {
    return self.visualOffset.x;
}

- (void)setVisualOffsetY:(CGFloat)visualOffsetY {
    CGPoint offset = self.visualOffset;
    offset.y = visualOffsetY;
    self.visualOffset = offset;
}

- (CGFloat)visualOffsetY {
    return self.visualOffset.y;
}

#pragma mark - Offset
- (void)setVisualOffset:(CGPoint)visualOffset {
    self.contentOffset = [self convertToContentOffsetFromVisualOffset:visualOffset];
}

- (CGPoint)visualOffset {
    return [self convertToVisualOffsetFromContentOffset:self.contentOffset];
}

- (CGPoint)relativeOffset {
    if (@available(iOS 11.0, *)) {
        CGFloat x = self.contentOffset.x + self.adjustedContentInset.left;
        CGFloat y = self.contentOffset.y + self.adjustedContentInset.top;
        return CGPointMake(x, y);
    } else {
        CGFloat x = self.contentOffset.x + self.contentInset.left;
        CGFloat y = self.contentOffset.y + self.contentInset.top;
        return CGPointMake(x, y);
    }
}

- (CGPoint)convertToContentOffsetFromVisualOffset:(CGPoint)visualOffset { //转换成content offset
    if (@available(iOS 11.0, *)) {
        if (self.contentInsetAdjustmentBehavior == UIScrollViewContentInsetAdjustmentNever) {
            return visualOffset;
        } else {
            CGFloat x = visualOffset.x + self.contentInset.left - self.adjustedContentInset.left;
            CGFloat y = visualOffset.y + self.contentInset.top - self.adjustedContentInset.top;
            return CGPointMake(x, y);
        }
    } else {
        UIViewController *controller = self.currentViewController;
        if (controller && controller.automaticallyAdjustsScrollViewInsets) {
            return CGPointMake(visualOffset.x, visualOffset.y - controller.topLayoutGuide.length);
        } else {
            return visualOffset;
        }
    }
}

- (CGPoint)convertToVisualOffsetFromContentOffset:(CGPoint)contentOffset { //转换成visual offset
    if (@available(iOS 11.0, *)) {
        if (self.contentInsetAdjustmentBehavior == UIScrollViewContentInsetAdjustmentNever) {
            return contentOffset;
        } else {
            CGFloat offx = contentOffset.x + self.adjustedContentInset.left - self.contentInset.left;
            CGFloat offy = contentOffset.y + self.adjustedContentInset.top - self.contentInset.top;
            return CGPointMake(offx, offy);
        }
    } else {
        UIViewController *controller = self.currentViewController;
        if (controller && controller.automaticallyAdjustsScrollViewInsets) {
            return CGPointMake(contentOffset.x, contentOffset.y + controller.topLayoutGuide.length);
        } else {
            return contentOffset;
        }
    }
}

#pragma mark - Offset
- (UIView *)topExpandOffsetView { //frame&contentSize变化不联动
    UIView *topv = objc_getAssociatedObject(self, _cmd);
    if (!topv) {
        topv = [[UIView alloc] initWithFrame:CGRectZero color:self.backgroundColor];
        objc_setAssociatedObject(self, _cmd, topv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:topv];
    }
    topv.frame = CGRectMake(-200.0, -self.height, MAX(self.height, self.sizeWidth) + 400.0, self.height);
    [self sendSubviewToBack:topv];
    return topv;
}

- (UIView *)bottomExpandOffsetView { //frame&contentSize变化不联动
    UIView *bottomv = objc_getAssociatedObject(self, _cmd);
    if (!bottomv) {
        bottomv = [[UIView alloc] initWithFrame:CGRectZero color:self.backgroundColor];
        objc_setAssociatedObject(self, _cmd, bottomv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:bottomv];
    }
    CGFloat resBottom = 0;
    if ([self isKindOfClass:UITableView.class] && [(UITableView *)self style] == UITableViewStyleGrouped) {
        if (self.currentViewController.automaticallyAdjustsScrollViewInsets) {
            resBottom = 20.0;
        }
        if (@available(iOS 11.0, *)) {
            if (self.contentInsetAdjustmentBehavior == UIScrollViewContentInsetAdjustmentAutomatic) {
                resBottom = 20.0;
            }
        }
    }
    CGFloat top = self.sizeHeight - self.insetBottom - resBottom;
    bottomv.frame = CGRectMake(-200.0, top, MAX(self.height, self.sizeWidth) + 400.0, self.height + 500);
    [self sendSubviewToBack:bottomv];
    return bottomv;
}

- (void)setTopExpandColor:(UIColor *)topExpandColor {
    self.topExpandOffsetView.backgroundColor = topExpandColor;
}

- (UIColor *)topExpandColor {
    return self.topExpandOffsetView.backgroundColor;
}

- (void)setBottomExpandColor:(UIColor *)bottomExpandColor {
    self.bottomExpandOffsetView.backgroundColor = bottomExpandColor;
}

- (UIColor *)bottomExpandColor {
    return self.bottomExpandOffsetView.backgroundColor;
}

#pragma mark - Basic
- (UIScrollView *)initWithFrame:(CGRect)frame isPaging:(BOOL)isPaging isBounces:(BOOL)isBounces {
    if (self = [self initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = ZCClear;
        self.directionalLockEnabled = YES;
        self.pagingEnabled = isPaging;
        self.bounces = isBounces;
        if (frame.size.height > 0) {
            self.contentSize = CGSizeMake(frame.size.width, frame.size.height + ZSSepHei);
        }
    }
    return self;
}

#pragma mark - Direction
static NSString * const directionOffset = @"contentOffset";
static void *directionContext = @"scrollViewDirectionContext";
- (void)startObservingDirection {
    [self addObserver:self forKeyPath:directionOffset options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:directionContext];
}

- (void)stopObservingDirection {
    [self removeObserver:self forKeyPath:directionOffset context:directionContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:directionOffset] && context == directionContext) {
        CGPoint newContentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        CGPoint oldContentOffset = [[change valueForKey:NSKeyValueChangeOldKey] CGPointValue];
        if (oldContentOffset.x < newContentOffset.x) {
            self.horizontalScrollingDirection = ZCEnumScrollViewDirectionRight;
        } else if (oldContentOffset.x > newContentOffset.x) {
            self.horizontalScrollingDirection = ZCEnumScrollViewDirectionLeft;
        } else {
            self.horizontalScrollingDirection = ZCEnumScrollViewDirectionNone;
        }
        if (oldContentOffset.y < newContentOffset.y) {
            self.verticalScrollingDirection = ZCEnumScrollViewDirectionDown;
        } else if (oldContentOffset.y > newContentOffset.y) {
            self.verticalScrollingDirection = ZCEnumScrollViewDirectionUp;
        } else {
            self.verticalScrollingDirection = ZCEnumScrollViewDirectionNone;
        }
    }
}

- (ZCEnumScrollViewDirection)horizontalScrollingDirection {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setHorizontalScrollingDirection:(ZCEnumScrollViewDirection)horizontalScrollingDirection {
    objc_setAssociatedObject(self, @selector(horizontalScrollingDirection),
                             [NSNumber numberWithInteger:horizontalScrollingDirection], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZCEnumScrollViewDirection)verticalScrollingDirection {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setVerticalScrollingDirection:(ZCEnumScrollViewDirection)verticalScrollingDirection {
    objc_setAssociatedObject(self, @selector(verticalScrollingDirection),
                             [NSNumber numberWithInteger:verticalScrollingDirection], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Private
- (void)shieldNavigationInteractivePop { //使系统导航手势失效，不可逆
    UIViewController *controller = self.currentViewController;
    if (controller && controller.navigationController && controller.parentViewController == controller.navigationController) {
        [self.panGestureRecognizer requireGestureRecognizerToFail:controller.navigationController.interactivePopGestureRecognizer];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] && [otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] && [otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) return YES;
    }
    return NO;
}

@end
