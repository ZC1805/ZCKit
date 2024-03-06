//
//  ZCService.h
//  ZCKit
//
//  Created by admin on 2019/1/22.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZCServiceProtocol <NSObject>  /**< 回调时子类可用的方法 */

@optional

- (void)serviceInit;  /**< 初始化回调 */

- (void)serviceCleanData;  /**< 销毁回调 */

- (void)serviceEnterBackground;  /**< 状态回调 */

- (void)serviceEnterForeground;  /**< 状态回调 */

@end


@interface ZCServiceHandler: NSObject  /**< 单例基类，可设置启动和销毁 */

+ (void)fire;  /**< 启动单例管理类，在程序启用的时候调用，只需调用1次 */

+ (void)destoryService;  /**< 销毁单例类，将清除所有继承于ZCService的对象 */

@end


@interface ZCService : NSObject <ZCServiceProtocol>  /**< 通用单例类，可供子类继承 */

- (void)start;  /**< 空方法&调用可以让对象提前初始化 */

+ (instancetype)sharedService;  /**< 单例初始化方法 */

@end

NS_ASSUME_NONNULL_END
