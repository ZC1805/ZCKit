//
//  ZCScrollView.h
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCScrollView : UIScrollView

@property (nonatomic, assign) BOOL isShieldPriorityEditGestures;  /**< 屏蔽优先识别子TableView侧滑编辑手势 */

@end

NS_ASSUME_NONNULL_END
