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


/** ----- normal ----- */
#define ZCiOS8          ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)  /**< 版本>=8.0 */
#define ZCiOS9          ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)  /**< 版本>=9.0 */
#define ZCiOS10         @available(iOS 10.0, *)                                        /**< 版本>=10.0 */
#define ZCiPad          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)         /**< 是否是iPad */
#define ZCiPhone        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)       /**< 是否是iPhone */
#define ZClandscape     [ZCGlobal isLandscape]                                         /**< 当前是否是横屏 */
#define ZCInvalidStr    @"zc_invalid_value &.Ignore"                                   /**< 定义的特定无效值 */


/** ----- color ----- */
#define ZCRGB(hex)          [UIColor colorFormHex:hex alpha:1.0]              /**< 十六进制颜色 */
#define ZCRGBA(hex, a)      [UIColor colorFormHex:hex alpha:a]                /**< 十六进制颜色 + 透明度 */
#define ZCRGBV(r, g, b, a)  [UIColor colorFormRad:r green:g blue:b alpha:a]   /**< 十进制颜色 + 透明度 */
#define ZCRed               [UIColor colorFormHex:0xFF0000 alpha:1.0]   
#define ZCBlue              [UIColor colorFormHex:0x0000FF alpha:1.0]
#define ZCGreen             [UIColor colorFormHex:0x00FF00 alpha:1.0]
#define ZCWhite             [UIColor colorFormHex:0xFFFFFF alpha:1.0]
#define ZCBlack             [UIColor colorFormHex:0x000000 alpha:1.0]
#define ZCBlack30           [UIColor colorFormHex:0x303030 alpha:1.0]
#define ZCBlack80           [UIColor colorFormHex:0x808080 alpha:1.0]
#define ZCBlackA2           [UIColor colorFormHex:0xA2A2A2 alpha:1.0]
#define ZCSPColor           [UIColor colorFormHex:0xC8C8C8 alpha:1.0]   /**< 分割线颜色 */
#define ZCBKColor           [UIColor colorFormHex:0xF6F6F8 alpha:1.0]   /**< 背景颜色 */


/** ----- adapt 360 ----- */
#define ZCRadix             360.0                                     /**< 适配竖屏720px */
#define ZCA(radix)          (radix * (MIN(ZSWid, ZSHei) / ZCRadix))   /**< 适配比例计算值 */
#define ZCFont(size)        [UIFont systemFontOfSize:ZCA(size)]       /**< 适配了的系统字体 */
#define ZCBoldFont(size)    [UIFont boldSystemFontOfSize:ZCA(size)]   /**< 适配了的粗体系统字体 */

/** ----- adapt 320 ----- */
#define zs_radix            (ZClandscape ? 568.0 : 320.0)   /**< 总基准点数，按照iPhone5设定 */
#define zs_unit             (ZSWid / zs_radix)              /**< 单位基准相当于的实例点数 */
#define zs_is320            (ZFEqual(ZSWid, zs_radix))      /**< 是否基准屏 */
#define zs_to_radix(real)   (real / zs_unit)                /**< 将实例点转为基准点 */
#define zs_to_real(radix)   (radix * zs_unit)               /**< 将基准点转为实例点 */

/** ----- layout cal ----- */
#define ZSWid               ([UIScreen mainScreen].bounds.size.width)   /**< 屏幕宽 */
#define ZSHei               ([UIScreen mainScreen].bounds.size.height)  /**< 屏幕高 */
#define ZSSepHei            (1.0 / [UIScreen mainScreen].scale)         /**< 最小显示点 */
#define ZSMarInvl           ([ZCGlobal isiPhoneX] ? ZCA(13) : ZCA(15))  /**< 标准边距值 */
#define ZSNaviSowHei        ([ZCGlobal naviShadowHeight])               /**< 导航阴影高 */
#define ZSNaviHei           ([ZCGlobal isiPhoneX] ? 88.0 : 44.0)        /**< 导航栏高，默认为竖屏通常值 */
#define ZSStuBarHei         ([ZCGlobal isiPhoneX] ? 44.0 : 20.0)        /**< 状态栏高，默认为竖屏通常值 */
#define ZSTabBarHei         ([ZCGlobal isiPhoneX] ? 83.0 : 49.0)        /**< 标签栏高，默认为竖屏通常值 */
#define ZSTopResHei         ([ZCGlobal isiPhoneX] ? 30.0 : 0)           /**< 顶预留高，默认为竖屏通常值 */
#define ZSBomResHei         ([ZCGlobal isiPhoneX] ? 34.0 : 0)           /**< 底预留高，默认为竖屏通常值 */
#define ZSAvailableHei      (ZSHei - ZSNaviHei - ZSBomResHei)           /**< 内容高度，默认为竖屏通常值 */


