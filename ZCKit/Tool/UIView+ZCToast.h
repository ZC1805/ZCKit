//
//  UIView+ZCToast.h
//  ZCKit
//
//  Created by admin on 2018/10/12.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZCEnumToastPosition) {
    ZCEnumToastPositionCenter = 0,  /**< 位于中心 */
    ZCEnumToastPositionTop    = 1,  /**< 位于顶部 */
    ZCEnumToastPositionBottom = 2,  /**< 位于底部 */
};

@interface UIView (ZCToast)  /**< 页面toast显示分类 */

- (void)makeToast:(NSString *)message;  /**< 显示文字内容，默认居中持续显示2秒 */

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(ZCEnumToastPosition)position;

- (void)makeToast:(nullable NSString *)message duration:(NSTimeInterval)interval position:(ZCEnumToastPosition)position title:(nullable NSString *)title image:(nullable UIImage *)image;

- (void)showToast:(UIView *)toast;  /**< 显示图片内容，默认居中持续显示2秒 */

- (void)showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(ZCEnumToastPosition)position;

- (void)showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(ZCEnumToastPosition)position action:(nullable void(^)(void))action;

@end

NS_ASSUME_NONNULL_END
