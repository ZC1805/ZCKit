//
//  UIView+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZC)

@property (nonatomic, readonly) CGFloat visibleAlpha;   /** 返回屏幕上可见的alpha，考虑到超视窗和窗口 */

@property (nullable, nonatomic, readonly) UIViewController *viewController;   /** 返回当前所在的控制器 */

- (void)removeAllSubviews;

- (nullable UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

- (void)setShadow:(nullable UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

- (CGPoint)convertPointToScrren:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END










