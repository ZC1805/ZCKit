//
//  ZCService.m
//  ZCKit
//
//  Created by admin on 2019/1/22.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import "ZCService.h"
#import "ZCKitBridge.h"
#import <UIKit/UIKit.h>
#import "ZCMacro.h"

#pragma mark - ~ ZCServiceImpl ~
@interface ZCServiceImpl : NSObject

@property (nonatomic, strong) NSMutableDictionary *singletons;

@end

@implementation ZCServiceImpl

+ (ZCServiceImpl *)coreImpl {
    ZCServiceImpl *impl = [[ZCServiceImpl alloc] init];
    impl.singletons = [NSMutableDictionary dictionary];
    return impl;
}

- (instancetype)startSingletonByClass:(Class)singletonClass {
    NSString *singletonClassName = NSStringFromClass(singletonClass);
    id singleton = [_singletons objectForKey:singletonClassName];
    if (!singleton) {
        singleton = [[singletonClass alloc] init];
        [_singletons setObject:singleton forKey:singletonClassName];
    }
    return singleton;
}

- (void)stopSingletonByClass:(Class)singletonClass {
    [self.singletons removeObjectForKey:NSStringFromClass(singletonClass)];
}

- (void)callSingletonSelector:(SEL)selecotr {
    NSArray *instances = [_singletons allValues];
    for (id instance in instances) {
        if ([instance respondsToSelector:selecotr]) {
            kZSuppressLeakWarn([instance performSelector:selecotr]);
        }
    }
}

@end


#pragma mark - ~ ZCServiceManager ~
@interface ZCServiceManager ()

@property (nonatomic, strong) NSLock *lock;

@property (nonatomic, strong) ZCServiceImpl *core;

@end

@implementation ZCServiceManager

+ (instancetype)sharedManager {
    static ZCServiceManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZCServiceManager alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        _lock = [[NSLock alloc] init];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(callMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [center addObserver:self selector:@selector(callEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [center addObserver:self selector:@selector(callEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        [center addObserver:self selector:@selector(callAppWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)fire {
    ZCServiceManager *manager = [ZCServiceManager sharedManager];
    [manager.lock lock];
    manager.core = [ZCServiceImpl coreImpl];
    [manager.lock unlock];
}

+ (void)destory {
    ZCServiceManager *manager = [ZCServiceManager sharedManager];
    [manager.lock lock];
    [manager callSingletonClean];
    [manager.core.singletons removeAllObjects];
    manager.core = nil;
    [manager.lock unlock];
}

- (id)singletonByClass:(Class)singletonClass {
    id instance = nil;
    [_lock lock];
    instance = [_core startSingletonByClass:singletonClass];
    [_lock unlock];
    return instance;
}

- (void)stopSingletonByClass:(Class)singletonClass {
    [_lock lock];
    [_core stopSingletonByClass:singletonClass];
    [_lock unlock];
}

#pragma mark - Call
- (void)callSingletonClean {
    [self callSelector:@selector(serviceCleanData)];
}

- (void)callMemoryWarning {
    [self callSelector:@selector(serviceReceiveMemoryWarning)];
}

- (void)callEnterBackground {
    [self callSelector:@selector(serviceEnterBackground)];
}

- (void)callEnterForeground {
    [self callSelector:@selector(serviceEnterForeground)];
}

- (void)callAppWillTerminate {
    [self callSelector:@selector(serviceAppWillTerminate)];
}

- (void)callSelector:(SEL)selector {
    [_core callSingletonSelector:selector];
}

@end


#pragma mark - ~ ZCService ~
@implementation ZCService

+ (instancetype)sharedService {
    return [[ZCServiceManager sharedManager] singletonByClass:self.class];
}

- (void)start {
    if (ZCKitBridge.isPrintLog) NSLog(@"ZCKit: service %@ start", self);
}

- (void)stop {
    if (ZCKitBridge.isPrintLog) NSLog(@"ZCKit: service %@ stop", self);
    [[ZCServiceManager sharedManager] stopSingletonByClass:self.class];
}

@end
