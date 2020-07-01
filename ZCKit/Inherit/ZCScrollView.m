//
//  ZCScrollView.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCScrollView.h"

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
    }
    return YES;
}

@end
