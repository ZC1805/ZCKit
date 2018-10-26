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

+ (double)systemVersion;  /**< 系统版本 */

@property (nonatomic, readonly) BOOL isPad;  /**< 是否是iPad */

@property (nonatomic, readonly) BOOL isSimulator;  /**< 是否是模拟器 */

@property (nonatomic, readonly) BOOL isCanMakePhoneCalls NS_EXTENSION_UNAVAILABLE_IOS("");  /**< 是否可打电话 */

@property (nullable, nonatomic, readonly) NSString *ipAddressWIFI;  /**< 设备的wifi IP地址 */

@property (nullable, nonatomic, readonly) NSString *ipAddressCell;  /**< IP地址 */

@property (nullable, nonatomic, readonly) NSString *machineModel;  /**< 设备型号 "iPhone6,1" */

@property (nonatomic, readonly) NSUInteger cpuCount;  /**< 处理器核数 (-1表示错误) */

@property (nonatomic, readonly) int64_t diskSpace;  /**< 磁盘大小 */

@property (nonatomic, readonly) int64_t memoryTotal;  /**< 内存大小 */

@end

NS_ASSUME_NONNULL_END

