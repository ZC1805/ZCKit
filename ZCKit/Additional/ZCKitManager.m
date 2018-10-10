//
//  ZCKitManager.m
//  ZCKit
//
//  Created by admin on 2018/10/10.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCKitManager.h"

@interface ZCKitManager ()

@end

@implementation ZCKitManager

@dynamic naviBackImageName, sideArrowImageName, isPrintLog, invalidStr;

static NSString *_sideArrowImageName = nil;
static NSString *_naviBackImageName = nil;
static BOOL _isPrintLog = NO;

+ (instancetype)instance {
    static ZCKitManager *instacne = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instacne = [[ZCKitManager alloc] init];
    });
    return instacne;
}

+ (NSString *)naviBackImageName {
    if (_naviBackImageName == nil) {
        _naviBackImageName = @"zc_image_back_arrow";
    }
    return _naviBackImageName;
}

+ (void)setNaviBackImageName:(NSString *)naviBackImageName {
    if (naviBackImageName) {
        _naviBackImageName = [naviBackImageName copy];
    }
}

+ (NSString *)sideArrowImageName {
    if (_sideArrowImageName == nil) {
        _sideArrowImageName = @"zc_image_side_accessory";
    }
    return _sideArrowImageName;
}

+ (void)setSideArrowImageName:(NSString *)sideArrowImageName {
    if (sideArrowImageName) {
        _sideArrowImageName = sideArrowImageName;
    }
}

+ (BOOL)isPrintLog {
    return _isPrintLog;
}

+ (void)setIsPrintLog:(BOOL)isPrintLog {
    _isPrintLog = isPrintLog;
}

+ (NSString *)invalidStr {
    return @"zc_invalid_value &.Ignore";
}

@end











