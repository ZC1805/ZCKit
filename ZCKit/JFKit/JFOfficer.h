//
//  JFOfficer.h
//  gobe
//
//  Created by zjy on 2019/3/15.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 运行的环境 */
typedef NS_ENUM(NSUInteger, JFEnumRunServer) {
    JFEnumRunServerFormal = 0,  //正式环境
    JFEnumRunServerInside = 1,  //内测环境
    JFEnumRunServerTest   = 2,  //测试环境
};

@interface JFOfficer : NSObject  /** 需外部手动配置 */

@property (nonatomic, assign) JFEnumRunServer runServer;  /** 运行环境 */

@property (nonatomic, copy, readonly) NSString *basicUrl;  /** 网络请求头url */

@property (nonatomic, copy, readonly) NSString *basicApi;  /** web页面头部url */

@property (nonatomic, copy, readonly) NSString *appkeyPath;  /** 按appkey存储文件的路径 */

@property (nonatomic, copy, readonly) NSString *accountId;  /**< 当前用户的账户id */


+ (instancetype)sharedOfficer;

- (void)start;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
