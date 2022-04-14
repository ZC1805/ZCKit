//
//  UIView+ZXXXXX.m
//  ZCTest
//
//  Created by zjy on 2022/4/14.
//

#import "UIView+ZXXXXX.h"
#import "UITableViewCell+ZC.h"

@implementation UIView (ZXXXXX)

- (UITableViewCell *)currentCell {
    for (UIView *view = self; view; view = view.superview) {
        if ([view isKindOfClass:UITableViewCell.class]) {
            return (UITableViewCell *)view;
        }
    }
    return nil;
}

- (NSIndexPath *)currentCellIndexPath {
    UITableViewCell *cell = [self currentCell];
    if (cell) {
        UITableView *table = [cell currentTableView];
        if (table) {
            return [table indexPathForCell:cell];
        }
    }
    return nil;
}


//SEL sel1 = @selector(pointInside:withEvent:);
//SEL sel1x = @selector(swizzle1_vi_pointInside:withEvent:);
//SEL sel3 = @selector(hitTest:withEvent:);
//SEL sel3x = @selector(swizzle1_vi_hitTest:withEvent:);
//zc_swizzle_exchange_instance_selector(UIView.class, sel1, sel1x);
//zc_swizzle_exchange_instance_selector(UIView.class, sel3, sel3x);

//- (BOOL)swizzle1_vi_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    id <ZCViewControllerViewProtocol> currentVc = self.currentViewController;
//    if ([currentVc respondsToSelector:@selector(isHandlePointInside:point:event:)] && [currentVc isHandlePointInside:self point:point event:event]) {
//        if ([currentVc respondsToSelector:@selector(pointInside:view:event:)]) {
//            return [currentVc pointInside:point view:self event:event];
//        }
//    }
//    return [self swizzle1_vi_pointInside:point withEvent:event];
//}
//
//- (UIView *)swizzle1_vi_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    id <ZCViewControllerViewProtocol> currentVc = self.currentViewController;
//    if ([currentVc respondsToSelector:@selector(isHandleHitView:point:event:)] && [currentVc isHandleHitView:self point:point event:event]) {
//        if ([currentVc respondsToSelector:@selector(hitTest:view:event:)]) {
//            return [currentVc hitTest:point view:self event:event];
//        }
//    }
//    return [self swizzle1_vi_hitTest:point withEvent:event];
//}


@end
