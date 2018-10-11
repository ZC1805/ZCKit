//
//  NSObject+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/6.
//  Copyright © 2018年 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZC)

@property (nullable, nonatomic, weak) id voidProperty;   /**< 通用属性 */

+ (NSArray *)allIvarsName;   /**< 所有实例变量 */

+ (NSArray *)allProperiesName;   /**< 所有属性 */

+ (NSArray *)allSubclasses;   /**< 所有子类 */

+ (BOOL)swizzleInstanceMethod:(SEL)originSel with:(SEL)newSel;   /**< 替换实例方法，返回是否成功 */

+ (BOOL)swizzleClassMethod:(SEL)originSel with:(SEL)newSel;   /**< 替换类方法，返回是否成功 */

- (NSDictionary *)allIvarsKeysValus;   /**< 实例变量键值对 */

- (nullable id)performSelector:(SEL)selector arguments:(nullable NSArray *)arguments;   /**< 多参数 */

@end

NS_ASSUME_NONNULL_END

