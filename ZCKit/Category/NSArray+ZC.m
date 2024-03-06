//
//  NSArray+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/28.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "NSArray+ZC.h"
#import "NSData+ZC.h"
#import "ZCMacro.h"
#import "ZCKitBridge.h"
#import "NSNumber+ZC.h"
#import "NSString+ZC.h"

#pragma mark - ~ NSArray ~
@implementation NSArray (ZC)

- (NSString *)descriptionWithLocale:(id)locale {
    if (self.jsonFormatString.length) return self.jsonFormatString;
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"[\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"%@,\n", obj];
    }];
    [str appendString:@"]"];
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) {
        [str deleteCharactersInRange:range];
    }
    return str;
}

- (id)randomObject {
    if (self.count) {
        return [self objectAtIndex:(arc4random_uniform((u_int32_t)self.count))];
    }
    return nil;
}

- (NSArray *)subArrayValueForRange:(NSRange)range {
    if (range.length > 0 && range.location >= 0 && self.count > 0) {
        if (range.location + range.length <= self.count && range.location <= INT32_MAX && range.length <= INT32_MAX) {
            return [self subarrayWithRange:range];
        } else if (range.location < self.count) {
            return [self subarrayWithRange:NSMakeRange(range.location, self.count - range.location)];
        }
    } return @[];
}

- (id)objectOrNilAtIndex:(NSUInteger)index {
    return (index >= 0 && index < self.count) ? [self objectAtIndex:index] : nil;
}

- (NSArray *)restExceptObjects:(NSArray *)objects {
    NSMutableArray *rest = [NSMutableArray array];
    for (id item in self) {
        if (![objects containsObject:item]) {
            [rest addObject:item];
        }
    }
    return [rest copy];
}

- (id)objectForPropertyName:(NSString *)propertyName propertyValue:(id)propertyValue {
    if (!propertyName || !propertyValue) return nil;
    for (NSInteger i = 0; i < self.count; i++) {
        id obj = [self objectAtIndex:i];
        id value = [obj valueForKey:propertyName];
        if (value) {
            if ([value isKindOfClass:NSString.class] && [propertyValue isKindOfClass:NSString.class]) {
                if ([value isEqualToString:propertyValue]) {
                    return obj;
                }
            } else if ([value isKindOfClass:NSDictionary.class] && [propertyValue isKindOfClass:NSDictionary.class]) {
                if ([value isEqualToDictionary:propertyValue]) {
                    return obj;
                }
            } else if ([value isKindOfClass:NSArray.class] && [propertyValue isKindOfClass:NSArray.class]) {
                if ([value isEqualToArray:propertyValue]) {
                    return obj;
                }
            } else if ([value isKindOfClass:NSNumber.class] && [propertyValue isKindOfClass:NSNumber.class]) {
                if ([value isEqualToNumber:propertyValue]) {
                    return obj;
                }
            } else if ([value isEqual:propertyValue]) {
                return obj;
            }
        }
    }
    return nil;
}

- (NSInteger)indexForPropertyName:(NSString *)propertyName propertyValue:(id)propertyValue {
    if (!propertyName || !propertyValue) return -1;
    for (NSInteger i = 0; i < self.count; i++) {
        id obj = [self objectAtIndex:i];
        id value = [obj valueForKey:propertyName];
        if (value) {
            if ([value isKindOfClass:NSString.class] && [propertyValue isKindOfClass:NSString.class]) {
                if ([value isEqualToString:propertyValue]) {
                    return i;
                }
            } else if ([value isKindOfClass:NSDictionary.class] && [propertyValue isKindOfClass:NSDictionary.class]) {
                if ([value isEqualToDictionary:propertyValue]) {
                    return i;
                }
            } else if ([value isKindOfClass:NSArray.class] && [propertyValue isKindOfClass:NSArray.class]) {
                if ([value isEqualToArray:propertyValue]) {
                    return i;
                }
            } else if ([value isKindOfClass:NSNumber.class] && [propertyValue isKindOfClass:NSNumber.class]) {
                if ([value isEqualToNumber:propertyValue]) {
                    return i;
                }
            } else if ([value isEqual:propertyValue]) {
                return i;
            }
        }
    }
    return -1;
}

