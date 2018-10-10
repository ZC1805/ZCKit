//
//  UINavigationItem+ZC.h
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationItem (ZC)

/** 自定义导航返回按钮，不设定target或者action时候点击只执行导航pop返回 */
- (UIButton *)itemCustomBackTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action;

/** 自定义一个 rightItems，item可为image名称或者title名称 */
- (UIButton *)itemRightOneItem:(NSString *)item target:(id)target action:(SEL)action;

/** 添加rightItems，后加的靠左边 */
- (UIButton *)itemAddRightImage:(NSString *)image target:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END







