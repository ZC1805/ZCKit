//
//  UIView+JF.h
//  gobe
//
//  Created by zjy on 2019/3/16.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JF)

/** 影藏当前视图所有Hud */
- (void)hideAllHud;

/** 显示失败弹窗，持续2秒 */
- (void)showFailureWithTip:(NSString *)tip;

/** 显示完成弹窗，持续2秒 */
- (void)showCompletedWithTip:(NSString *)tip;

/** 隐藏等待页面 */
- (void)hideLoading;

/** 显示等待页面 */
- (void)showLoading:(nullable NSString *)tip;

/** 显示信息提示框，持续2秒 */
- (void)showToastWithTip:(NSString *)tip;

/** 显示信息提示框，时间自定 */
- (void)showToastWithTip:(NSString *)tip delay:(NSTimeInterval)delay;

/** 显示error提示框，持续2秒 */
- (void)showToastWithError:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_END
