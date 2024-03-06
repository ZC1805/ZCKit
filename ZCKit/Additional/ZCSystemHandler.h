//
//  ZCSystemHandler.h
//  ZCKit
//
//  Created by admin on 2018/10/17.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCSystemHandler : NSObject  /**< 系统控件处理类 */

+ (BOOL)cameraAvailable;  /**< 相机是否可用 */

+ (BOOL)photoLibraryAvailable;  /**< 相册是否可用 */

/**< 从特定地方选取照片，点击取消不回调，edit是否可编辑 */
+ (void)photoPicker:(UIImagePickerControllerSourceType)type edit:(BOOL)edit front:(BOOL)front
             finish:(void(^)(UIImage * _Nullable image, NSString * _Nullable fail))finish;

/**< 从相册或者相机选取照片，点击取消不回调，messaget选取照片提示信息，mustCamera只从相机选择，mustAlbum只从相册选择，edit是否可编辑 */
+ (void)photoPicker:(nullable NSString *)message mustCamera:(BOOL)mustCamera mustAlbum:(BOOL)mustAlbum edit:(BOOL)edit
              front:(BOOL)front finish:(void(^)(UIImage * _Nullable image, NSString * _Nullable fail))done;

/**< 发送短信，短信内容可以再编辑，isSendSuccesss是否发送成功，isCancelSend是否取消发送 */
+ (void)sendMessage:(nullable NSString *)message receivers:(NSArray <NSString *>*)receivers
             finish:(nullable void(^)(BOOL isSendSuccess, BOOL isCancelSend))finish;

/**< 用系统alertController展示提示框，ctor调用两次，默认是isCancel为YES & actionTitle为"确定" */
+ (void)alertChoice:(NSString *)title message:(nullable NSString *)message
               ctor:(nullable NSString * _Nullable(^)(BOOL isCancel, BOOL *destructive))ctor
             action:(nullable void(^)(BOOL isCancel))doAction;

/**< 用系统alertController展示提示框，cancel为nil默认添加取消action & 此时index = -1，ctor调用多次 & 直到返回重复或者nil */
+ (void)alertSheet:(nullable NSString *)title message:(nullable NSString *)message
            cancel:(nullable NSString * _Nullable(^)(void))cancel
              ctor:(NSString *(^)(NSInteger index, BOOL *destructive))ctor
            action:(void(^)(NSInteger index))doAction;

@end

NS_ASSUME_NONNULL_END
