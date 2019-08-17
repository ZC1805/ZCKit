//
//  ZCNavigationController.h
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCViewController.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSNotificationName const ZCViewControllerWillBeTouchPopNotification;  /**< 手动点击Pop事件通知，object为当前top控制器 */

@interface ZCNavigationController : UINavigationController <ZCViewControllerPrivateProtocol>  /**< 通用vc，供子类继承 */

@property (nonatomic, assign) BOOL isShowRootControllerBackIndicator;  /**< 是否在rootViewController显示返回箭头，默认NO */

@end

NS_ASSUME_NONNULL_END
