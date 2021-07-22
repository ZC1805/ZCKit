//
//  ZCIndicatorView.h
//  ZCKit
//
//  Created by admin on 2018/10/18.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCIndicatorView : UIView  /**< 转圈等待动画视图 */

@property (nonatomic, assign) CGFloat diameter;  /**< 小圆圈半径，默认wid/9 */

@property (nonatomic, strong) UIColor *tintColor;  /**< 小圆圈颜色，默认灰色 */

- (instancetype)initWithFrame:(CGRect)frame diameter:(CGFloat)diameter;  /**< 初始化 */

- (void)pause;  /**< 暂停 */

- (void)resume;  /**< 继续 */

@end

NS_ASSUME_NONNULL_END
