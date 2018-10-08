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

/** 字符串标记 */
@property (nullable, nonatomic, strong) NSString *stringTag;

/** 构建一个Button */
+ (instancetype)button:(CGRect)frame title:(nullable NSString *)title image:(nullable NSString *)image target:(nullable id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END










