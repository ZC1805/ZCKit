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

- (BOOL)isUseNaviBarShadowColor;  /**< 使用导航栏阴影色，默认NO */

@end


@protocol ZCViewControllerViewProtocol <NSObject>  /**< 回调控制器子视图的响应方法*/

@optional

- (BOOL)isHandlePointInside:(UIView *)view point:(CGPoint)point event:(UIEvent *)event;  /**< 返回处理这个视图的响应事件，然后再进行下一步回调 */

- (BOOL)pointInside:(CGPoint)point view:(UIView *)view event:(UIEvent *)event;  /**< 返回是否响应这个交互事件 */

- (BOOL)isHandleHitView:(UIView *)view point:(CGPoint)point event:(UIEvent *)event;  /**< 返回处理事件的视图，然后再进行下一步回调 */

- (nullable UIView *)hitTest:(CGPoint)point view:(UIView *)view event:(UIEvent *)event;  /**< 返回处理事件的视图 */

@end


@interface UIViewController (ZC) <ZCViewControllerBarProtocol, ZCViewControllerViewProtocol>

@property (nonatomic, readonly) UIViewController *presentFromViewController;  /**< 当前控制器顶部的Present控制器 */

@property (nonatomic, readonly) NSString *hierarchicalRoute;  /**< 当前控制器层级链，可能返回@"" */

/** 返回到上一次控制器，dissmiss或者pop */
- (void)backToUpControllerAnimated:(BOOL)animated;

/** dismiss所有从当前控制器present出来的控制器 */
- (void)dismissAllViewControllerAnimated:(BOOL)animated completion:(nullable void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
