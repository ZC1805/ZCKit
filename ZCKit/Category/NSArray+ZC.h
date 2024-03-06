//
//  NSArray+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/28.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCGlobal.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (ZC)

- (nullable id)randomObject;  /**< 随机值 */

- (NSArray *)subArrayValueForRange:(NSRange)range;  /**< 返回指定值 */

- (nullable id)objectOrNilAtIndex:(NSUInteger)index;  /**< 越界返回nil */

- (NSArray *)restExceptObjects:(NSArray *)objects;  /**< 返回余下的对象数组 */

- (nullable id)objectForPropertyName:(NSString *)propertyName propertyValue:(id)propertyValue;  /**< 返回能匹配到第一个成员的键值 */

- (NSInteger)indexForPropertyName:(NSString *)propertyName propertyValue:(id)propertyValue;  /**< 返回能匹配到第一个成员的键值对象的index，没找到返回-1 */

- (NSArray *)objectValueArrayForKey:(NSString *)key defaultValue:(id)defaultValue;  /**< 返回成员对象按key取值得到的value的数组 */

- (NSString *)jsonFormatString;  /**< 返回json字符串，已经做格式化显示处理 */

- (nullable NSString *)jsonString;  /**< 返回json字符串，未做格式化处理 */

#pragma mark - Parse
- (nullable ZCJsonValue)jsonValueForIndex:(NSInteger)index;

- (NSArray *)arrayValueForIndex:(NSInteger)index;

- (NSDictionary *)dictionaryValueForIndex:(NSInteger)index;

- (NSString *)stringValueForIndex:(NSInteger)index;

- (NSNumber *)numberValueForIndex:(NSInteger)index;

- (NSDecimalNumber *)decimalValueForIndex:(NSInteger)index;

- (NSString *)priceValueForIndex:(NSInteger)index;

- (long)longValueForIndex:(NSInteger)index;

- (float)floatValueForIndex:(NSInteger)index;

- (BOOL)boolValueForIndex:(NSInteger)index;

- (BOOL)boolValueForIndex:(NSInteger)index defaultValue:(BOOL)defalut;

#pragma mark - Misc
- (nullable NSData *)plistData;

- (nullable NSString *)plistString;

+ (nullable NSArray *)arrayWithPlistData:(NSData *)plist;

+ (nullable NSArray *)arrayWithPlistString:(NSString *)plist;

@end


@interface NSMutableArray (ZC)

- (void)removeFirstObject;  /**< 移除首位 */

- (void)addObjectIfNoExist:(nullable id)anObject;  /**< 非空且不包含时才添加此对象 */

- (void)removeObjectIfExist:(nullable id)anObject;  /**< 非空且包含时才移除此对象 */

- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index;  /**< 插入数组 */

- (void)insertObject:(id)object expectIndex:(NSUInteger)expectIndex;  /**< 插入数据，坐标匹配不上默认追加到末尾 */

- (void)reverse;  /**< 首尾倒置排列 */

- (void)shuffle;  /**< 重新乱序排列 */

- (void)injectBoolValue:(BOOL)value;  /**< 末尾添加数据 */

- (void)injectLongValue:(long)value;  /**< 末尾添加数据 */

- (void)injectFloatValue:(float)value;  /**< 末尾添加数据 */

- (void)injectValue:(nullable ZCJsonValue)value;  /**< 末尾添加数据 */

- (void)injectValue:(nullable ZCJsonValue)value forIndex:(NSUInteger)index;  /**< 插入数据 */

@end

NS_ASSUME_NONNULL_END
