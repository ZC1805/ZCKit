//
//  NSDate+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/28.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "NSDate+ZC.h"
#import "ZCDateManager.h"

@implementation NSDate (ZC)

#pragma mark - Usually
- (NSInteger)year {
    return [[NSCalendar.gregorianCalendar components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month {
    return [[NSCalendar.gregorianCalendar components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day {
    return [[NSCalendar.gregorianCalendar components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour {
    return [[NSCalendar.gregorianCalendar components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute {
    return [[NSCalendar.gregorianCalendar components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second {
    return [[NSCalendar.gregorianCalendar components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)nanosecond {
    return [[NSCalendar.gregorianCalendar components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

- (NSInteger)weekday {
    NSInteger weekday = [[NSCalendar.gregorianCalendar components:NSCalendarUnitWeekday fromDate:self] weekday];
    return weekday == 1 ? 7 : (weekday - 1);
}

- (NSInteger)weekdayOrdinal {
    return [[NSCalendar.gregorianCalendar components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)weekOfMonth {
    return [[NSCalendar.gregorianCalendar components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)weekOfYear {
    return [[NSCalendar.gregorianCalendar components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)daysOfMonth {
    return [NSCalendar.gregorianCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}

- (BOOL)isLeapMonth {
    return [[NSCalendar.gregorianCalendar components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL)isLeapYear {
    NSUInteger year = self.year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)isToday {
    return [NSCalendar.gregorianCalendar isDateInToday:self];
}

- (BOOL)isYesterday {
    return [NSCalendar.gregorianCalendar isDateInYesterday:self];
}

- (BOOL)isTomorrow {
    return [NSCalendar.gregorianCalendar isDateInTomorrow:self];
}

- (BOOL)isWeekend {
    return [NSCalendar.gregorianCalendar isDateInWeekend:self];
}

- (BOOL)isThisYear {
    NSDateComponents *selfCmps = [NSCalendar.gregorianCalendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowCmps = [NSCalendar.gregorianCalendar components:NSCalendarUnitYear fromDate:NSDate.date];
    return nowCmps.year == selfCmps.year;
}

- (long)stamp {
    return (long)(self.timeIntervalSince1970 * 1000);
}

- (NSString *)timestamp {
    return [[NSNumber numberWithLong:(long)(self.timeIntervalSince1970 * 1000)] stringValue];
}

- (NSString *)dateString {
    return [[NSDate normalFormatter] stringFromDate:self];
}

- (NSString *)dateChinese {
    return [ZCDateManager chineseDate:self];
}

- (NSDate *)startDayDate {
    NSCalendarUnit unit = kCFCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comps = [NSCalendar.gregorianCalendar components:unit fromDate:self];
    NSDate *start = [NSCalendar.gregorianCalendar dateFromComponents:comps];
    return start ? start : self;
}

- (NSDate *)stopDayDate {
    NSDate *date = [self startDayDate];
    NSTimeInterval aTimeInterval = [date timeIntervalSinceReferenceDate] + 86400 - 0.001;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate ? newDate : self;
}

- (NSDate *)startWeekDate {
    NSCalendarUnit unit = kCFCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comps = [NSCalendar.gregorianCalendar components:unit fromDate:self];
    NSDate *start = [[NSCalendar.gregorianCalendar dateFromComponents:comps] dateByAddingDays:(1-self.weekday)];
    return start ? start : self;
}

- (NSDate *)startMonthDate {
    NSCalendarUnit unit = kCFCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *comps = [NSCalendar.gregorianCalendar components:unit fromDate:self];
    NSDate *start = [NSCalendar.gregorianCalendar dateFromComponents:comps];
    return start ? start : self;
}

- (NSDate *)startWeekEnglishDate {
    NSCalendarUnit unit = kCFCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comps = [NSCalendar.gregorianCalendar components:unit fromDate:self];
    NSDate *start = [[NSCalendar.gregorianCalendar dateFromComponents:comps] dateByAddingDays:-self.weekday];
    return start ? start : self;
}

+ (NSDate *)dateFromTimestamp:(long)timestamp {
    NSTimeInterval sec = timestamp / 1.0;
    if (timestamp > 1000000000000) sec = timestamp / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sec];
    return date ? date : NSDate.date;
}

+ (NSDate *)dateFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    return [NSCalendar.gregorianCalendar dateWithEra:1 year:year month:month day:day hour:0 minute:0 second:0 nanosecond:0];
}

+ (NSDate *)dateFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    return [NSCalendar.gregorianCalendar dateWithEra:1 year:year month:month day:day hour:hour minute:minute second:second nanosecond:0];
}

#pragma mark - Adding
- (NSDate *)dateByAddingYears:(NSInteger)years {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [NSCalendar.gregorianCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [NSCalendar.gregorianCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingWeeks:(NSInteger)weeks {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [NSCalendar.gregorianCalendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingSeconds:(NSInteger)seconds {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark - Date format
- (BOOL)isSameDayAsDate:(NSDate *)date {
    if (!date) return NO;
    return [NSCalendar.gregorianCalendar isDate:self inSameDayAsDate:date];
}

- (BOOL)isSameMonthAsDate:(NSDate *)date {
    if (!date) return NO;
    return [NSCalendar.gregorianCalendar isDate:self equalToDate:date toUnitGranularity:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth];
}

- (BOOL)isSameYearAsDate:(NSDate *)date {
    if (!date) return NO;
    return [NSCalendar.gregorianCalendar isDate:self equalToDate:date toUnitGranularity:NSCalendarUnitEra|NSCalendarUnitYear];
}

- (NSString *)stringWithFormat:(NSString *)format {
    return [[ZCDateManager dateFormatter:format] stringFromDate:self];
}

- (NSString *)stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (!format || !format.length) format = @"yyyy-MM-dd HH:mm:ss";
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

+ (NSDateFormatter *)preciseFormatter {
    return [ZCDateManager dateFormatter:@"yyyy-MM-dd HH:mm:ss.SSS"];
}

+ (NSDateFormatter *)normalFormatter {  
    return [ZCDateManager dateFormatter:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDateFormatter *)dateFormatter {
    return [ZCDateManager dateFormatter:@"yyyy-MM-dd"];
}

+ (NSDateFormatter *)timeFormatter {
    return [ZCDateManager dateFormatter:@"HH:mm:ss"];
}

+ (NSString *)dateStringWithTime:(long)timestamp format:(NSString *)format {
    NSTimeInterval sec = timestamp / 1.0;
    if (timestamp > 1000000000000) sec = timestamp / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sec];
    if (!date) date = NSDate.date;
    return [date stringWithFormat:format];
}

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format {
    if (!dateString) return nil;
    return [[ZCDateManager dateFormatter:format] dateFromString:dateString];
}

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    if (!dateString) return nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (!format || !format.length) format = @"yyyy-MM-dd HH:mm:ss";
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter dateFromString:dateString];
}

@end
