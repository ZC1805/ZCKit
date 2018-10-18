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

@property (nonatomic, assign) CGFloat right;   /**< 在设置宽度后(或size)再设置right，同时设置左右不能确定宽 */

@property (nonatomic, assign) CGFloat bottom;   /**< 在设置高度后(或size)再设置bottom，同时设置上下不能确定高 */

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGSize  size;

@property (nonatomic, assign) CGFloat centerX;   /**< 在设置宽度后(或size)再设置centerX */

@property (nonatomic, assign) CGFloat centerY;   /**< 在设置高度后(或size)再设置centerY */

@property (nonatomic, readonly) CGFloat visibleAlpha;   /**< 返回屏幕上可见的alpha，考虑到超视窗和窗口 */

@property (nullable, nonatomic, readonly) UIViewController *viewController;   /**< 返回当前所在的控制器 */


- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color;   /**< 带背景颜色初始化 */

- (void)removeAllSubviews;   /**< 移除所有子视图 */

- (NSArray *)containAllSubviews;   /**< 所有子视图集合 */

- (nullable UIView *)findFirstResponder;   /**< 往下找到第一响应者 */

- (BOOL)containSubView:(UIView *)subView;   /**< 递归向下，找到最低层 */

- (BOOL)containSubViewOfClassType:(Class)aClass;   /**< 递归向下，找到最低层 */

- (nullable UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;   /**< 快照 */

- (void)setShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;   /**< 阴影 */

- (void)setCorner:(NSInteger)radius color:(UIColor *)color width:(CGFloat)width;   /**< 圆角 & 描边 */

- (void)setCorner:(UIRectCorner)corner radius:(CGSize)radius;   /**< 设置部分圆角 */

- (CGPoint)convertPointToScrren:(CGPoint)point;   /**< 转换到屏幕的坐标 */

@end

NS_ASSUME_NONNULL_END

