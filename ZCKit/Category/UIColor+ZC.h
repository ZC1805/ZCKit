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

+ (UIColor *)colorFromHexString:(NSString *)hexColorStr;   /**< 十六进制颜色@"0x000000" */

+ (UIColor *)colorFormHex:(NSInteger)hexValue alpha:(float)alpha;   /**< 十六进制颜色0x000000 */

+ (UIColor *)colorFormRad:(int)intR green:(int)intG blue:(int)intB alpha:(float)alpha;   /**< 十进制颜色255 */


- (UIColor *)brightColor;   /**< 明色 */

- (UIColor *)darkColor;   /**< 暗色 */

- (BOOL)isClear;   /**< 是否是透明颜色 */

- (float)R;   /**< 0~1，不适合white、black等颜色 */

- (float)G;

- (float)B;

- (float)A;

@end





