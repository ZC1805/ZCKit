//
//  UITableView+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UITableView+ZC.h"

@implementation UITableView (ZC)

- (void)updateWithBlock:(void(^)(UITableView *tableView))block {
    [self beginUpdates];
    block(self);
    [self endUpdates];
}

- (UIGestureRecognizer *)panEventGesture {
    UIGestureRecognizer *ges = nil;
    if (self.gestureRecognizers.count) {
        for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
            if ([gesture isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")]) {
                ges = gesture; break;
            }
        }
    }
    return ges;
}

- (void)clearSelectedRowsAnimated:(BOOL)animated {
    NSArray *indexs = [self indexPathsForSelectedRows];
    [indexs enumerateObjectsUsingBlock:^(NSIndexPath *path, NSUInteger idx, BOOL *stop) {
        [self deselectRowAtIndexPath:path animated:animated];
    }];
}

@end
