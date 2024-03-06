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
#import "ZCMacro.h"

#pragma mark - ~ NSDictionary ~
@implementation NSDictionary (ZC)

- (NSString *)descriptionWithLocale:(id)locale {
    if (self.jsonFormatString.length) return self.jsonFormatString;
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendFormat:@"\t%@ = %@,\n", key, obj];
    }];
    [str appendString:@"}"];
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) [str deleteCharactersInRange:range];
    return str;
}

#pragma mark - Usually
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
        [arr addObject:[self objectForKey:key]];
    }
    return [arr copy];
}

- (NSArray *)itemDictionaryArrayForKeyKey:(NSString *)keyKey valueKey:(NSString *)valueKey {
    NSMutableArray *array = [NSMutableArray array];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (keyKey) [dic setObject:key forKey:keyKey];
        if (valueKey) [dic setObject:obj forKey:valueKey];
        [array addObject:dic.copy];
    }];
    return array.copy;
}

- (NSDictionary *)dictionaryForKeysOrKeyReplaceKeys:(id)kvsOrKeys {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (kvsOrKeys && [kvsOrKeys isKindOfClass:NSArray.class] && ((NSArray *)kvsOrKeys).count) {
        for (NSString *key in (NSArray *)kvsOrKeys) {
            if ([key isKindOfClass:NSString.class]) {
                id value = [self objectForKey:key];
                if (!value) value = [NSNull null];
                [dic setObject:value forKey:key];
            } else {
                NSAssert(0, @"ZCKit: dic key key is invalid");
            }
        }
    } else if (kvsOrKeys && [kvsOrKeys isKindOfClass:NSDictionary.class] && ((NSDictionary *)kvsOrKeys).count) {
        [(NSDictionary *)kvsOrKeys enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isKindOfClass:NSString.class] && [obj isKindOfClass:NSString.class]) {
                id value = [self objectForKey:key];
                if (!value) value = [NSNull null];
                [dic setObject:value forKey:obj];
            } else {
                NSAssert(0, @"ZCKit: dic key key is invalid");
            }
        }];
    }
    return [dic copy];
}

- (NSDictionary *)dictionaryForKeys:(NSArray *)keys {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (!keys || !keys.count) return [dic copy];
    for (id key in keys) {
        id value = [self objectForKey:key];
        if (value) [dic setObject:value forKey:key];
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

- (id)keyForJsonValue:(id)jsonValue {
    __block id finalKey = nil;
    if (self.count && jsonValue && [ZCGlobal isJsonValue:jsonValue]) {
        [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([ZCGlobal isEqualToJsonValue:jsonValue other:obj]) {
                finalKey = key; *stop = YES;
            }
        }];
    }
    return finalKey;
}

- (BOOL)containsObjectForKey:(id)key {
    if (!key) return NO;
    return ([self objectForKey:key] == nil ? NO : YES);
}

- (BOOL)containsValidObjectForKey:(id)key {
    if (!key) return NO;
    id obj = [self objectForKey:key];
    if (obj == nil || obj == NULL || [obj isKindOfClass:NSNull.class]) return NO;
    if ([obj isKindOfClass:NSString.class]) {
        if (![obj length] || [obj isEqualToString:@"<null>"] || [obj isEqualToString:@"(null)"]) return NO;
    }
    return YES;
}

- (BOOL)containsObjectForValue:(id)value {
    if (!value) return NO;
    return [self.allValues containsObject:value];
}

- (NSString *)jsonFormatString {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error; NSString *jsonStr = nil;
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

#pragma mark - Misc
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
    if ([dictionary isKindOfClass:NSDictionary.class]) return dictionary;
    return nil;
}

+ (NSDictionary *)dictionaryWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self dictionaryWithPlistData:data];
}

#pragma mark - Parse
/**< 键是否有效 */
- (BOOL)keyIsInvalidKey:(NSString *)key {
    if (key != nil && [key isKindOfClass:NSString.class]) return NO;
    NSAssert(0, @"ZCKit: parse dic for key is fail");
    return YES;
}

