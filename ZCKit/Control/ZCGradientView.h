//
//  ZCGradientView.h
//  ZCKit
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCGradientView : UIView  /**< 渐变的View */

- (void)resetAlphaGradientColors:(NSArray<UIColor *>*)colors isAxial:(BOOL)isAxial startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint location:(nullable NSArray<NSNumber *> *)locations;

- (void)resetBKColor:(nullable UIColor *)BKColor shadowColor:(nullable UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius
        cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor *)borderColor;

@end

NS_ASSUME_NONNULL_END
