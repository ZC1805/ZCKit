//
//  NSObject+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/6.
//  Copyright © 2018年 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZC)

@property (nonatomic, weak) id voidProperty;   /**< 通用属性 */

+ (NSArray *)allIvars;   /**< 所有实例变量 */

+ (NSArray *)allProperies;   /**< 所有属性 */

+ (NSArray *)allSubclasses;   /**< 所有子类 */

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;   /**< 替换实例方法，返回是否成功 */

+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;   /**< 替换类方法，返回是否成功 */

- (NSDictionary *)allKeysValus;   /**< 实例变量键值对 */

- (id)performSelector:(SEL)selector arguments:(NSArray *)arguments;   /**< 多参数 */

@end







