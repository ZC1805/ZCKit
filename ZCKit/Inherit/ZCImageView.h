//
//  ZCImageView.h
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCImageView : UIImageView  /**< 默认开启用户交互 */

@property (nullable, nonatomic, copy) NSString *linkUrl;

@end

NS_ASSUME_NONNULL_END

