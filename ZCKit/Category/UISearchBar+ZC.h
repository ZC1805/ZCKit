//
//  UISearchBar+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISearchBar (ZC)

//@property (nullable, nonatomic, copy) NSString *rightCancelText;  /**< 右侧取消按钮的文本 */

@property (nullable, nonatomic, strong) UIImage *leftSearchIcon;  /**< 可设置左侧放大镜图片 */

@property (nullable, nonatomic, strong) UIImage *insideFieldBKImage;  /**< 可设背景图片，需要时记得设置圆角 */

//@property (nullable, nonatomic, strong, readonly) UIButton *rightCancelButton;  /**< 获取内部CancelButton */

//@property (nullable, nonatomic, strong, readonly) UITextField *insideTextField;  /**< 获取内部TextField */

@end

NS_ASSUME_NONNULL_END
