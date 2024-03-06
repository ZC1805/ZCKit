//
//  ZCCountLabel.h
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZCEnumLabelCountingMethod) {
    ZCEnumLabelCountingMethodEaseInOut = 0,  /**< 计数方式 */
    ZCEnumLabelCountingMethodEaseIn    = 1,  /**< 计数方式 */
    ZCEnumLabelCountingMethodEaseOut   = 2,  /**< 计数方式 */
    ZCEnumLabelCountingMethodLinear    = 3,  /**< 计数方式 */
};

@interface ZCCountLabel : UILabel  /**< 快速计数标签 */

@property (nonatomic, assign) ZCEnumLabelCountingMethod method;  /**< 计数方式 */

@property (nonatomic, assign) NSTimeInterval animationDuration;  /**< 动画时长，默认2s */

@property (nullable, nonatomic, copy) NSString *format;  /**< 显示格式，@"%d"、@"%.1f%%"、默认@"%f" */

@property (nullable, nonatomic, copy) NSString *(^formatBlock)(CGFloat value);  /**< 显示格式回调 */

@property (nullable, nonatomic, copy) NSAttributedString *(^attributedFormatBlock)(CGFloat value);  /**< 显示格式回调 */

@property (nullable, nonatomic, copy) void(^completionBlock)(void);  /**< 显示完成回调 */

- (void)countFrom:(CGFloat)startValue to:(CGFloat)endValue;

- (void)countFrom:(CGFloat)startValue to:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

- (void)countFromCurrentValueTo:(CGFloat)endValue;

- (void)countFromCurrentValueTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

- (void)countFromZeroTo:(CGFloat)endValue;

- (void)countFromZeroTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

- (CGFloat)currentValue;

@end

NS_ASSUME_NONNULL_END
