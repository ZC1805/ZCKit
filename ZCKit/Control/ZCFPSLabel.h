//
//  ZCFPSLabel.h
//  ZCKit
//
//  Created by admin on 2018/10/26.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCFPSLabel : UILabel  /**< 显示屏幕刷新频率，默认加入视图或从视图移除就会开始或停止监测 */

- (void)FPSInvalidate;  /**< 停止FPS监测 */

- (void)FPSResume;  /**< 开始FPS监测 */

@end

NS_ASSUME_NONNULL_END
