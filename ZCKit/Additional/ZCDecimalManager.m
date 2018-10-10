//
//  ZCDecimalManager.m
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCDecimalManager.h"
#import "ZCKitManager.h"
#import "NSString+ZC.h"

@interface ZCDecimalManager () <NSDecimalNumberBehaviors>

@property (nonatomic, strong) NSMutableArray <NSNumberFormatter *>*numberFormatters;

@property (nonatomic, strong) NSMutableArray <NSDecimalNumberHandler *>*decimalRoundHandles;

@property (nonatomic, strong) NSMutableArray <NSDecimalNumberHandler *>*decimalUpHandles;

@property (nonatomic, strong) NSMutableArray <NSDecimalNumberHandler *>*decimalDownHandles;

@end

@implementation ZCDecimalManager

#pragma mark - ZCDecimalManagerInstance
- (NSMutableArray <NSNumberFormatter *>*)numberFormatters {
    if (!_numberFormatters) {
        _numberFormatters = [NSMutableArray array];
    }
    return _numberFormatters;
}

- (NSMutableArray <NSDecimalNumberHandler *>*)decimalRoundHandles {
    if (!_decimalRoundHandles) {
        _decimalRoundHandles = [NSMutableArray array];
    }
    return _decimalRoundHandles;
}

- (NSMutableArray <NSDecimalNumberHandler *>*)decimalDownHandles {
    if (!_decimalDownHandles) {
        _decimalDownHandles = [NSMutableArray array];
    }
    return _decimalDownHandles;
}

- (NSMutableArray <NSDecimalNumberHandler *>*)decimalUpHandles {
    if (!_decimalUpHandles) {
        _decimalUpHandles = [NSMutableArray array];
    }
    return _decimalUpHandles;
}

- (NSNumberFormatter *)handerFormatNumberDigits:(int)digits {
    if (digits < 0 || digits > 6) {
        if (ZCKitManager.isPrintLog) NSLog(@"digits point error");
        digits = 0;
    }
    if (self.numberFormatters.count <= digits) {
        for (NSUInteger i = self.numberFormatters.count; i <= digits; i ++) {
            [self.numberFormatters addObject:(NSNumberFormatter *)[NSNumber numberWithInt:digits]];
        }
    }
    NSNumberFormatter *formatter = self.numberFormatters[digits];
    if ([formatter isKindOfClass:[NSNumberFormatter class]] == NO) {
        formatter = [[NSNumberFormatter alloc] init];
        formatter.roundingMode = NSNumberFormatterRoundFloor;
        NSString *positiveFormat = @"0.";
        for (int i = 0; i < digits; i++) {
            positiveFormat = [positiveFormat stringByAppendingString:@"0"];
        }
        [formatter setPositiveFormat:positiveFormat];
        [self.numberFormatters replaceObjectAtIndex:digits withObject:formatter];
    }
    return formatter;
}

