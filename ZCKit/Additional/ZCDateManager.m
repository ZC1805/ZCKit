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

@end

@implementation ZCDateManager

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

#pragma mark - set & get
- (NSMutableDictionary *)formatMaps {
    if (!_formatMaps) {
        _formatMaps = [NSMutableDictionary dictionary];
    }
    return _formatMaps;
}

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

@end

