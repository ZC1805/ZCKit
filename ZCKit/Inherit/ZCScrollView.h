//
//  ZCScrollView.h
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCScrollView : UIScrollView  /**< 好用的ScrollView控件 */

@property (nonatomic, assign) BOOL isPriorityEditGestures;  /**< 优先识别子TableView编辑手势 */

@property (nonatomic, assign) BOOL isInterceptTouchEvent;  /**< 是否截取Touch事件，默认NO(即不截取可向上再传递) */

#pragma mark - Basic
/**< 初始化scrollView，别第一个加入到容器view中，可在addSubView之前加入一个一个无用的View(ios9.0的问题) */
- (instancetype)initWithFrame:(CGRect)frame isPaging:(BOOL)isPaging isBounces:(BOOL)isBounces;

@end

NS_ASSUME_NONNULL_END
