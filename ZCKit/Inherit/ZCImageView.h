//
//  ZCImageView.h
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCImageView : UIImageView  /**< 默认不开启用户交互 */

@property (nullable, nonatomic, copy) NSString *linkUrl;

- (instancetype)initWithFrame:(CGRect)frame image:(nullable UIImage *)image interact:(BOOL)interact;  /**< 要父视图有交互则interact为NO，子视图有交互则interact为YES */

- (instancetype)initWithFrame:(CGRect)frame image:(nullable UIImage *)image;  /**< interact_NO */

@end

NS_ASSUME_NONNULL_END
