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
- (NSInteger)cRGBHexValue { //如0xFF0000FF
    NSNumber *hexValue = objc_getAssociatedObject(self, _cmd);
    return (hexValue ? hexValue.integerValue : -1);
}

- (void)setCRGBHexValue:(NSInteger)cRGBHexValue {
    NSNumber *hexValue = [NSNumber numberWithInteger:cRGBHexValue];
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
    int intA = MIN(MAX((int)floorf(alpha * 255), 255), 0);
    aimColor.cRGBHexValue = (intR << 24) + (intG << 16) + (intB << 8) + (intA << 0);
    return aimColor;
}

+ (UIColor *)colorFormHex:(NSInteger)hexValue alpha:(float)alpha {
    UIColor *aimColor = nil;
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
    int intA = MIN(MAX((int)floorf(alpha * 255), 255), 0);
    aimColor.cRGBHexValue = (((hexValue & 0xFF0000) >> 16) << 24) + (((hexValue & 0xFF00) >> 8) << 16) + (((hexValue & 0xFF) >> 0) << 8) + (intA << 0);
    return aimColor;
}

+ (UIColor *)colorFromHexString:(NSString *)hexColorStr {
    if (!hexColorStr) return [UIColor colorFormHex:0x000000 alpha:1.0];
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
            aimColor = [UIColor colorWithDisplayP3Red:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        } else {
            aimColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        }
        aimColor.cRGBHexValue = (r << 24) + (g << 16) + (b << 8) + 255;
        return aimColor;
    } else {
        return [UIColor colorFormHex:0x000000 alpha:1.0];
    }
}

+ (UIColor *)colorFromGradientColors:(NSArray <UIColor *>*)colors isHorizontal:(BOOL)isHorizontal {
    UIImage *image = [UIImage imageWithGradientColors:colors size:CGSizeMake(100.0, 100.0) isHorizontal:isHorizontal];
    UIColor *color = [UIColor colorWithPatternImage:image];
    if (colors.firstObject) {
        color.cRGBHexValue = colors.firstObject.cRGBHexValue;
    } else {
        color.cRGBHexValue = 0xFFFFFF00;
    }
    return color;
}

#pragma mark - Instance
- (uint32_t)RGBValue {
    uint32_t cHex = (uint32_t)(self.cRGBHexValue);
    if (cHex != -1) {
        return (((cHex & 0xFF000000) >> 24) << 16) + (((cHex & 0xFF0000) >> 16) << 8) + (((cHex & 0xFF00) >> 8) << 0);
    } else {
        CGFloat r = 0, g = 0, b = 0, a = 0;
        [self getRed:&r green:&g blue:&b alpha:&a];
        int8_t red = r * 255;
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
        int8_t red = r * 255;
        uint8_t green = g * 255;
        uint8_t blue = b * 255;
        uint8_t alpha = a * 255;
        return (red << 24) + (green << 16) + (blue << 8) + alpha;
    }
}

- (BOOL)isClear {
    if ([self isEqual:[UIColor clearColor]]) return YES;
    if (CGColorGetAlpha(self.CGColor) < 0.01) return YES;
    return NO;
}

- (CGColorSpaceModel)colorSpaceType {
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

//- (NSString *)hexString {
//    return [self hexStringWithAlpha:NO];
//}
//
//- (NSString *)hexStringWithAlpha {
//    return [self hexStringWithAlpha:YES];
//}
//
//- (NSString *)hexStringWithAlpha:(BOOL)withAlpha {
//    CGColorRef color = self.CGColor;
//    size_t count = CGColorGetNumberOfComponents(color);
//    const CGFloat *components = CGColorGetComponents(color);
//    static NSString *kColorStringFormat = @"%02x%02x%02x";
//    NSString *hex = nil;
//    if (count == 2) {
//        NSUInteger white = (NSUInteger)(components[0] * 255.0);
//        hex = [NSString stringWithFormat:kColorStringFormat, white, white, white];
//    } else if (count == 4) {
//        hex = [NSString stringWithFormat:kColorStringFormat,
//               (NSUInteger)(components[0] * 255.0),
//               (NSUInteger)(components[1] * 255.0),
//               (NSUInteger)(components[2] * 255.0)];
//    }
//    if (hex && withAlpha) {
//        hex = [hex stringByAppendingFormat:@"%02lx", (unsigned long)(CGColorGetAlpha(self.CGColor) * 255.0 + 0.5)];
//    }
//    return hex;
//}
//
//- (uint32_t)RGBValue {
//    NSString *hexStr = [self hexString];
//    if (!hexStr && hexStr.length != 6)  return 0;
//    const char *hexChar = [hexStr cStringUsingEncoding:NSUTF8StringEncoding];
//    int hexNum; sscanf(hexChar, "%x", &hexNum);
//    return (uint32_t)hexNum;
//}

@end
