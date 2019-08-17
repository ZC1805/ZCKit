//
//  UIViewController+ZC.h
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZCViewControllerBarProtocol <NSObject>  /**< 回调可实现的方法 */

@optional

- (void)isUseCustomBar;  /**< 使用自定义导航栏的实现 */

- (BOOL)isUseClearBar;  /**< 使用全透明导航栏，默认NO */

- (BOOL)isShieldBarShadow;  /**< 屏蔽导航栏阴影线，默认NO */

- (BOOL)isUseTranslucentBar;  /**< 使用半透明导航栏，默认NO */

@end


@interface UIViewController (ZC) <ZCViewControllerBarProtocol>

@property (nonatomic, readonly) UIViewController *presentFromViewController;  /**< 当前控制器顶部的Present控制器 */

/** 返回到上一次控制器，dissmiss或者pop */
- (void)backToUpControllerAnimated:(BOOL)animated;

/** dismiss所有present出来的控制器 */
- (void)dismissAllViewControllerAnimated:(BOOL)animated completion:(nullable void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
