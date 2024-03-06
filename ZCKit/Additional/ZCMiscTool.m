//
//  ZCMiscTool.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCMiscTool.h"
#import <dlfcn.h>
#import <stdlib.h>
#import <sys/stat.h>
#import <UIKit/UIKit.h>
#import "UIDevice+ZC.h"
#import "NSString+ZC.h"
#import "ZCQueueHandler.h"

@interface ZCMiscTool ()

@property (nonatomic, copy) NSString *iPhoneIsUseVPN;

@property (nonatomic, copy) NSString *iPhoneIsJailBreak;

@property (nonatomic, copy) NSString *mobileIpv4Address;

@property (nonatomic, copy) NSString *wifiIpv4Address;

@end

@implementation ZCMiscTool

+ (instancetype)sharedTool {
    static ZCMiscTool *instacne = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instacne = [[ZCMiscTool alloc] init];
    });
    return instacne;
}

#pragma mark - Api1
+ (NSString *)timestamp {
    return [[NSNumber numberWithLong:(long)(NSDate.date.timeIntervalSince1970 * 1000)] stringValue];
}

+ (BOOL)isChinese {
    NSString *languageCode = [NSLocale preferredLanguages].firstObject;
    if (languageCode && [languageCode hasPrefix:@"zh"]) return YES;
    return NO;
}

+ (BOOL)isOpenVPN {
    if ([ZCMiscTool sharedTool].iPhoneIsUseVPN) {
        return [ZCMiscTool sharedTool].iPhoneIsUseVPN.boolValue;
    }
    BOOL isOpenVPN = NO;
    NSDictionary *dict = CFBridgingRelease(CFNetworkCopySystemProxySettings());
    NSArray *keys = [dict[@"__SCOPED__"] allKeys];
    for (NSString *key in keys) {
        if ([key rangeOfString:@"tap"].location != NSNotFound ||
            [key rangeOfString:@"tun"].location != NSNotFound ||
            [key rangeOfString:@"ppp"].location != NSNotFound ||
            [key rangeOfString:@"ipsec"].location != NSNotFound) {
            isOpenVPN = YES; break;
        }
    }
    [ZCMiscTool sharedTool].iPhoneIsUseVPN = isOpenVPN ? @"1" : @"0";
    return isOpenVPN;
}

+ (BOOL)isJailBreak {
    if ([ZCMiscTool sharedTool].iPhoneIsJailBreak) {
        return [ZCMiscTool sharedTool].iPhoneIsJailBreak.boolValue;
    }
    BOOL isJailBreak = NO;
    if (!isJailBreak) {
        NSArray *breakPaths = @[@"/Applications/Cydia.app", @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                                @"/bin/bash", @"/usr/sbin/sshd", @"/etc/apt", @"/private/var/lib/apt"];
        for (NSString *path in breakPaths) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                isJailBreak = YES; break;
            }
        }
    }
    if (!isJailBreak) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
            isJailBreak = YES;
        }
    }
    if (!isJailBreak) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:@"User/Applications/"]) {
            NSArray *appList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"User/Applications/" error:nil];
            if (appList.count) isJailBreak = YES;
        }
    }
    if (!isJailBreak) {
        if (getenv("DYLD_INSERT_LIBRARIES")) {
            isJailBreak = YES;
        }
    }
    if (!isJailBreak) {
        int ret;
        Dl_info dylib_info;
        int (*func_stat)(const char*, struct stat*) = stat;
        char *dylib_name = "/usr/lib/system/libsystem_kernel.dylib";
        if ((ret = dladdr(func_stat, &dylib_info)) && strncmp(dylib_info.dli_fname, dylib_name, strlen(dylib_name))) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wunused-value"
            ret;
            #pragma clang diagnostic pop
            struct stat stat_info;
            if (0 != stat("/Applications/Cydia.app", &stat_info)) {
                isJailBreak = YES;
            }
        }
    }
    [ZCMiscTool sharedTool].iPhoneIsJailBreak = isJailBreak ? @"1" : @"0";
    return isJailBreak;
}

