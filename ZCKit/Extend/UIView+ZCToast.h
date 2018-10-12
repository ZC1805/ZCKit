//
//  UIView+ZCToast.h
//  ZCKit
//
//  Created by admin on 2018/10/12.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZCEnumToastPosition) {
    ZCEnumToastPositionCenter,
    ZCEnumToastPositionTop,
    ZCEnumToastPositionBottom,
};

@interface UIView (ZCToast)

- (void)makeToast:(nullable NSString *)message;

- (void)makeToast:(nullable NSString *)message duration:(NSTimeInterval)interval position:(ZCEnumToastPosition)position;

- (void)makeToast:(nullable NSString *)message duration:(NSTimeInterval)interval position:(ZCEnumToastPosition)position
            title:(nullable NSString *)title image:(nullable UIImage *)image;


- (void)showToast:(nullable UIView *)toast;

- (void)showToast:(nullable UIView *)toast duration:(NSTimeInterval)interval position:(ZCEnumToastPosition)position;

- (void)showToast:(nullable UIView *)toast duration:(NSTimeInterval)interval position:(ZCEnumToastPosition)position
      tapCallback:(nullable void(^)(void))tapCallback;

@end

NS_ASSUME_NONNULL_END
