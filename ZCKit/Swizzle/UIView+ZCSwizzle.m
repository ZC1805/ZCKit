//
//  UIView+ZCSwizzle.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIView+ZCSwizzle.h"
#import "ZCSwizzleHeader.h"

@implementation UIView (ZCSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL sel2 = @selector(layoutSubviews);
        SEL sel2x = @selector(swizzle1_vi_layoutSubviews);
        zc_swizzle_exchange_instance_selector(UIView.class, sel2, sel2x);
    });
}

- (void)swizzle1_vi_layoutSubviews {
    UIView *lineTopView = [self valueForKey:@"holderLineTopView"];
    if (lineTopView) {
        UIEdgeInsets insetsTop = [lineTopView convertHolderLineViewInsets];
        lineTopView.frame = CGRectMake(insetsTop.left,
                                       insetsTop.top,
                                       self.frame.size.width - insetsTop.left - insetsTop.right,
                                       insetsTop.bottom);
    }
    UIView *lineLeftView = [self valueForKey:@"holderLineLeftView"];
    if (lineLeftView) {
        UIEdgeInsets insetsLeft = [lineLeftView convertHolderLineViewInsets];
        lineLeftView.frame = CGRectMake(insetsLeft.left,
                                        insetsLeft.top,
                                        insetsLeft.right,
                                        self.frame.size.height - insetsLeft.top - insetsLeft.bottom);
    }
    UIView *lineBottomView = [self valueForKey:@"holderLineBottomView"];
    if (lineBottomView) {
        UIEdgeInsets insetsBottom = [lineBottomView convertHolderLineViewInsets];
        lineBottomView.frame = CGRectMake(insetsBottom.left,
                                          self.frame.size.height - insetsBottom.bottom - insetsBottom.top,
                                          self.frame.size.width - insetsBottom.left - insetsBottom.right,
                                          insetsBottom.top);
    }
    UIView *lineRightView = [self valueForKey:@"holderLineRightView"];
    if (lineRightView) {
        UIEdgeInsets insetsRight = [lineRightView convertHolderLineViewInsets];
        lineRightView.frame = CGRectMake(self.frame.size.width - insetsRight.left - insetsRight.right,
                                         insetsRight.top,
                                         insetsRight.left,
                                         self.frame.size.height - insetsRight.top - insetsRight.bottom);
    }
    [self swizzle1_vi_layoutSubviews];
}

- (UIEdgeInsets)convertHolderLineViewInsets {
    NSValue *value = [self valueForKey:@"holderLineViewInsets"];
    if (value && [value isKindOfClass:NSValue.class]) {
        return [value UIEdgeInsetsValue];
    }
    return UIEdgeInsetsZero;
}

@end
