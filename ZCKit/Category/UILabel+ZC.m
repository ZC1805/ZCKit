//
//  UILabel+ZC.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UILabel+ZC.h"

@implementation UILabel (ZC)

- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font color:(UIColor *)color {
    if (self = [self initWithFrame:frame]) {
        self.textColor = color;
        self.font = font;
    }
    return self;
}

@end
