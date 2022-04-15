//
//  UIScrollView+ZXXXX.m
//  ZCTest
//
//  Created by zjy on 2022/4/15.
//

#import "UIScrollView+ZXXXX.h"
#import "UIScrollView+ZC.h"
#import <objc/runtime.h>
#import "ZCMacro.h"

@implementation UIScrollView (ZXXXX)

#pragma mark - Offset
- (UIView *)topExpandOffsetView { //frame&contentSize变化不联动
    UIView *topv = objc_getAssociatedObject(self, _cmd);
    if (!topv) {
        topv = [[UIView alloc] initWithFrame:CGRectZero];
        topv.backgroundColor = self.backgroundColor;
        objc_setAssociatedObject(self, _cmd, topv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:topv];
    }
    topv.frame = CGRectMake(-200.0, -self.frame.size.height - 200.0, MAX(self.frame.size.height, self.zc_sizeWidth) + 400.0, self.frame.size.height + 200.0);
    [self sendSubviewToBack:topv];
    return topv;
}

- (UIView *)bottomExpandOffsetView { //frame&contentSize变化不联动
    UIView *bottomv = objc_getAssociatedObject(self, _cmd);
    if (!bottomv) {
        bottomv = [[UIView alloc] initWithFrame:CGRectZero];
        bottomv.backgroundColor = self.backgroundColor;
        objc_setAssociatedObject(self, _cmd, bottomv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:bottomv];
    }
    CGFloat top = self.zc_sizeHeight - self.contentInset.bottom;
    bottomv.frame = CGRectMake(-200.0, top, MAX(self.frame.size.height, self.zc_sizeWidth) + 400.0, self.frame.size.height + 500.0);
    [self sendSubviewToBack:bottomv];
    return bottomv;
}

- (void)setTopExpandColor:(UIColor *)topExpandColor {
    self.topExpandOffsetView.backgroundColor = topExpandColor;
}

- (UIColor *)topExpandColor {
    return self.topExpandOffsetView.backgroundColor;
}

- (void)setBottomExpandColor:(UIColor *)bottomExpandColor {
    self.bottomExpandOffsetView.backgroundColor = bottomExpandColor;
}

- (UIColor *)bottomExpandColor {
    return self.bottomExpandOffsetView.backgroundColor;
}


@end
