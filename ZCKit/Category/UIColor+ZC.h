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

@property (nonatomic, readonly) CGFloat R;  /**< 0~1 */

@property (nonatomic, readonly) CGFloat G;  /**< 0~1 */

@property (nonatomic, readonly) CGFloat B;  /**< 0~1 */

@property (nonatomic, readonly) CGFloat A;  /**< 0~1 */

@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;  /**< 色彩空间 */


+ (UIColor *)colorForRandomColor;  /**< 随机颜色 */

+ (UIColor *)colorFromHexString:(NSString *)hexColorStr;  /**< 十六进制颜色@"0x000000" & @"#000000" & @"000000" */

+ (UIColor *)colorFormHex:(NSInteger)hexValue alpha:(float)alpha;  /**< 十六进制颜色0x000000 */

+ (UIColor *)colorFormRad:(int)intR green:(int)intG blue:(int)intB alpha:(float)alpha;  /**< 十进制颜色255 */


- (BOOL)isClear;  /**< 是否是透明颜色或透明度小于0.01 */

- (UIColor *)brightColor;  /**< 明色 */

- (UIColor *)darkColor;  /**< 暗色 */

- (uint32_t)RGBValue;  /**< such as 0x66CCFF */

- (uint32_t)RGBAValue;  /**< such as 0x66CCFFFF */

- (nullable NSString *)hexString;  /**< such as @"66CCFF" */

- (nullable NSString *)hexStringWithAlpha;  /**< such as @"0066CCFF" */

@end

NS_ASSUME_NONNULL_END

