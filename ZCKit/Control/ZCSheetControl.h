//
//  ZCSheetControl.h
//  ZCKit
//
//  Created by admin on 2018/10/22.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZCLabel, ZCButton;

NS_ASSUME_NONNULL_BEGIN

@interface ZCSheetControl : UIView  /**< 底部sheet菜单控件，加载在自定义window上 */

@property (nonatomic, assign) BOOL isMaskHide;  /**< 点击背景是否隐藏，默认YES */

@property (nonatomic, assign) BOOL isMaskClear;  /**< 是否使用透明背景，默认NO，用灰色 */

@property (nonatomic, assign) CGFloat maxHeight;  /**< 最大高度，默认383.0 */

@property (nullable, nonatomic, copy) NSString *cancelTitle;  /**< 取消title，默认"取消"，设置nil则不显示 */

@property (nullable, nonatomic, strong) NSArray <NSNumber *>*dangerous;  /**< 红色Title数组，默认nil */

/**< 当点击背景或者取消时selectIndex = -1，其余从0开始，ctor回调中可给sheet的属性赋值，但不可改frame */
+ (void)display:(nullable NSString *)msg sheet:(NSArray <NSString *>*)sheet
           ctor:(nullable void(^)(ZCSheetControl *sheetControl))ctor
         action:(nullable void(^)(NSInteger selectIndex))action;

/**< 当点击背景或者取消时selectIndex = -1，其余从0开始，ctor回调中可给sheet的属性赋值，但不可改frame */
+ (void)display:(nullable NSString *)msg sheet:(NSArray <NSString *>*)sheet
           ctor:(nullable void(^)(ZCSheetControl *sheetControl))ctor
      labelCtor:(nullable void(^)(ZCLabel *msgLabel))labelCtor
     buttonCtor:(nullable void(^)(ZCButton *itemBtn, NSInteger itemIndex, BOOL isCancelBtn))buttonCtor
         action:(nullable void(^)(NSInteger selectIndex))action;

@end

NS_ASSUME_NONNULL_END
