//
//  ZCMonitorService.h
//  ZCKit
//
//  Created by admin on 2019/1/11.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, ZCMonitorType) {
    ZCMonitorTypeNone   = 0,  /**< 用于获取监听类型 */
    ZCMonitorTypeTest   = 1 << 0,
};

typedef NS_ENUM(NSInteger, ZCMonitorPriority) {
    ZCMonitorPriorityLow      = 0,  /**< 低优先级 */
    ZCMonitorPriorityNormal   = 1,  /**< 默认优先 */
    ZCMonitorPriorityMiddle   = 2,  /**< 中优先级 */
    ZCMonitorPriorityHigh     = 3,  /**< 高优先级 */
};

NS_ASSUME_NONNULL_BEGIN

@interface ZCMonitorBroadcast : NSObject

@property (nonatomic, assign, readonly) int rank;  /**< 广播接收者先后排名，从0开始 */

@property (nonatomic, assign, readonly) ZCMonitorType type;  /**< 广播类型 */

@property (nonatomic, assign, readonly) ZCMonitorPriority priority;  /**< 广播优先级 */

@property (nullable, nonatomic, strong, readonly) id issuer;  /**< 广播的发布者 */

@property (nullable, nonatomic, strong, readonly) id object;  /**< 广播传递的对象 */

@property (nonatomic, strong, readonly) NSDictionary *infos;  /**< 传递的信息字典 */

@property (nonatomic, strong, readonly) NSArray <NSString *>*ids;  /**< 传递的信息数组 */

+ (instancetype)broadcastType:(ZCMonitorType)type issuer:(nullable id)issuer;  /**< 初始化 */

- (void)resetObject:(nullable id)object ids:(nullable NSArray <NSString *>*)ids infos:(nullable NSDictionary *)infos;  /**< 赋值 */

@end


@protocol ZCMonitorProtocol <NSObject>

@required
/** 返回的复合值值就是需要监听的广播 & 返回值不可变，收到广播在此分发下去，特定对象在此接收，broadcast.type在此为单值 */
- (ZCMonitorType)monitorForwardBroadcast:(ZCMonitorBroadcast *)broadcast;

@optional
/** 返回对特定类型的广播接收的优先级，broadcast.type在此为单值 */
- (ZCMonitorPriority)monitorPriorityWithType:(ZCMonitorType)type;

@end


@interface ZCMonitorService : NSObject  /**< 通知广播发送类 */

/** 发布广播，type在此可以是复合值来同时发送多个广播 & 复合值发送顺序按子type从小到大 */
+ (void)issue_broadcast:(ZCMonitorType)type issuer:(nullable id)issuer;

/** 发布广播，type在此可以是复合值来同时发送多个广播 & 复合值发送顺序按子type从小到大 */
+ (void)issue_broadcast:(ZCMonitorBroadcast *)broadcast;

/** 移除监听 */
+ (void)remove_listener:(id <ZCMonitorProtocol>)listener;
    
/** 注册监听 */
+ (void)register_listener:(id <ZCMonitorProtocol>)listener;

@end

NS_ASSUME_NONNULL_END
