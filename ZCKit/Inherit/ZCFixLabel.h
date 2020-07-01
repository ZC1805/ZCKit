//
//  ZCFixLabel.h
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCFixLabel : UILabel

@property (nonatomic, assign) CGFloat lineSpace;  /**< 行间距，需在setText/.text=之前设置，默认0 */

@property (nonatomic, assign) CGSize fixSize;  /**< 自适应size大小，需实现sizeThatFits，默认sizeZero，即无效设置 */

@property (nonatomic, assign) UIEdgeInsets insideRect;  /**< 设置内部边距，默认为edgeZero，最好在设置Text之前就设置好 */

- (instancetype)initWithColor:(nullable UIColor *)color font:(nullable UIFont *)font alignment:(NSTextAlignment)alignment adjustsSize:(BOOL)adjustsSize;  /**< 初始化 */

- (void)resetVerticalCenterAlignmentOffsetTop:(CGFloat)offset;  /**< 居中对齐向上偏移offset，与insideRect同时设无效 */

- (void)resetVerticalTopAlignmentOffsetBottom:(CGFloat)offset;  /**< 居上对齐向下偏移offset，与insideRect同时设无效 */

- (void)resetVerticalBottomAlignmentOffsetTop:(CGFloat)offset;  /**< 居下对齐向上偏移offset，与insideRect同时设无效 */

- (void)resetInitProperty;  /**< 重设到初始化属性值 */

/** 匹配字符串设置富文本，只匹配一次，isReverse为是否反向匹配，rSpacing为行间距 */
- (void)setText:(NSString *)text matchText:(nullable NSString *)mText isReverse:(BOOL)isReverse
     attributes:(nullable NSDictionary <NSAttributedStringKey, id>*)attributes rowSpacing:(CGFloat)rSpacing;

@end

NS_ASSUME_NONNULL_END
