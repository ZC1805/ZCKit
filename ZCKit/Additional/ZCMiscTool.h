//
//  ZCMiscTool.h
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCMiscTool : NSObject  /**< 杂碎处理类 */

@property (class, nonatomic, readonly) NSString *timestamp;  /**< 系统是否是中文 */

@property (class, nonatomic, readonly) BOOL isChinese;  /**< 系统是否是中文 */

@property (class, nonatomic, readonly) BOOL isOpenVPN;  /**< 是否使用VPN */

@property (class, nonatomic, readonly) BOOL isJailBreak;  /**< 是否越狱 */
 
@property (class, nonatomic, readonly) NSString *wifiName;  /**< 获取wifi名字 */

+ (void)ipAddressWifi:(BOOL)wifi block:(void(^)(NSString *address))block;  /**< 获取ip地址 */

+ (NSString *)urlStringFromHost:(NSString *)host parms:(nullable NSDictionary <NSString *, NSString *>*)parms;  /**< 合并成Url */

+ (NSDictionary <NSString *, NSString *>*)paramsFromUrlString:(NSString *)urlString;  /**< 从Url上提取参数 */

+ (long long)calculateFileSizeAtPath:(NSString *)path;  /**< 文件大小 */

+ (long long)calculateFolderSizeAtPath:(NSString *)path;  /**< 文件夹大小 */

@end

NS_ASSUME_NONNULL_END