+ (NSString *)wifiName {
    return [UIDevice.wifiSSID copy];
}

+ (void)ipAddressWifi:(BOOL)wifi block:(void(^)(NSString *address))block {
    if (wifi) { ///!!!: 在此切换WiFi不会及时更新WiFi地址
        if ([ZCMiscTool sharedTool].wifiIpv4Address.length) {
            if (block) block([ZCMiscTool sharedTool].wifiIpv4Address.copy);
        } else {
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [queue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                NSError *ipError; NSURL *ipURL = [NSURL URLWithString:@"http://ifconfig.me/ip"];
                NSString *ipStr = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&ipError];
                if (ipError || !ipStr || ![UIDevice isValidateIP:ipStr]) ipStr = @"";
                [ZCMiscTool sharedTool].wifiIpv4Address = ipStr;
                main_imp(^{ if (block) block([ipStr copy]); });
            }]];
        }
    } else {
        if (![ZCMiscTool sharedTool].mobileIpv4Address.length) {
            [ZCMiscTool sharedTool].mobileIpv4Address = UIDevice.ipv4Address;
        }
        if (block) {
            block([ZCMiscTool sharedTool].mobileIpv4Address.copy);
        }
    }
}

#pragma mark - Api2
+ (NSString *)urlStringFromHost:(NSString *)host param:(NSDictionary <NSString *, NSString *>*)param {
    if (!host) {NSAssert(0, @"ZCKit: url host is nil"); return @"";}
    if (!param || !param.count) return host;
    __block NSString *str = @"?";
    [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:NSString.class] && [obj isKindOfClass:NSString.class]) {
            str = [str stringByAppendingString:key];
            str = [str stringByAppendingString:@"="];
            str = [str stringByAppendingString:obj];
            str = [str stringByAppendingString:@"&"];
        }
    }];
    if (str.length > 1 && host.length) {
        str = [str substringToIndex:str.length - 1];
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        return [[host stringByAppendingString:str] stringByAddingPercentEncodingWithAllowedCharacters:set];
    }
    return host;
}

+ (NSDictionary <NSString *, NSString *>*)paramFromUrlString:(NSString *)urlString isNeedDecode:(BOOL)isNeedDecode isOnlyParam:(BOOL)isOnlyParam {
    if (!urlString || !urlString.length) return @{};
    if (isNeedDecode) { urlString = urlString.stringByURLDecode; }
    NSMutableDictionary <NSString *, NSString *>*param = [NSMutableDictionary dictionary];
    NSString *paramString = nil;
    if (!isOnlyParam) {
        NSArray *allElements = [urlString.stringByURLDecode componentsSeparatedByString:@"?"];
        if (allElements.count == 2) { paramString = allElements[1]; }
    } else {
        paramString = urlString;
    }
    if (paramString.length) {
        NSArray *paramArray = [paramString componentsSeparatedByString:@"&"];
        if (paramArray.count) {
            for (NSString *singleParamString in paramArray) {
                NSArray *singleParamSet = [singleParamString componentsSeparatedByString:@"="];
                if (singleParamSet.count == 2) {
                    NSString *key = singleParamSet[0];
                    NSString *value = singleParamSet[1];
                    if (key.length && value.length) {
                        [param setObject:value forKey:key];
                    }
                }
            }
        }
    }
    return param.copy;
}

#pragma mark - Api3
+ (long long)calculateFileSizeAtPath:(NSString *)path {
    if (!path) return 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}

+ (long long)calculateFolderSizeAtPath:(NSString *)path {
    if (!path) return 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    long long folderSize = 0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
            if ([fileManager fileExistsAtPath:fileAbsolutePath]) {
                long long size = [fileManager attributesOfItemAtPath:fileAbsolutePath error:nil].fileSize;
                folderSize += size;
            }
        }
    }
    return folderSize;
}

@end
