//
//  UIColor+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/10.
//  Copyright © 2018年 Squat in house. All rights reserved.
//

#import "UIColor+ZC.h"

@implementation UIColor (ZC)

#pragma mark - class
+ (UIColor *)colorForRandomColor {
    float r = arc4random_uniform(256);
    float g = arc4random_uniform(256);
    float b = arc4random_uniform(256);
    if (@available(iOS 10.0, *)) {
        return [UIColor colorWithDisplayP3Red:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    } else {
        return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    }
}

+ (UIColor *)colorFormRad:(int)intR green:(int)intG blue:(int)intB alpha:(float)alpha {
    if (@available(iOS 10.0, *)) {
        return [UIColor colorWithDisplayP3Red:intR/255.0 green:intG/255.0 blue:intB/255.0 alpha:alpha];
    } else {
        return [UIColor colorWithRed:intR/255.0 green:intG/255.0 blue:intB/255.0 alpha:alpha];
    }
}

+ (UIColor *)colorFormHex:(NSInteger)hexValue alpha:(float)alpha {
    if (@available(iOS 10.0, *)) {
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
    if (hexColorStr.length == 6) hexColorStr = [@"0x" stringByAppendingString:hexColorStr];
    if (hexColorStr && hexColorStr.length == 8) {
        NSString *rStr = [hexColorStr substringWithRange:NSMakeRange(2, 2)];
        NSString *gStr = [hexColorStr substringWithRange:NSMakeRange(4, 2)];
        NSString *bStr = [hexColorStr substringWithRange:NSMakeRange(6, 2)];
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rStr] scanHexInt:&r];
        [[NSScanner scannerWithString:gStr] scanHexInt:&g];
        [[NSScanner scannerWithString:bStr] scanHexInt:&b];
        if (@available(iOS 10.0, *)) {
            return [UIColor colorWithDisplayP3Red:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        } else {
            return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        }
    } else {
        return [UIColor blackColor];
    }
}

#pragma mark - instance
- (UIColor *)brightColor {
    if ([self isEqual:[UIColor whiteColor]]) return [UIColor colorWithWhite:0.99 alpha:1.0];
    if ([self isEqual:[UIColor blackColor]]) return [UIColor colorWithWhite:0.01 alpha:1.0];
    CGFloat hue, sat, bri, alpha, white;
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
    CGFloat hue, sat, bri, alpha, white;
    if ([self getHue:&hue saturation:&sat brightness:&bri alpha:&alpha]) {
        return [UIColor colorWithHue:hue saturation:sat brightness:bri * 0.75 alpha:alpha];
    } else if ([self getWhite:&white alpha:&alpha]) {
        return [UIColor colorWithWhite:MAX(white * 0.75, 0.0) alpha:alpha];
    }
    return self;
}

- (uint32_t)RGBValue {
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    return (red << 16) + (green << 8) + blue;
}

- (uint32_t)RGBAValue {
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    uint8_t alpha = a * 255;
    return (red << 24) + (green << 16) + (blue << 8) + alpha;
}

- (BOOL)isClear {
    if ([self isEqual:[UIColor clearColor]]) return YES;
    if (self.A < 0.01) return YES;
    return NO;
}

- (CGFloat)R {
    CGFloat r = 0, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)G {
    CGFloat r, g = 0, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)B {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)A {
    return CGColorGetAlpha(self.CGColor);
}

- (CGColorSpaceModel)colorSpaceModel {
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (NSString *)hexString {
    return [self hexStringWithAlpha:NO];
}

- (NSString *)hexStringWithAlpha {
    return [self hexStringWithAlpha:YES];
}

- (NSString *)hexStringWithAlpha:(BOOL)withAlpha {
    CGColorRef color = self.CGColor;
    size_t count = CGColorGetNumberOfComponents(color);
    const CGFloat *components = CGColorGetComponents(color);
    static NSString *stringFormat = @"%02x%02x%02x";
    NSString *hex = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)(components[0] * 255.0f);
        hex = [NSString stringWithFormat:stringFormat, white, white, white];
    } else if (count == 4) {
        hex = [NSString stringWithFormat:stringFormat,
               (NSUInteger)(components[0] * 255.0f),
               (NSUInteger)(components[1] * 255.0f),
               (NSUInteger)(components[2] * 255.0f)];
    }
    if (hex && withAlpha) {
        hex = [hex stringByAppendingFormat:@"%02lx", (unsigned long)(self.A * 255.0 + 0.5)];
    }
    return hex;
}

@end

