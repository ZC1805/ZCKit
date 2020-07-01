//
//  UIApplication+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIApplication+ZC.h"

@implementation UIApplication (ZC)

#pragma mark - Usually
+ (NSURL *)documentsURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)documentsPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSURL *)cachesURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)cachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSURL *)libraryURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)libraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)appBundleName {
    NSString *str = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    return  str ? str : @"";
}

+ (NSString *)appBundleID {
    NSString *str = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    return  str ? str : @"";
}

+ (NSString *)appVersion {
    NSString *str = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return  str ? str : @"";
}

+ (NSString *)appBuildVersion {
    NSString *str = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    return  str ? str : @"";
}

+ (NSString *)appSign {
    NSString *str = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleSignature"];
    return  str ? str : @"";
}

@end
