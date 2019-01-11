//
//  ZCMonitorService.h
//  ZCKit
//
//  Created by admin on 2019/1/11.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCMonitorService.h"

#define MONITOR_USE_PRIORITY  0  /* 是否使用优先级，暂不使用 */

#pragma mark - Class - ZCMonitorBroadcast
@implementation ZCMonitorBroadcast

- (instancetype)initWithType:(ZCMonitorType)type issuer:(id)issuer {
    if (self = [super init]) {
        _rank = 0;
        _type = type;
        _issuer = issuer;
        _ids = [NSArray array];
        _infos = [NSDictionary dictionary];
        _priority = ZCMonitorPriorityNormal;
    }
    return self;
}

- (void)resetObject:(id)object ids:(NSArray <NSString *>*)ids infos:(NSDictionary *)infos {
    _object = object;
    if (ids) _ids = ids;
    if (infos) _infos = infos;
}

- (void)resetRank:(int)rank priority:(ZCMonitorPriority)priority {
    _rank = rank;
    _priority = priority;
}

+ (instancetype)broadcastType:(ZCMonitorType)type issuer:(id)issuer {
    ZCMonitorBroadcast *broadcast = [[ZCMonitorBroadcast alloc] initWithType:type issuer:issuer];
    return broadcast;
}

+ (instancetype)broadcastType:(ZCMonitorType)type issuer:(id)issuer copy:(ZCMonitorBroadcast *)origin {
    ZCMonitorBroadcast *broadcast = [[ZCMonitorBroadcast alloc] initWithType:type issuer:issuer];
    [broadcast resetObject:origin.object ids:origin.ids infos:origin.infos];
    return broadcast;
}

@end


#pragma mark - Class - ZCMonitorListener
@interface ZCMonitorListener : NSObject

@property (nonatomic, weak) id <ZCMonitorProtocol> listener;  /**< 广播接收者 */

@property (nonatomic, assign) ZCMonitorType listenType;  /**< 广播接收类型 */

@property (nonatomic, assign) NSUInteger mask1;  /**< mask * 2e+0 */

@property (nonatomic, assign) NSUInteger mask2;  /**< mask * 2e+1 */

@end

@implementation ZCMonitorListener

- (instancetype)initWith_listener:(id <ZCMonitorProtocol>)listener {
    if (self = [super init]) {
        self.listener = listener;
    }
    return self;
}

- (void)setListener:(id<ZCMonitorProtocol>)listener {
    _listener = listener;
    if ([listener respondsToSelector:@selector(monitorForwardBroadcast:)]) {
        _listenType = [listener monitorForwardBroadcast:[ZCMonitorBroadcast broadcastType:ZCMonitorTypeNone issuer:nil]];
    }
    if (MONITOR_USE_PRIORITY) {
        _mask1 = 0; _mask2 = 0;
        NSUInteger n = _listenType; NSUInteger i = 0;
        while (n > 0) {
            NSUInteger y = n % 2; n >>= 1;
            if (y == 1) {
                NSUInteger type = 1 << i;
                if ([listener respondsToSelector:@selector(monitorPriorityWithType:)]) {
                    ZCMonitorPriority priority = [listener monitorPriorityWithType:type];
                    if (priority & 1) _mask1 = _mask1 | type;
                    if (priority & 2) _mask2 = _mask2 | type;
                } else {
                    _mask1 = _mask1 | type;
                }
            }
            i += 1;
        }
    }
}

@end


#pragma mark - Class - ZCMonitor
@interface ZCMonitorService ()

@property (nonatomic, strong) NSMutableArray <ZCMonitorListener *>*listeners;

@end

@implementation ZCMonitorService

+ (instancetype)instance {
    static ZCMonitorService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZCMonitorService alloc] init];
    });
    return instance;
}

- (NSMutableArray <ZCMonitorListener *>*)listeners {
    if (!_listeners) {
        _listeners = [NSMutableArray array];
    }
    return _listeners;
}

- (void)dealloc {
    [self.listeners removeAllObjects];
}

- (ZCMonitorPriority)listenPriority:(ZCMonitorListener *)listen mask:(NSUInteger)mask {
    return 2 * ((listen.mask2 & mask) ? 1 : 0) + ((listen.mask1 & mask) ? 1 : 0);
}

