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

/** 构建一个Button */
+ (instancetype)button:(CGRect)frame title:(nullable NSString *)title image:(nullable NSString *)image target:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END

