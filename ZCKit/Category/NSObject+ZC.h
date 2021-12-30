//
//  NSObject+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/6.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZC)

+ (NSArray *)allIvarsName;  /**< 所有实例变量 */

+ (NSArray *)allMethodsName;  /**< 所有方法名字 */

+ (NSArray *)allProperiesName;  /**< 所有属性 */

+ (NSArray *)allSubclasses;  /**< 所有子类 */

- (NSDictionary *)allIvarsKeysValus;  /**< 实例变量键值对 */

- (nullable id)performSelector:(SEL)selector arguments:(nullable NSArray *)arguments;  /**< 多参数 */

@end

NS_ASSUME_NONNULL_END
