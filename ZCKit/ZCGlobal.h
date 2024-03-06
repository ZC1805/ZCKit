//
//  ZCGlobal.h
//  ZCKit
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef id ZCJsonValue;  /**< 只可为 nil & NSString & NSNumber & NSArray & NSDictionary 这五种 */

@protocol ZCJsonProtocol <NSObject>

@property (nonatomic, assign) BOOL isJsonValue;

@end


@interface ZCGlobal : NSObject  /**< 全局管理类 */

#pragma mark - Misc1
+ (CGFloat)ratio;  /**< 按375适配的单位比例点 */

+ (BOOL)isiPhoneX;  /**< 是否是iPhoneX系列手机 */

+ (BOOL)isLandscape;  /**< 当前手机是否是横屏状态 */

+ (BOOL)isJsonValue:(nullable ZCJsonValue)value;  /**< 是否是ZCJsonValue */

+ (BOOL)isEqualToJsonValue:(nullable ZCJsonValue)value1 other:(nullable ZCJsonValue)value2;  /**< 是否相等 */

+ (BOOL)isValidString:(nullable NSString *)str;  /**< 非空长度 & 不只首尾空格和换行 & 非<null> */

+ (BOOL)isValidArray:(nullable NSArray *)array;  /**< 判断对象是否是有效的数组 & count不为零 */

+ (BOOL)isValidDictionary:(nullable NSDictionary *)dictionary;  /**< 判断对象是否是有效的字典 & count不为零 */

+ (BOOL)isExplicitArray:(nullable NSArray *)array elementClass:(Class)elementClass;  /**< 判断数组是否是指定元素类型的数组，空数组时返回YES */

+ (nullable NSString *)resourcePath:(nullable NSString *)bundle name:(NSString *)name ext:(NSString *)ext;  /**< 资源文件路径 */

+ (nullable UIImage *)ZCImageName:(NSString *)imageName;  /**< ZCBundle中图片资源 */

#pragma mark - Misc2
+ (nullable UIViewController *)topController:(nullable UIViewController *)rootvc;  /**< 顶控制器，初始rootvc可为nil */

+ (nullable UIViewController *)currentController;  /**< 当前控制器 */

+ (nullable UIViewController *)rootController;  /**< 根控制器 */

@end

NS_ASSUME_NONNULL_END
