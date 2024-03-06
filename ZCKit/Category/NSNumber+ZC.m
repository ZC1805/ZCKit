//
//  NSNumber+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/27.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "NSNumber+ZC.h"
#import "NSString+ZC.h"

#pragma mark - ~ NSNumber ~
@implementation NSNumber (ZC)

+ (NSString *)stringByMyTrim:(NSString *)string {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [string stringByTrimmingCharactersInSet:set];
}

+ (NSNumber *)numberWithString:(NSString *)string {
    if (!string) return nil;
    NSString *str = [[self stringByMyTrim:string] lowercaseString];
    if (!str || !str.length) return nil;
    
    static NSDictionary *kNumberMapDic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kNumberMapDic = @{@"true"   : @(YES),
                          @"yes"    : @(YES),
                          @"false"  : @(NO),
                          @"no"     : @(NO),
                          @"nil"    : [NSNull null],
                          @"null"   : [NSNull null],
                          @"<null>" : [NSNull null]};
    });
    id num = kNumberMapDic[str];
    if (num) {
        if (num == [NSNull null]) { return nil; }
        return num;
    }
    
    int sign = 0;
    if ([str hasPrefix:@"0x"]) sign = 1;
    else if ([str hasPrefix:@"-0x"]) sign = -1;
    if (sign != 0) {
        NSScanner *scan = [NSScanner scannerWithString:str];
        unsigned num = -1;
        BOOL suc = [scan scanHexInt:&num];
        if (suc) {
            return [NSNumber numberWithLong:((long)num * sign)];
        } else {
            return nil;
        }
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
}

@end


#pragma mark - ~ NSDecimalNumber ~
@implementation NSDecimalNumber (ZC)

#pragma mark - Class func
/**< -1 */
+ (NSDecimalNumber *)nOne {
    return [self decimalNumberWithMantissa:1 exponent:0 isNegative:YES];
}

/**< string初始化，能规避精度问题，六位小数精度，string为nil或非浮点型时都返回notANumber */
+ (NSDecimalNumber *)decimalString:(NSString *)strValue {
    if (!strValue || !strValue.isPureDouble) return [NSDecimalNumber notANumber];
    double douValue = [strValue doubleValue];
    NSString *doubleStr = [NSString stringWithFormat:@"%lf", douValue];
    return [NSDecimalNumber decimalNumberWithString:doubleStr]; ///!!!: 以这种初始化方法测试结果表明只会保留6位小数精度
}

/**< double初始化，能规避精度问题，六位小数精度 */
+ (NSDecimalNumber *)decimalDouble:(double)douValue {
    NSString *doubleStr = [NSString stringWithFormat:@"%lf", douValue];
    return [NSDecimalNumber decimalNumberWithString:doubleStr];
}

/**< integer初始化 */
+ (NSDecimalNumber *)decimalInteger:(long)lonValue {
    NSString *longStr = [NSString stringWithFormat:@"%ld", lonValue];
    return [NSDecimalNumber decimalNumberWithString:longStr];
}

/**< number初始化，number为nil返回notANumber */
+ (NSDecimalNumber *)decimalNumber:(NSNumber *)number {
    if (number == nil) return [NSDecimalNumber notANumber];
    return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
}

#pragma mark - Instance func
/**< decimal的最精度，最小返回值为0.000001 */
- (NSDecimalNumber *)decimalPrecise {
    int dec = [ZCDecimalManager calculateDecimalDigitFromString:[self stringValue]];
    return [NSDecimalNumber decimalNumberWithMantissa:1 exponent:-dec isNegative:NO];
}

/**< decimal按小数位数四舍五入操作 */
- (NSDecimalNumber *)decimalRound:(short)decimal mode:(ZCEnumRoundType)mode {
    NSDecimalNumberHandler *handler = [ZCDecimalManager decimalHandler:decimal type:mode];
    return [self decimalNumberByRoundingAccordingToBehavior:handler];
}

#pragma mark - Calculate func
/**< 加 */
- (NSDecimalNumber *)plus:(NSDecimalNumber *)decimalNumber {
    if (!decimalNumber) decimalNumber = [NSDecimalNumber zero];
    return [self decimalNumberByAdding:decimalNumber withBehavior:[ZCDecimalManager sharedManager]];
}

/**< 减 */
- (NSDecimalNumber *)minus:(NSDecimalNumber *)decimalNumber {
    if (!decimalNumber) decimalNumber = [NSDecimalNumber zero];
    return [self decimalNumberBySubtracting:decimalNumber withBehavior:[ZCDecimalManager sharedManager]];
}

/**< 乘 */
- (NSDecimalNumber *)mltiply:(NSDecimalNumber *)decimalNumber {
    if (!decimalNumber) decimalNumber = [NSDecimalNumber one];
    return [self decimalNumberByMultiplyingBy:decimalNumber withBehavior:[ZCDecimalManager sharedManager]];
}

/**< 除 */
- (NSDecimalNumber *)divide:(NSDecimalNumber *)decimalNumber {
    if (!decimalNumber) decimalNumber = [NSDecimalNumber one];
    return [self decimalNumberByDividingBy:decimalNumber withBehavior:[ZCDecimalManager sharedManager]];
}

/**< 幂 */
- (NSDecimalNumber *)raisingToPower:(NSUInteger)power {
    return [self decimalNumberByRaisingToPower:power withBehavior:[ZCDecimalManager sharedManager]];
}

/**< 乘10^x方 */
- (NSDecimalNumber *)mltiplyPower10:(short)power {
    return [self decimalNumberByMultiplyingByPowerOf10:power withBehavior:[ZCDecimalManager sharedManager]];
}

#pragma mark - Compare func
/**< 小于 */
- (BOOL)less:(NSDecimalNumber *)decimalNumber {
    if (!decimalNumber) return NO;
    NSComparisonResult result = [self compare:decimalNumber];
    if (result == NSOrderedAscending) return YES;
    return NO;
}

/**< 大于 */
- (BOOL)more:(NSDecimalNumber *)decimalNumber {
    if (!decimalNumber) return NO;
    NSComparisonResult result = [self compare:decimalNumber];
    if (result == NSOrderedDescending) return YES;
    return NO;
}

/**< 等于 */
- (BOOL)equal:(NSDecimalNumber *)decimalNumber {
    if (!decimalNumber) return NO;
    NSComparisonResult result = [self compare:decimalNumber];
    if (result == NSOrderedSame) return YES;
    return NO;
}

/**< 返回价格格式，notANumber返回0.00 */
- (NSString *)priceValue {
    if (self.isANumber) return [ZCDecimalManager priceFormat:self orString:nil orDouble:0];
    return @"0.00";
}

/**< 是否是number */
- (BOOL)isANumber {
    if ([self equal:[NSDecimalNumber notANumber]]) return NO;
    return YES;
}

@end
