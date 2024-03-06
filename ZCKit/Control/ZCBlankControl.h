//
//  ZCBlankControl.h
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZCLabel, ZCButton, ZCImageView;

NS_ASSUME_NONNULL_BEGIN

@interface ZCBlankControl : UIControl  /**< 空白视图，需设置hidden来控制显示和隐藏 */

@property (nonatomic, strong, readonly) ZCLabel *headerLabel;  /**< 懒加载，头部label */

@property (nonatomic, strong, readonly) ZCImageView *imageView;  /**< 懒加载，顶部image、git */

@property (nonatomic, strong, readonly) ZCLabel *contentLabel;  /**< 懒加载，内容label */

@property (nonatomic, strong, readonly) ZCButton *handleButton;  /**< 懒加载，可点击的Button，不用添加Action */

@property (nonatomic, strong, readonly) ZCLabel *footerLabel;  /**< 懒加载，底部label */

@property (nonatomic, strong, readonly) UIView *containerView;  /**< 懒加载，底部容器视图 */

@property (nullable, nonatomic, copy) void(^touchAction)(BOOL isOnHandleButton);  /**< 添加TouchUpInset回调，默认nil */

- (instancetype)initWithFrame:(CGRect)frame color:(nullable UIColor *)color inBelow:(nullable UIView *)inBelow;  /**< 初始化添加在某视图下面 */

- (void)resetImage:(nullable UIImage *)image message:(nullable NSString *)message;  /**< 重置image和content */

- (void)resetImage:(nullable UIImage *)image handleText:(nullable NSString *)handleText;  /**< 重置image和button */

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;  /**< 设置是否隐藏 */

- (void)setInitHidden;  /**< 设置初始的空白样式 */

- (void)resetSize;  /**< 调用此方法来重新布局 */

@end

NS_ASSUME_NONNULL_END
