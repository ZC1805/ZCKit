//
//  UIColor+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/10.
//  Copyright © 2018年 Squat in house. All rights reserved.
//

#import "UIColor+ZC.h"
#import "ZCMacro.h"

@implementation UIColor (ZC)

#pragma mark - ClassFunc
+ (instancetype)randColor {
    float r = arc4random_uniform(256);
    float g = arc4random_uniform(256);
    float b = arc4random_uniform(256);
    if (ZCiOS10) {
        return [UIColor colorWithDisplayP3Red:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    } else {
        return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    }
}

+ (UIColor *)colorFormRad:(int)intR green:(int)intG blue:(int)intB alpha:(float)alpha {
    if (ZCiOS10) {
        return [UIColor colorWithDisplayP3Red:intR/255.0 green:intG/255.0 blue:intB/255.0 alpha:alpha];
    } else {
        return [UIColor colorWithRed:intR/255.0 green:intG/255.0 blue:intB/255.0 alpha:alpha];
    }
}

+ (UIColor *)colorFormHex:(NSInteger)hexValue alpha:(float)alpha {
    if (ZCiOS10) {
        return [UIColor colorWithDisplayP3Red:((float)((hexValue & 0xFF0000) >> 16))/255.0
                                        green:((float)((hexValue & 0xFF00) >> 8))/255.0
                                         blue:((float)((hexValue & 0xFF) >> 0))/255.0
                                        alpha:alpha];
    } else {
        return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                               green:((float)((hexValue & 0xFF00) >> 8))/255.0
                                blue:((float)((hexValue & 0xFF) >> 0))/255.0
                               alpha:alpha];
    }
}

+ (UIColor *)colorFromHexString:(NSString *)hexColorStr {
    if (hexColorStr && hexColorStr.length == 8) {
        NSString *rStr = [hexColorStr substringWithRange:NSMakeRange(2, 2)];
        NSString *gStr = [hexColorStr substringWithRange:NSMakeRange(4, 2)];
        NSString *bStr = [hexColorStr substringWithRange:NSMakeRange(6, 2)];
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rStr] scanHexInt:&r];
        [[NSScanner scannerWithString:gStr] scanHexInt:&g];
        [[NSScanner scannerWithString:bStr] scanHexInt:&b];
        if (ZCiOS10) {
            return [UIColor colorWithDisplayP3Red:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        } else {
            return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        }
    } else {
        return [UIColor blackColor];
    }
}

#pragma mark - InstanceFunc
- (UIColor *)brightColor {
    if ([self isEqual:[UIColor whiteColor]]) return [UIColor colorWithWhite:0.99 alpha:1.0];
    if ([self isEqual:[UIColor blackColor]]) return [UIColor colorWithWhite:0.01 alpha:1.0];
    float hue, sat, bri, alpha, white;
    if ([self getHue:&hue saturation:&sat brightness:&bri alpha:&alpha]) {
        return [UIColor colorWithHue:hue saturation:sat brightness:MIN(bri * 1.3, 1.0) alpha:alpha];
    } else if ([self getWhite:&white alpha:&alpha]) {
        return [UIColor colorWithWhite:MIN(white * 1.3, 1.0) alpha:alpha];
    }
    return self;
}

- (UIColor *)darkColor {
    if ([self isEqual:[UIColor whiteColor]]) return [UIColor colorWithWhite:0.99 alpha:1.0];
    if ([self isEqual:[UIColor blackColor]]) return [UIColor colorWithWhite:0.01 alpha:1.0];
    float hue, sat, bri, alpha, white;
    if ([self getHue:&hue saturation:&sat brightness:&bri alpha:&alpha]) {
        return [UIColor colorWithHue:hue saturation:sat brightness:bri * 0.75 alpha:alpha];
    } else if ([self getWhite:&white alpha:&alpha]) {
        return [UIColor colorWithWhite:MAX(white * 0.75, 0.0) alpha:alpha];
    }
    return self;
}

- (BOOL)isClear {
    return [self isEqual:[UIColor clearColor]];
}

- (float)R {
    const float* components = CGColorGetComponents(self.CGColor);
    return components[0];
}

- (float)G {
    const float* components = CGColorGetComponents(self.CGColor);
    return components[1];
}

- (float)B {
    const float* components = CGColorGetComponents(self.CGColor);
    return components[2];
}

- (float)A {
    return CGColorGetAlpha(self.CGColor);
}

@end









