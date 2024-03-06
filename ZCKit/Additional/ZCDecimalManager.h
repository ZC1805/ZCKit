//
//  ZCDecimalManager.h
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZCEnumRoundType) {
    ZCEnumRoundTypeRound = 0,  /**< 四舍五入 */
    ZCEnumRoundTypeDown  = 1,  /**< 只舍不入 */
    ZCEnumRoundTypeUp    = 2,  /**< 只入不舍 */
};

@interface ZCDecimalManager : NSObject <NSDecimalNumberBehaviors>  /**< 浮点数计算类 */

#pragma mark - Decimal number
/**< 获取DecimalHandler，来处理四舍五入 */
+ (NSDecimalNumberHandler *)decimalHandler:(int)decimal type:(ZCEnumRoundType)type;

/**< 转换成->NSDecimalNumber，会四舍五入处理，number为nil返回notANumbet */
+ (NSDecimalNumber *)decimalNumber:(NSNumber *)number decimalPoint:(int)point roundMode:(ZCEnumRoundType)mode;

/**< 舍入转换成string显示，zero是否舍去末尾0，number为nil返回@"NaN" */
+ (NSString *)roundNumber:(NSNumber *)number decimalPoint:(int)point roundMode:(ZCEnumRoundType)mode roundZero:(BOOL)zero;

/**< 四舍五入转换成string显示，且舍去末尾0，小于6位精度 */
+ (NSString *)roundString:(nullable NSString *)string orDouble:(double)dou decimalPoint:(int)point;

/**< 四舍五入转换成标准价格显示，四舍五入，不规范传入格式返回0.00 */
+ (nullable NSString *)priceFormat:(nullable NSNumber *)number orString:(nullable NSString *)string orDouble:(double)dou;

/**< 保留指定位数有效小数，后面舍去 */
+ (nullable NSString *)formatFloorNumber:(NSNumber *)number digits:(int)digits;

#pragma mark - Number function
/**< 唯一实例 */
+ (instancetype)sharedManager;

/**< 去除无效数字，只对浮点数有用 */
+ (NSString *)stringDisposeWithFloatString:(NSString *)floatString;

/**< 计算浮点数的有效小数位数，最大六位小数 */
+ (int)calculateDecimalDigitFromFloat:(double)dou;

/**< 计算字符串的小数位，最大六位小数 */
+ (int)calculateDecimalDigitFromString:(NSString *)str;

/**< string类型精确为字符串类型 */
+ (NSString *)preciseString:(NSString *)strvalue;

/**< double类型精确为字符串类型 */
+ (NSString *)preciseDouble:(double)douvalue;

@end

NS_ASSUME_NONNULL_END
