//
//  ZCService.h
//  ZCKit
//
//  Created by admin on 2019/1/22.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZCService <NSObject>

@optional

- (void)serviceCleanData;

- (void)serviceEnterBackground;

- (void)serviceEnterForeground;

- (void)serviceAppWillTerminate;

- (void)serviceReceiveMemoryWarning;

@end


@interface ZCServiceManager: NSObject  /**< 单例基类，可设置启动和销毁 */

+ (void)fire:(NSString *)fireId;  /**< 启动单例管理类，在程序启用的时候调用 */

+ (void)destory;  /**< 销毁单例类，回调clear date，将清除所有继承于ZCService的对象 */

@end


@interface ZCService : NSObject <ZCService>  /**< 通用单例类，可供子类继承 */

+ (instancetype)service;  /**< 单例初始化方法 */

- (void)start;  /**< 空方法，大部分的Service懒加载即可，但是有些因为业务需要在登录后就需要立马生成 */

- (void)stop;  /**< 这个方法，不会走 serviceCleanData 回调，自行在重写stop方法处理 */

@end

NS_ASSUME_NONNULL_END
