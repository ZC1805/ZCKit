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


/** --- image --- */
#define kZIN(image_name)        [UIImage imageNamed:(image_name)]                 /**< 获取图片，缓存，                                                               仅供外部用 */
#define kZIA(image, _a)         [image imageWithAlpha:_a]                         /**< 返回新的指定透明度的图片，                                             仅供外部用 */
#define kZIC(image_hex_color)   [UIImage imageWithColor:kZCRGB(image_hex_color)]  /**< 返回新的指定颜色图片(1.px，1.px)，                                 仅供外部用 */
#define kZIF(image_file_name)   [UIImage imageWithContentsOfFile:kZFilePath(nil, image_file_name, @"png")]  /**< 获取图片，                仅供外部用 */


/** --- font --- */
#define kZFR(adt_size)          [UIFont fontWithName:@"HelveticaNeue" size:kZSA(adt_size)]         /**< 适配了的均匀系统regular字体，    仅供外部用 */
#define kZFB(adt_size)          [UIFont fontWithName:@"HelveticaNeue-Bold" size:kZSA(adt_size)]    /**< 适配了的粗体系统bold字体，        仅供外部用 */
#define kZFL(adt_size)          [UIFont fontWithName:@"HelveticaNeue-Light" size:kZSA(adt_size)]   /**< 适配了的粗体系统light字体，         仅供外部用 */
#define kZFM(adt_size)          [UIFont fontWithName:@"HelveticaNeue-Medium" size:kZSA(adt_size)]  /**< 适配了的粗体系统medium字体，   仅供外部用 */


/** --- normal --- */
#define kZIsiPad                (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)      /**< 是否是iPad */
#define kZIsiPhone              (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)    /**< 是否是iPhone */
#define kZIsiPhoneX             [ZCGlobal isiPhoneX]                                        /**< 当前是否是iPhoneX */
#define kZIslandscape           [ZCGlobal isLandscape]                                      /**< 当前是否是横屏 */


/** --- misc --- */
#define kZArrNonnil(arr)        ((NSArray *)((arr && [arr isKindOfClass:NSArray.class]) ? arr : @[]))           /**< 返回非nil数组类型，用@[]替换nil或非arr类型数据 */
#define kZStrNonnil(str)        ((NSString *)((str && [str isKindOfClass:NSString.class]) ? str : @""))         /**< 返回非nil字符串型，用@""替换nil或非str类型数据 */
#define kZDicNonnil(dic)        ((NSDictionary *)((dic && [dic isKindOfClass:NSDictionary.class]) ? dic : @{})) /**< 返回非nil字典类型，用@{}替换nil或非dic类型数据 */
#define kZStrIsValid(str)       [ZCGlobal isValidString:str]                                                    /**< 返回布尔型，判断字符串是否有效 & 非空格 */
#define kZArrIsValid(arr)       [ZCGlobal isValidArray:arr]                                                     /**< 返回布尔型，判断数组是否有效 & 有count */
#define kZDicIsValid(dic)       [ZCGlobal isValidDictionary:dic]                                                /**< 返回布尔型，判断字典是否有效 & 有count */
#define kZUrlStr(str)           [NSURL URLWithString:kZStrNonnil(str)]                                          /**< 返回非nilRUL类型  */
#define kZStrFormat(format, ...) [NSString stringWithFormat:format, ##__VA_ARGS__]                              /**< 返回格式化字符串 */
#define kZObjAppoint(o, appoint) [ZCGlobal appointInvalid:o default:appoint]                                    /**< 对无效对象替换 */


/** --- color --- */
#define kZCClear                [UIColor clearColor]                       /**< 透明 */
#define kZCWhite                [UIColor colorFormHex:0xFFFFFF alpha:1.0]  /**< 白色 */
#define kZCBlack                [UIColor colorFormHex:0x000000 alpha:1.0]  /**< 黑色 */
#define kZCBlack30              [UIColor colorFormHex:0x303030 alpha:1.0]  /**< 0x30灰 */
#define kZCBlack50              [UIColor colorFormHex:0x505050 alpha:1.0]  /**< 0x50灰 */
#define kZCBlack80              [UIColor colorFormHex:0x808080 alpha:1.0]  /**< 0x80灰 */
#define kZCBlackA8              [UIColor colorFormHex:0xA8A8A8 alpha:1.0]  /**< 0xA8灰 */
#define kZCBlackC8              [UIColor colorFormHex:0xC8C8C8 alpha:1.0]  /**< 0xC8灰 */
#define kZCBlackDC              [UIColor colorFormHex:0xDCDCDC alpha:1.0]  /**< 0xDC灰 */
#define kZCPad                  [UIColor colorFormHex:0xF7F7F8 alpha:1.0]  /**< 背景的Pad颜色 */
#define kZCSplit                [UIColor colorFormHex:0xEAEAEA alpha:1.0]  /**< 分割线Split颜色 */
#define kZCHolder               [UIColor colorFormHex:0xAEAEAE alpha:0.7]  /**< 占位的Holder颜色 */


