//
//  ZCLabel.h
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCLabel : UILabel  /**< 当text或font改变会自动计算size */

@property (nonatomic, assign) BOOL isUseAutoSize;  /**< 是否使用自适应大小，默认YES */

@property (nullable, nonatomic, strong) NSValue *fitSize;  /**< 自适应size大小，CGSize，默认nil */

@property (nullable, nonatomic, copy) void(^textSetBlock)(void);  /**< 对text赋值回调 */

@end

NS_ASSUME_NONNULL_END
