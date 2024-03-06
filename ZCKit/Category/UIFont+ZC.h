//
//  UIFont+ZC.h
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (ZC)

@property (nonatomic, readonly) BOOL isBold;  /**< 是否是粗体 */

@property (nonatomic, readonly) BOOL isItalic;  /**< 是否是斜体 */

@property (nonatomic, readonly) BOOL isMonoSpace;  /**< 是否是isMonoSpace字体 */

@property (nonatomic, readonly) BOOL isColorGlyphs;  /**< 是否是isColorGlyphs字体 */

@property (nonatomic, readonly) CGFloat fontWeight;  /**< 获取weight值，从-1.0到1.0之间，Regular为0 */

@property (nonatomic, readonly) CGFloat fontHei;  /**< 获取字体单行标签所占的高度 */

@property (nonatomic, readonly) CGFloat fontSize;  /**< 获取字体字号大小 */

/**< 获取粗体font对象 */
- (UIFont *)fontWithBold;

/**< 获取斜体font对象 */
- (UIFont *)fontWithItalic;

/**< 获取粗体斜体font对象 */
- (UIFont *)fontWithBoldItalic;

/**< 获取normal font对象 */
- (UIFont *)fontWithNormal;

/**< 字体设置，weight [1, 9] */
+ (UIFont *)fontSize:(CGFloat)size weight:(NSInteger)weight;

/**< 字体设置，slant [-1, 1] */
+ (UIFont *)fontSize:(CGFloat)size weight:(NSInteger)weight slant:(CGFloat)slant;

/**< 字体设置，family 字体 */
+ (UIFont *)fontFamily:(NSString *)family size:(CGFloat)size weight:(NSInteger)weight slant:(CGFloat)slant;

@end

NS_ASSUME_NONNULL_END
