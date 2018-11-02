//
//  NSDictionary+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/28.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "NSDictionary+ZC.h"
#import "ZCKitBridge.h"
#import "NSNumber+ZC.h"
#import "NSString+ZC.h"
#import "NSArray+ZC.h"
#import "NSData+ZC.h"

#pragma mark - NSDictionary
@implementation NSDictionary (ZC)

#pragma mark - usually
- (id)randomValue {
    return [self.allValues randomObject];
}

- (NSArray *)allKeysSorted {
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSArray *)allValuesSortedByKeys {
    NSArray *sortedKeys = [self allKeysSorted];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (id key in sortedKeys) {
        [arr addObject:self[key]];
    }
    return [arr copy];
}

- (NSDictionary *)dictionaryForKeys:(NSArray *)keys {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (!keys || !keys.count) return [dic copy];
    for (id key in keys) {
        id value = self[key];
        if (value) dic[key] = value;
    }
    return [dic copy];
}

- (NSDictionary *)restExceptForKeys:(NSArray *)keys {
    NSMutableDictionary *rest = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![keys containsObject:key]) {
            [rest setObject:obj forKey:key];
        }
    }];
    return [rest copy];
}

- (BOOL)containsObjectForKey:(id)key {
    if (!key) return NO;
    return self[key] != nil;
}

- (BOOL)containsObjectForValue:(id)value {
    if (!value) return NO;
    return [self.allValues containsObject:value];
}

- (NSString *)jsonString {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error && jsonStr) return jsonStr;
    }
    return nil;
}

#pragma mark - misc
- (NSData *)plistData {
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

- (NSString *)plistString {
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) return xmlData.utf8String;
    return nil;
}

+ (NSDictionary *)dictionaryWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([dictionary isKindOfClass:[NSDictionary class]]) return dictionary;
    return nil;
}

+ (NSDictionary *)dictionaryWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self dictionaryWithPlistData:data];
}

#pragma mark - parse
/** 错误时候默认返回 @[] */
- (NSArray *)arrayValueForKey:(NSString *)key {
    if ([self keyIsInvalidKey:key]) return [NSArray array];
    NSArray *arrvalue = nil;
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSArray class]]) {
        arrvalue = (NSArray *)obj;
    } else if ([obj isKindOfClass:[NSNull class]] || obj == nil || obj == NULL) {
        if (ZCKitBridge.isPrintLog) NSLog(@"parse array obj is null");
    } else {
        NSAssert(0, @"parse array obj is invalid");
    }
    if (arrvalue == nil) arrvalue = [NSArray array];
    return arrvalue;
}

/** 错误时候默认返回 @{} */
- (NSDictionary *)dictionaryValueForKey:(NSString *)key {
    if ([self keyIsInvalidKey:key]) return [NSDictionary dictionary];
    NSDictionary *dicvalue = nil;
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        dicvalue = (NSDictionary *)obj;
    } else if ([obj isKindOfClass:[NSNull class]] || obj == nil || obj == NULL) {
        if (ZCKitBridge.isPrintLog) NSLog(@"parse dict obj is null");
    } else {
        NSAssert(0, @"parse dict obj is invalid");
    }
    if (dicvalue == nil) dicvalue = [NSDictionary dictionary];
    return dicvalue;
}

