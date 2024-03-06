//
//  ZCViewController.h
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSNotificationName const ZCViewControllerDidBeGesPopNotification;  /**< 系统手动侧滑返回成功Pop事件通知，object为当前top控制器 */

@interface ZCViewControllerCustomPageSet : NSObject  /**< 回调可实现的方法，每次进页面时会使用这些属性一次，有些属性需要配合ZCNavigationController使用 */

@property (nonatomic, assign) BOOL isPageShieldInteractivePop;  /**< 是否屏蔽手动返回，若实现了onPageCustomTapBackAction而没实现onPageCustomPanBackAction则自动返回YES，默认NO */

@property (nonatomic, assign) BOOL isPageHiddenNavigationBar;  /**< 是否在viewWillAppear&viewWillDisappear内设置导航隐藏，导航推出TabbarVC&其子视图为新的NaviVC时需要手动隐藏导航栏，默认NO */

@property (nonatomic, assign) BOOL isNaviUseClearBar;  /**< 使用全透明导航栏，默认NO */

@property (nonatomic, assign) BOOL isNaviUseShieldBarLine;  /**< 屏蔽导航栏阴影线，默认NO */

@property (nonatomic, assign) BOOL isNaviUseBarShadowColor;  /**< 使用导航栏阴影色，默认NO */

@property (nullable, nonatomic, copy) NSString *naviUseCustomTitleColor;  /**< 使用自定义导航标题颜色，默认nil */

@property (nullable, nonatomic, copy) NSString *naviUseCustomBackgroundName;  /**< 使用自定义导航背景颜色或图片名，默认nil */

@property (nullable, nonatomic, strong) UIImage *naviUseCustomBackArrowImage;  /**< 使用自定义导航背景返回箭头，默认nil */

@end


@protocol ZCViewControllerPageBackProtocol <NSObject>  /**< 关于导航的设置协议，需要配合ZCNavigationController使用 */

@optional

- (nullable UIViewController *)onPageCustomPanBackAction;  /**< 自定义手动侧换返回实现，返回需要手动侧滑到的目标控制器，返回nil或不实现此方法则按系统处理 */

- (void)onPageCustomTapBackAction;  /**< 自定义点击返回按钮的实现，注意手动返回将不走此方法 */

- (void)onPageCustomInitSet:(ZCViewControllerCustomPageSet *)customPageSet;  /**< 可对页面或者导航进行自定义设置 */

@end


@protocol ZCViewControllerPrivateProtocol <NSObject>  /**< 一些私有的设置协议 */

@property (nonatomic, assign) BOOL isUsePushStyleToPresent;  /**< 当Present出来时是否使用Push动画，默认NO */

@property (nullable, nonatomic, weak) UIViewController *visibleChildViewController;  /**< 返回当前可见的子视图控制器，addChildVc切换需Vc时，重新赋值返回当先正在显示的childVc，默认返回nil */

@end


@interface ZCViewController : UIViewController <ZCViewControllerPageBackProtocol, ZCViewControllerPrivateProtocol>  /**< 通用vc，供子类继承 */

@property (nonatomic, copy, readonly) NSDictionary <NSString *, id>*iniProps;  /**< 初始化属性 */

- (instancetype)initWithIniProps:(nullable NSDictionary<NSString *, id> *)iniProps;  /**< 统一初始化方法 */

- (BOOL)isCanMSideBack;  /**< 子类继承 能否侧滑 */

- (int)currentPageStyle;  /**< 子类继承 1.nav_white 2.nav_black 4.has_status_bar 8.no_status_bar */

@end

NS_ASSUME_NONNULL_END
