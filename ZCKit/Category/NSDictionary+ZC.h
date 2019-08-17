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

- (NSArray *)allKeysSorted;  /**< 返回排序好的所有键 */

- (NSArray *)allValuesSortedByKeys;  /**< 返回按键排序好的所有值 */

- (NSDictionary *)dictionaryForKeys:(NSArray *)keys;  /**< 返回所有目标键组合的子字典 */

- (NSDictionary *)restExceptForKeys:(NSArray *)keys;  /**< 返回余下的键值对的字典 */

- (BOOL)containsObjectForKey:(id)key;  /**< 是否包含某个键 */

- (BOOL)containsObjectForValue:(id)value;  /**< 是否包含某个值 */

- (NSString *)jsonString;  /**< 返回json字符串 */

#pragma mark - parse
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

- (nullable NSArray *)checkInvalidKeys:(NSString *)firstKey,... __attribute__((sentinel));

#pragma mark - misc
- (nullable NSData *)plistData;

- (nullable NSString *)plistString;

+ (nullable NSDictionary *)dictionaryWithPlistData:(NSData *)plist;

+ (nullable NSDictionary *)dictionaryWithPlistString:(NSString *)plist;

@end


@interface NSMutableDictionary (ZC)

- (void)injectBoolValue:(BOOL)value forKey:(NSString *)key;

- (void)injectFloatValue:(float)value forKey:(NSString *)key;

- (void)injectLongValue:(long)value forKey:(NSString *)key;

- (void)injectLongValue:(long)value forKey:(NSString *)key abnormalValue:(long)abnormalValue;

- (void)injectValue:(ZCJsonValue)value forKey:(NSString *)key;

- (void)injectValue:(nullable ZCJsonValue)value forAutoKey:(NSString *)autoKey;

- (void)injectValue:(nullable ZCJsonValue)value forKey:(NSString *)key allowNull:(BOOL)allowNull allowRemove:(BOOL)allowRemove;

@end

NS_ASSUME_NONNULL_END

