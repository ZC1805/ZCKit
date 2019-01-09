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
    ZCEnumScrollViewDirectionNone  = 0,  /**< 无滑动 */
    ZCEnumScrollViewDirectionRight = 1,  /**< 右滑动 */
    ZCEnumScrollViewDirectionLeft  = 2,  /**< 左滑动 */
    ZCEnumScrollViewDirectionUp    = 3,  /**< 上滑动 */
    ZCEnumScrollViewDirectionDown  = 4,  /**< 下滑动 */
};

@interface UIScrollView (ZC)

@property (nonatomic, assign) CGFloat offsetX;  /**< 水平偏移量 */

@property (nonatomic, assign) CGFloat offsetY;  /**< 垂直偏移量 */

@property (nonatomic, assign) CGFloat sizeWidth;  /**< size宽 */

@property (nonatomic, assign) CGFloat sizeHeight;  /**< size高 */

@property (nonatomic, assign) CGFloat insetTop;  /**< inset顶部 */

@property (nonatomic, assign) CGFloat insetLeft;  /**< inset左部 */

@property (nonatomic, assign) CGFloat insetBottom;  /**< inset底部 */

@property (nonatomic, assign) CGFloat insetRight;  /**< inset右部 */

@property (nonatomic, assign) CGFloat visualOffsetX;  /**< 直观的水平偏移量 */

@property (nonatomic, assign) CGFloat visualOffsetY;  /**< 直观的垂直偏移量 */


#pragma mark - misc
- (void)shieldNavigationInteractivePop;  /**< 使系统导航自带的右滑返回手势失效 (不可逆) */

#pragma mark - offset
@property (nonatomic, strong) UIColor *topOffsetColor;  /**< 上部偏移出来的颜色设置 */

@property (nonatomic, strong) UIColor *bottomOffsetColor;  /**< 底部偏移出来的颜色设置 */

@property (nonatomic, assign) CGPoint visualOffset;  /**< 肉眼直观偏移量，相对于初始位置目视滑动的距离 */

@property (nonatomic, assign, readonly) CGPoint relativeOffset;  /**< 相对与刚可反弹时零界点的偏移量 */

- (CGPoint)convertToContentOffsetFromVisualOffset:(CGPoint)visualOffset;  /**< 转换成 content offset */

- (CGPoint)convertToVisualOffsetFromContentOffset:(CGPoint)contentOffset;  /**< 转换成 visual offset */


#pragma mark - scroll
- (void)scrollToTopAnimated:(BOOL)animated;

- (void)scrollToBottomAnimated:(BOOL)animated;

- (void)scrollToLeftAnimated:(BOOL)animated;

- (void)scrollToRightAnimated:(BOOL)animated;


#pragma mark - direction
@property (nonatomic, assign, readonly) ZCEnumScrollViewDirection horizontalScrollingDirection;  /**< 水平滑动方向 */

@property (nonatomic, assign, readonly) ZCEnumScrollViewDirection verticalScrollingDirection;  /**< 垂直滑动方向 */

- (void)startObservingDirection;  /**< 开始监听滑动 */

- (void)stopObservingDirection;  /**< 结束监听滑动 */

@end

NS_ASSUME_NONNULL_END

