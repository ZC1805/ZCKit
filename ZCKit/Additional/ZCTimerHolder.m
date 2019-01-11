//
//  ZCTimerHolder.m
//  ZCKit
//
//  Created by admin on 2019/1/11.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCTimerHolder.h"
#import <UIKit/UIKit.h>

#pragma mark - Class - ZCTimerHolder
@interface ZCTimerHolder () {
    NSTimer *_timer;
    BOOL _sleep;
    BOOL _repeats;
    NSUInteger _timeoutCount;
    NSUInteger _overtime;
}

@property (nonatomic, weak) id <ZCTimerHolderDelegate> timerDelegate;

@end

@implementation ZCTimerHolder

- (void)dealloc {
    [self invalidateTimer];
}

- (void)startTimer:(NSTimeInterval)seconds sleepTimeout:(NSUInteger)timeoutCount delegate:(id<ZCTimerHolderDelegate>)delegate {
    if (_timer) [self invalidateTimer];
    NSTimeInterval interval = seconds <= 0 ? 1 : seconds;
    _timeoutCount = timeoutCount;
    _repeats = timeoutCount != 0;
    _timerDelegate = delegate;
    _overtime = 0;
    _sleep = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(onTimer:) userInfo:nil repeats:_repeats];
}

- (void)onTimer:(NSTimer *)timer {
    if (!_repeats) {
        [self invalidateTimer];
    }
    BOOL valid = NO;
    if (_timerDelegate && [_timerDelegate respondsToSelector:@selector(timerHolderFired:)]) {
        valid = [_timerDelegate timerHolderFired:self];
    }
    if (valid && _overtime != 0) {
        _overtime = 0;
    } else if (!valid) {
        _overtime = _overtime + 1;
    }
    if (_overtime >= _timeoutCount) {
        [self sleepTimer];
    }
}

- (void)sleepTimer {
    _sleep = YES;
    if (_timer) [_timer setFireDate:[NSDate distantFuture]];
    if (_timerDelegate && [_timerDelegate respondsToSelector:@selector(timerHolderSleep:)]) {
        [_timerDelegate timerHolderSleep:self];
    }
}

- (void)rebootTimer {
    _sleep = NO;
    _overtime = 0;
    if (_timer) [_timer setFireDate:[NSDate distantPast]];
}

- (void)invalidateTimer {
    if (_timer) [_timer invalidate];
    _timer = nil;
    _timerDelegate = nil;
}

#pragma mark - Getter
- (BOOL)isSleeping {
    return _sleep;
}

- (BOOL)isInvalid {
    return (_timer == nil);
}

- (NSUInteger)overtimeCount {
    return _overtime;
}

@end



#pragma mark - Class - ZCAssemblePart
@interface ZCAssemblePart ()

@property (nonatomic, strong) NSMutableArray <id>*contents;

@property (nonatomic, strong) NSMutableArray <NSString *>*fireIds;

@end

@implementation ZCAssemblePart

- (instancetype)initWithType:(ZCMonitorType)type fireId:(NSString *)fireId content:(id)content {
    if (self = [super init]) {
        _type = type;
        _fireId = fireId ? fireId : @"";
        _content = content ? content : [NSNull null];
    }
    return self;
}

- (NSArray <NSString *>*)fireIdAssemble {
    return self.fireIds;
}

- (NSArray <id>*)contentAssemble {
    return self.contents;
}

- (NSMutableArray <NSString *>*)fireIds {
    if (!_fireIds) {
        _fireIds = [NSMutableArray array];
    }
    return _fireIds;
}

- (NSMutableArray <id>*)contents {
    if (!_contents) {
        _contents = [NSMutableArray array];
    }
    return _contents;
}

@end


#pragma mark - Class - ZCAssembleFirer
@interface ZCAssembleFirer () <ZCTimerHolderDelegate>

@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSMutableArray <ZCAssemblePart *>*>*cachePool;

@property (nonatomic, strong) NSMutableArray <NSNumber *>*clearsTypes;

@property (nonatomic, strong) ZCTimerHolder *timer;

@end

@implementation ZCAssembleFirer

