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

extern NSNotificationName const ZCViewControllerWillBeTouchPopNotification;  /**< 手动点击系统Pop事件或NaviView.leftView的非自定义实现通知通知，object为当前top控制器 */

@interface ZCNavigationController : UINavigationController <ZCViewControllerPrivateProtocol>  /**< 通用vc，供子类继承 */

@end

NS_ASSUME_NONNULL_END
