//
//  ZCIndicatorView.h
//  ZCKit
//
//  Created by admin on 2018/10/18.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCIndicatorView : UIView

- (instancetype)initWithFrame:(CGRect)frame diameter:(CGFloat)diameter color:(UIColor *)color;   /**< 转圈图像，diameter是小圆圈半径 */

- (void)pause;   /**< 暂停 */

- (void)resume;   /**< 继续 */

@end

NS_ASSUME_NONNULL_END