- (NSDecimalNumberHandler *)handerForDecimalPoint:(int)point mode:(NSRoundingMode)mode {
    if (point < 0 || point > 6) {
        if (ZCKitManager.isPrintLog) NSLog(@"digits point error");
        point = 0;
    }
    NSDecimalNumberHandler *hander = nil;
    switch (mode) {
        case NSRoundPlain:{
            if (self.decimalRoundHandles.count <= point) {
                for (NSUInteger i = self.decimalRoundHandles.count; i <= point; i ++) {
                    [self.decimalRoundHandles addObject:(NSDecimalNumberHandler *)[NSNumber numberWithInt:point]];
                }
            }
            hander = [self.decimalRoundHandles objectAtIndex:point];
            if ([hander isKindOfClass:[NSDecimalNumberHandler class]] == NO) {
                hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:point raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
                [self.decimalRoundHandles replaceObjectAtIndex:point withObject:hander];
            }
            break;
        }
        case NSRoundDown:{
            if (self.decimalDownHandles.count <= point) {
                for (NSUInteger i = self.decimalDownHandles.count; i <= point; i ++) {
                    [self.decimalDownHandles addObject:(NSDecimalNumberHandler *)[NSNumber numberWithInt:point]];
                }
            }
            hander = [self.decimalDownHandles objectAtIndex:point];
            if ([hander isKindOfClass:[NSDecimalNumberHandler class]] == NO) {
                hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:point raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
                [self.decimalDownHandles replaceObjectAtIndex:point withObject:hander];
            }
            break;
        }
        case NSRoundUp:{
            if (self.decimalUpHandles.count <= point) {
                for (NSUInteger i = self.decimalUpHandles.count; i <= point; i ++) {
                    [self.decimalUpHandles addObject:(NSDecimalNumberHandler *)[NSNumber numberWithInt:point]];
                }
            }
            hander = [self.decimalUpHandles objectAtIndex:point];
            if ([hander isKindOfClass:[NSDecimalNumberHandler class]] == NO) {
                hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:point raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
                [self.decimalUpHandles replaceObjectAtIndex:point withObject:hander];
            }
            break;
        }
        default:{
            hander = [NSDecimalNumberHandler defaultDecimalNumberHandler];
            if (ZCKitManager.isPrintLog) NSLog(@"round mode error");
            break;
        }
    }
    return hander;
}

#pragma mark - NSDecimalNumberBehaviors
- (short)scale {
    return 16;
}

- (NSRoundingMode)roundingMode {
    return NSRoundPlain;
}

- (nullable NSDecimalNumber *)exceptionDuringOperation:(SEL)operation error:(NSCalculationError)error leftOperand:(NSDecimalNumber *)leftOperand rightOperand:(nullable NSDecimalNumber *)rightOperand {
    if (ZCKitManager.isPrintLog) NSLog(@"decimal number calculate fail");
    return nil;
}

#pragma mark - class decimal number
/** 获取DecimalHandler，来处理四舍五入 */
+ (NSDecimalNumberHandler *)decimalHander:(int)decimal type:(ZCEnumRoundType)type {
    return [[ZCDecimalManager instance] handerForDecimalPoint:decimal mode:(NSRoundingMode)type];
}

/** 转化成->NSDecimalNumber，在此会稍微转换，返回数据都是6位精度 */
+ (NSDecimalNumber *)decimalNumberString:(NSString *)string orDouble:(double)dou {
    NSString *douvalue = nil;
    if (string && string.length) {
        douvalue = [NSString stringWithFormat:@"%lf", [string doubleValue]];
    } else {
        douvalue = [NSString stringWithFormat:@"%lf", dou];
    }
    return [NSDecimalNumber decimalNumberWithString:douvalue];
}

/** 转化成->NSDecimalNumber，会四舍五入处理 */
+ (NSDecimalNumber *)decimalNumber:(NSNumber *)number decimalPoint:(int)point roundMode:(ZCEnumRoundType)mode {
    NSDecimalNumberHandler *hander = [self decimalHander:point type:mode];
    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    return [decimal decimalNumberByRoundingAccordingToBehavior:hander];
}

/** 舍入转换成string显示，zero是否舍去末尾0 */
+ (NSString *)roundNumber:(NSNumber *)number decimalPoint:(int)point roundMode:(ZCEnumRoundType)mode roundZero:(BOOL)zero {
    NSDecimalNumber *decimal = [self decimalNumber:number decimalPoint:point roundMode:mode];
    if (zero) return [decimal stringValue];
    return [self formatFloorNumber:decimal digits:point];
}

/** 四舍五入转换成string显示，且舍去末尾0，小于6位精度 */
+ (NSString *)roundString:(NSString *)string orDouble:(double)dou decimalPoint:(int)point {
    NSDecimalNumberHandler *hander = [self decimalHander:point type:ZCEnumRoundTypeRound];
    NSDecimalNumber *decimal = [self decimalNumberString:string orDouble:dou];
    NSDecimalNumber *result = [decimal decimalNumberByRoundingAccordingToBehavior:hander];
    return [result stringValue];
}

