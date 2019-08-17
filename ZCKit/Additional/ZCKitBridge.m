//
//  ZCKitBridge.m
//  ZCKit
//
//  Created by admin on 2018/10/10.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCKitBridge.h"

@interface ZCKitBridge ()

@property (nonatomic, weak) id<ZCKitExternalRealize> singleRealize;

@end

@implementation ZCKitBridge

@dynamic naviBackImageName, sideArrowImageName, isPrintLog, invalidStr;
@dynamic toastTextColor, toastBackGroundColor, realize, naviBarImageOrColor, naviBarTitleColor;

static UIColor *_toastTextColor = nil;
static UIColor *_toastBackGroundColor = nil;
static NSString *_sideArrowImageName = nil;
static NSString *_naviBackImageName = nil;
static NSString *_naviBarImageOrColor = nil;
static NSString *_naviBarTitleColor = nil;
static BOOL _isPrintLog = NO;

+ (instancetype)instance {
    static ZCKitBridge *instacne = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instacne = [[ZCKitBridge alloc] init];
    });
    return instacne;
}

#pragma mark - ivar
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

+ (NSString *)naviBarImageOrColor {
    if (_naviBarImageOrColor == nil) {
        _naviBarImageOrColor = @"0xF5F5F7";
    }
    return _naviBarImageOrColor;
}

+ (void)setNaviBarImageOrColor:(NSString *)naviBarImageOrColor {
    if (naviBarImageOrColor) {
        _naviBarImageOrColor = [naviBarImageOrColor copy];
    }
}

+ (NSString *)naviBarTitleColor {
    if (_naviBarTitleColor == nil) {
        _naviBarTitleColor = @"0x222222";
    }
    return _naviBarTitleColor;
}

+ (void)setNaviBarTitleColor:(NSString *)naviBarTitleColor {
    if (naviBarTitleColor) {
        _naviBarTitleColor = [naviBarTitleColor copy];
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

+ (UIColor *)toastBackGroundColor {
    if (_toastBackGroundColor == nil) {
        _toastBackGroundColor = [UIColor blackColor];
    }
    return _toastBackGroundColor;
}

+ (void)setToastBackGroundColor:(UIColor *)toastBackGroundColor {
    if (toastBackGroundColor) {
        _toastBackGroundColor = toastBackGroundColor;
    }
}

+ (UIColor *)toastTextColor {
    if (_toastTextColor == nil) {
        _toastTextColor = [UIColor whiteColor];
    }
    return _toastTextColor;
}

+ (void)setToastTextColor:(UIColor *)toastTextColor {
    if (toastTextColor) {
        _toastTextColor = toastTextColor;
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

+ (id<ZCKitExternalRealize>)realize {
    id <ZCKitExternalRealize> singleRealize = [ZCKitBridge instance].singleRealize;
    if (!singleRealize) {if (self.isPrintLog) NSLog(@"ZCKit: kit manager delegate is nil");}
    return singleRealize;
}

+ (void)setRealize:(id<ZCKitExternalRealize>)realize {
    if ([ZCKitBridge instance].singleRealize) {
        if (self.isPrintLog) NSLog(@"ZCKit: single delegate only registration once");
    }
    if (realize) {
        [ZCKitBridge instance].singleRealize = realize;
    } else {
        if (self.isPrintLog) NSLog(@"ZCKit: kit manager delegate is nil");
    }
}

@end

