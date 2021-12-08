//
//  ZCScrollView.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCScrollView.h"
#import "ZCMacro.h"

@interface ZCScrollView ()

@end

@implementation ZCScrollView

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.contentOffset.y != 0) { //适配io9的问题
        self.contentOffset = CGPointMake(self.contentOffset.x, 0);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (!self.isShieldPriorityEditGestures && [NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    } return YES;
}

#pragma mark - Basic
- (UIScrollView *)initWithFrame:(CGRect)frame isPaging:(BOOL)isPaging isBounces:(BOOL)isBounces {
    if (self = [self initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.directionalLockEnabled = YES;
        self.backgroundColor = kZCClear;
        self.pagingEnabled = isPaging;
        self.bounces = isBounces;
        self.isInterceptTouchEvent = NO;
        if (frame.size.height > 0) { self.contentSize = CGSizeMake(frame.size.width, frame.size.height + (isBounces ? kZSPixel : 0)); }
    } return self;
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
