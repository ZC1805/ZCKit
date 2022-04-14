//
//  UINavigationController+ZC.h
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (ZC)

- (void)popToViewControllerLike:(Class)likeClass isOtherwiseRoot:(BOOL)isOtherwiseRoot animated:(BOOL)animated;  /**< pop到倒序寻找到第一个likeClassController */

- (nullable __kindof UIViewController *)containViewControllerLike:(Class)likeClass;  /**< 返回容器栈内倒序寻找到第一个likeClassController */

@end

NS_ASSUME_NONNULL_END
