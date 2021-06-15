//
//  UIButton+ZC.h
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ZC)

/** 初始化一个SystemButton，可是设置title和image */
+ (instancetype)customTitle:(nullable NSString *)title font:(nullable UIFont *)font color:(nullable UIColor *)color image:(nullable NSString *)image target:(nullable id)target action:(nullable SEL)action;

@end

NS_ASSUME_NONNULL_END

