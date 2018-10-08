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

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat right;   /** 在设置宽度后(或size)再设置right，同时设置左右不能确定宽 */
@property (nonatomic, assign) CGFloat bottom;   /** 在设置高度后(或size)再设置bottom，同时设置上下不能确定高 */
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGFloat centerX;   /** 在设置宽度后(或size)再设置centerX */
@property (nonatomic, assign) CGFloat centerY;   /** 在设置高度后(或size)再设置centerY */

@property (nonatomic, readonly) CGFloat visibleAlpha;   /**< 返回屏幕上可见的alpha，考虑到超视窗和窗口 */

@property (nullable, nonatomic, readonly) UIViewController *viewController;   /**< 返回当前所在的控制器 */

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color;

- (void)removeAllSubviews;

- (nullable UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

- (void)setShadow:(nullable UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

- (CGPoint)convertPointToScrren:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END