/**< 错误时候默认返回 nil*/
- (ZCJsonValue)jsonValueForKey:(NSString *)key {
    if ([self keyIsInvalidKey:key]) return nil;
    id obj = [self objectForKey:key];
    if (![ZCGlobal isJsonValue:obj]) {
        NSAssert(0, @"ZCKit: parse json value is not json value");
        return nil;
    }
    return obj;
}

/**< 错误时候默认返回 @[] */
- (NSArray *)arrayValueForKey:(NSString *)key {
    if ([self keyIsInvalidKey:key]) return [NSArray array];
    NSArray *arrvalue = nil;
    id obj = [self objectForKey:key];
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
- (NSDictionary *)dictionaryValueForKey:(NSString *)key {
    if ([self keyIsInvalidKey:key]) return [NSDictionary dictionary];
    NSDictionary *dicvalue = nil;
    id obj = [self objectForKey:key];
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
- (NSString *)stringValueForKey:(NSString *)key {
    if ([self keyIsInvalidKey:key]) return @"";
    NSString *strvalue = nil;
    id obj = [self objectForKey:key];
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
- (NSNumber *)numberValueForKey:(NSString *)key {
    if ([self keyIsInvalidKey:key]) return [NSNumber numberWithFloat:0];
    NSNumber *numvalue = nil;
    id obj = [self objectForKey:key];
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
- (NSDecimalNumber *)decimalValueForKey:(NSString *)key {
    if ([self keyIsInvalidKey:key]) return [NSDecimalNumber zero];
    NSDecimalNumber *decvalue = nil;
    id obj = [self objectForKey:key];
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
- (NSString *)priceValueForKey:(NSString *)key {
    if ([self keyIsInvalidKey:key]) return @"0.00";
    NSString *privalue = nil;
    id obj = [self objectForKey:key];
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
- (long)longValueForKey:(NSString *)key {
    if ([self keyIsInvalidKey:key]) return 0;
    long intvalue = 0;
    id obj = [self objectForKey:key];
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
- (float)floatValueForKey:(NSString *)key {
    if ([self keyIsInvalidKey:key]) return 0;
    float flovalue = 0;
    id obj = [self objectForKey:key];
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
- (BOOL)boolValueForKey:(NSString *)key defaultValue:(BOOL)defalut {
    if ([self keyIsInvalidKey:key]) return defalut;
    BOOL boolvalue = defalut;
    id obj = [self objectForKey:key];
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
- (BOOL)boolValueForKey:(NSString *)key {
    return [self boolValueForKey:key defaultValue:NO];
}

#pragma mark - Check
/**< 判断字典是否含有指定的键，存在未知键则返回nil，否则返回key对应value的数组 */
- (NSArray *)checkInvalidKeys:(NSString *)firstKey,... __attribute__((sentinel)) {
    if (self.count && firstKey) {
        id firstObject = [self objectForKey:firstKey];
        if (firstObject == nil) return nil;
        NSMutableArray *validObjects = [NSMutableArray array];
        [validObjects addObject:firstObject];
        va_list param;
        va_start(param, firstKey);
        NSString *arg;
        BOOL isContain = YES;
        while ((arg = va_arg(param, NSString *))) {
            if (arg) {
                if (!isContain) continue;
                id object = [self objectForKey:arg];
                if (object == nil) isContain = NO;
                else [validObjects addObject:object];
            }
        }
        va_end(param);
        if (isContain) return validObjects;
    }
    return nil;
}

@end


#pragma mark - ~ NSMutableDictionary ~
@implementation NSMutableDictionary (ZC)

/**< 替换键，若传入空键或没有值将按不做处理 */
- (void)replaceKey:(NSString *)originKey toKey:(NSString *)finalKey {
    if (!originKey) return;
    id value = [self objectForKey:originKey];
    if (!value) return;
    [self removeObjectForKey:originKey];
    if (!finalKey) return;
    [self setObject:value forKey:finalKey];
}

/**< 当从dict按keys取值然后按keys注入到self字典中，为nil则不注入 */
- (void)extractKeyValue:(NSDictionary *)dictionary forKeys:(NSArray *)keys {
    if (!keys.count || !dictionary.count) return;
    for (NSString *key in keys) { if (key && [key isKindOfClass:NSString.class]) {
        id object = [dictionary objectForKey:key];
        if (object) [self setObject:object forKey:key];
    }}
}

/**< 注入布尔值(会转换为NSNumber存储) */
- (void)injectBoolValue:(BOOL)value forKey:(NSString *)key {
    [self injectValue:[NSNumber numberWithBool:value] forKey:key];
}

/**< 注入整型值(会转换为NSNumber存储) */
- (void)injectFloatValue:(float)value forKey:(NSString *)key {
    [self injectValue:[NSNumber numberWithFloat:value] forKey:key];
}

/**< 注入长整型值(会转换为NSNumber存储) */
- (void)injectLongValue:(long)value forKey:(NSString *)key {
    [self injectValue:[NSNumber numberWithLong:value] forKey:key];
}

/**< 当value = abnormalValue 不会注入到字典中 */
- (void)injectLongValue:(long)value forKey:(NSString *)key abnormalValue:(long)abnormalValue {
    if (value != abnormalValue) {
        [self injectValue:[NSNumber numberWithLong:value] forKey:key];
    }
}

/**< 当value为nil、@""、@"null"时不会注入字典 */
- (void)injectValue:(ZCJsonValue)value forKey:(NSString *)key {
    [self injectValue:value forKey:key allowNull:NO allowRemove:NO];
}

/**< 当value为nil、@""、@"null"时不会注入字典且会移除之前的键值对 */
- (void)injectValue:(ZCJsonValue)value forAutoKey:(NSString *)autoKey {
    [self injectValue:value forKey:autoKey allowNull:NO allowRemove:YES];
}

/**< allowNull为YES时候，不规则的value值将替换成NSNull注入 */
/**< allowNull为NO时候，allowRemove为NO，不规则的value值将不会注入也不会移除原有值 */
/**< allowNull为NO时候，allowRemove为YES，不规则的value将按key移除之前的key-value */
- (void)injectValue:(ZCJsonValue)value forKey:(NSString *)key allowNull:(BOOL)allowNull allowRemove:(BOOL)allowRemove {
    if ([self keyIsInvalidKey:key value:value allowNull:allowNull allowRemove:allowRemove]) return;
    if (allowNull && (value == nil || value == NULL)) {
        [self setObject:[NSNull null] forKey:key]; return;
    }
    if ([value isKindOfClass:NSString.class]) {
        if (allowNull) {
            if ([value isEqualToString:@"<null>"] || [value isEqualToString:@"(null)"]) {
                [self setObject:[NSNull null] forKey:key];
            } else {
                [self setObject:value forKey:key];
            }
        } else if ([value length] && ![value isEqualToString:@"<null>"] && ![value isEqualToString:@"(null)"]) {
            [self setObject:value forKey:key];
        } else {
            if (allowRemove) {
                [self removeObjectForKey:key];
            } else {
                if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: dic inject string obj is invalid");
            }
        }
    } else {
        [self setObject:value forKey:key];
    }
}

- (BOOL)keyIsInvalidKey:(NSString *)key value:(id)value allowNull:(BOOL)allowNull allowRemove:(BOOL)allowRemove {
    if (key == nil || ![key isKindOfClass:NSString.class]) {
        NSAssert(0, @"ZCKit: dic inject key obj is invalid");
        return YES;
    }
    if (![ZCGlobal isJsonValue:value]) {
        NSAssert(0, @"ZCKit: dic inject value is not json value");
        return YES;
    }
    if (allowNull) {
        return NO;
    }
    if (value == nil || value == NULL) {
        if (allowRemove) {
            [self removeObjectForKey:key];
        } else {
            if (ZCKitBridge.isPrintLog) kZLog(@"ZCKit: dic inject value obj is nil");
        }
        return YES;
    }
    return NO;
}

@end
