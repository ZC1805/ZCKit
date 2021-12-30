//
//  ZCSwitch.m
//  ZCKit
//
//  Created by admin on 2019/1/4.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import "ZCSwitch.h"
#import "ZCMacro.h"

@implementation ZCSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kZCClear;
    }
    return self;
}

- (void)setTouchAction:(void (^)(ZCSwitch * _Nonnull))touchAction {
    _touchAction = touchAction;
    if ([self.allTargets containsObject:self] && (self.allControlEvents & UIControlEventValueChanged)) {
        if ([[self actionsForTarget:self forControlEvent:UIControlEventValueChanged] containsObject:NSStringFromSelector(@selector(onTouchActionZC:))]) {
            [self removeTarget:self action:@selector(onTouchActionZC:) forControlEvents:UIControlEventValueChanged];
        }
    }
    if (touchAction) {
        [self addTarget:self action:@selector(onTouchActionZC:) forControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - Misc
- (void)onTouchActionZC:(id)sender {
    if (_touchAction) _touchAction(self);
}

@end
