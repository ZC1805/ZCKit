//
//  ZCNavigationHandler.h
//  ZCKit
//
//  Created by admin on 2019/1/11.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCNavigationHandler : NSObject  /**< 导航控制类，需要外部强引用 */

@property (nonatomic, assign) BOOL isShieldInteractivePopGesture;  /**< 是否屏蔽滑动返回，对所有子视图有效，默认NO */

@property (nonatomic, assign) BOOL isInteractivePopGestureFullScreen;  /**< 是否是全屏滑动返回，对所有子视图有效，默认NO */

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *interactiveCustomPopPanGesture;  /**< 滑动手势交互 */

@property (nullable, nonatomic, strong) UIGestureRecognizer *conflictGesture;  /**< 冲突的手势，暂未实现，默认nil */

- (instancetype)initWithNavigation:(UINavigationController *)navigation;  /**< 初始化方法 */

@end

NS_ASSUME_NONNULL_END
