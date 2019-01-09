//
//  UINavigationBar+ZCSwizzle.m
//  ZCKit
//
//  Created by admin on 2019/1/9.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import "UINavigationBar+ZCSwizzle.h"
#import "ZCSwizzleHeader.h"
#import "UIView+ZC.h"

@implementation UINavigationBar (ZCSwizzle)

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        zc_swizzle_exchange_selector([UINavigationBar class], @selector(layoutSubviews), @selector(swizzle_layoutSubviews));
//    });
//}
//
//- (void)swizzle_layoutSubviews {
//    [self swizzle_layoutSubviews];
//    UINavigationItem *navigationItem = [self topItem];
//    if (navigationItem.backBarButtonItem.title.length) {
//        UIView *customView = [[navigationItem leftBarButtonItem] customView];
//        if (customView) customView.left = 28.0;
//    } else {
//        UIView *customView = [[navigationItem leftBarButtonItem] customView];
//        if (customView) customView.left = 20;
//    }
//}

@end