/** 错误时候默认返回 @""，number型或者浮点型字符串都会强制精确到6位小数点 */
- (NSString *)stringValueForKey:(NSString *)key {
    if ([self keyIsInvalidKey:key]) return @"";
    NSString *strvalue = nil;
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSString class]]) {
        if ([obj isEqualToString:@"null"] || [obj isEqualToString:@"<null>"] || [obj isEqualToString:@"(null)"]) {
            if (ZCKitBridge.isPrintLog) NSLog(@"parse string obj is null");
        } else if ([obj isPureDouble]) {
            NSDecimalNumber *decimal = [NSDecimalNumber decimalString:obj];
            if (decimal.isANumber) {
                strvalue = [decimal stringValue];
            } else {
                strvalue = obj;
            }
        } else {
            strvalue = obj;
        }
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        NSDecimalNumber *decimal = [[NSDecimalNumber decimalNumber:obj] decimalRound:6 mode:ZCEnumRoundTypeRound];
        if (decimal.isANumber) {
            strvalue = [decimal stringValue];
        } else {
            NSAssert(0, @"parse string obj is invalid string");
        }
    } else if ([obj isKindOfClass:[NSNull class]] || obj == nil || obj == NULL) {
        if (ZCKitBridge.isPrintLog) NSLog(@"parse string obj is null");
    } else {
        NSAssert(0, @"parse string obj is invalid string");
    }
    if (strvalue == nil) strvalue = @"";
    return strvalue;
}

/** 错误时候默认返回 0，字符串浮点数解析会精确到6位小数点 */
- (NSNumber *)numberValueForKey:(NSString *)key {
    if ([self keyIsInvalidKey:key]) return [NSNumber numberWithFloat:0];
    NSNumber *numvalue = nil;
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]]) { 
        numvalue = obj;
    } else if ([obj isKindOfClass:[NSString class]]) {
        NSDecimalNumber *decimal = [NSDecimalNumber decimalString:obj];
        if (decimal.isANumber) {
            numvalue = decimal;
        } else {
            NSAssert(0, @"parse number obj is invalid number");
        }
    } else if ([obj isKindOfClass:[NSNull class]] || obj == nil || obj == NULL) {
        if (ZCKitBridge.isPrintLog) NSLog(@"parse number obj is null");
    } else {
        NSAssert(0, @"parse number obj is invalid");
    }
    if (numvalue == nil) numvalue = [NSNumber numberWithFloat:0];
    return numvalue;
}

/** 错误时候默认返回 zero，字符串浮点数解析会精确到6位小数点 */
- (NSDecimalNumber *)decimalValueForKey:(NSString *)key {
    if ([self keyIsInvalidKey:key]) return [NSDecimalNumber zero];
    NSDecimalNumber *decvalue = nil;
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]]) {
        decvalue = [NSDecimalNumber decimalNumber:obj];
    } else if ([obj isKindOfClass:[NSString class]]) {
        decvalue = [NSDecimalNumber decimalString:obj];
    } else if ([obj isKindOfClass:[NSNull class]] || obj == nil || obj == NULL) {
        if (ZCKitBridge.isPrintLog) NSLog(@"parse decimal obj is null");
    } else {
        NSAssert(0, @"parse decimal obj is invalid");
    }
    if (decvalue && !decvalue.isANumber) {
        NSAssert(0, @"parse decimal obj is invalid");
    }
    if (decvalue == nil || !decvalue.isANumber) decvalue = [NSDecimalNumber zero];
    return decvalue;
}

/** 错误时候默认返回 @"0.00"，四舍五入，保留2位小数点 */
- (NSString *)priceValueForKey:(NSString *)key {
    if ([self keyIsInvalidKey:key]) return @"0.00";
    NSString *privalue = nil;
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSString class]]) {
        NSDecimalNumber *decimal = [NSDecimalNumber decimalString:obj];
        if (decimal.isANumber) {
            privalue = [decimal priceValue];
        } else {
            NSAssert(0, @"parse price obj is invalid price");
        }
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        NSDecimalNumber *decimal = [NSDecimalNumber decimalNumber:obj];
        if (decimal.isANumber) {
            privalue = [decimal priceValue];
        } else {
            NSAssert(0, @"parse price obj is invalid price");
        }
    } else if ([obj isKindOfClass:[NSNull class]] || obj == nil || obj == NULL) {
        if (ZCKitBridge.isPrintLog) NSLog(@"parse price obj is null");
    } else {
        NSAssert(0, @"parse price obj is invalid");
    }
    if (privalue == nil) privalue = @"0.00";
    return privalue;
}

