//
//  UIViewController+ZXXXX.h
//  ZCTest
//
//  Created by zjy on 2022/4/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZCViewControllerViewProtocol <NSObject>  /**< 回调控制器子视图的响应方法*/

@optional

- (BOOL)isHandlePointInside:(UIView *)view point:(CGPoint)point event:(UIEvent *)event;  /**< 返回处理这个视图的响应事件，然后再进行下一步回调 */

- (BOOL)pointInside:(CGPoint)point view:(UIView *)view event:(UIEvent *)event;  /**< 返回是否响应这个交互事件 */

- (BOOL)isHandleHitView:(UIView *)view point:(CGPoint)point event:(UIEvent *)event;  /**< 返回处理事件的视图，然后再进行下一步回调 */

- (nullable UIView *)hitTest:(CGPoint)point view:(UIView *)view event:(UIEvent *)event;  /**< 返回处理事件的视图 */

@end


@interface UIViewController (ZXXXX) <ZCViewControllerViewProtocol>

@property (nonatomic, readonly) NSString *hierarchicalRoute;  /**< 当前控制器层级链，可能返回@"" */

- (void)backToUpControllerAnimated:(BOOL)animated;  /**< 返回到上一次控制器，dissmiss或者pop */

@end

NS_ASSUME_NONNULL_END
