//
//  UIColor+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/10.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ZC)

@property (nonatomic, readonly) CGColorSpaceModel colorSpaceType;  /**< 色彩空间 */

+ (UIColor *)colorForRandomColor;  /**< 随机颜色 */

+ (UIColor *)colorFormHex:(long)hexValue alpha:(float)alpha;  /**< 十六进制颜色0x000000 */

+ (UIColor *)colorFromHexString:(NSString *)hexColorStr alpha:(float)alpha;  /**< 十六进制颜色@"0x000000" & @"#000000" & @"000000" */

+ (UIColor *)colorFormRad:(int)intR green:(int)intG blue:(int)intB alpha:(float)alpha;  /**< 十进制颜色255 */

+ (UIColor *)colorFromGradientColors:(NSArray <UIColor *>*)colors isHorizontal:(BOOL)isHorizontal;  /**< 渐变颜色 */

- (BOOL)isClear;  /**< 是否是透明颜色或透明度小于0.01 */

- (uint32_t)RGBValue;  /**< such as 0x66CCFF */

- (uint32_t)RGBAValue;  /**< such as 0x66CCFFFF */

- (UIColor *)colorFromAlpha:(float)alpha;  /**< 按透明度生成新的颜色 */

@end

NS_ASSUME_NONNULL_END
