//
//  ZCMacro.h
//  ZCKit
//
//  Created by admin on 2018/9/6.
//  Copyright © 2018年 Squat in house. All rights reserved.
//

#ifndef ZCMacro_h
#define ZCMacro_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/*----- base zc_base ----- ZC */
#define ZCiOS8          ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)   /**< 版本>=8.0 */
#define ZCiOS9          ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)   /**< 版本>=9.0 */
#define ZCiOS10         @available(iOS 10.0, *)                                         /**< 版本>=10.0 */
#define ZCiPad          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)          /**< 是否是iPad */
#define ZCiPhone        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)        /**< 是否是iPhone */
#define ZCFont(size)    [UIFont systemFontOfSize:size]                                  /**< 特定大小系统字体 */
#define ZCInvalidValue  @"ZC_Invalid_Value &.Ignore"                                    /**< 特定的无效值 */
#define ZCIsLandscape   ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || \
                        [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)


#endif /* ZCMacro_h */
