//
//  UIViewController+ZC.h
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZC)

@property (nonatomic, readonly) BOOL isViewInDisplay;  /**< 当前的view是否正在展示 */

@property (nonatomic, readonly) UIViewController *presentFromViewController;  /**< 当前控制器顶部的Present控制器 */

- (void)dismissAllViewControllerAnimated:(BOOL)animated completion:(nullable void(^)(void))completion;  /**< dismiss所有从当前控制器present出来的控制器 */

@end

NS_ASSUME_NONNULL_END
