//
//  NSDictionary+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/28.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCGlobal.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ZC)

- (nullable id)randomValue;  /**< 随机值 */

- (NSArray *)allKeysSorted;  /**< 返回排序好的所有键，忽略大小写 */

- (NSArray *)allValuesSortedByKeys;  /**< 返回按键排序好的所有值 */

- (NSArray *)itemDictionaryArrayForKeyKey:(NSString *)keyKey valueKey:(NSString *)valueKey;  /**< 返回用字典中每对键值对分别作值组成一个新的字典的数组 */

- (NSDictionary *)dictionaryForKeysOrKeyReplaceKeys:(id)kvsOrKeys;  /**< 返回所有目标键或者替换目标键的键值对字典，没有查询到的键值对按NSNull值注入 */

- (NSDictionary *)dictionaryForKeys:(NSArray *)keys;  /**< 返回所有目标键组合的子字典，没有查询到对应的值则不会将键值对加入到新字典中 */

- (NSDictionary *)restExceptForKeys:(NSArray *)keys;  /**< 返回余下的键值对的字典 */

- (nullable id)keyForJsonValue:(id)jsonValue;  /**< 返回根据值匹配到的第一个键值对的键 */

- (BOOL)containsObjectForKey:(id)key;  /**< 是否包含某个键 */

- (BOOL)containsValidObjectForKey:(id)key;  /**< 是否包含某个有效的键，nil 、null、@""都返回NO */

- (BOOL)containsObjectForValue:(id)value;  /**< 是否包含某个值 */

- (NSString *)jsonFormatString;  /**< 返回json字符串，已经做格式化显示处理 */

- (nullable NSString *)jsonString;  /**< 返回json字符串，未做格式化处理 */

#pragma mark - Parse
- (nullable ZCJsonValue)jsonValueForKey:(NSString *)key;

- (NSArray *)arrayValueForKey:(NSString *)key;

- (NSDictionary *)dictionaryValueForKey:(NSString *)key;

- (NSString *)stringValueForKey:(NSString *)key;

- (NSNumber *)numberValueForKey:(NSString *)key;

- (NSDecimalNumber *)decimalValueForKey:(NSString *)key;

- (NSString *)priceValueForKey:(NSString *)key;

- (long)longValueForKey:(NSString *)key;

- (float)floatValueForKey:(NSString *)key;

- (BOOL)boolValueForKey:(NSString *)key;

- (BOOL)boolValueForKey:(NSString *)key defaultValue:(BOOL)defalut;

#pragma mark - Misc
- (nullable NSData *)plistData;

- (nullable NSString *)plistString;

+ (nullable NSDictionary *)dictionaryWithPlistData:(NSData *)plist;

+ (nullable NSDictionary *)dictionaryWithPlistString:(NSString *)plist;

- (nullable NSArray *)checkInvalidKeys:(NSString *)firstKey,... __attribute__((sentinel));

@end


@interface NSMutableDictionary (ZC)

- (void)replaceKey:(NSString *)originKey toKey:(NSString *)finalKey;

- (void)extractKeyValue:(NSDictionary *)dictionary forKeys:(NSArray *)keys;

- (void)injectBoolValue:(BOOL)value forKey:(NSString *)key;

- (void)injectFloatValue:(float)value forKey:(NSString *)key;

- (void)injectLongValue:(long)value forKey:(NSString *)key;

- (void)injectLongValue:(long)value forKey:(NSString *)key abnormalValue:(long)abnormalValue;

- (void)injectValue:(nullable ZCJsonValue)value forKey:(NSString *)key;

- (void)injectValue:(nullable ZCJsonValue)value forAutoKey:(NSString *)autoKey;

- (void)injectValue:(nullable ZCJsonValue)value forKey:(NSString *)key allowNull:(BOOL)allowNull allowRemove:(BOOL)allowRemove;

@end

NS_ASSUME_NONNULL_END
