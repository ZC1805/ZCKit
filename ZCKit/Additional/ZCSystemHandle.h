//
//  ZCSystemHandle.h
//  ZCKit
//
//  Created by admin on 2018/10/17.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCSystemHandle : NSObject

+ (BOOL)cameraAvailable;   /**< 相机是否可用 */

+ (BOOL)photoLibraryAvailable;   /**< 相册是否可用 */

/** 从特定地方选取照片，点击取消不回调，edit是否可编辑 */
+ (void)photoPicker:(UIImagePickerControllerSourceType)type edit:(BOOL)edit
             finish:(nullable void(^)(UIImage * _Nullable image, NSString * _Nullable fail))finish;

/** 从相册或者相机选取照片，点击取消不回调，messaget选取照片提示信息，mustCamera只从相机选择，mustAlbum只从相册选择，edit是否可编辑 */
+ (void)photoPicker:(nullable NSString *)message mustCamera:(BOOL)mustCamera mustAlbum:(BOOL)mustAlbum edit:(BOOL)edit
             finish:(nullable void(^)(UIImage * _Nullable image, NSString * _Nullable fail))done;

/**< 发送短信，短信内容可以再编辑，isSendSuccesss是否发送成功，isCancelSend是否取消发送 */
+ (void)send:(nullable NSString *)message receivers:(NSArray <NSString *>*)receivers finish:(nullable void(^)(BOOL isSendSuccess, BOOL isCancelSend))finish;

@end

NS_ASSUME_NONNULL_END
