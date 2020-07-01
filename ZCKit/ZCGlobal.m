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

@property (nonatomic, assign) CGFloat radio360; //比例

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
        instance.radio360 = minvl / 360.0;
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

#pragma mark - Misc
+ (CGFloat)ratio {
    return [ZCGlobal sharedGlobal].radio360;
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

+ (nullable id)appointInvalid:(nullable id)originObj default:(nullable id)defaultObj {
    if (originObj == nil || ([originObj isKindOfClass:NSString.class] && [(NSString *)originObj length] == 0)) {
        return defaultObj;
    }
    if ([self isValidString:originObj] || [self isValidArray:originObj] || [self isValidDictionary:originObj]) {
        return originObj;
    }
    if ([originObj isKindOfClass:NSSet.class] && [(NSSet *)originObj count]) {
        return originObj;
    }
    if ([originObj isKindOfClass:NSString.class] || [originObj isKindOfClass:NSArray.class] ||
        [originObj isKindOfClass:NSDictionary.class] || [originObj isKindOfClass:NSSet.class]) {
        return defaultObj;
    }
    return originObj;
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
    if (path) {return [UIImage imageWithContentsOfFile:path];}
    return nil;
}

#pragma mark - Controller
+ (UIViewController *)rootController { //根控制器
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

+ (UIViewController *)topController:(UIViewController *)rootvc { //顶控制器，初始rootvc可为nil
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
        if ([(UINavigationController *)rootvc visibleViewController]) {
            return [self topController:[(UINavigationController *)rootvc visibleViewController]];
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

+ (UIViewController *)currentController { //当前控制器
    return [self topController:[self rootController]];
}

#pragma mark - Safe layout
+ (CGFloat)leadingSpacing { //左边距离 -> 0 / 44
    CGFloat height = [self safeLeft];
    if (height <= 0 && [self isLandscape]) { //暂时默认横屏左右都是44
        //if ([self bottomReserveHeight]) height = 44.0;
        if ([self isiPhoneX]) height = 44.0;
    }
    return MAX(height, 0);
}

+ (CGFloat)trailingSpacing { //右边距离 -> 0 / 44
    CGFloat height = [self safeRight];
    if (height <= 0 && [self isLandscape]) { //暂时默认横屏左右都是44
        //if ([self bottomReserveHeight]) height = 44.0;
        if ([self isiPhoneX]) height = 44.0;
    }
    return MAX(height, 0);
}

+ (CGFloat)statusBarHeight { //状态栏高度 -> 0 / 20 / 44
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

+ (CGFloat)naviShadowHeight { //导航条阴影高度 -> 0 / 1
    UIViewController *topvc = [self currentController];
    UINavigationController *navvc = topvc.navigationController;
    if ([topvc isKindOfClass:UINavigationController.class]) {
        navvc = (UINavigationController *)topvc;
    }
    if (navvc && !navvc.navigationBarHidden && !navvc.navigationBar.hidden) {
        UIImage *shadowImage = navvc.navigationBar.shadowImage;
        if (!shadowImage || !CGSizeEqualToSize(shadowImage.size, CGSizeZero)) {
            return 1.0;
        }
    }
    return 0;
}

+ (CGFloat)naviBarHeight { //导航条高度 -> 0 / 32 / 44 / 96
    UIViewController *topvc = [self currentController];
    UINavigationController *navvc = topvc.navigationController;
    if ([topvc isKindOfClass:UINavigationController.class]) {
        navvc = (UINavigationController *)topvc;
    }
    if (navvc && !navvc.navigationBarHidden && !navvc.navigationBar.hidden) {
        return navvc.navigationBar.frame.size.height;
    }
    return 0;
}

+ (CGFloat)naviHeight { //导航栏高度 -> 0 / 32 / 44 / 64 / 88 / 116 / 140 (影藏导航栏时高度为0, 而不是状态栏高度)
    CGFloat top = [self naviBarHeight];
    if (top && ![UIApplication sharedApplication].statusBarHidden) {
        top += [self statusBarHeight];
    }
    return MAX(top, 0);
}

+ (CGFloat)topFringeHeight { //顶部刘海底部到屏幕顶部距离 -> 0 / 30
    if (![self isLandscape]) {
        //if ([self bottomReserveHeight]) return 30.0;
        if ([self isiPhoneX]) return 30.0;
    }
    return 0;
}

+ (CGFloat)bottomFringeHeight { //底部刘海顶部到屏幕底部距离 -> 0 / 13
    //if ([self bottomReserveHeight]) return 13.0;
    if ([self isiPhoneX]) return 13.0;
    return 0;
}

+ (CGFloat)topReserveHeight { //顶部保留高度，即顶部刘海安全高度 -> 0 / 44
    CGFloat stateHeight = [self statusBarHeight];
    if (stateHeight > 20.0) {
        return stateHeight;
    } else if (stateHeight == 20.0) {
        return 0;
    } else if (![self isLandscape]) {
        //if ([self bottomReserveHeight]) return 44.0;
        if ([self isiPhoneX]) return 44.0;
    }
    return 0;
}

+ (CGFloat)bottomReserveHeight { //底部保留高度，即底部刘海安全高度 -> 0 / 21 / 34
    CGFloat bottom = 0;
    UIViewController *rootvc = [self rootController];
    UITabBarController *tabvc = rootvc.tabBarController;
    if (rootvc && [rootvc isKindOfClass:UITabBarController.class]) {
        tabvc = (UITabBarController *)rootvc;
    }
    if (tabvc && tabvc.view.subviews.count != 1 && !tabvc.tabBar.hidden) {
        bottom = tabvc.tabBar.frame.size.height - 49.0;
    } else {
        if (@available(iOS 11.0, *)) {
            if (rootvc) bottom = rootvc.view.safeAreaInsets.bottom;
        } else {
            if (rootvc) bottom = rootvc.bottomLayoutGuide.length;
        }
    }
    if (bottom > 0) {
        if ([self isLandscape]) {
            bottom = 21.0;
        } else {
            bottom = 34.0;
        }
    }
    return MAX(bottom, 0);
}

+ (CGFloat)tabBarHeight { //tabbar高度(暂时不适用于横竖屏交换) -> 值为:0 / 32 / 49 / 53 / 83
    UIViewController *topvc = [self currentController];
    UITabBarController *tabvc = topvc.tabBarController;
    if (topvc && [topvc isKindOfClass:UITabBarController.class]) {
        tabvc = (UITabBarController *)topvc;
    }
    if (tabvc && tabvc.view.subviews.count != 1 && !tabvc.tabBar.hidden) {
        if (topvc.hidesBottomBarWhenPushed) { //设置hides应在在此调用之前，导航推出第一个控制器tabbar没有迅速消失
            if (topvc.navigationController && ![topvc isKindOfClass:UINavigationController.class]) {
                return 0;
            }
        }
        return tabvc.tabBar.frame.size.height;
    }
    return 0;
}

+ (CGFloat)tabHeight { //底部高度(暂时不适用于横竖屏交换) -> 值为:0 / 21 / 32 / 34 / 49 / 53 / 83
    CGFloat bottom = [self tabBarHeight];
    if (bottom) return bottom;
    return [self bottomReserveHeight]; 
}

+ (UIEdgeInsets)safeInset {
    CGFloat top = 0, left = 0, bottom = 0, right = 0;
    UIViewController *topvc = [self currentController];
    if (@available(iOS 11.0, *)) {
        top = topvc.view.safeAreaInsets.top;
        left = topvc.view.safeAreaInsets.left;
        right = topvc.view.safeAreaInsets.right;
        bottom = topvc.view.safeAreaInsets.bottom;
    } else {
        top = topvc.topLayoutGuide.length;
        bottom = topvc.bottomLayoutGuide.length;
    }
    return UIEdgeInsetsMake(top, left, bottom, right);
}

+ (CGFloat)safeLeft {
    return [self safeInset].left;
}

+ (CGFloat)safeRight {
    return [self safeInset].right;
}

@end