- (NSArray *)objectValueArrayForKey:(NSString *)key defaultValue:(id)defaultValue {
    if (!key) key = @""; if (!defaultValue) defaultValue = [NSNull null];
    NSMutableArray *subArray = [NSMutableArray array];
    for (id object in self) {
        id value = [object valueForKey:key];
        if (!value) value = defaultValue;
        [subArray addObject:value];
    }
    return subArray.copy;
}

- (NSString *)jsonFormatString {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil; NSString *jsonStr = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        if (!error && jsonData) jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (jsonStr.length) return jsonStr;
    }
    if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: parse to json string fail");
    return @"";
}

- (NSString *)jsonString {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil; NSString *jsonStr = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (!error && jsonData) jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (jsonStr.length) return jsonStr;
    }
    if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: parse to json string fail");
    return nil;
}

- (NSData *)plistData {
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

- (NSString *)plistString {
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) return xmlData.utf8String;
    return nil;
}

+ (NSArray *)arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([array isKindOfClass:NSArray.class]) return array;
    return nil;
}

+ (NSArray *)arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self arrayWithPlistData:data];
}

#pragma mark - Parse
/**< 键是否有效 */
- (BOOL)indexIsInvalidIndex:(NSInteger)index {
    if (index >= 0 && index < self.count) return NO;
    NSAssert(0, @"ZCKit: parse array for index is fail");
    return YES;
}

/**< 错误时候默认返回 nil*/
- (ZCJsonValue)jsonValueForIndex:(NSInteger)index {
    if ([self indexIsInvalidIndex:index]) return nil;
    id obj = [self objectAtIndex:index];
    if (![ZCGlobal isJsonValue:obj]) {
        NSAssert(0, @"ZCKit: parse json value is not json value");
        return nil;
    }
    return obj;
}

/**< 错误时候默认返回 @[] */
- (NSArray *)arrayValueForIndex:(NSInteger)index {
    if ([self indexIsInvalidIndex:index]) return [NSArray array];
    NSArray *arrvalue = nil;
    id obj = [self objectAtIndex:index];
    if ([obj isKindOfClass:NSArray.class]) {
        arrvalue = (NSArray *)obj;
    } else if (obj == nil || obj == NULL || [obj isKindOfClass:NSNull.class]) {
        if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: parse array obj is null");
    } else {
        NSAssert(0, @"ZCKit: parse array obj is invalid");
    }
    if (!arrvalue || ![arrvalue isKindOfClass:NSArray.class]) {
        arrvalue = [NSArray array];
    }
    return arrvalue;
}

/**< 错误时候默认返回 @{} */
- (NSDictionary *)dictionaryValueForIndex:(NSInteger)index {
    if ([self indexIsInvalidIndex:index]) return [NSDictionary dictionary];
    NSDictionary *dicvalue = nil;
    id obj = [self objectAtIndex:index];
    if ([obj isKindOfClass:NSDictionary.class]) {
        dicvalue = (NSDictionary *)obj;
    } else if (obj == nil || obj == NULL || [obj isKindOfClass:NSNull.class]) {
        if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: parse dict obj is null");
    } else {
        NSAssert(0, @"ZCKit: parse dict obj is invalid");
    }
    if (!dicvalue || ![dicvalue isKindOfClass:NSDictionary.class]) {
        dicvalue = [NSDictionary dictionary];
    }
    return dicvalue;
}

