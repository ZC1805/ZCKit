//
//  JFNetworkModel.h
//  ZCKit
//
//  Created by zjy on 2018/4/28.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JFNetworkModelProtocol <NSObject>

@optional

- (void)propertyAssignmentFinish;

- (void)propertyAssignmentFromJsonArr:(nonnull NSArray *)jsonArr;

- (void)propertyAssignmentFromJsonDic:(nonnull NSDictionary *)jsonDic;

@end


@interface JFNetworkModel : NSObject <JFNetworkModelProtocol>

@property (nonatomic, assign) long refreshStep;  /** 用于记录一些状态，默认0 */

- (instancetype)initWithJsonArr:(nullable NSArray *)jsonArr;

- (instancetype)initWithJsonDic:(nullable NSDictionary *)jsonDic;

@end

NS_ASSUME_NONNULL_END