/** ----- float ----- */
#define ZFZero(a)           (fabs((a)) < FLT_EPSILON)                       /**< a = 0 */
#define ZFEqual(a, b)       (fabs((a) - (b)) < FLT_EPSILON)                 /**< a = b */
#define ZFAbove(a, b)       (fabs((a) - (b)) >= FLT_EPSILON && (a) > (b))   /**< a > b */
#define ZFBelow(a, b)       (fabs((a) - (b)) >= FLT_EPSILON && (a) < (b))   /**< a < b */
#define ZFNotEqual(a, b)    (fabs((a) - (b)) >= FLT_EPSILON)                /**< a != b */
#define ZFAboveEqual(a, b)  (ZFAbove((a), (b)) || ZFEqual((a), (b)))        /**< a >= b */
#define ZFBelowEqual(a, b)  (ZFBelow((a), (b)) || ZFEqual((a), (b)))        /**< a <= b */


/** ----- string ----- */
#define ZCNonnil(str)      (str ? str : @"")              /**< 返回非nil字符串，用@""替换nil */
#define ZCNonlen(str)      ([str length] ? str : @" ")    /**< 返回非空长度字符串, 用@" "替换nil、@"" */
#define ZCIsValid(str)     [ZCGlobal isValidString:str]   /**< 判断字符串是否有效 */


/** ----- image ----- */
#define ZCImage(name)       [UIImage imageNamed:(name)]                        /**< 获取图片，缓存 */
#define ZCFileImage(name)   [ZCGlobal resourcePath:nil name:name ext:@"png"]   /**< 获取图片，不缓存 */


/** ----- misc ----- */
#define ZCSyncTime      15.0     /**< 同步请求超时时间 */
#define ZCAsyncTime     20.0     /**< 异步请求超时时间 */
#define ZCPromptTime    2.0      /**< 提示警告时间 */
#define ZCAnimateTime   0.3      /**< 动画持续时间 */


#pragma mark - misc
/** 判断对象是否是非空&NSNumber类型 */
#define DEFObjectIsValidNumber(object) (object && [object isKindOfClass:[NSNumber class]])
/** 判断对象是否是数组&数组有效（不为空 & 是NSArray类型 & count不为零）*/
#define DEFObjectIsValidArray(object) (object && [object isKindOfClass:[NSArray class]] && [object count])
/** 判断对象是否是字典&字典有效（不为空 & 是Dictionary类型 & count不为零）*/
#define DEFObjectIsValidDictionary(object) (object && [object isKindOfClass:[NSDictionary class]] && [object count])
/** 判断对象是否是字符串&非空&不是只有空格和换行&非<null> */
#define DEFObjectIsValidString(object) (object != nil && object != NULL && ([object isKindOfClass:[NSNull class]] == NO) && \
([object isKindOfClass:[NSString class]] == YES) && ([object length] > 0) && \
([[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) && \
([object isEqualToString:@"<null>"] == NO))
/** 转换为确定为非空字符串 */
#define DEFNonnullString(object) ((object == nil || [object isKindOfClass:[NSNull class]] || \
([object isKindOfClass:[NSString class]] == NO) || [object isEqualToString:@"<null>"]) ? @"" : object)

/** 打印日志 */
#ifdef DEBUG
#define NSLog(format, ...) fprintf(stderr, "%s\n", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif

/** 断言，else时不要逗号 */
#ifdef DEBUG
#define DEFAbnormal(lev, desc)  {if (lev == 0) {NSAssert(NO, desc);} \
else if (lev == 1) {NSLog(@"abnormal error -> %@", desc);} \
else {NSLog(@"abnormal warning -> %@", desc);}}   /** 0->assert 1->error 2->warning */
#else
#define DEFAbnormal(lev, desc)
#endif

/** 屏蔽leaks警告 */
#define zc_suppress_leak_warning(func) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
func; \
_Pragma("clang diagnostic pop") \
} while (0)

/** 回到主线程执行 */
#define zc_dispatch_main(block) \
if ([NSThread isMainThread]) { \
block(); \
} else { \
dispatch_async(dispatch_get_main_queue(), block); \
}

#endif /* ZCMacro_h */













