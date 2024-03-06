//
//  ZCDateManager.m
//  ZCKit
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCDateManager.h"
#import "NSDictionary+ZC.h"
#import "ZCKitBridge.h"

@implementation NSCalendar (ZC)

+ (NSCalendar *)gregorianCalendar {
    static NSCalendar *gregorian = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    });
    if (![ZCDateManager.appTimeZone.name isEqualToString:gregorian.timeZone.name]) {
        gregorian.timeZone = ZCDateManager.appTimeZone;
    }
    if (![ZCDateManager.appLocale.localeIdentifier isEqualToString:gregorian.locale.localeIdentifier]) {
        gregorian.locale = ZCDateManager.appLocale;
    }
    return gregorian;
}

@end


@interface ZCDateManager ()

@property (nonatomic, strong) NSMutableDictionary *formatMaps;

@property (nonatomic, strong) NSArray *chineseYears;

@property (nonatomic, strong) NSArray *chineseMonths;

@property (nonatomic, strong) NSArray *chineseDays;

@property (nonatomic, strong) NSArray *weekdays;

@property (nonatomic, strong, readonly) NSLocale *chinaLocale;

@property (nonatomic, strong, readonly) NSTimeZone *beijingTimeZone;

@property (nonatomic, strong, readonly) NSCalendar *chineseGregorianCalendar;

@property (nonatomic, strong, readonly) NSCalendar *chineseCalendar;

@end

@implementation ZCDateManager

@synthesize chinaLocale = _chinaLocale, beijingTimeZone = _beijingTimeZone;
@synthesize chineseCalendar = _chineseCalendar, chineseGregorianCalendar = _chineseGregorianCalendar;

+ (instancetype)sharedManager {
    static ZCDateManager *instacne = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instacne = [[ZCDateManager alloc] init];
    });
    return instacne;
}

+ (NSDateFormatter *)dateFormatter:(NSString *)format {
    if (!format || !format.length) format = @"yyyy-MM-dd HH:mm:ss";
    ZCDateManager *manager = [ZCDateManager sharedManager];
    if ([manager.formatMaps containsObjectForKey:format]) { return [manager.formatMaps objectForKey:format]; }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:self.appLocale];
    [formatter setTimeZone:self.appTimeZone];
    [manager.formatMaps setObject:formatter forKey:format];
    return formatter;
}

+ (NSString *)chineseDate:(NSDate *)date {
    if (!date) return @"";
    ZCDateManager *manager = [ZCDateManager sharedManager];
    NSCalendarUnit unit = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comp = [manager.chineseCalendar components:unit fromDate:date];
    NSString *year = [manager.chineseYears objectAtIndex:(comp.year - 1)];
    NSString *month = [manager.chineseMonths objectAtIndex:(comp.month - 1)];
    NSString *day = [manager.chineseDays objectAtIndex:(comp.day - 1)];
    return [NSString stringWithFormat:@"%@%@%@", year, month, day];
}

+ (NSString *)showPastTime:(NSTimeInterval)interval detail:(BOOL)detail {
    NSString *result = nil;
    if (interval > 1000000000000) interval = interval / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    if ([NSCalendar.gregorianCalendar isDateInToday:date]) { //今天，显示时间段，12小时制
        NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute;
        NSDateComponents *comps = [NSCalendar.gregorianCalendar components:unit fromDate:date];
        NSInteger hour = comps.hour > 12 ? (comps.hour - 12) : comps.hour;
        result = [NSString stringWithFormat:@"%@%zd:%02zd", [self timeSlot:comps.hour], hour, comps.minute];
    } else if ([NSCalendar.gregorianCalendar isDateInYesterday:date]) { //昨天，显示时间段，12小时制
        result = [NSLocalizedString(@"Yesterday", nil) stringByAppendingString:@" "]; //昨天
        if (detail) {
            NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute;
            NSDateComponents *comps = [NSCalendar.gregorianCalendar components:unit fromDate:date];
            NSInteger hour = comps.hour > 12 ? (comps.hour - 12) : comps.hour;
            result = [result stringByAppendingFormat:@"%@%zd:%02zd", [self timeSlot:comps.hour], hour, comps.minute];
        }
    } else if ([NSCalendar.gregorianCalendar isDate:date equalToDate:NSDate.date toUnitGranularity:NSCalendarUnitYear]) { //今年，显示日期，24小时制
        NSCalendarUnit unit = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        NSDateComponents *comps = [NSCalendar.gregorianCalendar components:unit fromDate:date];
        result = [NSString stringWithFormat:@"%zd%@%zd%@ ", comps.month, NSLocalizedString(@"Month", nil), comps.day, NSLocalizedString(@"Day", nil)]; //月日
        if (detail) result = [result stringByAppendingFormat:@"%02zd:%02zd", comps.hour, comps.minute];
    } else { //去年，显示日期，24小时制
        NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        NSDateComponents *comps = [NSCalendar.gregorianCalendar components:unit fromDate:date];
        result = [NSString stringWithFormat:@"%zd%@%zd%@%zd%@ ", comps.year, NSLocalizedString(@"Year", nil), comps.month, NSLocalizedString(@"Month", nil), comps.day, NSLocalizedString(@"Day", nil)]; //年月日
        if (detail) result = [result stringByAppendingFormat:@"%02zd:%02zd", comps.hour, comps.minute];
    }
    return result;
}

