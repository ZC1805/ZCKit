//
//  UIScrollView+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIScrollView+ZC.h"
#import "UIView+ZC.h"
#import <objc/runtime.h>

@implementation UIScrollView (ZC)

#pragma mark - usually
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

#pragma mark - misc
- (void)shieldNavigationInteractivePop {
    UIViewController *controller = self.viewController;
    if (controller && controller.navigationController) {
        [self.panGestureRecognizer requireGestureRecognizerToFail:controller.navigationController.interactivePopGestureRecognizer];
    }
}

#pragma mark - direction
static void *directionContext = @"ScrollViewDirectionContext";
- (void)startObservingDirection {
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:directionContext];
}

- (void)stopObservingDirection {
    [self removeObserver:self forKeyPath:@"contentOffset" context:directionContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![keyPath isEqualToString:@"contentOffset"] || context != directionContext) return;
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

- (ZCEnumScrollViewDirection)horizontalScrollingDirection {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setHorizontalScrollingDirection:(ZCEnumScrollViewDirection)horizontalScrollingDirection {
    objc_setAssociatedObject(self, @selector(horizontalScrollingDirection), [NSNumber numberWithInteger:horizontalScrollingDirection], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZCEnumScrollViewDirection)verticalScrollingDirection {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setVerticalScrollingDirection:(ZCEnumScrollViewDirection)verticalScrollingDirection {
    objc_setAssociatedObject(self, @selector(verticalScrollingDirection), [NSNumber numberWithInteger:verticalScrollingDirection], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - offset
- (UIView *)topExpandOffsetView {   //frame变化不联动
    UIView *topv = objc_getAssociatedObject(self, _cmd);
    if (!topv) {
        topv = [[UIView alloc] initWithFrame:CGRectZero];
        topv.backgroundColor = self.backgroundColor;
        objc_setAssociatedObject(self, _cmd, topv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:topv];
    }
    topv.frame = CGRectMake(0, -self.height, self.width, self.height);
    [self sendSubviewToBack:topv];
    return topv;
}

- (UIView *)bottomExpandOffsetView {   //frame变化不联动
    UIView *bottomv = objc_getAssociatedObject(self, _cmd);
    if (!bottomv) {
        bottomv = [[UIView alloc] initWithFrame:CGRectZero];
        bottomv.backgroundColor = self.backgroundColor;
        objc_setAssociatedObject(self, _cmd, bottomv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:bottomv];
    }
    bottomv.frame = CGRectMake(0, self.height, self.width, self.height);
    [self sendSubviewToBack:bottomv];
    return bottomv;
}

- (void)setTopOffsetColor:(UIColor *)topOffsetColor {
    self.topExpandOffsetView.backgroundColor = topOffsetColor;
}

- (UIColor *)topOffsetColor {
    return self.topExpandOffsetView.backgroundColor;
}

- (void)setBottomOffsetColor:(UIColor *)bottomOffsetColor {    ///contentSize/frame变化需要更新位置
    self.bottomExpandOffsetView.backgroundColor = bottomOffsetColor;
}

- (UIColor *)bottomOffsetColor {
    return self.bottomExpandOffsetView.backgroundColor;
}

- (void)setAbsoluteOffset:(CGPoint)absoluteOffset {
    self.contentOffset = [self convertIntoContentOffsetWithAbsoluteOffset:absoluteOffset];
}

- (CGPoint)absoluteOffset {
    return [self convertIntoAbsoluteOffsetWithContentOffset:self.contentOffset];
}

- (CGPoint)convertIntoContentOffsetWithAbsoluteOffset:(CGPoint)absoluteOffset {
    if (@available(iOS 11.0, *)) {
        if (self.contentInsetAdjustmentBehavior == UIScrollViewContentInsetAdjustmentNever) {
            return absoluteOffset;
        } else {
            CGFloat offx = absoluteOffset.x - self.adjustedContentInset.left - self.contentInset.left;
            CGFloat offy = absoluteOffset.y - self.adjustedContentInset.top - self.contentInset.top;
            return CGPointMake(offx, offy);
        }
    } else {
        if (self.viewController.automaticallyAdjustsScrollViewInsets) {
            CGFloat offx = absoluteOffset.x - self.contentInset.left;
            CGFloat offy = absoluteOffset.y - self.viewController.topLayoutGuide.length - self.contentInset.top;
            return CGPointMake(offx, offy);
        } else {
            return absoluteOffset;
        }
    }
}

- (CGPoint)convertIntoAbsoluteOffsetWithContentOffset:(CGPoint)contentOffset {
    if (@available(iOS 11.0, *)) {
        if (self.contentInsetAdjustmentBehavior == UIScrollViewContentInsetAdjustmentNever) {
            return contentOffset;
        } else {
            CGFloat offx = contentOffset.x + self.adjustedContentInset.left + self.contentInset.left;
            CGFloat offy = contentOffset.y + self.adjustedContentInset.top + self.contentInset.top;
            return CGPointMake(offx, offy);
        }
    } else {
        if (self.viewController.automaticallyAdjustsScrollViewInsets) {
            CGFloat offx = contentOffset.x + self.contentInset.left;
            CGFloat offy = contentOffset.y + self.viewController.topLayoutGuide.length + self.contentInset.top;
            return CGPointMake(offx, offy);
        } else {
            return contentOffset;
        }
    }
}

#pragma mark - scroll
- (void)scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToLeftAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}

@end













