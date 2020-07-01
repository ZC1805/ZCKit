//
//  UIGestureRecognizer+ZCSwizzle.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIGestureRecognizer+ZCSwizzle.h"
#import "ZCSwizzleHeader.h"

NSNotificationName const ZCGestureGenerateEventNotification = @"ZCGestureGenerateEventNotification";

@implementation UIGestureRecognizer (ZCSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        SEL sel1 = @selector(addTarget:action:);
//        SEL sel1x = @selector(swizzle_addTarget:action:);
//        SEL sel2 = @selector(initWithTarget:action:);
//        SEL sel2x = @selector(swizzle_initWithTarget:action:);
//        SEL sel3 = @selector(removeTarget:action:);
//        SEL sel3x = @selector(swizzle_removeTarget:action:);
//        zc_swizzle_exchange_selector([UIGestureRecognizer class], sel1, sel1x);
//        zc_swizzle_exchange_selector([UIGestureRecognizer class], sel2, sel2x);
//        zc_swizzle_exchange_selector([UIGestureRecognizer class], sel3, sel3x);
    });
}

- (void)swizzle_addTarget:(id)target action:(SEL)action {
    [self swizzle_addTarget:target action:action];
    if (target && action && [target respondsToSelector:action]) {
        self.currentTargetCount++;
        SEL collectSel = @selector(receiveCollectGestureEvent:);
        if ([self confirmCollectGesture] && [self respondsToSelector:collectSel] && self.isCollectReceive != 1) {
            [self swizzle_addTarget:self action:collectSel];
            self.isCollectReceive = 1;
        }
    }
}

- (instancetype)swizzle_initWithTarget:(id)target action:(SEL)action {
    id instance = [self swizzle_initWithTarget:target action:action];
    if (target && action && [target respondsToSelector:action]) {
        self.currentTargetCount++;
        SEL collectSel = @selector(receiveCollectGestureEvent:);
        if ([self confirmCollectGesture] && [self respondsToSelector:collectSel] && self.isCollectReceive != 1) {
            [self swizzle_addTarget:self action:collectSel];
            self.isCollectReceive = 1;
        }
    }
    return instance;
}

- (void)swizzle_removeTarget:(id)target action:(SEL)action {
    [self swizzle_removeTarget:target action:action];
    if (target == nil || action == nil) {
        self.currentTargetCount = 0;
    } else {
        self.currentTargetCount--;
    }
    if (self.currentTargetCount == 0) {
        SEL collectSel = @selector(receiveCollectGestureEvent:);
        if ([self confirmCollectGesture] && [self respondsToSelector:collectSel] && self.isCollectReceive == 1) {
            [self swizzle_removeTarget:self action:collectSel];
        }
    }
}

- (BOOL)confirmCollectGesture {
    if ([self isKindOfClass:UIPanGestureRecognizer.class]) {
        return YES;
    } else if ([self isMemberOfClass:UITapGestureRecognizer.class]) {
        return YES;
    } else if ([self isMemberOfClass:UILongPressGestureRecognizer.class]) {
        return YES;
    } else if ([self isMemberOfClass:UISwipeGestureRecognizer.class]) {
        return YES;
    } else if ([self isMemberOfClass:UIPinchGestureRecognizer.class]) {
        return YES;
    } else if ([self isMemberOfClass:UIRotationGestureRecognizer.class]) {
        return YES;
    }
    return NO;
}

- (void)receiveCollectGestureEvent:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ZCGestureGenerateEventNotification object:gesture];
    }
}

#pragma mark - set & get
- (void)setCurrentTargetCount:(NSInteger)currentTargetCount {
    objc_setAssociatedObject(self, @selector(currentTargetCount), @(currentTargetCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)currentTargetCount {
    return [(NSNumber *)objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setIsCollectReceive:(NSInteger)isCollectReceive {
    objc_setAssociatedObject(self, @selector(isCollectReceive), @(isCollectReceive), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)isCollectReceive {
    return [(NSNumber *)objc_getAssociatedObject(self, _cmd) integerValue];
}

@end
