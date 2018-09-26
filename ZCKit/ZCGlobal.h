//
//  ZCGlobal.h
//  ZCKit
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCGlobal : NSObject

#pragma mark - misc
+ (BOOL)isiPhoneX;

+ (BOOL)isLandscape;

+ (BOOL)isValidString:(NSString *)str;

+ (NSString *)resourcePath:(nullable NSString *)bundleName name:(NSString *)name ext:(NSString *)ext;


+ (nullable UIViewController *)topController:(nullable UIViewController *)rootvc;  /**< 顶控制器，初始rootvc可为nil */

+ (nullable UIViewController *)currentController;  /**< 当前控制器 */

+ (nullable UIViewController *)rootController;  /**< 根控制器 */

#pragma mark - layout
+ (CGFloat)leadingSpacing;  /**< 到屏幕安全左边距离 -> 0、44 */

+ (CGFloat)trailingSpacing;  /**< 到屏幕安全右边距离 -> 0、44 */

+ (CGFloat)statusBarHeight;  /**< 状态栏高度 -> 0、20、44 */

+ (CGFloat)naviShadowHeight;  /**< 导航条阴影高度 -> 0、1 */

+ (CGFloat)naviBarHeight;  /**< 导航条高度 -> 0、32、44、96 */

+ (CGFloat)naviHeight;  /**< 导航栏高度 -> 0、32、44、64、88、116、140 (导航栏隐藏时高度为0) */

+ (CGFloat)topFringeHeight;  /**< 顶部刘海底部到屏幕顶部距离 -> 0、30 */

+ (CGFloat)bottomFringeHeight;  /**< 底部刘海顶部到屏幕底部距离 -> 0、13 */

+ (CGFloat)topReserveHeight;  /**< 顶部保留高度，即顶部刘海安全高度 -> 0、44 */

+ (CGFloat)bottomReserveHeight;  /**< 底部保留高度，即底部刘海安全高度 -> 0、21、34 */

+ (CGFloat)tabBarHeight;  /**< tabbar高度(暂不适用于横竖屏交换) -> 值为:0、32、49、53、83 */

+ (CGFloat)tabHeight;  /**< 底部高度(暂不适用于横竖屏交换) -> 值为:0、21、32、34、49、53、83 */

@end

NS_ASSUME_NONNULL_END









