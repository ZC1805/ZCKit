//
//  ZCSystemHandler.m
//  ZCKit
//
//  Created by admin on 2018/10/17.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCSystemHandler.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <CoreServices/CoreServices.h>
#import <Photos/PHPhotoLibrary.h>
#import <MessageUI/MessageUI.h>
#import "ZCQueueHandler.h"
#import "ZCKitBridge.h"
#import "ZCMacro.h"

@interface ZCSystemHandler () <MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) void(^messageResultBlock)(BOOL isSendSuccess, BOOL isCancelSend);

@property (nonatomic, copy) void(^pickerPhotoBlock)(UIImage *image, NSString *fail);

@property (nonatomic, strong) UIImagePickerController *picker;

@property (nonatomic, assign) BOOL isEditedImage;

@end

@implementation ZCSystemHandler

+ (instancetype)sharedHandler {
    static ZCSystemHandler *instacne = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instacne = [[ZCSystemHandler alloc] init];
    });
    return instacne;
}

- (UIImagePickerController *)picker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
    }
    return _picker;
}

#pragma mark - Photo pick
+ (BOOL)cameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)photoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (void)photoPicker:(UIImagePickerControllerSourceType)type edit:(BOOL)edit front:(BOOL)front finish:(void(^)(UIImage *image, NSString *fail))finish {
    if (!finish) return;
    if (type == UIImagePickerControllerSourceTypePhotoLibrary) {
        PHAuthorizationStatus libAuthStatus = [PHPhotoLibrary authorizationStatus];
        if (libAuthStatus == PHAuthorizationStatusAuthorized) {
            [self pickerHandler:type edit:edit front:front finish:finish];
        } else if (libAuthStatus == PHAuthorizationStatusRestricted || libAuthStatus == PHAuthorizationStatusDenied) {
            finish(nil, NSLocalizedString(@"Please allow app access to album", nil));
        } else {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                main_imp(^{
                    if (status == PHAuthorizationStatusAuthorized) {
                        [self pickerHandler:type edit:edit front:front finish:finish];
                    } else {
                        finish(nil, NSLocalizedString(@"Failed to get photos", nil));
                    }
                });
            }];
        }
    } else if (type == UIImagePickerControllerSourceTypeCamera) {
        AVAuthorizationStatus cameraAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (cameraAuthStatus == AVAuthorizationStatusAuthorized) {
            [self pickerHandler:type edit:edit front:front finish:finish];
        } else if (cameraAuthStatus == AVAuthorizationStatusRestricted || cameraAuthStatus == AVAuthorizationStatusDenied) {
            finish(nil, NSLocalizedString(@"Please allow app access to camera", nil));
        } else {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                main_imp(^{
                    if (granted) {
                        [self pickerHandler:type edit:edit front:front finish:finish];
                    } else {
                        finish(nil, NSLocalizedString(@"Failed to get photos", nil));
                    }
                });
            }];
        }
    }
}

+ (void)photoPicker:(NSString *)message mustCamera:(BOOL)mustCamera mustAlbum:(BOOL)mustAlbum edit:(BOOL)edit front:(BOOL)front finish:(void(^)(UIImage *image, NSString *fail))done {
    if (mustCamera == mustAlbum) {
        BOOL camera = [self cameraAvailable];
        BOOL album = [self photoLibraryAvailable];
        NSMutableArray *items = [NSMutableArray array];
        NSMutableArray *sourceTypes = [NSMutableArray array];
        if (camera) { [items addObject:NSLocalizedString(@"Photograph", nil)]; [sourceTypes addObject:@(UIImagePickerControllerSourceTypeCamera)]; } //拍照
        if (album) { [items addObject:NSLocalizedString(@"Select from album", nil)]; [sourceTypes addObject:@(UIImagePickerControllerSourceTypePhotoLibrary)]; } //从相册选取
        if (items.count == 2) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *ac1 = [UIAlertAction actionWithTitle:items[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self photoPicker:[sourceTypes[0] integerValue] edit:edit front:front finish:done];
            }];
            UIAlertAction *ac2 = [UIAlertAction actionWithTitle:items[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self photoPicker:[sourceTypes[1] integerValue] edit:edit front:front finish:done];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:ac1]; [alert addAction:ac2]; [alert addAction:cancel];
            UIViewController *fromVc = [ZCGlobal currentController];
            if (fromVc) [fromVc presentViewController:alert animated:YES completion:nil];
        } else if (items.count == 1) {
            [self photoPicker:[sourceTypes[0] integerValue] edit:edit front:front finish:done];
        } else {
            if (done) done(nil, NSLocalizedString(@"Can't open album and camera", nil)); //无法打开相册和相机
        }
    } else if (mustCamera) {
        if ([self cameraAvailable]) {
            [self photoPicker:UIImagePickerControllerSourceTypeCamera edit:edit front:front finish:done];
        } else {
            if (done) done(nil, NSLocalizedString(@"Enable camera failed", nil)); //启用相机失败
        }
    } else if (mustAlbum) {
        if ([self photoLibraryAvailable]) {
            [self photoPicker:UIImagePickerControllerSourceTypePhotoLibrary edit:edit front:front finish:done];
        } else {
            if (done) done(nil, NSLocalizedString(@"Failed to open album", nil)); //打开相册失败
        }
    }
}