/** 错误时候默认返回 0，浮点数在此取整会舍弃小数部分 */
- (long)longValueForKey:(NSString *)key {
    if ([self keyIsInvalidKey:key]) return 0;
    long intvalue = 0;
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]]) {
        NSDecimalNumber *decimal = [NSDecimalNumber decimalNumber:obj];
        if (decimal.isANumber) {
            intvalue = [decimal longValue];
        } else {
            NSAssert(0, @"parse long obj is invalid integer");
            intvalue = [obj longValue];
        }
    } else if ([obj isKindOfClass:[NSString class]]) {
        NSDecimalNumber *decimal = [NSDecimalNumber decimalString:obj];
        if (decimal.isANumber) {
            intvalue = [decimal longValue];
        } else {
            NSAssert(0, @"parse long obj is invalid integer");
            intvalue = [obj longValue];
        }
    } else if ([obj isKindOfClass:[NSNull class]] || obj == nil || obj == NULL) {
        if (ZCKitBridge.isPrintLog) NSLog(@"parse long obj is null");
    } else {
        NSAssert(0, @"parse long obj is invalid");
    }
    return intvalue;
}

/** 错误时候默认返回 0，保留有效位数为四舍五入模式，保留6位小数 */
- (float)floatValueForKey:(NSString *)key {
    if ([self keyIsInvalidKey:key]) return 0;
    float flovalue = 0;
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]]) {
        NSDecimalNumber *decimal = [[NSDecimalNumber decimalNumber:obj] decimalRound:6 mode:ZCEnumRoundTypeRound];
        if (decimal.isANumber) {
            flovalue = (float)[decimal doubleValue];
        } else {
            NSAssert(0, @"parse float obj is invalid number");
        }
    } else if ([obj isKindOfClass:[NSString class]]) {
        NSDecimalNumber *decimal = [NSDecimalNumber decimalString:obj];
        if (decimal.isANumber) {
            flovalue = (float)[decimal doubleValue];
        } else {
            NSAssert(0, @"parse float obj is invalid number");
        }
    } else if ([obj isKindOfClass:[NSNull class]] || obj == nil || obj == NULL) {
        if (ZCKitBridge.isPrintLog) NSLog(@"parse float obj is null");
    } else {
        NSAssert(0, @"parse float obj is invalid");
    }
    return flovalue;
}

/** 错误时候默认返回 defaultValue */
- (BOOL)boolValueForKey:(NSString *)key defaultValue:(BOOL)defalut {
    if ([self keyIsInvalidKey:key]) return defalut;
    BOOL boolvalue = defalut;
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]]) {
        if ([[obj stringValue] isEqualToString:@"1"]) {
            boolvalue = YES;
        } else if ([[obj stringValue] isEqualToString:@"0"]) {
            boolvalue = NO;
        } else {
            boolvalue = [obj boolValue];
            NSAssert(0, @"parse bool obj is invalid bool");
        }
    } else if ([obj isKindOfClass:[NSString class]]) {
        if ([obj isEqualToString:@"true"] || [obj isEqualToString:@"YES"] || [obj isEqualToString:@"yes"]) {
            boolvalue = YES;
        } else if ([obj isEqualToString:@"false"] || [obj isEqualToString:@"NO"] || [obj isEqualToString:@"no"]) {
            boolvalue = NO;
        } else {
            NSAssert(0, @"parse bool obj is invalid bool");
        }
    } else if ([obj isKindOfClass:[NSNull class]] || obj == nil || obj == NULL) {
        if (ZCKitBridge.isPrintLog) NSLog(@"parse bool obj is null");
    } else {
        NSAssert(0, @"parse bool obj is invalid");
    }
    return boolvalue;
}

/** 错误时候默认返回 NO */
- (BOOL)boolValueForKey:(NSString *)key {
    return [self boolValueForKey:key defaultValue:NO];
}

