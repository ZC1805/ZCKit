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

/** 初始化一个Button，可是设置title和image，默认字体FZCFS(15) */
+ (instancetype)button:(CGRect)frame title:(nullable NSString *)title image:(nullable NSString *)image target:(nullable id)target action:(nullable SEL)action;

@end

NS_ASSUME_NONNULL_END

