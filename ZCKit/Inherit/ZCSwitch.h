//
//  ZCSwitch.h
//  ZCKit
//
//  Created by admin on 2019/1/4.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCSwitch : UISwitch  /**< 添加响应block */

@property (nullable, nonatomic, copy) void(^touchAction)(ZCSwitch *sender);  /**< 添加valueChange回调，默认nil */

@end

NS_ASSUME_NONNULL_END
