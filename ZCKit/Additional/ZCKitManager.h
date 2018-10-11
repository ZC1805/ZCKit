//
//  ZCKitManager.h
//  ZCKit
//
//  Created by admin on 2018/10/10.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCKitManager : NSObject

@property (class, nonatomic, assign) BOOL isPrintLog;   /**< 是否需要打印日志，默认NO */

@property (class, nonatomic, copy) NSString *naviBackImageName;   /**< 导航的返回箭头图片，默认"zc_image_back_arrow" */

@property (class, nonatomic, copy) NSString *sideArrowImageName;   /**< 侧边箭头图片名字，默认"zc_image_side_accessory" */

@property (class, nonatomic, copy, readonly) NSString *invalidStr;   /**< 定义的特定无效值，默认"zc_invalid_value &.Ignore" */

@end

NS_ASSUME_NONNULL_END

