//
//  UITableView+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UITableView+ZC.h"
#import <objc/runtime.h>
#import "ZCMacro.h"

@implementation UITableView (ZC)

- (void)clearSelectedRowsAnimated:(BOOL)animated {
    NSArray *indexs = [self indexPathsForSelectedRows];
    [indexs enumerateObjectsUsingBlock:^(NSIndexPath *path, NSUInteger idx, BOOL *stop) {
        [self deselectRowAtIndexPath:path animated:animated];
    }];
}

- (void)updateWithBlock:(void(^)(UITableView *tableView))block {
    [self beginUpdates];
    block(self);
    [self endUpdates];
}

- (void)setRecentlyTouchIndexPath:(NSIndexPath * _Nullable)recentlyTouchIndexPath {
    objc_setAssociatedObject(self, @selector(recentlyTouchIndexPath), recentlyTouchIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)recentlyTouchIndexPath {
    return objc_getAssociatedObject(self, _cmd);
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

@end
