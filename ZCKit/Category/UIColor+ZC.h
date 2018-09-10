//
//  UIColor+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/10.
//  Copyright © 2018年 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZC)

+ (instancetype)randColor;   /**< 随机颜色 */

+ (UIColor *)colorFromString:(NSString *)hexColorStr;   /**< 十六进制颜色@"0x000000" */

+ (UIColor *)colorFormHex:(NSInteger)hexValue alpha:(CGFloat)alpha;   /**< 十六进制颜色0x000000 */

- (CGFloat)R;   /**< 0~1，不适合white、black等颜色 */

- (CGFloat)G;

- (CGFloat)B;

- (CGFloat)A;

- (BOOL)isClear;   /**< 是否是透明颜色 */

- (UIColor *)darkColor;   /**< 暗色 */

- (UIColor *)brightColor;   /**< 明色 */

@end





