//
//  ZCButton.m
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCButton.h"

@interface ZCButton ()

@property (nonatomic, assign) BOOL isIgnoreTouch; 

@end

@implementation ZCButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.responseAreaExtend, UIEdgeInsetsZero)) {
        return [super pointInside:point withEvent:event];
    }
    if (self.hidden || self.alpha < 0.01 || !self.enabled || !self.userInteractionEnabled) {
        return NO;
    }
    CGRect hit = CGRectMake(self.bounds.origin.x - self.responseAreaExtend.left,
                            self.bounds.origin.y - self.responseAreaExtend.top,
                            self.bounds.size.width + self.responseAreaExtend.left + self.responseAreaExtend.right,
                            self.bounds.size.height + self.responseAreaExtend.top + self.responseAreaExtend.bottom);
    return CGRectContainsPoint(hit, point);
}

- (void)resetNotIgnoreTouch {
    _isIgnoreTouch = NO;
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (_isIgnoreTouch) return;
    if (_responseTouchInterval <= 0) {
        if (_delayResponseTime > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_delayResponseTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [super sendAction:action to:target forEvent:event];
            });
        } else {
            [super sendAction:action to:target forEvent:event];
        }
    } else {
        [self performSelector:@selector(resetNotIgnoreTouch) withObject:nil afterDelay:_responseTouchInterval];
        _isIgnoreTouch = YES;
        if (_delayResponseTime > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_delayResponseTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [super sendAction:action to:target forEvent:event];
            });
        } else {
            [super sendAction:action to:target forEvent:event];
        }
    }
}

@end










