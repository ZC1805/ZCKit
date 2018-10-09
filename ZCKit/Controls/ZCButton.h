//
//  ZCButton.h
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCButton : UIButton

@property (nonatomic, assign) UIEdgeInsets responseAreaExtend;   /**< 延伸响应区域，默认zero */

@property (nonatomic, assign) NSTimeInterval delayResponseTime;   /**< 延迟响应时间，默认0 */

@property (nonatomic, assign) NSTimeInterval responseTouchInterval;   /**< 最小响应时间间隔，默认0 */

@end

NS_ASSUME_NONNULL_END






