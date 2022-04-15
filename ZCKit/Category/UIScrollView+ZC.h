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

@property (nonatomic) CGFloat zc_offsetX;  /**< 水平偏移量 */

@property (nonatomic) CGFloat zc_offsetY;  /**< 垂直偏移量 */

@property (nonatomic) CGFloat zc_sizeWidth;  /**< size宽 */

@property (nonatomic) CGFloat zc_sizeHeight;  /**< size高 */

#pragma mark - Direction
@property (nonatomic, assign, readonly) ZCEnumScrollViewDirection horizontalScrollingDirection;  /**< 水平滑动方向 */

@property (nonatomic, assign, readonly) ZCEnumScrollViewDirection verticalScrollingDirection;  /**< 垂直滑动方向 */

- (void)startObservingDirection;  /**< 开始监听滑动 */

- (void)stopObservingDirection;  /**< 结束监听滑动 */

@end

NS_ASSUME_NONNULL_END
