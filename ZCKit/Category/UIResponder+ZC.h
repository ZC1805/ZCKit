//
//  UIResponder+ZC.h
//  ZCKit
//
//  Created by admin on 2018/10/10.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (ZC)

NS_ASSUME_NONNULL_BEGIN

+ (instancetype)currentFirstResponder;

+ (instancetype)currentSecondResponder;

@end

NS_ASSUME_NONNULL_END








