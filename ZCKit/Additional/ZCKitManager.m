//
//  ZCKitManager.m
//  ZCKit
//
//  Created by admin on 2018/10/10.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCKitManager.h"

@interface ZCKitManager ()

@property (nonatomic, weak) id<ZCKitManagerDelegate> singleDelegate;

@end

@implementation ZCKitManager

@dynamic naviBackImageName, sideArrowImageName, isPrintLog, invalidStr;
@dynamic toastTextColor, toastBackGroundColor, delegate;

static UIColor *_toastTextColor = nil;
static UIColor *_toastBackGroundColor = nil;
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

+ (id<ZCKitManagerDelegate>)delegate {
    id <ZCKitManagerDelegate> singleDelegate = [ZCKitManager instance].singleDelegate;
    if (!singleDelegate) {if (self.isPrintLog) NSLog(@"kit manager delegate is nil");}
    return singleDelegate;
}

+ (void)setDelegate:(id<ZCKitManagerDelegate>)delegate {
    if ([ZCKitManager instance].singleDelegate) {
        if (self.isPrintLog) NSLog(@"single delegate only registration once");
    }
    if (delegate) {
        [ZCKitManager instance].singleDelegate = delegate;
    } else {
        if (self.isPrintLog) NSLog(@"kit manager delegate is nil");
    }
}

#pragma mark - func


@end