/** 四舍五入转换成标准价格显示，四舍五入，0.00 两位精度 */
+ (NSString *)priceFormat:(NSNumber *)number orString:(NSString *)string orDouble:(double)dou {
    NSDecimalNumberHandler *hander = [self decimalHander:2 type:ZCEnumRoundTypeRound];
    NSDecimalNumber *decimal = nil;
    if (number != nil) {
        decimal = [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } else {
        decimal = [self decimalNumberString:string orDouble:dou];
    }
    NSDecimalNumber *result = [decimal decimalNumberByRoundingAccordingToBehavior:hander];
    return [self formatFloorNumber:result digits:2];
}

/** 保留指定位数有效小数，后面舍去 */
+ (NSString *)formatFloorNumber:(NSNumber *)number digits:(int)digits {
    if (number == nil) return nil;
    NSNumberFormatter *formatter = [[ZCDecimalManager instance] handerFormatNumberDigits:digits];
    return [formatter stringFromNumber:number];
}

#pragma mark - class misc function
+ (instancetype)instance {
    static dispatch_once_t onceToken;
    static ZCDecimalManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ZCDecimalManager alloc] init];
    });
    return instance;
}

/** 去除无效数字，只对浮点数有用 */
+ (NSString *)stringDisposeWithFloatString:(NSString *)floatString {
    if (!floatString) return nil;
    if ([floatString rangeOfString:@"."].location == NSNotFound) {
        return floatString;
    }
    long len = floatString.length;
    for (int i = 0; i < len; i++) {
        if (![floatString hasSuffix:@"0"]) break;
        else floatString = [floatString substringToIndex:([floatString length] - 1)];
    }
    if ([floatString hasSuffix:@"."]) {
        return [floatString substringToIndex:([floatString length] - 1)];
    }
    else return floatString;
}

/** 计算浮点数的有效小数位数，最大六位小数 */
+ (int)calculateDecimalDigitFromFloat:(double)dou {
    NSString *string = [[self decimalNumberString:nil orDouble:dou] stringValue];
    return [self calculateDecimalDigitFromString:string];
}

/** 计算字符串的小数位数，最大六位小数 */
+ (int)calculateDecimalDigitFromString:(NSString *)str {
    int length = 0;
    if (str.length && [str isPureFloat]) {
        NSArray *comps = [str componentsSeparatedByString:@"."];
        if (comps && comps.count == 2) length = (int)[comps.lastObject length];
        if (length > 6) {
            str = [self preciseString:str];
            comps = [str componentsSeparatedByString:@"."];
            if (comps && comps.count == 2) length = (int)[comps.lastObject length];
            if (length > 6) {
                length = 6;
                if (ZCKitManager.isPrintLog) NSLog(@"float string is fail value");
            }
            if (ZCKitManager.isPrintLog) NSLog(@"float string is fail value");
        }
    } else if (str.length && [str isPureInteger]) {
        if (ZCKitManager.isPrintLog) NSLog(@"calculate integer digit");
    } else {
        if (ZCKitManager.isPrintLog) NSLog(@"calculate decimal digit fail");
    }
    return length;
}

/** 计算指定小数位数的最小正小数，默认 1 */
+ (float)minFloatFromDecimalDigit:(int)digit {
    double x = 10, y = -digit, min = 1.0;
    if (x < 0) {
        double fraction, integer;
        fraction = modf(y, &integer);
        if (fabs(fraction) > 0) {
            if (ZCKitManager.isPrintLog) NSLog(@"value is fail");
        } else min = pow(x, y);
    } else if (x == 0 && y <= 0) {
        if (ZCKitManager.isPrintLog) NSLog(@"value is fail");
    } else {
        min = pow(x, y);
    }
    return min;
}

#pragma mark - class switch judge
+ (NSString *)preciseString:(NSString *)strvalue {
    double douvalue = [strvalue doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", douvalue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

+ (NSString *)preciseDouble:(double)douvalue {
    NSString *doubleString = [NSString stringWithFormat:@"%lf", douvalue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

@end









