//
//  UITableView+ZXXXXX.m
//  ZCTest
//
//  Created by zjy on 2022/4/14.
//

#import "UITableView+ZXXXXX.h"
#import <objc/runtime.h>

@implementation UITableView (ZXXXXX)

- (void)setRecentlyTouchIndexPath:(NSIndexPath * _Nullable)recentlyTouchIndexPath {
    objc_setAssociatedObject(self, @selector(recentlyTouchIndexPath), recentlyTouchIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)recentlyTouchIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}

@end
