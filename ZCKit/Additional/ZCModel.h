//
//  ZCModel.h
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZCModelProtocol <NSObject>  /**< 手动转换需要子类实现的协议 */

@optional

- (void)propertyAssignmentFinish;  /**< 对象解析完成，供子类实现 */

- (void)propertyAssignmentFromJsonDic:(NSDictionary *)jsonDic;  /**< 解析字典对象，供子类实现 */

@end

@interface ZCModel : NSObject <ZCModelProtocol>  /**< 模型对象，供子类实现 */

- (instancetype)initWithJsonDic:(nullable NSDictionary *)jsonDic;  /**< 用json字典初始化 */

+ (NSArray *)instancesWithJsonDicArr:(nullable NSArray <NSDictionary *>*)jsonDicArr;  /**< 用json字典数组初始化实例对象数组 */

@end

NS_ASSUME_NONNULL_END
