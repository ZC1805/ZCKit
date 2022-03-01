//
//  UITapGestureRecognizer+ZC.m
//  ZCKit
//
//  Created by admin on 2020/3/23.
//  Copyright © 2020 Ttranssnet. All rights reserved.
//

#import "UITapGestureRecognizer+ZC.h"
#import <objc/runtime.h>

@implementation UITapGestureRecognizer (ZC)

- (void)setTouchAction:(void (^)(UITapGestureRecognizer * _Nonnull))touchAction {
    objc_setAssociatedObject(self, @selector(touchAction), touchAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self removeTarget:self action:@selector(onTouchActionZC:)];
    if (touchAction) { [self addTarget:self action:@selector(onTouchActionZC:)]; }
}

- (void (^)(UITapGestureRecognizer * _Nonnull))touchAction {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - Private
- (void)onTouchActionZC:(id)sender {
    if (self.touchAction) self.touchAction(self);
}

@end
