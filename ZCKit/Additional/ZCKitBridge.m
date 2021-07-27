//
//  ZCKitBridge.m
//  ZCKit
//
//  Created by admin on 2018/10/10.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCKitBridge.h"
#import "ZCDateManager.h"
#import "ZCMacro.h"

@interface ZCKitBridge ()

@property (nonatomic, weak) id<ZCKitExternalRealize> singleRealize;

@end

@implementation ZCKitBridge

@dynamic naviBackImage, sideArrowImage, isPrintLog;
@dynamic toastTextColor, toastBackGroundColor, realize, naviBarImageOrColor, naviBarTitleColor;
@dynamic aimLocale, aimTimeZone;

static UIColor *_toastBackGroundColor = nil;
static UIColor *_toastTextColor = nil;
static UIImage *_sideArrowImage = nil;
static UIImage *_naviBackImage = nil;
static NSString *_naviBarImageOrColor = nil;
static NSString *_naviBarTitleColor = nil;
static BOOL _isPrintLog = NO;
static NSLocale *_aimLocale = nil;
static NSTimeZone *_aimTimeZone = nil;

+ (instancetype)sharedBridge {
    static ZCKitBridge *instacne = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instacne = [[ZCKitBridge alloc] init];
    });
    return instacne;
}

#pragma mark - Ivar
+ (UIImage *)naviBackImage {
    if (_naviBackImage == nil) {
        _naviBackImage = [ZCGlobal ZCImageName:@"zc_image_back_arrow"];
    }
    return _naviBackImage;
}

+ (void)setNaviBackImage:(UIImage *)naviBackImage {
    if (naviBackImage) {
        _naviBackImage = naviBackImage;
    }
}

+ (NSString *)naviBarImageOrColor {
    if (_naviBarImageOrColor == nil) {
        _naviBarImageOrColor = ZCStrFormat(@"%06x", ZCBKColor.RGBValue);
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
        _naviBarTitleColor = ZCStrFormat(@"%06x", ZCBlack30.RGBValue);
    }
    return _naviBarTitleColor;
}

+ (void)setNaviBarTitleColor:(NSString *)naviBarTitleColor {
    if (naviBarTitleColor) {
        _naviBarTitleColor = [naviBarTitleColor copy];
    }
}

+ (UIImage *)sideArrowImage {
    if (_sideArrowImage == nil) {
        _sideArrowImage = [ZCGlobal ZCImageName:@"zc_image_common_side_arrow"];
    }
    return _sideArrowImage;
}

+ (void)setSideArrowImage:(UIImage *)sideArrowImage {
    if (sideArrowImage) {
        _sideArrowImage = sideArrowImage;
    }
}

+ (UIColor *)toastBackGroundColor {
    if (_toastBackGroundColor == nil) {
        _toastBackGroundColor = ZCBlack;
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
        _toastTextColor = ZCWhite;
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

+ (id<ZCKitExternalRealize>)realize {
    id <ZCKitExternalRealize> singleRealize = [ZCKitBridge sharedBridge].singleRealize;
    if (!singleRealize) {if (self.isPrintLog) NSLog(@"ZCKit: kit manager delegate is nil");}
    return singleRealize;
}

+ (void)setRealize:(id<ZCKitExternalRealize>)realize {
    if ([ZCKitBridge sharedBridge].singleRealize) {
        if (self.isPrintLog) NSLog(@"ZCKit: single delegate only registration once");
    }
    if (realize) {
        [ZCKitBridge sharedBridge].singleRealize = realize;
    } else {
        if (self.isPrintLog) NSLog(@"ZCKit: kit manager delegate is nil");
    }
}

+ (NSLocale *)aimLocale {
    if (_aimLocale == nil) {
        _aimLocale = ZCDateManager.chinaLocale;
    }
    return _aimLocale;
}

+ (void)setAimLocale:(NSLocale *)aimLocale {
    if (aimLocale) {
        _aimLocale = aimLocale;
    }
}

+ (NSTimeZone *)aimTimeZone {
    if (_aimTimeZone == nil) {
        _aimTimeZone = ZCDateManager.beijingTimeZone;
    }
    return _aimTimeZone;
}

+ (void)setAimTimeZone:(NSTimeZone *)aimTimeZone {
    if (aimTimeZone) {
        _aimTimeZone = aimTimeZone;
    }
}

@end
