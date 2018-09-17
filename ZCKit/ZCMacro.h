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
#define ZCInvalidValue  @"ZC_Invalid_Value &.Ignore"                                    /**< 特定的无效值 */
#define ZClandscape   ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || \
                        [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)

/** ----- 计算 ----- */
#define ZSSep / 2.0       (1.0 / [UIScreen mainScreen].scale)
#define ZSWid        ([UIScreen mainScreen].bounds.size.width)
#define ZSHei        ([UIScreen mainScreen].bounds.size.height)
#define ZSNaviBar        ([UIScreen mainScreen].bounds.size.height)
#define ZSTabbar    49.0


#define ZCImage

#define ZCTime


/** ----- 颜色 ----- */
#define ZCRGB(hex)      [UIColor colorFormHex:hex alpha:1.0]
#define ZCRed           [UIColor colorFormHex:0xFF0000 alpha:1.0]
#define zc_black
#define ZCWhite
#define ZCBlack30
#define ZCBlack80
#define ZCSepline

#define ZFEqual

/** ----- misc ----- */
#define ZCRatio         //比率
#define ZCFont(size)    [UIFont systemFontOfSize:size]                                  /**< 特定大小系统字体 */
#define ZCFit(x)        ((float)(x) * (SCREEN_WIDTH / 360.0))

#endif /* ZCMacro_h */










