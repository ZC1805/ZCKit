//
//  UITableViewCell+ZCSwizzle.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UITableViewCell+ZCSwizzle.h"
#import "UITableViewCell+ZC.h"
#import "ZCSwizzleHeader.h"
#import "UITableView+ZC.h"

@implementation UITableViewCell (ZCSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL sel1 = @selector(hitTest:withEvent:);
        SEL sel1x = @selector(swizzle_hitTest:withEvent:);
        zc_swizzle_exchange_selector([UITableViewCell class], sel1, sel1x);
    });
}

- (UIView *)swizzle_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hit = [self swizzle_hitTest:point withEvent:event];
    if (hit) {
        UITableView *table = [self currentTableView];
        if (table) {
            [table setValue:[table indexPathForCell:self] forKey:@"recentlyTouchIndexPath"];
        }
    }
    return hit;
}

@end
