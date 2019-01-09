//
//  UINavigationController+ZCSwizzle.h
//  ZCKit
//
//  Created by admin on 2019/1/9.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (ZCSwizzle)

@property (nonatomic, assign) BOOL isNormalBar;  /**< 是否是通常的Bar，默认NO */

@end

NS_ASSUME_NONNULL_END
