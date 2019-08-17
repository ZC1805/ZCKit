//
//  ZCKitBridge.h
//  ZCKit
//
//  Created by admin on 2018/10/10.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZCKitExternalRealize <NSObject>  /**< 上层需要实现的方法 */

/** image view图片缓存，上层用此方法实现图片缓存操作 */
- (void)imageViewWebCache:(UIImageView *)imageView url:(nullable NSURL *)url holder:(nullable UIImage *)holder;

/** 图片缓存，层用此方法实现图片缓存操作，assigments视图赋值image操作 */
- (void)imageWebCache:(UIView *)view url:(nullable NSURL *)url holder:(nullable UIImage *)holder
           assignment:(nullable void(^)(UIImage * _Nullable image, NSData * _Nullable imageData,
                                        NSInteger cacheType, NSURL * _Nullable imageURL))assignment;

@end


@interface ZCKitBridge : NSObject  /**< 供上层直接操作的类 */

@property (class, nonatomic, assign) BOOL isPrintLog;  /**< 是否需要打印日志，默认NO */

@property (class, nonatomic, copy) NSString *naviBackImageName;  /**< 导航的返回箭头图片，默认"zc_image_back_arrow" */

@property (class, nonatomic, copy) NSString *naviBarImageOrColor;  /**< 导航栏背景图或者背景颜色，默认"0xF5F5F7" */

@property (class, nonatomic, copy) NSString *naviBarTitleColor;  /**< 导航栏标题字体颜色，默认"0x222222" */

@property (class, nonatomic, copy) NSString *sideArrowImageName;  /**< 侧边箭头图片名字，默认"zc_image_side_accessory" */

@property (class, nonatomic, strong) UIColor *toastBackGroundColor;  /**< toast背景颜色，默认@"0x000000 black" */

@property (class, nonatomic, strong) UIColor *toastTextColor;  /**< toast文字颜色，默认@"0xFFFFFF white" */

@property (class, nonatomic, copy, readonly) NSString *invalidStr;  /**< 定义的特定无效值，默认"zc_invalid_value &.Ignore" */

@property (class, nullable, nonatomic, strong) id<ZCKitExternalRealize> realize;  /**< 上层外部实现，供Kit调用，程序启动时需要上层注入 */

@end

NS_ASSUME_NONNULL_END
