//
//  UIButton+ZC.m
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIButton+ZC.h"
#import <objc/runtime.h>

@implementation UIButton (ZC)

- (NSString *)stringTag {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setStringTag:(NSString *)stringTag {
    objc_setAssociatedObject(self, @selector(stringTag), stringTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (instancetype)button:(CGRect)frame title:(NSString *)title image:(NSString *)image target:(id)target action:(SEL)action {
    UIButton *btn = [self buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = frame;
    if (title.length) [btn setTitle:title forState:UIControlStateNormal];
    UIImage *im = image ? [UIImage imageNamed:image] : nil;
    if (im) [btn setImage:im forState:UIControlStateNormal];
    if (target && action) [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end










