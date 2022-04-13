//
//  UIViewController+ZC.h
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZCViewControllerNaviBarProtocol <NSObject>  /**< 回调可实现的方法，只调用一次且不可逆 */

@optional

- (void)onNaviUseCustomBar;  /**< 使用自定义系统导航栏的实现 */

- (BOOL)isNaviUseClearBar;  /**< 使用全透明导航栏，默认NO */

- (BOOL)isNaviUseShieldBarLine;  /**< 屏蔽导航栏阴影线，默认NO */

- (BOOL)isNaviUseTranslucentBar;  /**< 使用半透明导航栏，默认NO */

- (BOOL)isNaviUseBarShadowColor;  /**< 使用导航栏阴影色，默认NO */

@end


@protocol ZCViewControllerViewProtocol <NSObject>  /**< 回调控制器子视图的响应方法*/

@optional

- (BOOL)isHandlePointInside:(UIView *)view point:(CGPoint)point event:(UIEvent *)event;  /**< 返回处理这个视图的响应事件，然后再进行下一步回调 */

- (BOOL)pointInside:(CGPoint)point view:(UIView *)view event:(UIEvent *)event;  /**< 返回是否响应这个交互事件 */

- (BOOL)isHandleHitView:(UIView *)view point:(CGPoint)point event:(UIEvent *)event;  /**< 返回处理事件的视图，然后再进行下一步回调 */

- (nullable UIView *)hitTest:(CGPoint)point view:(UIView *)view event:(UIEvent *)event;  /**< 返回处理事件的视图 */

@end


@interface UIViewController (ZC) <ZCViewControllerNaviBarProtocol, ZCViewControllerViewProtocol>

@property (nonatomic, readonly) UIViewController *presentFromViewController;  /**< 当前控制器顶部的Present控制器 */

@property (nonatomic, readonly) NSString *hierarchicalRoute;  /**< 当前控制器层级链，可能返回@"" */

- (void)backToUpControllerAnimated:(BOOL)animated;  /**< 返回到上一次控制器，dissmiss或者pop */

- (void)dismissAllViewControllerAnimated:(BOOL)animated completion:(nullable void(^)(void))completion;  /**< dismiss所有从当前控制器present出来的控制器 */

@end

NS_ASSUME_NONNULL_END
