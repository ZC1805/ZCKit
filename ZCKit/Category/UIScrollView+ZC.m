//
//  UIScrollView+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIScrollView+ZC.h"
#import <objc/runtime.h>
#import "ZCMacro.h"

@implementation UIScrollView (ZC)

#pragma mark - Usually
- (void)setZc_offsetX:(CGFloat)zc_offsetX {
    CGPoint offset = self.contentOffset;
    offset.x = zc_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)zc_offsetX {
    return self.contentOffset.x;
}

- (void)setZc_offsetY:(CGFloat)zc_offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = zc_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)zc_offsetY {
    return self.contentOffset.y;
}

- (void)setZc_sizeWidth:(CGFloat)zc_sizeWidth {
    CGSize contentSize = self.contentSize;
    contentSize.width = zc_sizeWidth;
    self.contentSize = contentSize;
}

- (CGFloat)zc_sizeWidth {
    return self.contentSize.width;
}

- (void)setZc_sizeHeight:(CGFloat)zc_sizeHeight {
    CGSize contentSize = self.contentSize;
    contentSize.height = zc_sizeHeight;
    self.contentSize = contentSize;
}

- (CGFloat)zc_sizeHeight {
    return self.contentSize.height;
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
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class] && [otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class] && [otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) return YES;
    }
    return NO;
}

@end
