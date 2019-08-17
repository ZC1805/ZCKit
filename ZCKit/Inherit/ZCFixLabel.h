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

@property (nonatomic, assign) CGSize fixSize;  /**< 自适应size大小，需实现sizeThatFits，默认sizeZero，即无效设置 */

- (void)resetVerticalCenterAlignmentOffsetTop:(CGFloat)offset;  /**< 居中对齐向上偏移offset */

- (void)resetVerticalTopAlignmentOffsetBottom:(CGFloat)offset;  /**< 居上对齐向下偏移offset */

- (void)resetVerticalBottomAlignmentOffsetTop:(CGFloat)offset;  /**< 居下对齐向上偏移offset */

- (void)resetLeftIndent:(CGFloat)leftIndent rightIndent:(CGFloat)rightIndent;  /**< 设置label的左右偏移距离 */

/** 匹配字符串设置富文本，isReverse为是否反向匹配，rSpacing为行间距 */
- (void)setText:(NSString *)text matchText:(NSString *)mText isReverse:(BOOL)isReverse
     attributes:(NSDictionary <NSAttributedStringKey, id>*)attributes rowSpacing:(CGFloat)rSpacing;

@end

NS_ASSUME_NONNULL_END
