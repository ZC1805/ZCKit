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

@protocol ZCViewControllerBackProtocol <NSObject>  /**< 关于导航的设置协议 */

@optional

- (void)onCustomBackAction;  /**< 自定义点击返回实现，注意手动返回将不走此方法 */

- (BOOL)isShieldInteractivePop;  /**< 能否屏蔽手动返回，当实现了onCustomBackAction时候默认此返回YES，默认NO */

- (BOOL)isCanResponseTouchPop;  /**< 是否能手动点击返回，默认YES */

- (BOOL)isHiddenNavigationBar;  /**< 是否在viewWillAppear&viewWillDisappear内设置导航隐藏，默认NO */

@end


@protocol ZCViewControllerPrivateProtocol <NSObject>  /**< 一些私有的设置协议 */

/** 当Present出来时是否使用Push动画，默认NO */
@property (nonatomic, assign) BOOL isUsePushStyleToPresent;

/** 返回当前可见的子视图控制器，addChildVc切换需Vc时，重新赋值返回当先正在显示的childVc，默认返回nil */
@property (nullable, nonatomic, weak) UIViewController *visibleChildViewController;

@end


@interface ZCViewController : UIViewController <ZCViewControllerBackProtocol, ZCViewControllerPrivateProtocol>  /**< 通用vc，供子类继承 */

@end

NS_ASSUME_NONNULL_END
