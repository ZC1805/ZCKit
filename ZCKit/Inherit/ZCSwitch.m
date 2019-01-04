//
//  ZCSwitch.m
//  ZCKit
//
//  Created by admin on 2019/1/4.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import "ZCSwitch.h"

@implementation ZCSwitch

- (void)setTouchAction:(void (^)(ZCSwitch * _Nonnull))touchAction {
    _touchAction = touchAction;
    [self removeTarget:self action:@selector(onTouchAction:) forControlEvents:UIControlEventValueChanged];
    [self addTarget:self action:@selector(onTouchAction:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - misc
- (void)onTouchAction:(id)sender {
    if (_touchAction) _touchAction(self);
}

@end
