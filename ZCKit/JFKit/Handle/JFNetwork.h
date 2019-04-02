//
//  JFNetwork.h
//  gobe
//
//  Created by zjy on 2019/3/16.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFNetwork : NSObject

@property (nonatomic, assign) BOOL isBreakContact;

@property (nonatomic, copy) NSString *networkState;

/** 单例实例对象 */
+ (instancetype)sharedNetwork;

/** 错误解析处理 */
+ (NSString *)errorString:(nullable NSError *)error;

/** 使用http、https发送post请求，cmdUrl子路径，pars参数，block请求结果回调 */
+ (void)post:(NSString *)cmdUrl pars:(nullable NSDictionary *)pars
       block:(nullable void(^)(NSString *_Nullable fail, NSDictionary *_Nullable data))block;

/** 使用http、https发送get请求，cmdUrl子路径，pars参数，block请求结果回调 */
+ (void)get:(NSString *)cmdUrl pars:(nullable NSDictionary *)pars
      block:(nullable void(^)(NSString *_Nullable fail, NSDictionary *_Nullable data))block;

/** 使用http、https发送post上传图片请求，cmdUrl子路径，block请求结果回调 */
+ (void)image:(UIImage *)image block:(nullable void(^)(NSString *_Nullable fail, NSString *_Nullable path))block;

@end

NS_ASSUME_NONNULL_END
