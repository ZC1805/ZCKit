//
//  ZCNaviView.h
//  ZCKit
//
//  Created by admin on 2018/10/23.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCNaviView : UIView  /**< 自定义导航 */

@property (nonatomic, strong, readonly) ZCImageView *cushionView;  /**< 背景视图，外部可设置颜色和透明度 */

@property (nonatomic, strong, readonly) UIView *lineShadowView;  /**< 阴影线，外部可设置颜色和透明度 */

/** 设置中间黑字文本，无右侧按钮 */
+ (instancetype)viewWithTitle:(nullable NSString *)title;

/** 设置中间黑字文本，可设置右侧按钮，right可为文字或者本地图片名称，customView不走这两个block，leftBlock传nil会自动处理跳转，rightBlock传nil将不做处理 */
+ (instancetype)viewWithTitle:(nullable NSString *)title rightName:(nullable NSString *)rightName leftBlock:(nullable void(^)(void))leftBlock rightBlock:(nullable void(^)(void))rightBlock;

/** 设置中间黑字文本，可设置右侧自定义视图，rightView不走rightBlock */
+ (instancetype)viewWithTitle:(nullable NSString *)title rightView:(nullable UIView *)rightView;

/** 设置左右图片和文本，传入nil将重置为不显示，name为文字或本地图片名，调用有可能会更改子视图布局 */
- (void)setTitle:(nullable NSString *)title leftName:(nullable NSString *)leftName rightName:(nullable NSString *)rightName;

/** 设置自定义视图，传入nil将不做更改，此view不走block，调用有可能会更改子视图布局 */
- (void)resetTitleView:(nullable UIView *)titleView leftView:(nullable UIView *)leftView rightView:(nullable UIView *)rightView;

/** 重设置背景和文字颜色，传入nil将不做更改 */
- (void)resetCushionImage:(nullable UIImage *)cushionImage titleColor:(nullable UIColor *)titleColor leftColor:(nullable UIColor *)leftColor rightColor:(nullable UIColor *)rightColor;

@end

NS_ASSUME_NONNULL_END
