//
//  JFNetworkParameter.h
//  ZCKit
//
//  Created by zjy on 2018/5/4.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static long static_page_size = 10;
static long static_base_tag = 10210;
static long static_ignore_value = (NSIntegerMin + 100);

@interface JFNetworkParameter : NSObject

/** 做数据请求参数属性，类型(NSString/NSArray/NSDictionary/long/float/本类类型) */
@property (nullable, nonatomic, copy) NSString *Id;  //既id

@property (nonatomic, assign) long pageNumber;

@property (nonatomic, assign) long pageSize;

@property (nonatomic, assign) float productCount;

/** 做保存数据属性 & 以var_开头 */
@property (nonatomic, assign) bool var_loadlast;  /** 是否加载到最后，get属性 */

@property (nonatomic, assign) bool var_loading;   /** 是否正在加载，get属性 */

/** 构造请求参数 */
- (NSMutableDictionary *)injectPropertyToParameter;

@end

NS_ASSUME_NONNULL_END


