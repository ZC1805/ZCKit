//
//  ZCSystemHandler.m
//  ZCKit
//
//  Created by admin on 2018/10/17.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCSystemHandler.h"
#import <MessageUI/MessageUI.h>
#import "ZCKitBridge.h"
#import "UIColor+ZC.h"
#import "ZCGlobal.h"

@interface ZCSystemHandler () <MFMessageComposeViewControllerDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) void(^messageResultBlock)(BOOL isSendSuccess, BOOL isCancelSend);

@property (nonatomic, copy) void(^pickerPhotoBlock)(UIImage *image, NSString *fail);

@property (nonatomic, strong) UIImagePickerController *picker;

@property (nonatomic, assign) BOOL isEditedImage;

@property (nonatomic, strong) UIColor *alertDoneColor;

@property (nonatomic, strong) UIColor *alertCancelColor;

@end

@implementation ZCSystemHandler

+ (instancetype)instance {
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

#pragma mark - photo pick
+ (BOOL)cameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)photoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (void)photoPicker:(UIImagePickerControllerSourceType)type edit:(BOOL)edit finish:(void(^)(UIImage *image, NSString *fail))finish {
    if (!finish) return;
    UIViewController *fromVc = [ZCGlobal currentController];
    if (!fromVc) return;
    ZCSystemHandler *handle = [ZCSystemHandler instance];
    handle.pickerPhotoBlock = finish;
    handle.isEditedImage = edit;
    handle.picker.allowsEditing = edit;
    handle.picker.sourceType = type;
    [fromVc presentViewController:handle.picker animated:YES completion:nil];
}

+ (void)photoPicker:(NSString *)message mustCamera:(BOOL)mustCamera mustAlbum:(BOOL)mustAlbum edit:(BOOL)edit finish:(void(^)(UIImage *image, NSString *fail))done {
    if (mustCamera == mustAlbum) {
        BOOL camera = [self cameraAvailable];
        BOOL album = [self photoLibraryAvailable];
        NSMutableArray *items = [NSMutableArray array];
        NSMutableArray *sourceTypes = [NSMutableArray array];
        if (camera) {[items addObject:NSLocalizedString(@"拍照", nil)]; [sourceTypes addObject:@(UIImagePickerControllerSourceTypeCamera)];}
        if (album) {[items addObject:NSLocalizedString(@"从相册选取", nil)]; [sourceTypes addObject:@(UIImagePickerControllerSourceTypePhotoLibrary)];}
        if (items.count == 2) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *ac1 = [UIAlertAction actionWithTitle:items[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self photoPicker:[sourceTypes[0] integerValue] edit:edit finish:done];
            }];
            UIAlertAction *ac2 = [UIAlertAction actionWithTitle:items[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self photoPicker:[sourceTypes[1] integerValue] edit:edit finish:done];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:ac1]; [alert addAction:ac2]; [alert addAction:cancel];
            UIViewController *fromVc = [ZCGlobal currentController];
            if (fromVc) [fromVc presentViewController:alert animated:YES completion:nil];
        } else if (items.count == 1) {
            [self photoPicker:[sourceTypes[0] integerValue] edit:edit finish:done];
        } else {
            if (done) done(nil, NSLocalizedString(@"无法打开相册和相机", nil));
        }
    } else if (mustCamera) {
        if ([self cameraAvailable]) {
            [self photoPicker:UIImagePickerControllerSourceTypeCamera edit:edit finish:done];
        } else {
            if (done) done(nil, NSLocalizedString(@"启用相机失败", nil));
        }
    } else if (mustAlbum) {
        if ([self photoLibraryAvailable]) {
            [self photoPicker:UIImagePickerControllerSourceTypePhotoLibrary edit:edit finish:done];
        } else {
            if (done) done(nil, NSLocalizedString(@"打开相册失败", nil));
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[self.isEditedImage ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.pickerPhotoBlock) {
            if (image) {
                self.pickerPhotoBlock(image, nil);
            } else {
                self.pickerPhotoBlock(nil, NSLocalizedString(@"获取照片失败", nil));
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

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    navigationController.navigationBar.barTintColor = [UIColor colorFromHexString:ZCKitBridge.naviBarImageOrColor];
    navigationController.navigationBar.tintColor = [UIColor colorFromHexString:ZCKitBridge.naviBarTitleColor];
}

#pragma mark - send message
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
            [ZCSystemHandler instance].messageResultBlock = finish;
            MFMessageComposeViewController *mvc = [[MFMessageComposeViewController alloc] init];
            mvc.messageComposeDelegate = [ZCSystemHandler instance];
            mvc.recipients = receivers;
            mvc.body = message;
            [fromVc presentViewController:mvc animated:YES completion:nil];
        } else {
            UIAlertController *avc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"该设备不支持短信功能", nil) preferredStyle:UIAlertControllerStyleAlert];
            [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleCancel handler:nil]];
            [fromVc presentViewController:avc animated:YES completion:nil];
        }
    }
}

#pragma mark - system alert
+ (void)customAlertDoneColor:(UIColor *)doneColor cancelColor:(nonnull UIColor *)cancelColor {
    [ZCSystemHandler instance].alertDoneColor = doneColor;
    [ZCSystemHandler instance].alertCancelColor = cancelColor;
}

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
            if ([ZCSystemHandler instance].alertCancelColor) {
                [action setValue:[ZCSystemHandler instance].alertCancelColor forKey:@"_titleTextColor"];
            }
        }
        destructive = NO;
        confirm = ctor(NO, &destructive);
        if (confirm.length && !(cancel.length && [cancel isEqualToString:confirm])) {
            UIAlertActionStyle style = destructive ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault;
            UIAlertAction *action = [UIAlertAction actionWithTitle:confirm style:style handler:^(UIAlertAction * _Nonnull action) {
                if (doAction) doAction(NO);
            }];
            [alert addAction:action];
            if ([ZCSystemHandler instance].alertDoneColor) {
                [action setValue:[ZCSystemHandler instance].alertDoneColor forKey:@"_titleTextColor"];
            }
        }
    }
    if (!cancel.length && !confirm.length) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (doAction) doAction(YES);
        }];
        [alert addAction:action];
        if ([ZCSystemHandler instance].alertDoneColor) {
            [action setValue:[ZCSystemHandler instance].alertDoneColor forKey:@"_titleTextColor"];
        }
    }
    [fromVc presentViewController:alert animated:YES completion:nil];
}

+ (void)alertSheet:(NSString *)title cancel:(NSString * _Nullable (^)(void))cancel ctor:(NSString * _Nonnull (^)(NSInteger, BOOL * _Nonnull))ctor action:(void (^)(NSInteger))doAction {
    UIViewController *fromVc = [ZCGlobal currentController];
    if (!fromVc || !ctor || !doAction) return;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (doAction) doAction(-1);
            }]];
        }
        [fromVc presentViewController:alert animated:YES completion:nil];
    }
}

@end