/**< 错误时候默认返回 @""，number型会强制精确到6位小数点 */
- (NSString *)stringValueForIndex:(NSInteger)index {
    if ([self indexIsInvalidIndex:index]) return @"";
    NSString *strvalue = nil;
    id obj = [self objectAtIndex:index];
    if ([obj isKindOfClass:NSString.class]) {
        if ([obj isEqualToString:@"<null>"] || [obj isEqualToString:@"(null)"]) {
            if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: parse string obj is null");
        } else if (ZCKitBridge.isStrToAccurateFloat && ![obj isPureInteger] && [obj isPureDouble]) { //对纯数字字符串检查是否是不精确的浮点类型
            NSDecimalNumber *decimal = [NSDecimalNumber decimalString:obj];
            if (decimal.isANumber) {
                strvalue = [decimal stringValue];
            } else {
                strvalue = obj;
            }
        } else {
            strvalue = obj;
        }
    } else if ([obj isKindOfClass:NSNumber.class]) {
        NSDecimalNumber *decimal = [[NSDecimalNumber decimalNumber:obj] decimalRound:6 mode:ZCEnumRoundTypeRound];
        if (decimal.isANumber) {
            strvalue = [decimal stringValue];
        } else {
            NSAssert(0, @"ZCKit: parse string obj is invalid string");
        }
    } else if (obj == nil || obj == NULL || [obj isKindOfClass:NSNull.class]) {
        if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: parse string obj is null");
    } else {
        NSAssert(0, @"ZCKit: parse string obj is invalid string");
    }
    if (!strvalue || ![strvalue isKindOfClass:NSString.class]) {
        strvalue = @"";
    }
    return strvalue;
}

/**< 错误时候默认返回 0，字符串浮点数解析会精确到6位小数点 */
- (NSNumber *)numberValueForIndex:(NSInteger)index {
    if ([self indexIsInvalidIndex:index]) return [NSNumber numberWithFloat:0];
    NSNumber *numvalue = nil;
    id obj = [self objectAtIndex:index];
    if ([obj isKindOfClass:NSNumber.class]) {
        numvalue = obj;
    } else if ([obj isKindOfClass:NSString.class]) {
        NSDecimalNumber *decimal = [NSDecimalNumber decimalString:obj];
        if (decimal.isANumber) {
            numvalue = decimal;
        } else {
            NSAssert(0, @"ZCKit: parse number obj is invalid number");
        }
    } else if (obj == nil || obj == NULL || [obj isKindOfClass:NSNull.class]) {
        if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: parse number obj is null");
    } else {
        NSAssert(0, @"ZCKit: parse number obj is invalid");
    }
    if (!numvalue || ![numvalue isKindOfClass:NSNumber.class]) {
        numvalue = [NSNumber numberWithFloat:0];
    }
    return numvalue;
}

/**< 错误时候默认返回 zero，字符串浮点数解析会精确到6位小数点 */
- (NSDecimalNumber *)decimalValueForIndex:(NSInteger)index {
    if ([self indexIsInvalidIndex:index]) return [NSDecimalNumber zero];
    NSDecimalNumber *decvalue = nil;
    id obj = [self objectAtIndex:index];
    if ([obj isKindOfClass:NSNumber.class]) {
        decvalue = [NSDecimalNumber decimalNumber:obj];
    } else if ([obj isKindOfClass:NSString.class]) {
        decvalue = [NSDecimalNumber decimalString:obj];
    } else if (obj == nil || obj == NULL || [obj isKindOfClass:NSNull.class]) {
        if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: parse decimal obj is null");
    } else {
        NSAssert(0, @"ZCKit: parse decimal obj is invalid");
    }
    if (decvalue && !decvalue.isANumber) {
        NSAssert(0, @"ZCKit: parse decimal obj is invalid");
    }
    if (decvalue == nil || !decvalue.isANumber) decvalue = [NSDecimalNumber zero];
    return decvalue;
}

/**< 错误时候默认返回 @"0.00"，四舍五入，保留2位小数点 */
- (NSString *)priceValueForIndex:(NSInteger)index {
    if ([self indexIsInvalidIndex:index]) return @"0.00";
    NSString *privalue = nil;
    id obj = [self objectAtIndex:index];
    if ([obj isKindOfClass:NSString.class]) {
        NSDecimalNumber *decimal = [NSDecimalNumber decimalString:obj];
        if (decimal.isANumber) {
            privalue = [decimal priceValue];
        } else {
            NSAssert(0, @"ZCKit: parse price obj is invalid price");
        }
    } else if ([obj isKindOfClass:NSNumber.class]) {
        NSDecimalNumber *decimal = [NSDecimalNumber decimalNumber:obj];
        if (decimal.isANumber) {
            privalue = [decimal priceValue];
        } else {
            NSAssert(0, @"ZCKit: parse price obj is invalid price");
        }
    } else if (obj == nil || obj == NULL || [obj isKindOfClass:NSNull.class]) {
        if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: parse price obj is null");
    } else {
        NSAssert(0, @"ZCKit: parse price obj is invalid");
    }
    if (privalue == nil) privalue = @"0.00";
    return privalue;
}

