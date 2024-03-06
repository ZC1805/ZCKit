//
//  ZCGlobal.m
//  ZCKit
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCGlobal.h"
#import "ZCViewController.h"

@interface ZCGlobal ()

@property (nonatomic, assign) CGFloat radio375; //比例

@property (nonatomic, assign) BOOL isFullScreen; //全面屏

@property (nonatomic, copy) NSString *imageSuffix; //exp@3x

@property (nonatomic, copy) NSString *imageSuffixSmaller; //exp@2x

@end

@implementation ZCGlobal

+ (instancetype)sharedGlobal {
    static ZCGlobal *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZCGlobal alloc] init];
        CGFloat scale = [UIScreen mainScreen].bounds.size.height / [UIScreen mainScreen].bounds.size.width;
        CGFloat minvl = MIN([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        instance.isFullScreen = (scale > 2.0 || scale < 0.5);
        instance.radio375 = minvl / 375.0;
    });
    return instance;
}

- (NSString *)imageSuffix {
    if (!_imageSuffix) {
        _imageSuffix = [NSString stringWithFormat:@"@%dx", (int)[UIScreen mainScreen].scale];
    }
    return _imageSuffix;
}

- (NSString *)imageSuffixSmaller {
    if (!_imageSuffixSmaller) {
        _imageSuffixSmaller = [NSString stringWithFormat:@"@%dx", (int)([UIScreen mainScreen].scale - 1)];
    }
    return _imageSuffixSmaller;
}

#pragma mark - Misc1
+ (CGFloat)ratio {
    return [ZCGlobal sharedGlobal].radio375;
}

+ (BOOL)isiPhoneX {
    return [ZCGlobal sharedGlobal].isFullScreen;
}

+ (BOOL)isLandscape {
    return ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ||
            [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight);
}

+ (BOOL)isJsonValue:(ZCJsonValue)value {
    if (value == nil || value == NULL) {
        return YES;
    } else if ([value isKindOfClass:NSString.class]) {
        return YES;
    } else if ([value isKindOfClass:NSNumber.class]) {
        return YES;
    } else if ([value isKindOfClass:NSArray.class]) {
        BOOL isJsonValue = YES;
        for (ZCJsonValue item in value) {
            if (![self isJsonValue:item]) {
                isJsonValue = NO; break;
            }
        }
        return isJsonValue;
    } else if ([value isKindOfClass:NSDictionary.class]) {
        __block BOOL isJsonValue = YES;
        [value enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (![key isKindOfClass:NSString.class]) {
                isJsonValue = NO; *stop = YES;
            }
            if (![self isJsonValue:obj]) {
                isJsonValue = NO; *stop = YES;
            }
        }];
        return isJsonValue;
    } else {
        if ([value conformsToProtocol:NSProtocolFromString(@"ZCJsonProtocol")]) {
            return ((id<ZCJsonProtocol>)value).isJsonValue;
        }
        return NO;
    }
}

