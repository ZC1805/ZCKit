//
//  ZCSearchControl.h
//  ZCKit
//
//  Created by admin on 2018/10/26.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCSearchControl : UIControl  /**< 搜索样式控件 */

@property (nonatomic, assign) BOOL isGrayStyle;  /**< 是否是灰色风格，默认YES */

@property (nonatomic, assign) BOOL isCenterAlignment;  /**< 是否内容居中，默认YES */

@property (nonatomic, strong) UIColor *tintColor;  /**< 控件的 tint color，默认灰色 */

@property (nonatomic, strong) UIColor *barColor;  /**< 控件的 bar color，默认灰色 */

@property (nonatomic, strong) NSString *holderText;  /**< 占位文字说明，默认nil */

@property (nullable, nonatomic, copy) void(^touchAction)(void);  /**< 添加TouchUpInset回调 */

- (instancetype)initWithFrame:(CGRect)frame holder:(nullable NSString *)holder;  /**< 初始化方法 */

@end

NS_ASSUME_NONNULL_END
