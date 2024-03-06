//
//  ZCLabel.h
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCLabel : UILabel  /**< 好用的label控件setText前设置对齐颜色字体 */

@property (nonatomic, assign) CGFloat lineSpacing;  /**< 行间距(不适用富文本)，需在setText/.text=之&self.font=前设置，默认0 */

@property (nonatomic, assign) CGFloat headIndent;  /**< 头部缩进(不适用富文本)，需在setText/.text=之&self.font=前设置，默认0 */

@property (nonatomic, assign) CGSize fixSize;  /**< 自适应size大小，需实现sizeThatFits，默认sizeZero，即无效设置 */

@property (nonatomic, assign) UIEdgeInsets insideInsets;  /**< 设置内部边距，默认为edgeZero，最好在设置Text之前就设置好 */

@property (nullable, nonatomic, copy) void(^touchAction)(ZCLabel *sender);  /**< 添加TouchUpInset手势回调，默认nil */

- (instancetype)initWithColor:(nullable UIColor *)color font:(nullable UIFont *)font alignment:(NSTextAlignment)alignment adjustsSize:(BOOL)adjustsSize;  /**< 初始化，多行的话最好设置字体自适应 */

- (instancetype)initWithColor:(nullable UIColor *)color font:(nullable UIFont *)font;  /**< 初始化，多行的话最好设置字体自适应，alignment_left，adjustsSize_YES */

- (void)resetVerticalCenterAlignmentOffsetTop:(CGFloat)offset;  /**< 居中对齐向上偏移offset，与insideInsets同时设无效，不适用minToSize */

- (void)resetVerticalTopAlignmentOffsetBottom:(CGFloat)offset;  /**< 居上对齐向下偏移offset，与insideInsets同时设无效，不适用minToSize */

- (void)resetVerticalBottomAlignmentOffsetTop:(CGFloat)offset;  /**< 居下对齐向上偏移offset，与insideInsets同时设无效，不适用minToSize */

/**< 匹配字符串设置富文本(调用此方法前需initWithColor:font:alignment:adjustsSize:方法前设置了font和color)，只匹配一次，isReverse为是否反向匹配，font为匹配文字的字体(nil时不改变)&color为匹配文字的颜色(nil时不改变)，spacing为lable的行间距，忽略首位缩进 */
- (void)setText:(NSString *)text matchText:(NSString *)mText isReverse:(BOOL)isReverse font:(nullable UIFont *)font color:(nullable UIColor *)color spacing:(CGFloat)spacing;

/**< 计算高度或者宽度且重新设置frame(isLimitLines是否使用当前设置的行数，isRichText是否使用富文本计算)，初始时需要传入最大宽度，最好在设置了text、font、space、alignment后调用此方法 */
- (CGSize)autoToSizeIsLimitLines:(BOOL)isLimitLines isRichText:(BOOL)isRichText;

/**< 不限行高的使用Text计算高度或者宽度且重新设置frame，初始时需要传入最大宽度，最好在设置了text、lines、head、font、space、alignment后调用此方法 */
- (CGSize)autoAdaptToSize;

@end

NS_ASSUME_NONNULL_END