/**< 错误时候默认返回 0，浮点数在此取整后会舍弃小数部分 */
- (long)longValueForIndex:(NSInteger)index {
    if ([self indexIsInvalidIndex:index]) return 0;
    long intvalue = 0;
    id obj = [self objectAtIndex:index];
    if ([obj isKindOfClass:NSNumber.class]) {
        NSDecimalNumber *decimal = [NSDecimalNumber decimalNumber:obj];
        if (decimal.isANumber) {
            intvalue = [decimal longValue];
        } else {
            NSAssert(0, @"ZCKit: parse long obj is invalid integer");
            intvalue = [obj longValue];
        }
    } else if ([obj isKindOfClass:NSString.class]) {
        NSDecimalNumber *decimal = [NSDecimalNumber decimalString:obj];
        if (decimal.isANumber) {
            intvalue = [decimal longValue];
        } else {
            NSAssert(0, @"ZCKit: parse long obj is invalid integer");
            intvalue = [obj integerValue];
        }
    } else if (obj == nil || obj == NULL || [obj isKindOfClass:NSNull.class]) {
        if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: parse long obj is null");
    } else {
        NSAssert(0, @"ZCKit: parse long obj is invalid");
    }
    return intvalue;
}

/**< 错误时候默认返回 0，保留有效位数为四舍五入模式，保留6位小数 */
- (float)floatValueForIndex:(NSInteger)index {
    if ([self indexIsInvalidIndex:index]) return 0;
    float flovalue = 0;
    id obj = [self objectAtIndex:index];
    if ([obj isKindOfClass:NSNumber.class]) {
        NSDecimalNumber *decimal = [[NSDecimalNumber decimalNumber:obj] decimalRound:6 mode:ZCEnumRoundTypeRound];
        if (decimal.isANumber) {
            flovalue = (float)[decimal doubleValue];
        } else {
            NSAssert(0, @"ZCKit: parse float obj is invalid number");
        }
    } else if ([obj isKindOfClass:NSString.class]) {
        NSDecimalNumber *decimal = [NSDecimalNumber decimalString:obj];
        if (decimal.isANumber) {
            flovalue = (float)[decimal doubleValue];
        } else {
            NSAssert(0, @"ZCKit: parse float obj is invalid number");
        }
    } else if (obj == nil || obj == NULL || [obj isKindOfClass:NSNull.class]) {
        if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: parse float obj is null");
    } else {
        NSAssert(0, @"ZCKit: parse float obj is invalid");
    }
    return flovalue;
}

/**< 错误时候默认返回 defaultValue */
- (BOOL)boolValueForIndex:(NSInteger)index defaultValue:(BOOL)defalut {
    if ([self indexIsInvalidIndex:index]) return defalut;
    BOOL boolvalue = defalut;
    id obj = [self objectAtIndex:index];
    if ([obj isKindOfClass:NSNumber.class]) {
        if ([obj isEqualToNumber:@(1)] || [[obj stringValue] isEqualToString:@"1"]) {
            boolvalue = YES;
        } else if ([obj isEqualToNumber:@(0)] || [[obj stringValue] isEqualToString:@"0"]) {
            boolvalue = NO;
        } else {
            boolvalue = [obj boolValue];
            NSAssert(0, @"ZCKit: parse bool obj is invalid bool");
        }
    } else if ([obj isKindOfClass:NSString.class]) {
        if ([obj isEqualToString:@"true"] || [obj isEqualToString:@"YES"] || [obj isEqualToString:@"yes"] || [obj isEqualToString:@"1"]) {
            boolvalue = YES;
        } else if ([obj isEqualToString:@"false"] || [obj isEqualToString:@"NO"] || [obj isEqualToString:@"no"] || [obj isEqualToString:@"0"]) {
            boolvalue = NO;
        } else {
            NSAssert(0, @"ZCKit: parse bool obj is invalid bool");
        }
    } else if (obj == nil || obj == NULL || [obj isKindOfClass:NSNull.class]) {
        if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: parse bool obj is null");
    } else {
        NSAssert(0, @"ZCKit: parse bool obj is invalid");
    }
    return boolvalue;
}