- (void)issue_map:(ZCMonitorBroadcast *)subbro {
    NSMutableArray *maps = [NSMutableArray arrayWithCapacity:self.listeners.count];
    for (ZCMonitorListener *listen in self.listeners) {
        if (listen.listener && (listen.listenType & subbro.type)) {
            [maps addObject:listen];
        }
    }
    [maps sortUsingComparator:^NSComparisonResult(ZCMonitorListener *_Nonnull obj1, ZCMonitorListener *_Nonnull obj2) {
        ZCMonitorPriority pri1 = [self listenPriority:obj1 mask:subbro.type];
        ZCMonitorPriority pri2 = [self listenPriority:obj2 mask:subbro.type];
        if (pri1 == pri2) return NSOrderedSame;
        else if (pri1 > pri2) return NSOrderedAscending;
        else return NSOrderedDescending;
    }];
    int rank = 0;
    for (ZCMonitorListener *listen in maps) {
        if ([listen.listener respondsToSelector:@selector(monitorForwardBroadcast:)]) {
            [subbro resetRank:rank priority:[self listenPriority:listen mask:subbro.type]];
            [listen.listener monitorForwardBroadcast:subbro];
            rank += 1;
        }
    }
}

- (void)issue_api:(ZCMonitorBroadcast *)broadcast {
    if (!broadcast || broadcast.type == ZCMonitorTypeNone) {
        NSAssert(0, @"monitor type is mistake"); return;
    }
    NSMutableArray *subbros = [NSMutableArray array];
    NSUInteger n = broadcast.type; NSUInteger i = 0;
    while (n > 0) {
        NSUInteger y = n % 2; n >>= 1;
        if (y == 1) [subbros addObject:[ZCMonitorBroadcast broadcastType:(1 << i) issuer:broadcast.issuer copy:broadcast]];
        i += 1;
    }
    for (ZCMonitorBroadcast *subbro in subbros) {
        if (MONITOR_USE_PRIORITY) {[self issue_map:subbro]; continue;}
        int rank = 0;
        for (ZCMonitorListener *listen in self.listeners) {
            if (listen.listener && (listen.listenType & subbro.type)) {
                if ([listen.listener respondsToSelector:@selector(monitorForwardBroadcast:)]) {
                    [subbro resetRank:rank priority:ZCMonitorPriorityNormal];
                    [listen.listener monitorForwardBroadcast:subbro];
                    rank += 1;
                }
            }
        }
    }
}

#pragma mark - API
+ (void)issue_broadcast:(ZCMonitorType)type issuer:(id)issuer {
    NSAssert([NSThread currentThread].isMainThread, @"current is not main thread");
    ZCMonitorBroadcast *broadcast = [ZCMonitorBroadcast broadcastType:type issuer:issuer];
    [[ZCMonitorService instance] issue_api:broadcast];
}

+ (void)issue_broadcast:(ZCMonitorBroadcast *)broadcast {
    NSAssert([NSThread currentThread].isMainThread, @"current is not main thread");
    [[ZCMonitorService instance] issue_api:broadcast];
}

+ (void)register_listener:(id <ZCMonitorProtocol>)listener {
    if (!listener) return;
    NSAssert([NSThread currentThread].isMainThread, @"current is not main thread");
    ZCMonitorService *monitor = [ZCMonitorService instance];
    ZCMonitorListener *audience = nil;
    for (ZCMonitorListener *member in monitor.listeners) {
        if (member.listener && [member.listener isEqual:listener]) {
            audience = member; break;
        }
        if (!member.listener && !audience) {
            audience = member;
        }
    }
    if (audience) {
        if (!audience.listener) audience.listener = listener;
    } else {
        [monitor.listeners addObject:[[ZCMonitorListener alloc] initWith_listener:listener]];
    }
}

+ (void)remove_listener:(id <ZCMonitorProtocol>)listener {
    if (!listener) return;
    NSAssert([NSThread currentThread].isMainThread, @"current is not main thread");
    ZCMonitorService *monitor = [ZCMonitorService instance];
    ZCMonitorListener *removeAudience = nil;
    NSMutableArray *audiences = [NSMutableArray array];
    for (ZCMonitorListener *member in monitor.listeners) {
        if (!member.listener) {
            [audiences addObject:member];
        } else if ([member.listener isEqual:listener]) {
            removeAudience = member;
        }
    }
    if (audiences.count) {
        [monitor.listeners removeObjectsInArray:audiences];
    }
    if (removeAudience) {
        [monitor.listeners removeObject:removeAudience];
    }
}

@end
