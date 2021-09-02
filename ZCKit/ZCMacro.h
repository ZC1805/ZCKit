//
//  ZCMacro.h
//  ZCKit
//
//  Created by admin on 2018/9/6.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#ifndef ZCMacro_h
#define ZCMacro_h


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIColor+ZC.h"
#import "UIImage+ZC.h"
#import "ZCGlobal.h"


/** --- normal --- */
#define ZCIsiPad            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)    /**< 是否是iPad */
#define ZCIsiPhone          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)  /**< 是否是iPhone */
#define ZCIsiPhoneX         [ZCGlobal isiPhoneX]    /**< 当前是否是iPhoneX */
#define ZCIslandscape       [ZCGlobal isLandscape]  /**< 当前是否是横屏 */


/** --- misc --- */
#define ZCStrNonnil(str)    ((NSString *)((str && [str isKindOfClass:NSString.class]) ? str : @""))         /**< 返回非nil字符串类型，用@""替换nil或非str类型数据 */
#define ZCArrNonnil(arr)    ((NSArray *)((arr && [arr isKindOfClass:NSArray.class]) ? arr : @[]))           /**< 返回非nil数组类型，用@[]替换nil或非arr类型数据 */
#define ZCDicNonnil(dic)    ((NSDictionary *)((dic && [dic isKindOfClass:NSDictionary.class]) ? dic : @{})) /**< 返回非nil字典类型，用@{}替换nil或非dic类型数据 */
#define ZCStrIsValid(str)   [ZCGlobal isValidString:str]                                /**< 返回布尔型，判断字符串是否有效 & 非空格 */
#define ZCArrIsValid(arr)   [ZCGlobal isValidArray:arr]                                 /**< 返回布尔型，判断数组是否有效 & 有count */
#define ZCDicIsValid(dic)   [ZCGlobal isValidDictionary:dic]                            /**< 返回布尔型，判断字典是否有效 & 有count */
#define ZCStrFormat(format, ...) [NSString stringWithFormat:format, ##__VA_ARGS__]      /**< 返回格式化字符串 */
#define ZCObjAppoint(origin, appoint) [ZCGlobal appointInvalid:origin default:appoint]  /**< 对无效对象替换 */


/** --- color --- */
#define ZCBlack30           [UIColor colorFormHex:0x303030 alpha:1.0]  /**< 0x30灰 */
#define ZCBlack50           [UIColor colorFormHex:0x505050 alpha:1.0]  /**< 0x50灰 */
#define ZCBlack80           [UIColor colorFormHex:0x808080 alpha:1.0]  /**< 0x80灰 */
#define ZCBlackA8           [UIColor colorFormHex:0xA8A8A8 alpha:1.0]  /**< 0xA8灰 */
#define ZCBlackC8           [UIColor colorFormHex:0xC8C8C8 alpha:1.0]  /**< 0xC8灰 */
#define ZCBlackDC           [UIColor colorFormHex:0xDCDCDC alpha:1.0]  /**< 0xDC灰 */
#define ZCSPColor           [UIColor colorFormHex:0xEAEAEA alpha:1.0]  /**< 交线颜色 */
#define ZCBKColor           [UIColor colorFormHex:0xF7F7F8 alpha:1.0]  /**< 背景颜色 */
#define ZCPHColor           [UIColor colorFormHex:0xAEAEAE alpha:0.7]  /**< 占位颜色 */
#define ZCWhite             [UIColor colorFormHex:0xFFFFFF alpha:1.0]  /**< 白色 */
#define ZCBlack             [UIColor colorFormHex:0x000000 alpha:1.0]  /**< 黑色 */
#define ZCGreen             [UIColor colorFormHex:0x00FF00 alpha:1.0]  /**< 绿色 */
#define ZCBlue              [UIColor colorFormHex:0x0000FF alpha:1.0]  /**< 蓝色 */
#define ZCRed               [UIColor colorFormHex:0xFF0000 alpha:1.0]  /**< 红色 */
#define ZCClear             [UIColor clearColor]  /**< 透明 */


/** --- color --- */
#define ZCCS(hex_str)           [UIColor colorFromHexString:hex_str]                  /**< 十六进制颜色#&0x& */
#define ZCCA(color, alpha)      [color colorWithAlphaComponent:alpha]                 /**< 返回指定透明度颜色 */
#define ZCRGB(hex_rgb)          [UIColor colorFormHex:hex_rgb alpha:1.0]              /**< 十六进制颜色0x开头 */
#define ZCRGBA(hex_rgb, _alpha) [UIColor colorFormHex:hex_rgb alpha:_alpha]           /**< 十六进制颜色0x开头 & 透明度 */
#define ZCRGBV(r, g, b, _alpha) [UIColor colorFormRad:r green:g blue:b alpha:_alpha]  /**< 十进制颜色 & 透明度 */


