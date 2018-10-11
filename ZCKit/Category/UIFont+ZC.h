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

@property (nonatomic, readonly) BOOL isBold NS_AVAILABLE_IOS(7_0);   /**< 是否是粗体 */

@property (nonatomic, readonly) BOOL isItalic NS_AVAILABLE_IOS(7_0);   /**< 是否是斜体 */

@property (nonatomic, readonly) BOOL isMonoSpace NS_AVAILABLE_IOS(7_0);   /**< 是否是isMonoSpace字体 */

@property (nonatomic, readonly) BOOL isColorGlyphs NS_AVAILABLE_IOS(7_0);   /**< 是否是isColorGlyphs字体 */

@property (nonatomic, readonly) CGFloat fontWeight NS_AVAILABLE_IOS(7_0);   /**< 获取weight值，从-1.0到1.0之间，Regular为0.0 */


/** 获取粗体font对象 */
- (nullable UIFont *)fontWithBold NS_AVAILABLE_IOS(7_0);

/** 获取斜体font对象 */
- (nullable UIFont *)fontWithItalic NS_AVAILABLE_IOS(7_0);

/** 获取粗体斜体font对象 */
- (nullable UIFont *)fontWithBoldItalic NS_AVAILABLE_IOS(7_0);

/** 获取粗体normal font对象 */
- (nullable UIFont *)fontWithNormal NS_AVAILABLE_IOS(7_0);


/** 字体设置，weight [1, 9] */
+ (UIFont *)fontSize:(CGFloat)size weight:(NSInteger)weight;

/** 字体设置，slant [-1, 1] */
+ (UIFont *)fontSize:(CGFloat)size weight:(NSInteger)weight slant:(CGFloat)slant;

/** 字体设置，family 字体 */
+ (UIFont *)fontFamily:(NSString *)family size:(CGFloat)size weight:(NSInteger)weight slant:(CGFloat)slant;

@end

NS_ASSUME_NONNULL_END

