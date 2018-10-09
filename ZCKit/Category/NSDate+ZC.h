//
//  NSDate+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/28.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ZC)

#pragma mark - usually
@property (nonatomic, readonly) NSInteger year;         /**< 年 */
@property (nonatomic, readonly) NSInteger month;        /**< 月 (1~12) */
@property (nonatomic, readonly) NSInteger day;          /**< 日 (1~31) */
@property (nonatomic, readonly) NSInteger hour;         /**< 时 (0~23) */
@property (nonatomic, readonly) NSInteger minute;       /**< 分 (0~59) */
@property (nonatomic, readonly) NSInteger second;       /**< 秒 (0~59) */
@property (nonatomic, readonly) NSInteger nanosecond;   /**< 毫秒 (0~999) */
@property (nonatomic, readonly) NSInteger weekday;      /**< 周几，周日为7 (1~7) */
@property (nonatomic, readonly) NSInteger weekdayOrdinal;   /**< 月的第几个周几，每周从周日算起 */
@property (nonatomic, readonly) NSInteger weekOfMonth;      /**< 月的第几周，每周从周日算起 (1~5) */
@property (nonatomic, readonly) NSInteger weekOfYear;       /**< 年的第几周，每周从周日算起 (1~53) */

@property (nonatomic, readonly) BOOL isLeapMonth;       /**< 是否是闰月 */
@property (nonatomic, readonly) BOOL isLeapYear;        /**< 是否是闰年 */
@property (nonatomic, readonly) BOOL isToday;           /**< 是否是今天 (based on current locale) */
@property (nonatomic, readonly) BOOL isYesterday;       /**< 是否是昨天 (based on current locale) */
@property (nonatomic, readonly) BOOL isTomorrow;        /**< 是否是明天 (based on current locale) */
@property (nonatomic, readonly) BOOL isWeekend;         /**< 是否是周末 (based on current locale) */
@property (nonatomic, readonly) BOOL isThisYear;        /**< 是否是今年 (based on current locale) */


#pragma mark - adding
- (nullable NSDate *)dateByAddingYears:(NSInteger)years;

- (nullable NSDate *)dateByAddingMonths:(NSInteger)months;

- (nullable NSDate *)dateByAddingWeeks:(NSInteger)weeks;

- (nullable NSDate *)dateByAddingDays:(NSInteger)days;

- (nullable NSDate *)dateByAddingHours:(NSInteger)hours;

- (nullable NSDate *)dateByAddingMinutes:(NSInteger)minutes;

- (nullable NSDate *)dateByAddingSeconds:(NSInteger)seconds;


#pragma mark - format
- (NSString *)stringWithFormat:(nullable NSString *)format;   /**< 返回格式化时间 */

- (NSString *)stringWithFormat:(nullable NSString *)format timeZone:(nullable NSTimeZone *)timeZone locale:(nullable NSLocale *)locale;

+ (NSDateFormatter *)preciseFormatter;   /**< yyyy-MM-dd HH:mm:ss.SSS，dateFormatter外部不可对其属性赋值 */

+ (NSDateFormatter *)normalFormatter;   /**< yyyy-MM-dd HH:mm:ss，dateFormatter外部不可对其属性赋值 */

+ (NSDateFormatter *)dateFormatter;   /**< yyyy-MM-dd，dateFormatter外部不可对其属性赋值 */

+ (NSDateFormatter *)timeFormatter;   /**< HH:mm:ss，dateFormatter外部不可对其属性赋值 */

+ (NSString *)dateStringWithTime:(long)timeInterval format:(nullable NSString *)format;   /**< timeInterval为13位时可算上了三位毫秒数 */

+ (nullable NSDate *)dateWithString:(nullable NSString *)dateString format:(nullable NSString *)format;

+ (nullable NSDate *)dateWithString:(nullable NSString *)dateString format:(nullable NSString *)format
                           timeZone:(nullable NSTimeZone *)timeZone locale:(nullable NSLocale *)locale;

@end

NS_ASSUME_NONNULL_END











