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
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comp = [manager.chineseCalendar components:unit fromDate:chineseDate];
    NSString *year = [manager.chineseYears objectAtIndex:(comp.year - 1)];
    NSString *month = [manager.chineseMonths objectAtIndex:(comp.month - 1)];
    NSString *day = [manager.chineseDays objectAtIndex:(comp.day - 1)];
    return [NSString stringWithFormat:@"%@%@%@", year, month, day];
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
        result = [NSLocalizedString(@"昨天", nil) stringByAppendingString:@" "];
        if (detail) {
            NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute;
            NSDateComponents *comps = [[NSCalendar currentCalendar] components:unit fromDate:date];
            NSInteger hour = comps.hour > 12 ? (comps.hour - 12) : comps.hour;
            result = [result stringByAppendingFormat:@"%@%zd:%02zd", [self timeSlot:comps.hour], hour, comps.minute];
        }
    } else if ([[NSCalendar currentCalendar] isDate:date equalToDate:[NSDate date] toUnitGranularity:NSCalendarUnitYear]) { //今年，显示日期，24小时制
        NSCalendarUnit unit = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:unit fromDate:date];
        result = [NSString stringWithFormat:@"%zd%@%zd%@ ", comps.month, NSLocalizedString(@"月", nil), comps.day, NSLocalizedString(@"日", nil)];
        if (detail) result = [result stringByAppendingFormat:@"%02zd:%02zd", comps.hour, comps.minute];
    } else { //去年，显示日期，24小时制
        NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:unit fromDate:date];
        result = [NSString stringWithFormat:@"%zd%@%zd%@%zd%@ ", comps.year, NSLocalizedString(@"年", nil), comps.month, NSLocalizedString(@"月", nil), comps.day, NSLocalizedString(@"日", nil)];
        if (detail) result = [result stringByAppendingFormat:@"%02zd:%02zd", comps.hour, comps.minute];
    }
    return result;
}

#pragma mark - misc
+ (NSString *)timeSlot:(NSInteger)hour {
    if (hour >= 0 && hour < 6) {
        return NSLocalizedString(@"凌晨", nil);
    } else if (hour >= 6 && hour < 9) {
        return NSLocalizedString(@"早上", nil);
    } else if (hour >= 9 && hour < 12) {
        return NSLocalizedString(@"上午", nil);
    } else if (hour >= 12 && hour < 13) {
        return NSLocalizedString(@"中午", nil);
    } else if (hour >= 13 && hour < 18) {
        return NSLocalizedString(@"下午", nil);
    } else {
        return NSLocalizedString(@"晚上", nil);
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
        _weekdays = @[@"", NSLocalizedString(@"星期日", nil), NSLocalizedString(@"星期一", nil), NSLocalizedString(@"星期二", nil), NSLocalizedString(@"星期三", nil), NSLocalizedString(@"星期四", nil), NSLocalizedString(@"星期五", nil), NSLocalizedString(@"星期六", nil)];
    }
    return _weekdays;
}

- (NSArray *)chineseYears {
    if (!_chineseYears) {
        _chineseYears = @[@"甲子年", @"乙丑年", @"丙寅年", @"丁卯年", @"戊辰年", @"己巳年", @"庚午年", @"辛未年", @"壬申年", @"癸酉年",
                          @"甲戌年", @"乙亥年", @"丙子年", @"丁丑年", @"戊寅年", @"己卯年", @"庚辰年", @"辛己年", @"壬午年", @"癸未年",
                          @"甲申年", @"乙酉年", @"丙戌年", @"丁亥年", @"戊子年", @"己丑年", @"庚寅年", @"辛卯年", @"壬辰年", @"癸巳年",
                          @"甲午年", @"乙未年", @"丙申年", @"丁酉年", @"戊戌年", @"己亥年", @"庚子年", @"辛丑年", @"壬寅年", @"癸丑年",
                          @"甲辰年", @"乙巳年", @"丙午年", @"丁未年", @"戊申年", @"己酉年", @"庚戌年", @"辛亥年", @"壬子年", @"癸丑年",
                          @"甲寅年", @"乙卯年", @"丙辰年", @"丁巳年", @"戊午年", @"己未年", @"庚申年", @"辛酉年", @"壬戌年", @"癸亥年"];
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

