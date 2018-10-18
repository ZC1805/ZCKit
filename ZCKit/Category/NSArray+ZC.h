//
//  NSArray+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/28.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (ZC)

- (nullable id)randomObject;

- (nullable id)objectOrNilAtIndex:(NSUInteger)index;

- (NSArray *)restExceptObjects:(NSArray *)objects;   /**< 返回余下的对象数组 */

- (nullable id)objectForPropertyName:(NSString *)propertyName propertyValue:(id)propertyValue;   /**< 返回能匹配到成员的键值 */

- (nullable NSString *)jsonString;

#pragma mark - misc
- (nullable NSData *)plistData;

- (nullable NSString *)plistString;

+ (nullable NSArray *)arrayWithPlistData:(NSData *)plist;

+ (nullable NSArray *)arrayWithPlistString:(NSString *)plist;

@end


@interface NSMutableArray (ZC)

- (void)removeFirstObject;   /**< 移除首位 */

- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index;  /**< 插入数组 */

- (void)reverse;   /**< 反向排列 */

- (void)shuffle;   /**< 重新排列 */

@end

NS_ASSUME_NONNULL_END

