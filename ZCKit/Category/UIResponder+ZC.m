//
//  UIResponder+ZC.m
//  ZCKit
//
//  Created by admin on 2018/10/10.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIResponder+ZC.h"

static __weak id currentFirstResponder;
static __weak id currentSecodResponder;

@implementation UIResponder (ZC)

+ (instancetype)currentFirstResponder {
    currentFirstResponder = nil;
    currentSecodResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

+ (instancetype)currentSecondResponder {
    currentFirstResponder = nil;
    currentSecodResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentSecodResponder;
}

- (void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
    [self.nextResponder findSecondResponder:sender];
}

- (void)findSecondResponder:(id)sender {
    currentSecodResponder = self;
}

////在controller中实现自动记录和成为第一响应者
//static char ZCFirstResponderViewAddress;
//- (void)swizzle_didAppear:(BOOL)animated {
//    [self swiz_didAppear:animated];
//    UIView *view = objc_getAssociatedObject(self, &ZCFirstResponderViewAddress);
//    [view becomeFirstResponder];
//}
//
//- (void)swizzle_willDisappear:(BOOL)animated {
//    [self swiz_willDisappear:animated];
//    UIView *view = (UIView *)[UIResponder currentFirstResponder];
//    if ([view isKindOfClass:[UIView class]] && view.currentViewController == self) {
//        objc_setAssociatedObject(self, &ZCFirstResponderViewAddress, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        [view resignFirstResponder];
//    } else {
//        objc_setAssociatedObject(self, &ZCFirstResponderViewAddress, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//}

@end