+ (BOOL)isEqualToJsonValue:(ZCJsonValue)value1 other:(ZCJsonValue)value2 {
    if (value1 && value2 && [ZCGlobal isJsonValue:value1] && [ZCGlobal isJsonValue:value2]) {
        if ([value1 isKindOfClass:NSString.class] && [value2 isKindOfClass:NSString.class]) {
            return [value1 isEqualToString:value2];
        } else if ([value1 isKindOfClass:NSNumber.class] && [value2 isKindOfClass:NSNumber.class]) {
            return [value1 isEqualToNumber:value2];
        } else if ([value1 isKindOfClass:NSArray.class] && [value2 isKindOfClass:NSArray.class]) {
            return [value1 isEqualToArray:value2];
        } else if ([value1 isKindOfClass:NSDictionary.class] && [value2 isKindOfClass:NSDictionary.class]) {
            return [value1 isEqualToDictionary:value2];
        } else if (value1 == value2) {
            return YES;
        } else {
            return NO;
        }
    } else if (value1 == nil && value2 == nil) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isValidString:(NSString *)str {
    if (str && [str isKindOfClass:NSString.class] && str.length) {
        if (![str isEqualToString:@"<null>"] && ![str isEqualToString:@"(null)"] &&
            ![str isEqualToString:@"null"] && ![str isEqualToString:@"nil"] &&
            [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isValidArray:(NSArray *)array {
    if (array && [array isKindOfClass:NSArray.class] && array.count) {
        return YES;
    }
    return NO;
}

+ (BOOL)isValidDictionary:(NSDictionary *)dictionary {
    if (dictionary && [dictionary isKindOfClass:NSDictionary.class] && dictionary.count) {
        return YES;
    }
    return NO;
}

+ (BOOL)isExplicitArray:(nullable NSArray *)array elementClass:(Class)elementClass {
    BOOL isExplicitElement = YES;
    if (array && [array isKindOfClass:NSArray.class]) {
        if (elementClass) {
            for (id element in array) {
                if (![element isKindOfClass:elementClass]) { isExplicitElement = NO; break; }
            }
        }
    } else {
        isExplicitElement = NO;
    }
    return isExplicitElement;
}

+ (NSString *)resourcePath:(NSString *)bundle name:(NSString *)name ext:(NSString *)ext {
    if (!name) return nil;
    NSBundle *bdl = [NSBundle bundleForClass:self];
    if (bundle.length) bdl = [NSBundle bundleWithURL:[bdl URLForResource:bundle withExtension:@"bundle"]];
    if (!bdl) return nil;
    NSString *path = [bdl pathForResource:name ofType:ext];
    if (!path) path = [bdl pathForResource:[name stringByAppendingString:[ZCGlobal sharedGlobal].imageSuffix] ofType:ext];
    if (!path) path = [bdl pathForResource:[name stringByAppendingString:[ZCGlobal sharedGlobal].imageSuffixSmaller] ofType:ext];
    return path;
}

+ (nullable UIImage *)ZCImageName:(NSString *)imageName {
    NSString *path = [self resourcePath:@"ZCFiles" name:imageName ext:@"png"];
    if (path) { return [UIImage imageWithContentsOfFile:path]; }
    return nil;
}

#pragma mark - Misc2
+ (UIViewController *)rootController {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (!window || window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (long i = windows.count - 1; i >= 0; i --) {
            if ([windows[i] windowLevel] == UIWindowLevelNormal) {
                window = windows[i]; break;
            }
        }
        if (!window) window = windows.lastObject;
    }
    if (window && window.rootViewController) {
        id controller = [window.subviews.firstObject nextResponder];
        if (controller && [controller isKindOfClass:UIViewController.class]) {
            return controller;
        } else {
            return window.rootViewController;
        }
    } else {
        NSAssert(0, @"ZCKit: window is no normal level"); return nil;
    }
}

+ (UIViewController *)topController:(UIViewController *)rootvc {
    if (!rootvc) {
        rootvc = [UIApplication sharedApplication].delegate.window.rootViewController;
    }
    if (rootvc.presentedViewController) {
        return [self topController:rootvc.presentedViewController];
    } else if ([rootvc isKindOfClass:UITabBarController.class]) {
        if ([(UITabBarController *)rootvc selectedViewController]) {
            return [self topController:[(UITabBarController *)rootvc selectedViewController]];
        }
    } else if ([rootvc isKindOfClass:UINavigationController.class]) {
        if ([(UINavigationController *)rootvc topViewController]) {
            return [self topController:[(UINavigationController *)rootvc topViewController]];
        }
    } else if ([rootvc isKindOfClass:UISplitViewController.class]) {
        if ([(UISplitViewController *)rootvc viewControllers].count) {
            return [self topController:[(UISplitViewController *)rootvc viewControllers].lastObject];
        }
    } else if (rootvc.childViewControllers.count && [rootvc respondsToSelector:@selector(visibleChildViewController)]) {
        if ([(id<ZCViewControllerPrivateProtocol>)rootvc visibleChildViewController]) {
            return [self topController:[(id<ZCViewControllerPrivateProtocol>)rootvc visibleChildViewController]];
        }
    }
    return rootvc;
}

+ (UIViewController *)currentController {
    return [self topController:[self rootController]];
}

@end
