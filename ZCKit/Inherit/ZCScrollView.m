//
//  ZCScrollView.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCScrollView.h"
#import "ZCMacro.h"

#pragma mark - ~ UIScrollView ~
@interface UIScrollView ()

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

@end


#pragma mark - ~ ZCScrollView ~
@interface ZCScrollView ()

@end

@implementation ZCScrollView

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.contentOffset.y != 0) {
#warning - 待修改
        self.contentOffset = CGPointMake(self.contentOffset.x, 0);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.isPriorityEditGestures && touch.view && [NSStringFromClass(touch.view.class) isEqualToString:@"UITableViewCellContentView"]) {
#warning - pan手势在边缘时候返回YES吧 & boxView侧滑问题
        return NO;
    }
    if ([super respondsToSelector:@selector(gestureRecognizer:shouldReceiveTouch:)]) {
        return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
    } return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer.view && gestureRecognizer == self.panGestureRecognizer && [gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
        UIGestureRecognizerState state = gestureRecognizer.state;
        CGFloat screen_width = UIScreen.mainScreen.bounds.size.width;
        if ((self.frame.size.width >= screen_width - 60) && (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStatePossible)) {
            CGPoint verocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view];
            CGPoint point = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view];
            CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
            if (self.contentOffset.x <= 0 && point.x > 0 && location.x <= 40 && (fabs(verocity.x) - fabs(verocity.y)) > 0 && verocity.x > 0) {
                return YES;
            }
        }
    } return NO;
}

#pragma mark - Basic
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.directionalLockEnabled = YES;
        self.backgroundColor = kZCClear;
        self.pagingEnabled = NO;
        self.bounces = YES;
        self.isInterceptTouchEvent = NO;
        if (frame.size.height > 0) { self.contentSize = CGSizeMake(frame.size.width, frame.size.height + kZSPixel); }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame isPaging:(BOOL)isPaging isBounces:(BOOL)isBounces {
    if (self = [self initWithFrame:frame]) {
        self.pagingEnabled = isPaging;
        self.bounces = isBounces;
        if (frame.size.height > 0) { self.contentSize = CGSizeMake(frame.size.width, frame.size.height + (isBounces ? kZSPixel : 0)); }
    }
    return self;
}

#pragma mark - System
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isInterceptTouchEvent) { [[self nextResponder] touchesBegan:touches withEvent:event]; }
    //[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isInterceptTouchEvent) { [[self nextResponder] touchesMoved:touches withEvent:event]; }
    //[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isInterceptTouchEvent) { [[self nextResponder] touchesEnded:touches withEvent:event]; }
    //[super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isInterceptTouchEvent) { [[self nextResponder] touchesCancelled:touches withEvent:event]; }
    //[super touchesCancelled:touches withEvent:event];
}

@end
