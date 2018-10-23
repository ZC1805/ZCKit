//
//  ZCDateManager.h
//  ZCKit
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCDateManager : NSObject

@property (nonatomic, copy, readonly) NSString *today;  /**< 今天的年月日，2018-09-30 */

@property (nonatomic, strong, readonly) NSLocale *chinaLocale;  /**< 中国国家信息 */

@property (nonatomic, strong, readonly) NSTimeZone *beijingTimeZone;  /**< 东八时区 */

@property (nonatomic, strong, readonly) NSCalendar *gregorianCalendar;  /**< 中国公历，使用的中国时区 */

@property (nonatomic, strong, readonly) NSCalendar *chineseCalendar;  /**< 中国农历，使用的中国时区 */


+ (instancetype)instance;

+ (NSDateFormatter *)dateFormatter:(NSString *)format;  /**< 此处拿到的DateFormatter有缓存，外部不可对其属性赋值 */

+ (NSString *)chineseDate:(NSDate *)date;  /**< 返回中国农历日期，date时间为标准时区时间，戊戌年九月初八 */

+ (NSString *)showPastTime:(NSTimeInterval)interval detail:(BOOL)detail;  /**< 过去的时间描述，detail显示具体时分，昨天 早上6:00 */

@end

NS_ASSUME_NONNULL_END

