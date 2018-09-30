//
//  UITextField+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (ZC)

/** 选定所有文本 */
- (void)selectAllText;

/** 选定目标范围文本 */
- (void)setSelectedRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END











