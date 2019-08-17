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

#pragma mark - usually
- (NSInteger)year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)nanosecond {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

- (NSInteger)weekday {
    NSInteger weekday = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
    return weekday == 1 ? 7 : (weekday - 1);
}

- (NSInteger)weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)weekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (BOOL)isLeapMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL)isLeapYear {
    NSUInteger year = self.year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)isToday {
    return [[NSCalendar currentCalendar] isDateInToday:self];
}

- (BOOL)isYesterday {
    return [[NSCalendar currentCalendar] isDateInYesterday:self];
}

- (BOOL)isTomorrow {
    return [[NSCalendar currentCalendar] isDateInTomorrow:self];
}

- (BOOL)isWeekend {
    return [[NSCalendar currentCalendar] isDateInWeekend:self];
}

- (BOOL)isThisYear {
    NSDateComponents *selfCmps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowCmps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    return nowCmps.year == selfCmps.year;
}

- (NSString *)dateString {
    return [[NSDate normalFormatter] stringFromDate:self];
}

- (NSString *)dateChinese {
    return [ZCDateManager chineseDate:self];
}

#pragma mark - adding
- (NSDate *)dateByAddingYears:(NSInteger)years {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingWeeks:(NSInteger)weeks {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
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

#pragma mark - date format
- (BOOL)isSameDayAsDate:(NSDate *)date {
    if (!date) return NO;
    return [[NSCalendar currentCalendar] isDate:self inSameDayAsDate:date];
}

- (BOOL)isSameMonthAsDate:(NSDate *)date {
    if (!date) return NO;
    return [[NSCalendar currentCalendar] isDate:self equalToDate:date toUnitGranularity:NSCalendarUnitMonth];
}

- (BOOL)isSameYearAsDate:(NSDate *)date {
    if (!date) return NO;
    return [[NSCalendar currentCalendar] isDate:self equalToDate:date toUnitGranularity:NSCalendarUnitYear];
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

+ (NSString *)dateStringWithTime:(long)timeInterval format:(NSString *)format {
    NSString *interval = [NSString stringWithFormat:@"%ld", timeInterval];
    NSTimeInterval sec = timeInterval / 1.0;
    if (interval.length == 13) sec = timeInterval / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sec];
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

