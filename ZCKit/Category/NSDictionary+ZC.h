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

- (BOOL)containsObjectForKey:(id)key;

- (BOOL)containsObjectForValue:(id)value;

- (nullable NSString *)jsonString;

- (nullable NSData *)plistData;

- (nullable NSString *)plistString;

+ (nullable NSDictionary *)dictionaryWithPlistData:(nullable NSData *)plist;

+ (nullable NSDictionary *)dictionaryWithPlistString:(nullable NSString *)plist;

@end



@interface NSMutableDictionary (ZC)

@end

NS_ASSUME_NONNULL_END










