//
//  UIDevice+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (ZC)

@property (class, nonatomic, readonly) double systemVersion;  /**< 系统版本 */

@property (class, nonatomic, readonly) BOOL isPad;  /**< 是否是iPad */

@property (class, nonatomic, readonly) BOOL isSimulator;  /**< 是否是模拟器 */

@property (class, nonatomic, readonly) BOOL isCanMakePhoneCalls NS_EXTENSION_UNAVAILABLE_IOS("");  /**< 是否可打电话 */

@property (class, nonatomic, readonly) NSString *wifiSSID;  /**< wifi名称，ios12之后，需要capbilities打开access WiFi information */

@property (class, nonatomic, readonly) NSString *macBSSID;  /**< 路由器mac地址，ios12之后，需要capbilities打开access WiFi information */

@property (class, nonatomic, readonly) NSString *ipv4Address;  /**< 当前网络移动网络IPv4地址 */

@property (class, nonatomic, readonly) NSString *machineModel;  /**< 设备型号 "iPhone6,1" */

@property (class, nonatomic, readonly) NSString *iphoneDeviceName;  /**< 设备型号 "iPhone X" */

@property (class, nonatomic, readonly) NSUInteger cpuCount;  /**< 处理器核数 (-1表示错误) */

@property (class, nonatomic, readonly) NSTimeInterval systemUptime;  /**< 系统启动时间 */

@property (class, nonatomic, readonly) int64_t diskSpace;  /**< 磁盘大小 */

@property (class, nonatomic, readonly) int64_t memoryTotal;  /**< 内存大小 */

+ (BOOL)isValidateIP:(NSString *)ipAddress;  /**< 是否是标准IP地址 */

@end

NS_ASSUME_NONNULL_END
