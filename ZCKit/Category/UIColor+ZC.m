//
//  UIColor+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/10.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIColor+ZC.h"
#import "UIImage+ZC.h"
#import <objc/runtime.h>

@implementation UIColor (ZC)

#pragma mark - Get & Set
- (long)cRGBHexValue { //如0xFF0000FF
    NSNumber *hexValue = objc_getAssociatedObject(self, _cmd);
    long hex = -1;
    if (hexValue != nil && [hexValue isKindOfClass:NSNumber.class]) hex = hexValue.longValue;
    if (hex > 0xFFFFFFFF || hex < 0x00000000) hex = -1;
    return hex;
}

- (void)setCRGBHexValue:(long)cRGBHexValue {
    NSNumber *hexValue = [NSNumber numberWithLong:cRGBHexValue];
    objc_setAssociatedObject(self, @selector(cRGBHexValue), hexValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Class
+ (UIColor *)colorForRandomColor {
    uint32_t r = arc4random_uniform(256);
    uint32_t g = arc4random_uniform(256);
    uint32_t b = arc4random_uniform(256);
    UIColor *aimColor = nil;
    if (@available(iOS 10.0, *)) {
        aimColor = [UIColor colorWithDisplayP3Red:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    } else {
        aimColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    }
    aimColor.cRGBHexValue = (r << 24) + (g << 16) + (b << 8) + 255;
    return aimColor;
}

+ (UIColor *)colorFormRad:(int)intR green:(int)intG blue:(int)intB alpha:(float)alpha {
    UIColor *aimColor = nil;
    if (@available(iOS 10.0, *)) {
        aimColor = [UIColor colorWithDisplayP3Red:intR/255.0 green:intG/255.0 blue:intB/255.0 alpha:alpha];
    } else {
        aimColor = [UIColor colorWithRed:intR/255.0 green:intG/255.0 blue:intB/255.0 alpha:alpha];
    }
    int intA = MAX(MIN((int)floorf(alpha * 255), 255), 0);
    aimColor.cRGBHexValue = (intR << 24) + (intG << 16) + (intB << 8) + (intA << 0);
    return aimColor;
}

+ (UIColor *)colorFormHex:(long)hexValue alpha:(float)alpha {
    UIColor *aimColor = nil;
    if (hexValue < 0) hexValue = 0;
    if (@available(iOS 10.0, *)) {
        aimColor = [UIColor colorWithDisplayP3Red:((float)((hexValue & 0xFF0000) >> 16))/255.0
                                            green:((float)((hexValue & 0xFF00) >> 8))/255.0
                                             blue:((float)((hexValue & 0xFF) >> 0))/255.0
                                            alpha:alpha];
    } else {
        aimColor = [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                                   green:((float)((hexValue & 0xFF00) >> 8))/255.0
                                    blue:((float)((hexValue & 0xFF) >> 0))/255.0
                                   alpha:alpha];
    }
    int intA = MAX(MIN((int)floorf(alpha * 255), 255), 0);
    aimColor.cRGBHexValue = (((hexValue & 0xFF0000) >> 16) << 24) + (((hexValue & 0xFF00) >> 8) << 16) + (((hexValue & 0xFF) >> 0) << 8) + (intA << 0);
    return aimColor;
}

+ (UIColor *)colorFromHexString:(NSString *)hexColorStr alpha:(float)alpha {
    if (!hexColorStr) return [UIColor colorFormHex:0x000000 alpha:alpha];
    if (hexColorStr.length == 6) hexColorStr = [@"0x" stringByAppendingString:hexColorStr];
    if (hexColorStr.length == 7) hexColorStr = [hexColorStr stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    if (hexColorStr && hexColorStr.length == 8) {
        NSString *rStr = [hexColorStr substringWithRange:NSMakeRange(2, 2)];
        NSString *gStr = [hexColorStr substringWithRange:NSMakeRange(4, 2)];
        NSString *bStr = [hexColorStr substringWithRange:NSMakeRange(6, 2)];
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rStr] scanHexInt:&r];
        [[NSScanner scannerWithString:gStr] scanHexInt:&g];
        [[NSScanner scannerWithString:bStr] scanHexInt:&b];
        UIColor *aimColor = nil;
        if (@available(iOS 10.0, *)) {
            aimColor = [UIColor colorWithDisplayP3Red:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
        } else {
            aimColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
        }
        int intA = MAX(MIN((int)floorf(alpha * 255), 255), 0);
        aimColor.cRGBHexValue = (r << 24) + (g << 16) + (b << 8) + (intA << 0);
        return aimColor;
    } else {
        return [UIColor colorFormHex:0x000000 alpha:alpha];
    }
}

+ (UIColor *)colorFromGradientColors:(NSArray <UIColor *>*)colors isHorizontal:(BOOL)isHorizontal {
    UIImage *image = [UIImage imageWithGradientColors:colors size:CGSizeMake(100.0, 100.0) isHorizontal:isHorizontal];
    UIColor *color = [UIColor colorWithPatternImage:image];
    color.cRGBHexValue = 0x00000000;
    return color;
}

#pragma mark - Instance
- (UIColor *)colorFromAlpha:(float)alpha {
    uint32_t cHex = (uint32_t)(self.cRGBHexValue);
    if (cHex != -1) {
        uint8_t oldHexA = cHex & 0xFF;
        if (alpha > 1.0) alpha = 1.0;
        if (alpha < 0) alpha = 0;
        if (alpha != 0 && oldHexA != 0) {
            return [UIColor colorFormHex:(cHex >> 8) alpha:(oldHexA / 255.0 * alpha)];
        } else {
            return [UIColor colorFormHex:(cHex >> 8) alpha:0];
        }
    } else {
        return [self colorWithAlphaComponent:alpha];
    }
}

- (uint32_t)RGBValue {
    uint32_t cHex = (uint32_t)(self.cRGBHexValue);
    if (cHex != -1) {
        return (((cHex & 0xFF000000) >> 24) << 16) + (((cHex & 0xFF0000) >> 16) << 8) + (((cHex & 0xFF00) >> 8) << 0);
    } else {
        CGFloat r = 0, g = 0, b = 0, a = 0;
        [self getRed:&r green:&g blue:&b alpha:&a];
        uint8_t red = r * 255;
        uint8_t green = g * 255;
        uint8_t blue = b * 255;
        return (red << 16) + (green << 8) + blue;
    }
}

- (uint32_t)RGBAValue {
    uint32_t cHex = (uint32_t)(self.cRGBHexValue);
    if (cHex != -1) {
        return cHex;
    } else {
        CGFloat r = 0, g = 0, b = 0, a = 0;
        [self getRed:&r green:&g blue:&b alpha:&a];
        uint8_t red = r * 255;
        uint8_t green = g * 255;
        uint8_t blue = b * 255;
        uint8_t alpha = a * 255;
        return (red << 24) + (green << 16) + (blue << 8) + alpha;
    }
}

- (BOOL)isClear {
    if ([self isEqual:UIColor.clearColor]) return YES;
    if (CGColorGetAlpha(self.CGColor) < 0.01) return YES;
    return NO;
}

- (CGColorSpaceModel)colorSpaceType {
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

@end
