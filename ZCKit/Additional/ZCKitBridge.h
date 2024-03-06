//
//  ZCKitBridge.h
//  ZCKit
//
//  Created by admin on 2018/10/10.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZCImageView;

NS_ASSUME_NONNULL_BEGIN

@protocol ZCKitExternalRealize <NSObject>  /**< 上层需要实现的方法 */

/**< image view图片缓存，上层用此方法实现图片缓存操作 */
- (void)imageViewWebCache:(ZCImageView *)imageView url:(nullable NSURL *)url holder:(nullable UIImage *)holder;

/**< 图片缓存，层用此方法实现图片缓存操作，assigments视图赋值image操作 */
- (void)imageWebCache:(UIView *)view url:(nullable NSURL *)url holder:(nullable UIImage *)holder
           assignment:(nullable void(^)(UIImage * _Nullable image, NSData * _Nullable imageData,
                                        NSInteger cacheType, NSURL * _Nullable imageURL))assignment;

@end


@interface ZCKitBridge : NSObject  /**< 供上层直接操作的类 */

@property (class, nonatomic, assign) BOOL isPrintLog;  /**< 是否需要打印日志，默认NO */

@property (class, nonatomic, assign) BOOL isStrToAccurateFloat;  /**< 是否对数字字符串转成精确字符串，默认NO */

@property (class, nonatomic, copy) NSString *classNamePrefix;  /**< 类名前缀逗号隔开，默认@"" */

@property (class, nonatomic, copy) NSString *naviBarImageOrColor;  /**< 导航栏背景图或者背景颜色，默认"0xF7F7F8" */

@property (class, nonatomic, copy) NSString *naviBarTitleColor;  /**< 导航栏标题字体颜色，默认"0x303030" */

@property (class, nonatomic, strong) UIImage *naviBackImage;  /**< 导航的返回箭头图片，默认"zc_image_back_white" */

@property (class, nonatomic, strong) UIColor *toastBackGroundColor;  /**< toast背景颜色，默认@"0x000000 black" */

@property (class, nonatomic, strong) UIColor *toastTextColor;  /**< toast文字颜色，默认@"0xFFFFFF white" */

@property (class, nullable, nonatomic, strong) id<ZCKitExternalRealize> realize;  /**< 上层外部实现，供Kit调用，程序启动时需要上层注入 */

@property (class, nonatomic, strong) NSLocale *aimLocale;  /**< 用户语言环境，默认简体中文 */

@property (class, nonatomic, strong) NSTimeZone *aimTimeZone;  /**< 用户时区设置，默认北京时间 */

@end

NS_ASSUME_NONNULL_END