+ (void)pickerHandler:(UIImagePickerControllerSourceType)type edit:(BOOL)edit front:(BOOL)front finish:(void(^)(UIImage *image, NSString *fail))finish {
    UIViewController *fromVc = [ZCGlobal currentController];
    if (!fromVc) return;
    ZCSystemHandler *handle = [ZCSystemHandler sharedHandler];
    handle.pickerPhotoBlock = finish;
    handle.isEditedImage = edit;
    handle.picker.allowsEditing = edit;
    handle.picker.sourceType = type;
    if (type == UIImagePickerControllerSourceTypeCamera) {
        handle.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        handle.picker.cameraDevice = front ? UIImagePickerControllerCameraDeviceFront : UIImagePickerControllerCameraDeviceRear;
    }
    [fromVc presentViewController:handle.picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[self.isEditedImage ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.pickerPhotoBlock) {
            if (image) {
                self.pickerPhotoBlock(image, nil);
            } else {
                self.pickerPhotoBlock(nil, NSLocalizedString(@"Failed to get photos", nil)); //获取照片失败
            }
            self.pickerPhotoBlock = nil;
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.pickerPhotoBlock) {
            self.pickerPhotoBlock = nil;
        }
    }];
}

- (void)navigationController:(UINavigationController *)naviController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    naviController.navigationBar.barTintColor = kZCS(ZCKitBridge.naviBarImageOrColor);
    naviController.navigationBar.tintColor = kZCS(ZCKitBridge.naviBarTitleColor);
}

#pragma mark - Send message
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller.topViewController.view endEditing:YES];
    if (result == MessageComposeResultSent || result == MessageComposeResultFailed) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [controller dismissViewControllerAnimated:YES completion:nil];
            if (self.messageResultBlock) {
                self.messageResultBlock(result == MessageComposeResultSent, result == MessageComposeResultCancelled);
                self.messageResultBlock = nil;
            }
        });
    } else {
        [controller dismissViewControllerAnimated:YES completion:nil];
        if (self.messageResultBlock) {
            self.messageResultBlock(result == MessageComposeResultSent, result == MessageComposeResultCancelled);
            self.messageResultBlock = nil;
        }
    }
}

+ (void)sendMessage:(NSString *)message receivers:(NSArray <NSString *>*)receivers finish:(void(^)(BOOL isSendSuccess, BOOL isCancelSend))finish {
    UIViewController *fromVc = [ZCGlobal currentController];
    if (message && receivers.count && fromVc) {
        if ([MFMessageComposeViewController canSendText]) {
            [ZCSystemHandler sharedHandler].messageResultBlock = finish;
            MFMessageComposeViewController *mvc = [[MFMessageComposeViewController alloc] init];
            mvc.messageComposeDelegate = [ZCSystemHandler sharedHandler];
            mvc.recipients = receivers;
            mvc.body = message;
            [fromVc presentViewController:mvc animated:YES completion:nil];
        } else { //提示该设备不支持短信功能
            UIAlertController *avc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Tips", nil) message:NSLocalizedString(@"The device does not support SMS function", nil) preferredStyle:UIAlertControllerStyleAlert];
            [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil) style:UIAlertActionStyleCancel handler:nil]];
            [fromVc presentViewController:avc animated:YES completion:nil];
        }
    }
}

#pragma mark - System alert
+ (void)alertChoice:(NSString *)title message:(NSString *)message ctor:(NSString * _Nullable (^)(BOOL, BOOL * _Nonnull))ctor action:(void (^)(BOOL))doAction {
    UIViewController *fromVc = [ZCGlobal currentController];
    if (!fromVc) return;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    NSString *cancel = nil, *confirm = nil; BOOL destructive = NO;
    if (ctor) {
        destructive = NO;
        cancel = ctor(YES, &destructive);
        if (cancel.length) {
            UIAlertActionStyle style = destructive ? UIAlertActionStyleDestructive : UIAlertActionStyleCancel;
            UIAlertAction *action = [UIAlertAction actionWithTitle:cancel style:style handler:^(UIAlertAction * _Nonnull action) {
                if (doAction) doAction(YES);
            }];
            [alert addAction:action];
        }
        destructive = NO;
        confirm = ctor(NO, &destructive);
        if (confirm.length && !(cancel.length && [cancel isEqualToString:confirm])) {
            UIAlertActionStyle style = destructive ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault;
            UIAlertAction *action = [UIAlertAction actionWithTitle:confirm style:style handler:^(UIAlertAction * _Nonnull action) {
                if (doAction) doAction(NO);
            }];
            [alert addAction:action];
        }
    }
    if (!cancel.length && !confirm.length) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (doAction) doAction(YES);
        }];
        [alert addAction:action];
    }
    [fromVc presentViewController:alert animated:YES completion:nil];
}

+ (void)alertSheet:(NSString *)title message:(nullable NSString *)message
            cancel:(NSString * _Nullable (^)(void))cancel
              ctor:(NSString * _Nonnull (^)(NSInteger, BOOL * _Nonnull))ctor action:(void (^)(NSInteger))doAction {
    UIViewController *fromVc = [ZCGlobal currentController];
    if (!fromVc || !ctor || !doAction) return;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    BOOL isBreak = NO; NSInteger index = 0; NSMutableArray *sheets = [NSMutableArray array];
    do {
        BOOL destructive = NO;
        NSString *name = ctor(index, &destructive);
        isBreak = name.length && ![sheets containsObject:name];
        if (isBreak) {
            UIAlertActionStyle style = destructive ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault;
            [alert addAction:[UIAlertAction actionWithTitle:name style:style handler:^(UIAlertAction * _Nonnull action) {
                if (doAction) doAction(index);
            }]];
            [sheets addObject:name];
            index = index + 1;
        }
    } while (isBreak);
    if (index) {
        if (cancel) {
            NSString *name = cancel();
            if (name.length) {
                [alert addAction:[UIAlertAction actionWithTitle:name style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    if (doAction) doAction(-1);
                }]];
            }
        } else {
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (doAction) doAction(-1);
            }]];
        }
        [fromVc presentViewController:alert animated:YES completion:nil];
    }
}

@end
