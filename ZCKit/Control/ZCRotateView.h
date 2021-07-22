//
//  ZCRotateView.h
//  ZCKit
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCRotateView : UIView  /**< 等待转圈视图 */

@property (nonatomic, assign) CGFloat strokeThickness;  /**< 路径宽，默认3.5 */

@property (nonatomic, assign) CGFloat strokeRadius;  /**< 圆半径，默认15 */

@property (nonatomic, strong) UIColor *strokeColor;  /**< 路径颜色，默认red */

@end

NS_ASSUME_NONNULL_END
