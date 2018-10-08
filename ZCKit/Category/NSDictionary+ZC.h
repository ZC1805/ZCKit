//
//  NSDictionary+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/28.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ZC)

- (nullable id)randomValue;   /**< 随机值 */

- (NSArray *)allKeysSorted;   /**< 返回排序好的所有键 */

- (NSArray *)allValuesSortedByKeys;   /**< 返回按键排序好的所有值 */

- (NSDictionary *)dictionaryForKeys:(nullable NSArray *)keys;   /**< 返回所有目标键组合的子字典 */

- (NSDictionary *)restExceptForKeys:(nullable NSArray *)keys;   /**< 返回余下的键值对的字典 */

- (BOOL)containsObjectForKey:(id)key;

- (BOOL)containsObjectForValue:(id)value;

- (nullable NSString *)jsonString;

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

+ (nullable NSDictionary *)dictionaryWithPlistData:(nullable NSData *)plist;

+ (nullable NSDictionary *)dictionaryWithPlistString:(nullable NSString *)plist;

@end


@interface NSMutableDictionary (ZC)

- (void)injectBoolValue:(BOOL)value forKey:(NSString *)key;

- (void)injectFloatValue:(float)value forKey:(NSString *)key;

- (void)injectLongValue:(long)value forKey:(NSString *)key;

- (void)injectValue:(id)value forKey:(NSString *)key;

- (void)injectStringValue:(NSString *)value forKey:(NSString *)key allowNull:(BOOL)allowNull;

- (void)injectValue:(id)value forKey:(NSString *)key allowNull:(BOOL)allowNull;

@end

NS_ASSUME_NONNULL_END










