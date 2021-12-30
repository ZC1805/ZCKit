//
//  UITableViewCell+ZC.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UITableViewCell+ZC.h"

@implementation UITableViewCell (ZC)

- (UIGestureRecognizer *)longPressEventGesture {
    UIGestureRecognizer *ges = nil;
    if (self.contentView && self.contentView.gestureRecognizers) {
        for (UIGestureRecognizer *gesture in self.contentView.gestureRecognizers) {
            if ([gesture isKindOfClass:UILongPressGestureRecognizer.class]) {
                ges = gesture; break;
            }
        }
    }
    return ges;
}

- (UITableView *)currentTableView {
    UIView *view = self.superview;
    for (int i = 0; (view && i < 5); i ++) { //最多循环5次，没拿到返回nil
        if ([view isKindOfClass:UITableView.class]) {
            return (UITableView *)view;
        } else {
            view = view.superview;
        }
    }
    return nil;
}

@end
