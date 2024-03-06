//
//  ZCBoxView.h
//  ZCKit
//
//  Created by admin on 2018/10/23.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCBoxView : UIView  /**< 自定义view，添加cover和点击处理，仅透明度动画 */

@property (nonatomic, weak, readonly) UIView *coverView;  /**< 遮罩背景视图 */

/**< 展示子视图，默认灰色背景 & 点击背景不自动隐藏 */
+ (instancetype)display:(UIView *)displayView above:(UIView *)aboveView didHide:(nullable void(^)(BOOL isByAutoHide))didHide;

/**< 展示子视图，autoHides点击背景是否自动隐藏，clearCover是否使用透明cover，willHide/didHide手动隐藏或点击背景自动隐藏的回调(isByAutoHide为YES时是点击背景图层自动隐藏) */
+ (instancetype)display:(UIView *)displayView above:(UIView *)aboveView autoHide:(BOOL)autoHide clearCover:(BOOL)clearCover
               willHide:(nullable void(^)(BOOL isByAutoHide))willHide didHide:(nullable void(^)(BOOL isByAutoHide))didHide;

/**< 展示子视图，autoHides点击背景是否自动隐藏，clearCover是否使用透明cover，showAnimate显示的动画实现，hideAnimate隐藏动画的实现成对出现，willHide/didHide手动隐藏或点击背景自动隐藏的回调 */
+ (instancetype)display:(UIView *)displayView above:(UIView *)aboveView autoHide:(BOOL)autoHide clearCover:(BOOL)clearCover
                 effect:(nullable UIVisualEffectView *)effect
            showAnimate:(nullable void(^)(UIView *displayView))showAnimate
            hideAnimate:(nullable void(^)(UIView *displayView))hideAnimate
               willHide:(nullable void(^)(BOOL isByAutoHide))willHide
                didHide:(nullable void(^)(BOOL isByAutoHide))didHide;

/**< 主动隐藏或者点击背景能隐藏时会触发Action回调，注意循环引用 */
+ (void)dismiss:(nullable UIView *)displayView;

@end

NS_ASSUME_NONNULL_END
