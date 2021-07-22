//
//  ZCAdaptBar.h
//  ZCKit
//
//  Created by admin on 2019/1/22.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZCEnumAdaptBarPosition) {
    ZCEnumAdaptBarPositionTop    = 0,  /**< 顶部样式 */
    ZCEnumAdaptBarPositionBottom = 1,  /**< 底部样式 */
};

@interface ZCAdaptBar : UIView  /**< 视图位置的left，width已固定，只需设置top、height，最好加到控制器的view中去 */

@property (nonatomic, assign) BOOL isShowLine;  /**< 显示上或者下部分的割线，默认YES */

@property (nonatomic, assign) BOOL isShowMidLine;  /**< 显示中部分割线，默认NO */

@property (nonatomic, assign) BOOL isVagueBackground;  /**< 是否模糊背景，默认NO */

@property (nonatomic, strong, readonly) UIView *reserveView;  /**< 预留占位视图 */

@property (nonatomic, strong, readonly) UIView *contentView;  /**< 内容视图，可在此添加视图 */

- (instancetype)initWithFrame:(CGRect)frame position:(ZCEnumAdaptBarPosition)position;  /**< 指定初始化方法 */

@end

NS_ASSUME_NONNULL_END
