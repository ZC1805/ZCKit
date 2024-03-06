//
//  UIDevice+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIDevice+ZC.h"
#import "NSString+ZC.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <mach/mach.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <sys/utsname.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation UIDevice (ZC)

#pragma mark - Usually
+ (double)systemVersion {
    static double kDeviceVersion;
    static dispatch_once_t onceToken1;
    dispatch_once(&onceToken1, ^{
        kDeviceVersion = [UIDevice currentDevice].systemVersion.doubleValue;
    });
    return kDeviceVersion;
}

+ (BOOL)isPad {
    static BOOL kDeviceIsPad;
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        kDeviceIsPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    });
    return kDeviceIsPad;
}

+ (BOOL)isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
+ (BOOL)isCanMakePhoneCalls {
    static BOOL kDeviceIsCall;
    static dispatch_once_t onceToken3;
    dispatch_once(&onceToken3, ^{
        kDeviceIsCall = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    });
    return kDeviceIsCall;
}
#endif

+ (NSString *)ipv4Address {
    return [self IPAddress:YES isIPv6:NO wifi:NO];
}

+ (NSString *)wifiSSID {  
    NSString *ssid = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    if (ifs && [ifs isKindOfClass:NSArray.class]) {
        for (NSString *ifnam in ifs) {
            NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
            if (info && [info isKindOfClass:NSDictionary.class]) {
                ssid = [info objectForKey:@"SSID"]; if (ssid && ssid.length) break;
            }
        }
    }
    return ssid ? ssid : @"";
}

+ (NSString *)macBSSID { 
    NSString *bssid = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    if (ifs && [ifs isKindOfClass:NSArray.class]) {
        for (NSString *ifnam in ifs) {
            NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
            if (info && [info isKindOfClass:NSDictionary.class]) {
                bssid = [info objectForKey:@"BSSID"]; if (bssid && bssid.length) break;
            }
        }
    }
    return bssid ? bssid : @"";
}

+ (NSString *)machineModel {
    struct utsname systemInfo; uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    return platform ? platform : @"";
}

+ (NSUInteger)cpuCount {
    return [NSProcessInfo processInfo].activeProcessorCount;
}

+ (NSTimeInterval)systemUptime {
    return [NSProcessInfo processInfo].systemUptime;
}

#pragma mark - Misc
+ (int64_t)diskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space = [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

+ (int64_t)memoryTotal {
    int64_t mem = [[NSProcessInfo processInfo] physicalMemory];
    if (mem < -1) mem = -1;
    return mem;
}

#pragma mark - Other
+ (NSString *)iphoneDeviceName {
    NSString *iphoneType = nil;
    struct utsname systemInfo; uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) iphoneType = @"iPhone 2G";
    else if ([platform isEqualToString:@"iPhone1,2"]) iphoneType = @"iPhone 3G";
    else if ([platform isEqualToString:@"iPhone2,1"]) iphoneType = @"iPhone 3GS";
    else if ([platform isEqualToString:@"iPhone3,1"]) iphoneType = @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,2"]) iphoneType = @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,3"]) iphoneType = @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone4,1"]) iphoneType = @"iPhone 4S";
    else if ([platform isEqualToString:@"iPhone5,1"]) iphoneType = @"iPhone 5";
    else if ([platform isEqualToString:@"iPhone5,2"]) iphoneType = @"iPhone 5";
    else if ([platform isEqualToString:@"iPhone5,3"]) iphoneType = @"iPhone 5c";
    else if ([platform isEqualToString:@"iPhone5,4"]) iphoneType = @"iPhone 5c";
    else if ([platform isEqualToString:@"iPhone6,1"]) iphoneType = @"iPhone 5s";
    else if ([platform isEqualToString:@"iPhone6,2"]) iphoneType = @"iPhone 5s";
    else if ([platform isEqualToString:@"iPhone7,1"]) iphoneType = @"iPhone 6 Plus";
    else if ([platform isEqualToString:@"iPhone7,2"]) iphoneType = @"iPhone 6";
    else if ([platform isEqualToString:@"iPhone8,1"]) iphoneType = @"iPhone 6s";
    else if ([platform isEqualToString:@"iPhone8,2"]) iphoneType = @"iPhone 6s Plus";
    else if ([platform isEqualToString:@"iPhone8,4"]) iphoneType = @"iPhone SE";
    else if ([platform isEqualToString:@"iPhone9,1"]) iphoneType = @"iPhone 7";
    else if ([platform isEqualToString:@"iPhone9,3"]) iphoneType = @"iPhone 7";
    else if ([platform isEqualToString:@"iPhone9,2"]) iphoneType = @"iPhone 7 Plus";
    else if ([platform isEqualToString:@"iPhone9,4"]) iphoneType = @"iPhone 7 Plus";
    else if ([platform isEqualToString:@"iPhone10,1"]) iphoneType = @"iPhone 8";
    else if ([platform isEqualToString:@"iPhone10,4"]) iphoneType = @"iPhone 8";
    else if ([platform isEqualToString:@"iPhone10,2"]) iphoneType = @"iPhone 8 Plus";
    else if ([platform isEqualToString:@"iPhone10,5"]) iphoneType = @"iPhone 8 Plus";
    else if ([platform isEqualToString:@"iPhone10,3"]) iphoneType = @"iPhone X";
    else if ([platform isEqualToString:@"iPhone10,6"]) iphoneType = @"iPhone X";
    else if ([platform isEqualToString:@"iPhone11,2"]) iphoneType = @"iPhone XS";
    else if ([platform isEqualToString:@"iPhone11,3"]) iphoneType = @"iPhone XS Max";
    else if ([platform isEqualToString:@"iPhone11,4"]) iphoneType = @"iPhone XS Max";
    else if ([platform isEqualToString:@"iPhone11,6"]) iphoneType = @"iPhone XS Max";
    else if ([platform isEqualToString:@"iPhone11,8"]) iphoneType = @"iPhone XR";
    else if ([platform isEqualToString:@"iPhone12,1"]) iphoneType = @"iPhone 11";
    else if ([platform isEqualToString:@"iPhone12,3"]) iphoneType = @"iPhone 11 Pro";
    else if ([platform isEqualToString:@"iPhone12,5"]) iphoneType = @"iPhone 11 Pro Max";
    else if ([platform isEqualToString:@"iPhone12,8"]) iphoneType = @"iPhone 11 SE 2";
    else if ([platform isEqualToString:@"iPhone13,1"]) iphoneType = @"iPhone 12 mini";
    else if ([platform isEqualToString:@"iPhone13,2"]) iphoneType = @"iPhone 12";
    else if ([platform isEqualToString:@"iPhone13,3"]) iphoneType = @"iPhone 12 Pro";
    else if ([platform isEqualToString:@"iPhone13,4"]) iphoneType = @"iPhone 12 Pro Max";
    else if ([platform isEqualToString:@"i386"]) iphoneType = @"iPhone Simulator";
    else if ([platform isEqualToString:@"x86_64"]) iphoneType = @"iPhone Simulator";
    else iphoneType = @"iPhone";
    return iphoneType;
}