/** --- color --- */
#define kZCA(color, a)          [color colorFromAlpha:a]                                        /**< 返回指定透明度颜色 */
#define kZCS(hex_str)           [UIColor colorFromHexString:hex_str alpha:1.0]                  /**< 十六进制颜色#&0x& */
#define kZCSA(hex_str, a)       [UIColor colorFromHexString:hex_str alpha:a]                    /**< 十六进制颜色#&0x& */
#define kZCRGB(hex_rgb)         [UIColor colorFormHex:hex_rgb alpha:1.0]                        /**< 十六进制颜色0x开头 */
#define kZCRGBA(hex_rgb, a)     [UIColor colorFormHex:hex_rgb alpha:a]                          /**< 十六进制颜色0x开头 & 透明度 */
#define kZCRGBV(r, g, b, a)     [UIColor colorFormRad:(int)r green:(int)g blue:(int)b alpha:a]  /**< 十进制颜色 & 透明度 */


/** --- adapt --- */
#define kZSInvl                 kZSA(15.0)                                  /**< 按比例标准边距值，          仅供外部用 */
#define kZSA(radix)             ((radix) * [ZCGlobal ratio])                /**< 按比例适配计算值，          仅供外部用 */
#define kZSWid                  ([UIScreen mainScreen].bounds.size.width)   /**< 屏幕宽 */
#define kZSHei                  ([UIScreen mainScreen].bounds.size.height)  /**< 屏幕高 */
#define kZSScreen               (CGRectMake(0, 0, kZSWid, kZSHei))          /**< 全屏幕 */
#define kZSPixel                (1.0 / [UIScreen mainScreen].scale)         /**< 最小显示像素点 */
#define kZSNaviBarHei           ([ZCGlobal isiPhoneX] ? 44.0 : 44.0)        /**< 导航栏高，竖屏值 */
#define kZSNaviHei              ([ZCGlobal isiPhoneX] ? 88.0 : 64.0)        /**< 导航栏高，竖屏值 */
#define kZSTabBarHei            ([ZCGlobal isiPhoneX] ? 49.0 : 49.0)        /**< 标签栏高，竖屏值 */
#define kZSTabHei               ([ZCGlobal isiPhoneX] ? 83.0 : 49.0)        /**< 标签栏高，竖屏值 */
#define kZSStuBarHei            ([ZCGlobal isiPhoneX] ? 44.0 : 20.0)        /**< 状态栏高，竖屏值 */
#define kZSTopResHei            ([ZCGlobal isiPhoneX] ? 44.0 : 20.0)        /**< 顶预留高，竖屏值 */
#define kZSBomResHei            ([ZCGlobal isiPhoneX] ? 34.0 : 00.0)        /**< 底预留高，竖屏值 */
#define kZSBomSafeHei           ([ZCGlobal isiPhoneX] ? 34.0 : 20.0)        /**< 底安全高，竖屏值 */


/** --- float --- */
#define kZFZero(a)              (fabs((a)) < FLT_EPSILON)                      /**< a = 0，              仅供外部用 */
#define kZFEqual(a, b)          (fabs((a) - (b)) < FLT_EPSILON)                /**< a = b，              仅供外部用 */
#define kZFAbove(a, b)          (fabs((a) - (b)) >= FLT_EPSILON && (a) > (b))  /**< a > b，              仅供外部用 */
#define kZFBelow(a, b)          (fabs((a) - (b)) >= FLT_EPSILON && (a) < (b))  /**< a < b，              仅供外部用 */
#define kZFNotEqual(a, b)       (fabs((a) - (b)) >= FLT_EPSILON)               /**< a != b，             仅供外部用 */
#define kZFAboveEqual(a, b)     (kZFAbove((a), (b)) || kZFEqual((a), (b)))     /**< a >= b，            仅供外部用 */
#define kZFBelowEqual(a, b)     (kZFBelow((a), (b)) || kZFEqual((a), (b)))     /**< a <= b，            仅供外部用 */


/** --- 文件路径 --- */
#define kZFilePath(bundle, fileName, extName) [ZCGlobal resourcePath:bundle name:fileName ext:extName]


/** --- 数值交换 --- */
#define kZSwap(_a_, _b_) do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)


/** --- 打印日志 --- */
#ifdef DEBUG
#define NSLog(format, ...) fprintf(stderr, "%s\n", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif


/** --- leaks警告 --- */
#define kZSuppressLeakWarn(func) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
func; \
_Pragma("clang diagnostic pop") \
} while (0)


#endif /* ZCMacro_h */
