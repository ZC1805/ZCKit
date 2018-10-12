//
//  UIScrollView+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZCEnumScrollViewDirection) {
    ZCEnumScrollViewDirectionNone,
    ZCEnumScrollViewDirectionRight,
    ZCEnumScrollViewDirectionLeft,
    ZCEnumScrollViewDirectionUp,
    ZCEnumScrollViewDirectionDown,
};

@interface UIScrollView (ZC)

@property (nonatomic, assign) CGFloat offsetX;

@property (nonatomic, assign) CGFloat offsetY;

@property (nonatomic, assign) CGFloat sizeWidth;

@property (nonatomic, assign) CGFloat sizeHeight;

@property (nonatomic, assign) CGFloat insetTop;

@property (nonatomic, assign) CGFloat insetLeft;

@property (nonatomic, assign) CGFloat insetBottom;

@property (nonatomic, assign) CGFloat insetRight;

@property (nonatomic, assign) CGFloat visualOffsetX;

@property (nonatomic, assign) CGFloat visualOffsetY; 

#pragma mark - direction
@property (nonatomic, assign, readonly) ZCEnumScrollViewDirection horizontalScrollingDirection;   /**< 水平滑动方向 */

@property (nonatomic, assign, readonly) ZCEnumScrollViewDirection verticalScrollingDirection;   /**< 垂直滑动方向 */

- (void)startObservingDirection;   /**< 开始监听滑动 */

- (void)stopObservingDirection;   /**< 结束监听滑动 */

#pragma mark - misc
- (void)shieldNavigationInteractivePop;   /**< 使系统导航自带的右滑返回手势失效 (不可逆) */

#pragma mark - offset
@property (nonatomic, strong) UIColor *topOffsetColor;   /**< 上部偏移出来的颜色设置 */

@property (nonatomic, strong) UIColor *bottomOffsetColor;   /**< 底部偏移出来的颜色设置 */

@property (nonatomic, assign) CGPoint visualOffset;   /**< 直观的偏移量，相对于初始位置目视滑动的距离 */

- (CGPoint)convertToContentOffsetFromVisualOffset:(CGPoint)visualOffset;   /**< 转换成 content offset */

- (CGPoint)convertToVisualOffsetFromContentOffset:(CGPoint)contentOffset;   /**< 转换成 visual offset */

#pragma mark - scroll
- (void)scrollToTopAnimated:(BOOL)animated;

- (void)scrollToBottomAnimated:(BOOL)animated;

- (void)scrollToLeftAnimated:(BOOL)animated;

- (void)scrollToRightAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

