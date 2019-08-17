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

- (nullable id)objectOrNilAtIndex:(NSUInteger)index;  /**< 越界返回nil */

- (NSArray *)restExceptObjects:(NSArray *)objects;  /**< 返回余下的对象数组 */

- (nullable id)objectForPropertyName:(NSString *)propertyName propertyValue:(id)propertyValue;  /**< 返回能匹配到成员的键值 */

- (NSString *)jsonString;  /**< 返回json字符串 */

#pragma mark - misc
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

- (void)reverse;  /**< 首尾倒置排列 */

- (void)shuffle;  /**< 重新乱序排列 */

- (void)injectValue:(nullable ZCJsonValue)value;  /**< 插入数据 */

- (void)injectValue:(nullable ZCJsonValue)value forIndex:(NSUInteger)index;  /**< 插入数据 */

@end

NS_ASSUME_NONNULL_END