#pragma mark - Misc
+ (NSString *)timeSlot:(NSInteger)hour {
    if (hour >= 0 && hour < 6) {
        return NSLocalizedString(@"Morning", nil); //凌晨
    } else if (hour >= 6 && hour < 9) {
        return NSLocalizedString(@"Morning", nil); //早上
    } else if (hour >= 9 && hour < 12) {
        return NSLocalizedString(@"Morning", nil); //上午
    } else if (hour >= 12 && hour < 13) {
        return NSLocalizedString(@"Afternoon", nil); //中午
    } else if (hour >= 13 && hour < 18) {
        return NSLocalizedString(@"Afternoon", nil); //下午
    } else {
        return NSLocalizedString(@"Night", nil); //晚上
    }
}

#pragma mark - Get
- (NSMutableDictionary *)formatMaps {
    if (!_formatMaps) {
        _formatMaps = [NSMutableDictionary dictionary];
    }
    return _formatMaps;
}

- (NSArray *)weekdays {
    if (!_weekdays) {
        _weekdays = @[@"", NSLocalizedString(@"Sunday", nil), NSLocalizedString(@"Monday", nil), NSLocalizedString(@"Tuesday", nil), NSLocalizedString(@"Wednesday", nil), NSLocalizedString(@"Thursday", nil), NSLocalizedString(@"Friday", nil), NSLocalizedString(@"Saturday", nil)]; //星期日、星期一、星期二、星期三、星期四、星期五、星期六
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

#pragma mark - Set & Get
- (NSLocale *)chinaLocale {
    if (!_chinaLocale) {
        _chinaLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    return _chinaLocale;
}

- (NSTimeZone *)beijingTimeZone {
    if (!_beijingTimeZone) {
        _beijingTimeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*3600];
    }
    return _beijingTimeZone;
}

- (NSCalendar *)chineseCalendar {
    if (!_chineseCalendar) {
        _chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        _chineseCalendar.timeZone = self.beijingTimeZone;
        _chineseCalendar.locale = self.chinaLocale;
    }
    return _chineseCalendar;
}

- (NSCalendar *)chineseGregorianCalendar {
    if (!_chineseGregorianCalendar) {
        _chineseGregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _chineseGregorianCalendar.timeZone = self.beijingTimeZone;
        _chineseGregorianCalendar.locale = self.chinaLocale;
    }
    return _chineseGregorianCalendar;
}

#pragma mark - Api
+ (NSLocale *)chinaLocale {
    return [ZCDateManager sharedManager].chinaLocale;
}

+ (NSTimeZone *)beijingTimeZone {
    return [ZCDateManager sharedManager].beijingTimeZone;
}

+ (NSCalendar *)chineseCalendar {
    return [ZCDateManager sharedManager].chineseCalendar;
}

+ (NSCalendar *)chineseGregorianCalendar {
    return [ZCDateManager sharedManager].chineseGregorianCalendar;
}

+ (NSLocale *)appLocale {
    return ZCKitBridge.aimLocale;
}

+ (NSTimeZone *)appTimeZone {
    return ZCKitBridge.aimTimeZone;
}

@end
