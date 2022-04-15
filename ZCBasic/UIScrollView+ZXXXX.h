//
//  UIScrollView+ZXXXX.h
//  ZCTest
//
//  Created by zjy on 2022/4/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (ZXXXX)

#pragma mark - Offset
@property (nullable, nonatomic, strong) UIColor *topExpandColor;  /**< 上部偏移出来的颜色设置，在确定frame后再设置 */

@property (nullable, nonatomic, strong) UIColor *bottomExpandColor;  /**< 底部偏移出来的颜色设置，在确定frame后再设置 */

@end

NS_ASSUME_NONNULL_END
