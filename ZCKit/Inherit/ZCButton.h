//
//  ZCButton.h
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCButton : UIButton  /**< 拓展布局和响应范围 */

@property (nonatomic, assign) CGSize imageViewSize;  /**< 居中对齐，自定义图片的size，默认zero */

@property (nonatomic, assign) CGFloat centerAlignmentSpace;  /**< 居中对齐，图片和文字间的间距，默认0 */

@property (nonatomic, assign) BOOL isVerticalCenterAlignment;  /**< 图片和标题是否是竖直居中中心对齐，默认NO */

@property (nullable, nonatomic, copy) NSString *tagStr;  /**< 字符串标记，默认nil */

@property (nullable, nonatomic, strong) NSValue *fitSize;  /**< 自适应size大小，CGSize，默认nil */

@property (nullable, nonatomic, copy) void(^touchAction)(ZCButton *sender);  /**< 添加TouchUpInset回调，默认nil */

@property (nonatomic, assign) UIEdgeInsets responseAreaExtend;  /**< 延伸响应区域，默认zero */

@property (nonatomic, assign) NSTimeInterval delayResponseTime;  /**< 延迟响应时间，默认0 */

@property (nonatomic, assign) NSTimeInterval responseTouchInterval;  /**< 最小响应时间间隔，默认0 */

@end

NS_ASSUME_NONNULL_END

