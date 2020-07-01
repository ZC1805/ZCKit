//
//  UILabel+ZC.h
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (ZC)

- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font color:(UIColor *)color;  /**< 带字体的初始化，color为textColor */

- (void)setText:(NSString *)text lineSpacing:(CGFloat)lineSpacing;  /**< 设置行距，最好先设置font */

+ (CGFloat)heiText:(NSString *)text font:(UIFont *)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;  /**< 计算文字行高 */

@end

NS_ASSUME_NONNULL_END

