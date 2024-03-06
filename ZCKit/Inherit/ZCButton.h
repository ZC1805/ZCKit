//
//  ZCButton.h
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCButton : UIButton  /**< 拓展布局和响应范围 */

@property (nonatomic, strong) NSDictionary *data;  /**< 绑定数据，默认nil */

@property (nonatomic, assign) BOOL isUseGrayImage;  /**< 使用灰度图片，默认NO */

@property (nonatomic, assign) CGSize fixSize;  /**< 自适应size大小，需实现sizeThatFits，默认sizeZero，即无效设置 */

@property (nullable, nonatomic, copy) void(^touchAction)(ZCButton *sender);  /**< 添加TouchUpInset回调，默认nil */

@property (nonatomic, assign) UIEdgeInsets responseAreaExtend;  /**< 延伸响应区域，默认zero */

@property (nonatomic, assign) NSTimeInterval delayResponseTime;  /**< 延迟响应时间，默认0 */

@property (nonatomic, assign) NSTimeInterval responseTouchInterval;  /**< 最小响应时间间隔，默认0.3秒 */

@property (nullable, nonatomic, copy) NSString *ignoreConstraintSelector;  /**< 忽略上面设置的延迟时间、响应间隔的方法，默认nil */


- (instancetype)initWithTitle:(nullable NSString *)title font:(nullable UIFont *)font color:(nullable UIColor *)color image:(nullable id)image bgColor:(nullable UIColor *)bgColor;  /**< 指定初始化 */

- (instancetype)initWithBKColor:(nullable UIColor *)color target:(nullable id)target action:(nullable SEL)action;  /**< 指定初始化 */

/**< 图片顶文字底布局，且水平方向居中对齐，space为垂直方向的间距，设置space为-1则重置到系统布局，此时设置imageEdgeInsets和titleEdgeInsets无效 */
- (void)resetIsTopImageBottomTitleAndSpace:(CGFloat)space;

/**< 图片右文字左布局，且垂直方向居中对齐，space为水平方向的间距，offset水平方向整体偏移，titleTopExtraOffset为文字向上偏移量 */
/**< 设置space为-1则重置到系统布局，此时设置imageEdgeInsets和titleEdgeInsets无效 */
- (void)resetIsRightImageLeftTitleAndSpace:(CGFloat)space offset:(CGFloat)offset titleTopExtraOffset:(CGFloat)titleTopExtraOffset;

/**< 图片左文字右布局，且垂直方向居中对齐，space为水平方向的间距，offset水平方向整体偏移，titleTopExtraOffset为文字向上偏移量 */
/**< 设置space为-1则重置到系统布局，此时设置imageEdgeInsets和titleEdgeInsets无效 */
- (void)resetIsLeftImageRightTitleAndSpace:(CGFloat)space offset:(CGFloat)offset titleTopExtraOffset:(CGFloat)titleTopExtraOffset;

/**< 自定义图片和文本的大小，设置zero则使用系统计算大小 */
- (void)resetImageSize:(CGSize)imageSize titleSize:(CGSize)titleSize;

@end

NS_ASSUME_NONNULL_END
