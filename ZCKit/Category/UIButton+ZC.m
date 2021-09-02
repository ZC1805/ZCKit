//
//  UIButton+ZC.m
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIButton+ZC.h"
#import "ZCMacro.h"

@implementation UIButton (ZC)

+ (instancetype)customTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color image:(NSString *)image target:(id)target action:(SEL)action {
    UIButton *cusBtn = [self buttonWithType:UIButtonTypeCustom];
    cusBtn.backgroundColor = kZCClear;
    cusBtn.adjustsImageWhenHighlighted = NO;
    if (font) cusBtn.titleLabel.font = font;
    if (title) {
        [cusBtn setTitle:title forState:UIControlStateNormal];
        cusBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        cusBtn.titleLabel.minimumScaleFactor = 0.6;
    }
    if (color) [cusBtn setTitleColor:color forState:UIControlStateNormal];
    UIImage *im = image ? kZIN(image) : nil;
    if (im) [cusBtn setImage:im forState:UIControlStateNormal];
    if (target && action && [target respondsToSelector:action]) {
        [cusBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return cusBtn;
}

@end