/** --- image --- */
#define ZCIN(image_name)        [UIImage imageNamed:(image_name)]                /**< 获取图片，缓存 */
#define ZCIA(image,image_alpha) [image imageWithAlpha:image_alpha]               /**< 返回新的指定透明度的图片 */
#define ZCIC(image_hex_color)   [UIImage imageWithColor:ZCRGB(image_hex_color)]  /**< 返回新的指定颜色图片(1.px，1.px) */
#define ZCIF(image_file_name)   [UIImage imageWithContentsOfFile:ZCBundleFilePath(nil, image_file_name, @"png")]  /**< 获取图片 */


/** --- font --- */
#define ZCF(adt_size)           [UIFont fontWithName:@"HelveticaNeue" size:ZSA(adt_size)]        /**< 适配了的系统字体 */
#define ZCFB(adt_size)          [UIFont fontWithName:@"HelveticaNeue-Bold" size:ZSA(adt_size)]   /**< 适配了的粗体系统bold字体 */
#define ZCFL(adt_size)          [UIFont fontWithName:@"HelveticaNeue-Light" size:ZSA(adt_size)]  /**< 适配了的粗体系统light字体 */
#define ZCFM(adt_size)          [UIFont fontWithName:@"HelveticaNeue-Medium" size:ZSA(adt_size)] /**< 适配了的粗体系统medium字体 */


/** --- adapt 360 --- */
#define ZSMInvl             ZSA(15.0)                     /**< 按比例标准边距值 */
#define ZSA(radix)          ((radix) * [ZCGlobal ratio])  /**< 按比例适配计算值 */


/** --- layout cal --- */
#define ZSWid               ([UIScreen mainScreen].bounds.size.width)   /**< 屏幕宽 */
#define ZSHei               ([UIScreen mainScreen].bounds.size.height)  /**< 屏幕高 */
#define ZSScreen            (CGRectMake(0, 0, ZSWid, ZSHei))            /**< 全屏幕 */
#define ZSSepHei            (1.0 / [UIScreen mainScreen].scale)         /**< 最小显示点 */
#define ZSNaviSowHei        ([ZCGlobal naviShadowHeight])               /**< 导航阴影高 */
#define ZSNaviBarHei        ([ZCGlobal isiPhoneX] ? 44.0 : 44.0)        /**< 导航栏高，竖屏值 */
#define ZSNaviHei           ([ZCGlobal isiPhoneX] ? 88.0 : 64.0)        /**< 导航栏高，竖屏值 */
#define ZSTabBarHei         ([ZCGlobal isiPhoneX] ? 49.0 : 49.0)        /**< 标签栏高，竖屏值 */
#define ZSTabHei            ([ZCGlobal isiPhoneX] ? 83.0 : 49.0)        /**< 标签栏高，竖屏值 */
#define ZSStuBarHei         ([ZCGlobal isiPhoneX] ? 44.0 : 20.0)        /**< 状态栏高，竖屏值 */
#define ZSTopResHei         ([ZCGlobal isiPhoneX] ? 44.0 : 20.0)        /**< 顶预留高，竖屏值 */
#define ZSBomResHei         ([ZCGlobal isiPhoneX] ? 34.0 : 00.0)        /**< 底预留高，竖屏值 */
#define ZSBomSafeHei        ([ZCGlobal isiPhoneX] ? 34.0 : 20.0)        /**< 底安全高，竖屏值 */


/** --- float --- */
#define ZFZero(a)           (fabs((a)) < FLT_EPSILON)                      /**< a = 0 */
#define ZFEqual(a, b)       (fabs((a) - (b)) < FLT_EPSILON)                /**< a = b */
#define ZFAbove(a, b)       (fabs((a) - (b)) >= FLT_EPSILON && (a) > (b))  /**< a > b */
#define ZFBelow(a, b)       (fabs((a) - (b)) >= FLT_EPSILON && (a) < (b))  /**< a < b */
#define ZFNotEqual(a, b)    (fabs((a) - (b)) >= FLT_EPSILON)               /**< a != b */
#define ZFAboveEqual(a, b)  (ZFAbove((a), (b)) || ZFEqual((a), (b)))       /**< a >= b */
#define ZFBelowEqual(a, b)  (ZFBelow((a), (b)) || ZFEqual((a), (b)))       /**< a <= b */


/** --- 文件路径 --- */
#define ZCBundleFilePath(bundle, fileName, extName) [ZCGlobal resourcePath:bundle name:fileName ext:extName]


/** --- 数值交换 --- */
#define ZCSwap(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)


/** --- 打印日志 --- */
#ifdef DEBUG
#define NSLog(format, ...) fprintf(stderr, "%s\n", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif


/** --- leaks警告 --- */
#define zc_suppress_leak_warning(func) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
func; \
_Pragma("clang diagnostic pop") \
} while (0)


#endif /* ZCMacro_h */