/**< 错误时候默认返回 NO */
- (BOOL)boolValueForIndex:(NSInteger)index {
    return [self boolValueForIndex:index defaultValue:NO];
}

@end


#pragma mark - ~ NSMutableArray ~
@implementation NSMutableArray (ZC)

- (void)removeFirstObject {
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

- (void)addObjectIfNoExist:(id)anObject {
    if (anObject && ![self containsObject:anObject]) {
        [self addObject:anObject];
    }
}

- (void)removeObjectIfExist:(id)anObject {
    if (anObject && [self containsObject:anObject]) {
        [self removeObject:anObject];
    }
}

- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index {  
    if (!objects || !objects.count) return;
    if (index < 0 || index > self.count) {
        NSAssert(0, @"ZCKit: array insert value index is invalid");
        return;
    }
    NSUInteger i = index;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)insertObject:(id)object expectIndex:(NSUInteger)expectIndex {
    if (!object) return;
    if (expectIndex < 0 || expectIndex > self.count) {
        expectIndex = self.count;
    }
    [self insertObject:object atIndex:expectIndex];
}

- (void)reverse {
    if (self.count < 2) return;
    NSUInteger count = self.count;
    int mid = floorf(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

- (void)shuffle {
    if (self.count < 2) return;
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1) withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

/**< 注入布尔值(会转换为NSNumber存储) */
- (void)injectBoolValue:(BOOL)value {
    [self injectValue:[NSNumber numberWithBool:value]];
}

/**< 注入整形值(会转换为NSNumber存储) */
- (void)injectLongValue:(long)value {
    [self injectValue:[NSNumber numberWithLong:value]];
}

/**< 注入浮点值(会转换为NSNumber存储) */
- (void)injectFloatValue:(float)value {
    [self injectValue:[NSNumber numberWithFloat:value]];
}

/**< 当value为nil、@""、@"null"时不会注入数组 */
- (void)injectValue:(ZCJsonValue)value {
    if (![ZCGlobal isJsonValue:value]) {
        NSAssert(0, @"ZCKit: array inject value is not json value");
        return;
    }
    if (value == nil || value == NULL) {
        if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: array inject value obj is nil");
    } else if ([value isKindOfClass:NSString.class]) {
        if ([value length] && ![value isEqualToString:@"<null>"] && ![value isEqualToString:@"(null)"]) {
            [self addObject:value];
        } else {
            if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: array inject string obj is invalid");
        }
    } else {
        [self addObject:value];
    }
}

/**< 当value为nil、@""、@"null"时不会注入数组 */
- (void)injectValue:(ZCJsonValue)value forIndex:(NSUInteger)index {
    if (![ZCGlobal isJsonValue:value]) {
        NSAssert(0, @"ZCKit: array inject value is not json value");
        return;
    }
    if (index < 0 || index > self.count) {
        NSAssert(0, @"ZCKit: array inject value index is invalid");
        return;
    }
    if (value == nil || value == NULL) {
        if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: array inject value obj is nil");
    } else if ([value isKindOfClass:NSString.class]) {
        if ([value length] && ![value isEqualToString:@"<null>"] && ![value isEqualToString:@"(null)"]) {
            [self insertObject:value atIndex:index];
        } else {
            if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: array inject string obj is invalid");
        }
    } else {
        [self insertObject:value atIndex:index];
    }
}

@end