#pragma mark - check
/** 判断字典是否含有指定的键，存在未知键则返回nil，否则返回key对应value的数组 */
- (NSArray *)checkInvalidKeys:(NSString *)firstKey,... __attribute__((sentinel)) {
    if (self.count && firstKey) {
        id firstObject = [self objectForKey:firstKey];
        if (firstObject == nil) return nil;
        NSMutableArray *validObjects = [NSMutableArray array];
        [validObjects addObject:firstObject];
        va_list params;
        va_start(params, firstKey);
        NSString *arg;
        BOOL isContain = YES;
        while ((arg = va_arg(params, NSString *))) {
            if (arg) {
                if (!isContain) continue;
                id object = [self objectForKey:arg];
                if (object == nil) isContain = NO;
                else [validObjects addObject:object];
            }
        }
        va_end(params);
        if (isContain) return validObjects;
    }
    return nil;
}

#pragma mark - private
- (BOOL)keyIsInvalidKey:(NSString *)key {
    if (key != nil && [key isKindOfClass:[NSString class]]) return NO;
    NSAssert(0, @"parse dic or key is fail");
    return YES;
}

@end



#pragma mark - NSMutableDictionary
@implementation NSMutableDictionary (ZC)

- (void)injectBoolValue:(BOOL)value forKey:(NSString *)key {
    [self injectValue:[NSNumber numberWithBool:value] forKey:key];
}

- (void)injectFloatValue:(float)value forKey:(NSString *)key {
    [self injectValue:[NSNumber numberWithFloat:value] forKey:key];
}

- (void)injectLongValue:(long)value forKey:(NSString *)key {
    [self injectValue:[NSNumber numberWithLong:value] forKey:key];
}

/** 注入string，allowNull为YES时不规则value值将替换成NSNull注入，allowNull为NO时value为@""或者nil时不可注入字典 */
- (void)injectStringValue:(NSString *)value forKey:(NSString *)key allowNull:(BOOL)allowNull {
    [self injectValue:value forKey:key allowNull:allowNull];
}

/** 注入number string array dictionary 没问题，当value为nil或@""时不可注入字典 */
- (void)injectValue:(id)value forKey:(NSString *)key {
    [self injectValue:value forKey:key allowNull:NO];
}

/** 注入number string array dictionary 没问题，allowNull为YES时候，不规则value值将替换成NSNull注入 */
- (void)injectValue:(id)value forKey:(NSString *)key allowNull:(BOOL)allowNull {
    if ([self keyIsInvalidKey:key value:value allowNull:allowNull]) return;
    if (allowNull && (value == nil || value == NULL)) {
        [self setObject:[NSNull null] forKey:key]; return;
    }
    if ([value isKindOfClass:[NSString class]]) {
        if (allowNull) {
            if ([value isEqualToString:@"<null>"]) {
                [self setObject:[NSNull null] forKey:key];
            } else {
                [self setObject:value forKey:key];
            }
        } else if ([value length] && ![value isEqualToString:@"<null>"]) {
            [self setObject:value forKey:key];
        } else {
            if (ZCKitBridge.isPrintLog) NSLog(@"inject string obj is invalid");
        }
    } else if ([value isMemberOfClass:[NSNumber class]]) {
        [self setObject:value forKey:key];
    } else if ([value isKindOfClass:[NSArray class]]) {
        [self setObject:value forKey:key];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        [self setObject:value forKey:key];
    } else {
        if (ZCKitBridge.isPrintLog) NSLog(@"inject value obj is invalid");
    }
}

- (BOOL)keyIsInvalidKey:(NSString *)key value:(id)value allowNull:(BOOL)allowNull {
    if (key == nil || ![key isKindOfClass:[NSString class]]) {
        NSAssert(0, @"inject key obj is invalid"); return YES;
    }
    if (allowNull) return NO;
    if (value == nil || value == NULL || [value isKindOfClass:[NSNull class]]) return YES;
    return NO;
}

@end

