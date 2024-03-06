//
//  ZCPredefine.h
//  ZCKit
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**< 符合指定内容模式矩形 */
CGRect ZCRectFitWithContentMode(CGRect rect, CGSize size, UIViewContentMode mode);

/**< 将度转换为弧度 */
static inline CGFloat ZCDegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

/**< 将弧度转换为度 */
static inline CGFloat ZCRadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}

NS_ASSUME_NONNULL_END
