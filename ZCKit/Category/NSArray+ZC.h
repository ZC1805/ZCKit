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

- (nullable NSString *)jsonString;

- (nullable NSData *)plistData;

- (nullable NSString *)plistString;

+ (nullable NSArray *)arrayWithPlistData:(nullable NSData *)plist;

+ (nullable NSArray *)arrayWithPlistString:(nullable NSString *)plist;

@end


@interface NSMutableArray (ZC)

- (void)removeFirstObject;   /**< 移除首位 */

- (void)insertObjects:(nullable NSArray *)objects atIndex:(NSUInteger)index;  /**< 插入数组 */

- (void)reverse;   /**< 反向排列 */

- (void)shuffle;   /**< 重新排列 */

@end

NS_ASSUME_NONNULL_END