#define K_IOS_CELLULAR    @"pdp_ip0"
#define K_IOS_WIFI        @"en0"
#define K_IOS_VPN         @"utun0"
#define K_IP_ADDR_IPv4    @"ipv4"
#define K_IP_ADDR_IPv6    @"ipv6"

+ (NSString *)IPAddress:(BOOL)isIPv4 isIPv6:(BOOL)isIPv6 wifi:(BOOL)isWifi {
    NSArray *searchArray = isIPv4 ?
    @[K_IOS_VPN @"/" K_IP_ADDR_IPv4, K_IOS_VPN @"/" K_IP_ADDR_IPv6, K_IOS_WIFI @"/" K_IP_ADDR_IPv4,
      K_IOS_WIFI @"/" K_IP_ADDR_IPv6, K_IOS_CELLULAR @"/" K_IP_ADDR_IPv4, K_IOS_CELLULAR @"/" K_IP_ADDR_IPv6] :
    @[K_IOS_VPN @"/" K_IP_ADDR_IPv6, K_IOS_VPN @"/" K_IP_ADDR_IPv4, K_IOS_WIFI @"/" K_IP_ADDR_IPv6,
      K_IOS_WIFI @"/" K_IP_ADDR_IPv4, K_IOS_CELLULAR @"/" K_IP_ADDR_IPv6, K_IOS_CELLULAR @"/" K_IP_ADDR_IPv4];
    NSDictionary *addresses = [self IPAddresses];
    NSString *ipKey = nil;
    if (isIPv4) {
        ipKey = isWifi ? (K_IOS_WIFI @"/" K_IP_ADDR_IPv4) : (K_IOS_CELLULAR @"/" K_IP_ADDR_IPv4);
    } else if (isIPv6) {
        ipKey = isWifi ? (K_IOS_WIFI @"/" K_IP_ADDR_IPv6) : (K_IOS_CELLULAR @"/" K_IP_ADDR_IPv6);
    }
    __block NSString *address = nil;
    if (ipKey) {
        address = [addresses objectForKey:ipKey];
    } else {
        [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            address = [addresses objectForKey:key];
            if ([self isValidateIP:address]) {*stop = YES;}
        }];
    }
    return [self isValidateIP:address] ? address : @"";
}

+ (BOOL)isValidateIP:(NSString *)ipAddress {
    if (!ipAddress.length) return NO;
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, ipAddress.length)];
        if (firstMatch) return YES;
    }
    return NO;
}

+ (NSDictionary *)IPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    struct ifaddrs *interfaces;
    if (!getifaddrs(&interfaces)) {
        struct ifaddrs *interface;
        for (interface = interfaces; interface; interface = interface->ifa_next) {
            if (!(interface->ifa_flags & IFF_UP)) continue;
            const struct sockaddr_in *addr = (const struct sockaddr_in *)interface->ifa_addr;
            char addrBuf[MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN)];
            if (addr && (addr->sin_family == AF_INET || addr->sin_family == AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if (addr->sin_family == AF_INET) {
                    if (inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = K_IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6 *)interface->ifa_addr;
                    if (inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = K_IP_ADDR_IPv6;
                    }
                }
                if (type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        freeifaddrs(interfaces);
    }
    return addresses.count ? addresses : nil;
}

@end
