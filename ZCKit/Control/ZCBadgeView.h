//
//  ZCBadgeView.h
//  ZCKit
//
//  Created by admin on 2018/10/25.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCBadgeView : UIView  /**< 标书view，外部不需改变其size，自动计算出来 */

@property (nonatomic, strong) UIFont *badgeTextFont;  /**< 字体，默认blod12.0 */

@property (nonatomic, strong) UIColor *badgeBKColor;  /**< 画布颜色，默认红色 */

@property (nonatomic, strong) UIColor *badgeTextColor;  /**< 内容文字颜色，默认白色 */

@property (nonatomic, strong) UIColor *badgeBorderColor;  /**< 外部描边颜色，默认白色 */

@property (nullable, nonatomic, copy) NSString *badgeValue;  /**< badge值，没长度将不显示，默认nil */

- (instancetype)initWithFrame:(CGRect)frame badgeValue:(NSString *)badgeValue;  /**< 初始化，只需改变位置不必改变size */

@end

NS_ASSUME_NONNULL_END
