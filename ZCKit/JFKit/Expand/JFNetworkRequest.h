//
//  JFNetworkRequest.h
//  ZCKit
//
//  Created by zjy on 2018/4/27.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFNetworkParameter.h"

/** 刷新加载方式 */
typedef NS_ENUM(NSInteger, JFEnumNetworkRquestType) {
    JFEnumNetworkRquestTypeReload    = 0,  /**< 重载刷新 */
    JFEnumNetworkRquestTypeRefresh   = 1,  /**< 下拉刷新 */
    JFEnumNetworkRquestTypeOverload  = 2,  /**< 上拉加载 */
    JFEnumNetworkRquestTypeSave      = 3,  /**< 上传保存 */
};

NS_ASSUME_NONNULL_BEGIN

@interface JFNetworkRequest : NSObject

/** 默认NO，既对同一个request对象的一个par，按顺序依次请求，请求完成再请求下一个 */
@property (nonatomic, assign) BOOL *concurrencyRequest;

/** 请求参数 & 懒加载 & 也可以自定义赋值 */
@property (nonatomic, strong, readonly) JFNetworkParameter *parameter;


#pragma mark - public function
/** 我的问价列表数据 */
- (void)requestMineAskingPriceList:(void(^)(NSArray *list, BOOL last, long wait, NSString *warning))callback;

/** 购物车问价列表数据 */
- (void)requestCityAskingPriceList:(void(^)(NSArray <NSArray *>*list, NSString *warning))callback;

/** 购物车问价列表数据 */
- (void)submitCityAskingPrice:(void(^)(NSString *desc, BOOL success))callback;

@end

NS_ASSUME_NONNULL_END