- (instancetype)initWithSleepTimeoutCount:(NSUInteger)timeoutCount interval:(NSTimeInterval)interval {
    if (self = [super init]) {
        [self startTimer:timeoutCount interval:interval];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(lostActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [center addObserver:self selector:@selector(becomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (BOOL)isSleeping {
    return self.timer.isSleeping;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.timer invalidateTimer];
}

- (void)startTimer:(NSUInteger)timeoutCount interval:(NSTimeInterval)interval {
    if (timeoutCount <= 0) timeoutCount = 1;
    self.maxAssemble = 10;
    self.isAllowOverflowIssue = NO;
    self.timer = [[ZCTimerHolder alloc] init];
    self.clearsTypes = [NSMutableArray array];
    self.cachePool = [NSMutableDictionary dictionary];
    [self.timer startTimer:interval sleepTimeout:timeoutCount delegate:self];
}

- (void)lostActive:(id)sender {
    [self.timer sleepTimer];
}

- (void)becomeActive:(id)sender {
    if (self.cachePool.count) [self.timer rebootTimer];
}

#pragma mark - API
- (void)fireAssemblePart:(ZCMonitorType)type fireId:(NSString *)fireId content:(id)content {
    NSAssert([NSThread currentThread].isMainThread, @"info must be fired in main thread");
    [self fire:type fireId:fireId content:content];
    if (self.timer.isSleeping) [self.timer rebootTimer];
}

#pragma mark - Private
- (void)fire:(ZCMonitorType)type fireId:(NSString *)fireId content:(id)content {
    if (type == ZCMonitorTypeNone) return;
    NSUInteger n = type; NSUInteger i = 0;
    while (n > 0) {
        NSUInteger y = n % 2; n >>= 1;
        if (y == 1) {
            ZCAssemblePart *part = [[ZCAssemblePart alloc] initWithType:(1 << i) fireId:fireId content:content];
            [self partsForType:part.type addPart:part];
        }
        i += 1;
    }
}

- (void)partsForType:(ZCMonitorType)type addPart:(ZCAssemblePart *)part {
    NSNumber *key = [NSNumber numberWithUnsignedInteger:type];
    NSMutableArray *parts = [self.cachePool objectForKey:key];
    if (!parts) {
        parts = [NSMutableArray array];
        [self.cachePool setObject:parts forKey:key];
    }
    [parts addObject:part];
    if (self.isAllowOverflowIssue && parts.count > self.maxAssemble) {
        NSArray <ZCAssemblePart *>* subParts = [parts subarrayWithRange:NSMakeRange(0, self.maxAssemble)];
        [parts removeObjectsInRange:NSMakeRange(0, self.maxAssemble)];
        [self issueAssembleParts:subParts];
    }
}

- (void)issueAssembleParts:(NSArray <ZCAssemblePart *>*)parts {
    if (!parts || !parts.count) return;
    ZCAssemblePart *last = parts.lastObject;
    for (ZCAssemblePart *part in parts) {
        [last.fireIds addObject:part.fireId];
        [last.contents addObject:part.content];
    }
    ZCMonitorBroadcast *broadcast = [ZCMonitorBroadcast broadcastType:last.type issuer:nil];
    [broadcast resetObject:last ids:last.fireIds infos:nil];
    [ZCMonitorService issue_broadcast:broadcast];
}

#pragma mark - ZCTimerHolderDelegate
- (BOOL)timerHolderFired:(ZCTimerHolder *)holder {
    if (!self.cachePool.count) return NO;
    [self.cachePool enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSMutableArray<ZCAssemblePart *> * _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray <ZCAssemblePart *>* subParts = nil;
        if (obj.count > self.maxAssemble) {
            subParts = [obj subarrayWithRange:NSMakeRange(0, self.maxAssemble)];
            [obj removeObjectsInRange:NSMakeRange(0, self.maxAssemble)];
        } else {
            subParts = [NSArray arrayWithArray:obj];
            [self.clearsTypes addObject:key];
        }
        [self issueAssembleParts:subParts];
    }];
    [self.cachePool removeObjectsForKeys:self.clearsTypes];
    [self.clearsTypes removeAllObjects];
    return YES;
}

@end
