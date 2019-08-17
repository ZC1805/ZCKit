//
//  ZCLabel.h
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCLabel : UILabel  /**< 当text或font改变会自动计算size，字体默认系统16，颜色默认B30，默认可显示多行 */

@property (nonatomic, assign) CGFloat rowSpacing;  /**< 行间距，默认ZSA(0) */

@property (nonatomic, assign) CGFloat wordSpacing;  /**< 字间距，默认ZSA(0) */

@property (nonatomic, assign) CGFloat headTailIndent;  /**< 首尾缩进，默认ZSA(0) */

@property (nonatomic, strong, readonly) NSMutableParagraphStyle *pStyle;  /**< 段落风格，修改排版需要调用update */

/** 计算固定宽度时的高度 */
- (CGFloat)calculateTextHeight:(CGFloat)maxWidth;

/** 计算单行时候的宽度 */
- (CGFloat)calculateTextWidth;

/** 更新attribute或者Paragraph的设置 */
- (void)updateTextAttributeOrParagraphStyle;

@end

NS_ASSUME_NONNULL_END
