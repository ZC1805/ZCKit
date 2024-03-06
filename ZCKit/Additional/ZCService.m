//
//  ZCService.m
//  ZCKit
//
//  Created by admin on 2019/1/22.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import "ZCService.h"
#import "ZCMacro.h"

#define kZSuppressLeakWarn(func) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
func; \
_Pragma("clang diagnostic pop") \
} while (0)

#pragma mark - ~ ZCServiceImpl ~
@interface ZCService ()

- (instancetype)initWithClass:(Class)instanceClass;

@end

@interface ZCServiceImpl : NSObject

@property (nonatomic, strong) NSMutableDictionary *implKvs;

@end

@implementation ZCServiceImpl

+ (ZCServiceImpl *)implCore {
    ZCServiceImpl *impl = [[ZCServiceImpl alloc] init];
    impl.implKvs = [NSMutableDictionary dictionary];
    return impl;
}

- (instancetype)implStartSingletonByClass:(Class)singletonClass {
    NSString *singletonName = NSStringFromClass(singletonClass);
    id instance = [_implKvs objectForKey:singletonName];
    if (!instance) { instance = [(ZCService *)[singletonClass alloc] initWithClass:nil];
        [_implKvs setObject:instance forKey:singletonName];
        [self implCallSingletonSelector:@selector(serviceInit) class:singletonClass];
    } return instance;
}

- (void)implStopSingletonByClass:(Class)singletonClass {
    if (singletonClass) {
        [_implKvs removeObjectForKey:NSStringFromClass(singletonClass)];
    } else {
        [_implKvs removeAllObjects];
    }
}

- (void)implCallSingletonSelector:(SEL)selecotr class:(Class)singletonClass {
    if (singletonClass) {
        id instance = [_implKvs objectForKey:NSStringFromClass(singletonClass)];
        if (instance && [instance respondsToSelector:selecotr]) {
            kZSuppressLeakWarn([instance performSelector:selecotr]);
        }
    } else {
        for (id instance in _implKvs.allValues) {
            if (instance && [instance respondsToSelector:selecotr]) {
                kZSuppressLeakWarn([instance performSelector:selecotr]);
            }
        }
    }
}

@end


#pragma mark - ~ ZCServiceHandler ~
@interface ZCServiceHandler ()

@property (nonatomic, strong) NSLock *lock;

@property (nonatomic, strong) ZCServiceImpl *core;

@end

@implementation ZCServiceHandler

+ (instancetype)sharedManager {
    static ZCServiceHandler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZCServiceHandler alloc] init];
    }); return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _lock = [[NSLock alloc] init];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(callEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [center addObserver:self selector:@selector(callEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    } return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)fire {
    ZCServiceHandler *manager = ZCServiceHandler.sharedManager;
    [manager.lock lock];
    manager.core = [ZCServiceImpl implCore];
    [manager.lock unlock];
}

+ (void)destoryService {
    ZCServiceHandler *manager = ZCServiceHandler.sharedManager;
    [manager.lock lock];
    [manager.core implCallSingletonSelector:@selector(serviceCleanData) class:nil];
    [manager.core implStopSingletonByClass:nil];
    [manager.lock unlock];
}

- (id)constructInstanceByClass:(Class)instanceClass {
    id instance = nil;
    [_lock lock];
    instance = [_core implStartSingletonByClass:instanceClass];
    [_lock unlock];
    return instance;
}

- (void)cleanInstanceByClass:(Class)instanceClass {
    [_lock lock];
    [_core implCallSingletonSelector:@selector(serviceCleanData) class:instanceClass];
    [_core implStopSingletonByClass:instanceClass];
    [_lock unlock];
}

#pragma mark - Call
- (void)callEnterBackground {
    [_lock lock];
    [_core implCallSingletonSelector:@selector(serviceEnterBackground) class:nil];
    [_lock unlock];
}

- (void)callEnterForeground {
    [_lock lock];
    [_core implCallSingletonSelector:@selector(serviceEnterForeground) class:nil];
    [_lock unlock];
}

@end


#pragma mark - ~ ZCService ~
@implementation ZCService

+ (instancetype)sharedService {
    NSAssert(![NSStringFromClass(self) isEqualToString:@"ZCService"], @"ZCKit: service not be ZCService");
    return [ZCServiceHandler.sharedManager constructInstanceByClass:self];
}

- (instancetype)initWithClass:(Class)instanceClass {
    if (self = [super init]) {}
    return self;
}

- (instancetype)init {
    if (self = [super init]) { NSAssert(NO, @"ZCKit: service not be init"); }
    return self;
}

- (void)stop {
    [ZCServiceHandler.sharedManager cleanInstanceByClass:self.class];
}

- (void)start {
#warning - 数据本地化代码 & 日期选则框 & ZCBoxView & ZCMaskView & ZCScrollView
    
}

@end
