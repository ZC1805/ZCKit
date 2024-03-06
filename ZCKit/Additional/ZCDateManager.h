//
//  ZCDateManager.h
//  ZCKit
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCalendar (ZC)  /**< 日历处理类 */

@property (class, nonatomic, readonly) NSCalendar *gregorianCalendar;  /**< 公历 */

@end


@interface ZCDateManager : NSObject  /**< 日期处理类 */

@property (class, nonatomic, readonly) NSLocale *chinaLocale;  /**< 简体中文语言环境 */

@property (class, nonatomic, readonly) NSTimeZone *beijingTimeZone;  /**< 东八时区 */

@property (class, nonatomic, readonly) NSCalendar *chineseCalendar;  /**< 中国农历，使用的北京时区 */

@property (class, nonatomic, readonly) NSCalendar *chineseGregorianCalendar;  /**< 中国公历，使用的北京时区 */

@property (class, nonatomic, readonly) NSLocale *appLocale;  /**< 应用默认语言环境 */

@property (class, nonatomic, readonly) NSTimeZone *appTimeZone;  /**< 应用默认时区 */


+ (NSDateFormatter *)dateFormatter:(NSString *)format;  /**< 此处拿到的DateFormatter有缓存，外部不可对其属性赋值 */

+ (NSString *)chineseDate:(NSDate *)date;  /**< 返回中国农历日期，date时间为标准时区时间，戊戌年九月初八 */

+ (NSString *)showPastTime:(NSTimeInterval)interval detail:(BOOL)detail;  /**< 过去的时间描述，detail显示具体时分，昨天 早上6:00 */

@end

NS_ASSUME_NONNULL_END
