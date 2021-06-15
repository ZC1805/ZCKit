//
//  UITapGestureRecognizer+ZC.h
//  ZCKit
//
//  Created by admin on 2020/3/23.
//  Copyright © 2020 Ttranssnet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITapGestureRecognizer (ZC)

@property (nullable, nonatomic, copy) void(^touchAction)(UITapGestureRecognizer *sender);  /**< 添加TouchUpInset回调，默认nil */

@end

NS_ASSUME_NONNULL_END
