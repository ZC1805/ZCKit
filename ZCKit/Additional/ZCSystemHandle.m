//
//  ZCSystemHandle.m
//  ZCKit
//
//  Created by admin on 2018/10/17.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCSystemHandle.h"
#import <MessageUI/MessageUI.h>
#import "ZCGlobal.h"

@interface ZCSystemHandle () <MFMessageComposeViewControllerDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) void(^messageResultBlock)(BOOL isSendSuccess, BOOL isCancelSend);

@property (nonatomic, copy) void(^pickerPhotoBlock)(UIImage *image, NSString *fail);

@property (nonatomic, strong) UIImagePickerController *picker;

@property (nonatomic, assign) BOOL isEditedImage;

@end

@implementation ZCSystemHandle

+ (instancetype)instance {
    static ZCSystemHandle *instacne = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instacne = [[ZCSystemHandle alloc] init];
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
    UIViewController *rootVc = [ZCGlobal rootController];
    if (!rootVc) return;
    ZCSystemHandle *handle = [ZCSystemHandle instance];
    handle.pickerPhotoBlock = finish;
    handle.isEditedImage = edit;
    handle.picker.allowsEditing = edit;
    handle.picker.sourceType = type;
    [rootVc presentViewController:handle.picker animated:YES completion:nil];
}

+ (void)photoPicker:(NSString *)message mustCamera:(BOOL)mustCamera mustAlbum:(BOOL)mustAlbum edit:(BOOL)edit finish:(void(^)(UIImage *image, NSString *fail))done {
    if (mustCamera == mustAlbum) {
        BOOL camera = [self cameraAvailable];
        BOOL album = [self photoLibraryAvailable];
        NSMutableArray *items = [NSMutableArray array];
        NSMutableArray *sourceTypes = [NSMutableArray array];
        if (camera) {[items addObject:@"拍照"]; [sourceTypes addObject:@(UIImagePickerControllerSourceTypeCamera)];}
        if (album) {[items addObject:@"从相册选取"]; [sourceTypes addObject:@(UIImagePickerControllerSourceTypePhotoLibrary)];}
        if (items.count == 2) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *ac1 = [UIAlertAction actionWithTitle:items[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self photoPicker:[sourceTypes[0] integerValue] edit:edit finish:done];
            }];
            UIAlertAction *ac2 = [UIAlertAction actionWithTitle:items[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self photoPicker:[sourceTypes[1] integerValue] edit:edit finish:done];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:ac1]; [alert addAction:ac2]; [alert addAction:cancel];
            if ([ZCGlobal rootController]) {
                [[ZCGlobal rootController] presentViewController:alert animated:YES completion:nil];
            }
        } else if (items.count == 1) {
            [self photoPicker:[sourceTypes[0] integerValue] edit:edit finish:done];
        } else {
            if (done) done (nil, @"无法打开相册和相机");
        }
    } else if (mustCamera) {
        if ([self cameraAvailable]) {
            [self photoPicker:UIImagePickerControllerSourceTypeCamera edit:edit finish:done];
        } else {
            if (done) done (nil, @"启用相机失败");
        }
    } else if (mustAlbum) {
        if ([self photoLibraryAvailable]) {
            [self photoPicker:UIImagePickerControllerSourceTypePhotoLibrary edit:edit finish:done];
        } else {
            if (done) done (nil, @"打开相册失败");
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
                self.pickerPhotoBlock(nil, @"获取照片失败");
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
    navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.950 green:0.955 blue:0.965 alpha:1.0];
    navigationController.navigationBar.tintColor = [UIColor blackColor];
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
    UIViewController *rootVc = [ZCGlobal rootController];
    if (message && receivers.count && rootVc) {
        if ([MFMessageComposeViewController canSendText]) {
            [ZCSystemHandle instance].messageResultBlock = finish;
            MFMessageComposeViewController *mvc = [[MFMessageComposeViewController alloc] init];
            mvc.messageComposeDelegate = [ZCSystemHandle instance];
            mvc.recipients = receivers;
            mvc.body = message;
            [rootVc presentViewController:mvc animated:YES completion:nil];
        } else {
            UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"提示" message:@"该设备不支持短信功能" preferredStyle:UIAlertControllerStyleAlert];
            [avc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            [rootVc presentViewController:avc animated:YES completion:nil];
        }
    }
}

#pragma mark - system alert
+ (void)alertChoice:(NSString *)title message:(NSString *)message ctor:(NSString * _Nullable (^)(BOOL, BOOL * _Nonnull))ctor action:(void (^)(BOOL))doAction {
    if ([ZCGlobal rootController] == nil) return;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    NSString *cancel = nil, *confirm = nil; BOOL destructive = NO;
    if (ctor) {
        destructive = NO;
        cancel = ctor(YES, &destructive);
        if (cancel.length) {
            UIAlertActionStyle style = destructive ? UIAlertActionStyleDestructive : UIAlertActionStyleCancel;
            [alert addAction:[UIAlertAction actionWithTitle:cancel style:style handler:^(UIAlertAction * _Nonnull action) {
                if (doAction) doAction(YES);
            }]];
        }
        destructive = NO;
        confirm = ctor(NO, &destructive);
        if (confirm.length && !(cancel.length && [cancel isEqualToString:confirm])) {
            UIAlertActionStyle style = destructive ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault;
            [alert addAction:[UIAlertAction actionWithTitle:confirm style:style handler:^(UIAlertAction * _Nonnull action) {
                if (doAction) doAction(NO);
            }]];
        }
    }
    if (!cancel.length && !confirm.length) {
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (doAction) doAction(YES);
        }]];
    }
    [[ZCGlobal rootController] presentViewController:alert animated:YES completion:nil];
}

+ (void)alertSheet:(NSString *)title cancel:(NSString * _Nullable (^)(void))cancel ctor:(NSString * _Nonnull (^)(NSInteger, BOOL * _Nonnull))ctor action:(void (^)(NSInteger))doAction {
    if ([ZCGlobal rootController] == nil || ctor == nil || doAction == nil) return;
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
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (doAction) doAction(-1);
            }]];
        }
        [[ZCGlobal rootController] presentViewController:alert animated:YES completion:nil];
    }
}

@end
