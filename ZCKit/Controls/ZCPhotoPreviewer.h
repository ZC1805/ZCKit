//
//  ZCPhotoPreviewer.h
//  ZCKit
//
//  Created by admin on 2018/10/26.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCPhotoPreviewer : UIView  /**< 单图片浏览，单击返回 */

@property (nonatomic, assign) CGFloat radius;  /**< 原图圆角，默认0 */

@property (nonatomic, assign) BOOL doubleTap;  /**< 是否允许双击放大，默认YES */

@property (nonatomic, strong, readonly) UILabel *titleLabel;  /**< 标题视图 */

@property (nullable, nonatomic, copy) void(^longPressAction)(void);  /**< 长按Action */

@property (nullable, nonatomic, weak) UIView *carrier;  /**< 原image载体视图，默认nil */

@property (nullable, nonatomic, strong) NSURL *imageURL;  /**< 原图Url，此时image变成holder，默认nil */

/** image为显示的image，当给定imageUrl时，image为占位图，ctor回调中可给previewer的属性赋值 */
+ (void)display:(nullable UIImage *)image ctor:(nullable void(^)(ZCPhotoPreviewer *previewer))ctor;

@end

NS_ASSUME_NONNULL_END
