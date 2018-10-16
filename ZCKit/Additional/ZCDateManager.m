//
//  ZCDateManager.m
//  ZCKit
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCDateManager.h"
#import "NSDictionary+ZC.h"

@interface ZCDateManager ()

@property (nonatomic, strong) NSMutableDictionary *formatMaps;

@property (nonatomic, strong) NSArray *chineseYears;

@property (nonatomic, strong) NSArray *chineseMonths;

@property (nonatomic, strong) NSArray *chineseDays;

@property (nonatomic, strong) NSArray *weekdays;

@end

@implementation ZCDateManager

@synthesize chinaLocale = _chinaLocale, beijingTimeZone = _beijingTimeZone;
@synthesize chineseCalendar = _chineseCalendar, gregorianCalendar = _gregorianCalendar;

+ (instancetype)instance {
    static ZCDateManager *instacne = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instacne = [[ZCDateManager alloc] init];
    });
    return instacne;
}

+ (NSDateFormatter *)dateFormatter:(NSString *)format {
    if (!format || !format.length) format = @"yyyy-MM-dd HH:mm:ss";
    ZCDateManager *manager = [ZCDateManager instance];
    if ([manager.formatMaps containsObjectForKey:format]) {
        return [manager.formatMaps objectForKey:format];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [manager.formatMaps setObject:formatter forKey:format];
    return formatter;
}

+ (NSString *)chineseDate:(NSDate *)date {
    if (!date) date = [NSDate date];
    NSDate *chineseDate = [date dateByAddingTimeInterval:28800.0]; //将国际时间转为中国时间
    ZCDateManager *manager = [ZCDateManager instance];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *comp = [manager.chineseCalendar components:unit fromDate:chineseDate];
    NSString *year = [manager.chineseYears objectAtIndex:(comp.year - 1)];
    NSString *month = [manager.chineseMonths objectAtIndex:(comp.month - 1)];
    NSString *day = [manager.chineseDays objectAtIndex:(comp.day - 1)];
    return [NSString stringWithFormat:@"%@年%@%@", year, month, day];
}

+ (NSString *)showPastTime:(NSTimeInterval)interval detail:(BOOL)detail {
    NSString *result = nil;
    if (interval < 0) interval = [[NSDate date] timeIntervalSince1970];
    else if (interval > 9999999999) interval = interval / 100;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    if ([[NSCalendar currentCalendar] isDateInToday:date]) { //今天，显示时间段，12小时制
        NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute;
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:unit fromDate:date];
        NSInteger hour = comps.hour > 12 ? (comps.hour - 12) : comps.hour;
        result = [NSString stringWithFormat:@"%@%zd:%02zd", [self timeSlot:comps.hour], hour, comps.minute];
    } else if ([[NSCalendar currentCalendar] isDateInYesterday:date]) { //昨天，显示时间段，12小时制
        result = @"昨天 ";
        if (detail) {
            NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute;
            NSDateComponents *comps = [[NSCalendar currentCalendar] components:unit fromDate:date];
            NSInteger hour = comps.hour > 12 ? (comps.hour - 12) : comps.hour;
            result = [result stringByAppendingFormat:@"%@%zd:%02zd", [self timeSlot:comps.hour], hour, comps.minute];
        }
    } else if ([[NSCalendar currentCalendar] isDate:date equalToDate:[NSDate date] toUnitGranularity:NSCalendarUnitYear]) { //今年，显示日期，24小时制
        NSCalendarUnit unit = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:unit fromDate:date];
        result = [NSString stringWithFormat:@"%zd月%zd日 ", comps.month, comps.day];
        if (detail) result = [result stringByAppendingFormat:@"%02zd:%02zd", comps.hour, comps.minute];
    } else { //去年，显示日期，24小时制
        NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:unit fromDate:date];
        result = [NSString stringWithFormat:@"%zd年%zd月%zd日 ", comps.year, comps.month, comps.day];
        if (detail) result = [result stringByAppendingFormat:@"%02zd:%02zd", comps.hour, comps.minute];
    }
    return result;
}

#pragma mark - misc
+ (NSString *)timeSlot:(NSInteger)hour {
    if (hour >= 0 && hour < 6) {
        return @"凌晨";
    } else if (hour >= 6 && hour < 9) {
        return @"早上";
    } else if (hour >= 9 && hour < 12) {
        return @"上午";
    } else if (hour >= 12 && hour < 13) {
        return @"中午";
    } else if (hour >= 13 && hour < 18) {
        return @"下午";
    } else {
        return @"晚上";
    }
}

#pragma mark - get
- (NSMutableDictionary *)formatMaps {
    if (!_formatMaps) {
        _formatMaps = [NSMutableDictionary dictionary];
    }
    return _formatMaps;
}

- (NSArray *)weekdays {
    if (!_weekdays) {
        _weekdays = @[@"", @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    }
    return _weekdays;
}

- (NSArray *)chineseYears {
    if (!_chineseYears) {
        _chineseYears = @[@"甲子", @"乙丑", @"丙寅", @"丁卯", @"戊辰", @"己巳", @"庚午", @"辛未", @"壬申", @"癸酉",
                          @"甲戌", @"乙亥", @"丙子", @"丁丑", @"戊寅", @"己卯", @"庚辰", @"辛己", @"壬午", @"癸未",
                          @"甲申", @"乙酉", @"丙戌", @"丁亥", @"戊子", @"己丑", @"庚寅", @"辛卯", @"壬辰", @"癸巳",
                          @"甲午", @"乙未", @"丙申", @"丁酉", @"戊戌", @"己亥", @"庚子", @"辛丑", @"壬寅", @"癸丑",
                          @"甲辰", @"乙巳", @"丙午", @"丁未", @"戊申", @"己酉", @"庚戌", @"辛亥", @"壬子", @"癸丑",
                          @"甲寅", @"乙卯", @"丙辰", @"丁巳", @"戊午", @"己未", @"庚申", @"辛酉", @"壬戌", @"癸亥"];
    }
    return _chineseYears;
}

- (NSArray *)chineseMonths {
    if (!_chineseMonths) {
        _chineseMonths = @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"冬月", @"腊月"];
    }
    return _chineseMonths;
}

- (NSArray *)chineseDays {
    if (!_chineseDays) {
        _chineseDays = @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                         @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                         @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
    }
    return _chineseDays;
}

#pragma mark - set & get
- (NSTimeZone *)beijingTimeZone {
    if (!_beijingTimeZone) {
        _beijingTimeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    }
    return _beijingTimeZone;
}

- (NSLocale *)chinaLocale {
    if (!_chinaLocale) {
        _chinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    return _chinaLocale;
}

- (NSString *)today {
    return [[ZCDateManager dateFormatter:@"yyyy-MM-dd"] stringFromDate:[NSDate date]];
}

- (NSCalendar *)chineseCalendar {
    if (!_chineseCalendar) {
        _chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        _chineseCalendar.timeZone = self.beijingTimeZone;
        _chineseCalendar.locale = self.chinaLocale;
    }
    return _chineseCalendar;
}

- (NSCalendar *)gregorianCalendar {
    if (!_gregorianCalendar) {
        _gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _gregorianCalendar.timeZone = self.beijingTimeZone;
        _gregorianCalendar.locale = self.chinaLocale;
    }
    return _gregorianCalendar;
}

@end

