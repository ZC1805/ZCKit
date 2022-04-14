//
//  UIGestureRecognizer+ZCSwizzle.h
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSNotificationName const ZCGestureGenerateEventNotification;  /**< 手势产生了需要上传的埋点事件 */

@interface UIGestureRecognizer (ZCSwizzle)

@end

NS_ASSUME_NONNULL_END
