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

+ (instancetype)button:(CGRect)frame title:(NSString *)title image:(NSString *)image target:(id)target action:(SEL)action {
    UIButton *btn = [self buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = ZCClear;
    btn.frame = frame;
    if (title.length) [btn setTitle:title forState:UIControlStateNormal];
    if (title.length) btn.titleLabel.font = ZCFS(15);
    UIImage *im = image ? ZCIN(image) : nil;
    if (im) [btn setImage:im forState:UIControlStateNormal];
    if (target && action && [target respondsToSelector:action]) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

@end

