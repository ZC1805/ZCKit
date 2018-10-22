//
//  UIDevice+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIDevice+ZC.h"
#import "NSString+ZC.h"
//#include <sys/socket.h>
//#include <sys/sysctl.h>
//#include <net/if.h>
//#include <net/if_dl.h>
//#include <mach/mach.h>
//#include <arpa/inet.h>
//#include <ifaddrs.h>

@implementation UIDevice (ZC)

//#pragma mark - usually
//+ (double)systemVersion {
//    static double version;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        version = [UIDevice currentDevice].systemVersion.doubleValue;
//    });
//    return version;
//}
//
//- (BOOL)isPad {
//    static dispatch_once_t one;
//    static BOOL pad;
//    dispatch_once(&one, ^{
//        pad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
//    });
//    return pad;
//}
//
//- (BOOL)isSimulator {
//#if TARGET_OS_SIMULATOR
//    return YES;
//#else
//    return NO;
//#endif
//}
//
//- (BOOL)isJailbroken {
//    if ([self isSimulator]) return NO;
//    // iOS9 URL Scheme query changed ...
//    // NSURL *cydiaURL = [NSURL URLWithString:@"cydia://package"];
//    // if ([[UIApplication sharedApplication] canOpenURL:cydiaURL]) return YES;
//    NSArray *paths = @[@"/Applications/Cydia.app", @"/private/var/lib/apt/", @"/private/var/lib/cydia", @"/private/var/stash"];
//    for (NSString *path in paths) {
//        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return YES;
//    }
//    FILE *bash = fopen("/bin/bash", "r");
//    if (bash != NULL) {
//        fclose(bash);
//        return YES;
//    }
//    NSString *path = [NSString stringWithFormat:@"/private/%@", [NSString stringWithUUID]];
//    if ([@"test" writeToFile : path atomically : YES encoding : NSUTF8StringEncoding error : NULL]) {
//        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//        return YES;
//    }
//    return NO;
//}
//
//#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
//- (BOOL)isCanMakePhoneCalls {
//    __block BOOL can;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        can = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
//    });
//    return can;
//}
//#endif
//
//- (NSString *)ipAddressWithIfaName:(NSString *)name {
//    if (name.length == 0) return nil;
//    NSString *address = nil;
//    struct ifaddrs *addrs = NULL;
//    if (getifaddrs(&addrs) == 0) {
//        struct ifaddrs *addr = addrs;
//        while (addr) {
//            if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:name]) {
//                sa_family_t family = addr->ifa_addr->sa_family;
//                switch (family) {
//                    case AF_INET: { // IPv4
//                        char str[INET_ADDRSTRLEN] = {0};
//                        inet_ntop(family, &(((struct sockaddr_in *)addr->ifa_addr)->sin_addr), str, sizeof(str));
//                        if (strlen(str) > 0) {
//                            address = [NSString stringWithUTF8String:str];
//                        }
//                    } break;
//                    case AF_INET6: { // IPv6
//                        char str[INET6_ADDRSTRLEN] = {0};
//                        inet_ntop(family, &(((struct sockaddr_in6 *)addr->ifa_addr)->sin6_addr), str, sizeof(str));
//                        if (strlen(str) > 0) {
//                            address = [NSString stringWithUTF8String:str];
//                        }
//                    }
//                    default: break;
//                }
//                if (address) break;
//            }
//            addr = addr->ifa_next;
//        }
//    }
//    freeifaddrs(addrs);
//    return address;
//}
//
//- (NSString *)ipAddressWIFI {
//    return [self ipAddressWithIfaName:@"en0"];
//}
//
//- (NSString *)ipAddressCell {
//    return [self ipAddressWithIfaName:@"pdp_ip0"];
//}
//
//- (NSString *)machineModel {
//    static dispatch_once_t one;
//    static NSString *model;
//    dispatch_once(&one, ^{
//        size_t size;
//        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
//        char *machine = malloc(size);
//        sysctlbyname("hw.machine", machine, &size, NULL, 0);
//        model = [NSString stringWithUTF8String:machine];
//        free(machine);
//    });
//    return model;
//}
//
//- (NSArray *)cpuUsagePerProcessor {
//    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
//    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
//    unsigned _numCPUs;
//    NSLock *_cpuUsageLock;
//    
//    int _mib[2U] = { CTL_HW, HW_NCPU };
//    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
//    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
//    if (_status) _numCPUs = 1;
//    _cpuUsageLock = [[NSLock alloc] init];
//    
//    natural_t _numCPUsU = 0U;
//    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
//    if (err == KERN_SUCCESS) {
//        [_cpuUsageLock lock];
//        
//        NSMutableArray *cpus = [NSMutableArray new];
//        for (unsigned i = 0U; i < _numCPUs; ++i) {
//            Float32 _inUse, _total;
//            if (_prevCPUInfo) {
//                _inUse = (
//                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
//                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
//                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
//                          );
//                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
//            } else {
//                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
//                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
//            }
//            [cpus addObject:@(_inUse / _total)];
//        }
//        
//        [_cpuUsageLock unlock];
//        if (_prevCPUInfo) {
//            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
//            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
//        }
//        return cpus;
//    } else {
//        return nil;
//    }
//}
//
//- (NSUInteger)cpuCount {
//    return [NSProcessInfo processInfo].activeProcessorCount;
//}
//
//- (float)cpuUsage {
//    float cpu = 0;
//    NSArray *cpus = [self cpuUsagePerProcessor];
//    if (cpus.count == 0) return -1;
//    for (NSNumber *n in cpus) {
//        cpu += n.floatValue;
//    }
//    return cpu;
//}
//
//- (NSDate *)systemUptime {
//    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
//    return [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - time)];
//}
//
//#pragma mark - misc
//- (int64_t)diskSpace {
//    NSError *error = nil;
//    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
//    if (error) return -1;
//    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
//    if (space < 0) space = -1;
//    return space;
//}
//
//- (int64_t)memoryTotal {
//    int64_t mem = [[NSProcessInfo processInfo] physicalMemory];
//    if (mem < -1) mem = -1;
//    return mem;
//}

@end

