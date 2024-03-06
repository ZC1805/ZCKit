//
//  ZCMaskView.h
//  ZCKit
//
//  Created by admin on 2018/10/23.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCFocusView : UIView  /**< 自定义view，响应touchBegin事件 */

/**< 点击某空处是否可响应，如果可响应则会截断响应链，否则继续向上传递，isCanResponse为nil时可以响应，默认nil，即能响应 */
@property (nullable, nonatomic, copy) BOOL(^isCanResponse)(CGPoint focus);

/**< 点击空白处的响应的回调，默认为nil，什么都不执行 */
@property (nullable, nonatomic, copy) void(^responseAction)(void);

@end


@interface ZCMaskView : UIView  /**< 自定义view，添加mask和点击处理，仅透明度动画 */

/**< 半透明黑色透明度默认0.5 */
@property (class, nonatomic, assign) float maskAlpha;

/**< 可在此单例对象添加额外的子视图 */
+ (instancetype)sharedView;

/**< 展示子视图，默认灰色背景 & 点击背景不自动隐藏 */
+ (void)display:(UIView *)subview didHide:(nullable void(^)(BOOL isByAutoHide))didHide;

/**< 展示子视图，autoHides点击背景是否自动隐藏，clearMask是否使用透明mask，willHide/didHide手动隐藏或点击背景自动隐藏的回调(isByAutoHide为YES时是点击背景图层自动隐藏) */
+ (void)display:(UIView *)subview autoHide:(BOOL)autoHide clearMask:(BOOL)clearMask willHide:(nullable void(^)(BOOL isByAutoHide))willHide didHide:(nullable void(^)(BOOL isByAutoHide))didHide;

/**< 展示子视图，autoHides点击背景是否自动隐藏，clearMask是否使用透明mask，showAnimate显示的动画实现 */
/**< hideAnimate隐藏动画的实现成对出现，willHide/didHide手动隐藏或点击背景自动隐藏的回调(不是被挤出去时候才会触发这两回调) */
+ (void)display:(UIView *)displayView autoHide:(BOOL)autoHide clearMask:(BOOL)clearMask
    showAnimate:(nullable void(^)(UIView *displayView))showAnimate
    hideAnimate:(nullable void(^)(UIView *displayView))hideAnimate
       willHide:(nullable void(^)(BOOL isByAutoHide))willHide
        didHide:(nullable void(^)(BOOL isByAutoHide))didHide;

/**< 主动隐藏或者点击背景能隐藏时会触发Action回调，subview是nil时候，能隐藏时只要获取到了焦点就会隐藏 */
+ (void)dismissSubview;

@end


@interface ZCWindowView : UIView  /**< 自定义view，展示窗口和点击处理，仅透明度动画 */

/**< 添加子视图，view显示的动画在外部实现，time是动画时间，blur是否模糊，clear是mask是否透明，action点击mask回调，不会自动隐藏 (subview不要在外部被强引用) */
+ (void)display:(UIView *)subview time:(NSTimeInterval)time blur:(BOOL)blur clear:(BOOL)clear action:(nullable void(^)(void))action;

/**< 移除子视图，动画时间同上 (subview不要在外部被强引用，不是同一个window) */
+ (void)dismissSubview;

@end

NS_ASSUME_NONNULL_END
