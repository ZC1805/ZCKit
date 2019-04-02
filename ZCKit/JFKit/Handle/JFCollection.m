//
//  JFCollection.m
//  gobe
//
//  Created by zjy on 2019/3/16.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFCollection.h"
#import <Contacts/Contacts.h>
#import <objc/runtime.h>

@interface JFCollection ()

@property (nonatomic, copy) void(^addressListBlock)(BOOL success, NSArray *list);

@end

@implementation JFCollection

+ (instancetype)sharedCollection {
    static dispatch_once_t onceToken;
    static JFCollection *colloction = nil;
    dispatch_once(&onceToken, ^{
        colloction = [[JFCollection alloc] init];
    });
    return colloction;
}

#pragma mark - 获取通讯录列表
+ (void)startCollectionAddressList:(void(^)(BOOL success, NSArray *list))block {
    [JFCollection sharedCollection].addressListBlock = block;
    [[JFCollection sharedCollection] requestContactAuthorIOS9];
}

- (void)requestContactAuthorIOS9 {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error || granted == NO) {
                [self showAlertNotAuthorContact];
            } else {
                [self collectionContactList];
            }
        }];
    } else if (status == CNAuthorizationStatusRestricted || status == CNAuthorizationStatusDenied) {
        [self showAlertNotAuthorContact];
    } else if (status == CNAuthorizationStatusAuthorized) {
        [self collectionContactList];
    }
}

- (void)showAlertNotAuthorContact {
    if (self.addressListBlock) {
        self.addressListBlock(NO, @[]);
        self.addressListBlock = nil;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请授权通讯录权限", nil)
                                                                   message:NSLocalizedString(@"请在手机的\"设置-隐私-通讯录\"选项中,允许访问你的通讯录", nil)
                                                            preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:NSLocalizedString(@"好的", nil) style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:done];
    if ([ZCGlobal rootController]) {
        [[ZCGlobal rootController] presentViewController:alert animated:YES completion:nil];
    }
}

- (void)collectionContactList {
    // 获取指定的字段，并不是要获取所有字段，需要指定具体的字段
    NSMutableArray *list = [NSMutableArray array];
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSString *name = [NSString stringWithFormat:@"%@%@", contact.familyName, contact.givenName];  // 拼接姓名
        for (CNLabeledValue *labelValue in contact.phoneNumbers) {  // 遍历一个人名下的多个电话号码
            CNPhoneNumber *phoneNumber = labelValue.value;
            NSString *number = phoneNumber.stringValue;
            number = [number stringByReplacingOccurrencesOfString:@"+86" withString:@""];  // 去掉电话中的特殊字符
            number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
            number = [number stringByReplacingOccurrencesOfString:@"(" withString:@""];
            number = [number stringByReplacingOccurrencesOfString:@")" withString:@""];
            number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
            number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
            //NSLog(@"姓名:%@  电话号码是:%@  区分:%@  原号:%@", name, number, labelValue.label, phoneNumber.stringValue);
            if (number.length) {
                [list addObject:[name stringByAppendingString:[NSString stringWithFormat:@"  %@", number]]];
            }
        }
    }];
    if (self.addressListBlock) {
        self.addressListBlock(YES, [list copy]);
        self.addressListBlock = nil;
    }
}

#pragma mark - 获取手机应用列表


#pragma mark - 获取手机上的所有应用信息
//- (void)getIphoneAllApplications1 {
//    Class LSApplicationWorkspace_class =objc_getClass("LSApplicationWorkspace");
//    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
//    NSArray *apps= [workspace performSelector:@selector(allApplications)];
//    Class LSApplicationProxy_class = objc_getClass("LSApplicationProxy");
//    for (int i = 0; i < apps.count; i++) {
//        NSObject *temp = apps[i];
//        if ([temp isKindOfClass:LSApplicationProxy_class]) {
//            //应用的bundleId
//            NSString *appBundleId = [temp performSelector:NSSelectorFromString(@"applicationIdentifier")];
//            //应用的名称
//            NSString *appName = [temp performSelector:NSSelectorFromString(@"localizedName")];
//            //应用的类型是系统的应用还是第三方的应用
//            NSString * type = [temp performSelector:NSSelectorFromString(@"applicationType")];
//            //应用的版本
//            NSString * shortVersionString = [temp performSelector:NSSelectorFromString(@"shortVersionString")];
//            NSString * resourcesDirectoryURL = [temp performSelector:NSSelectorFromString(@"containerURL")];
//            NSLog(@"类型=%@应用的BundleId=%@ ++++应用的名称=%@版本号=%@\n%@", type, appBundleId, appName, shortVersionString, resourcesDirectoryURL);
//        }
//    }
//}
//
//
//
//- (void)openApp {
//    Class lsawsc = objc_getClass("LSApplicationWorkspace");
//    NSObject* workspace = [lsawsc performSelector:NSSelectorFromString(@"defaultWorkspace")];
//    // iOS6 没有defaultWorkspace
//    if ([workspace respondsToSelector:NSSelectorFromString(@"openApplicationWithBundleID:")]) {
//        //通过App的BundleID 就可以访问
//        [workspace performSelector:NSSelectorFromString(@"openApplicationWithBundleID:") withObject:@"jfxy.JFCredit"];
//    }
//}




//- (void)getAppList {
//    Class LSApplicationWorkspace_Class = NSClassFromString(@"LSApplicationWorkspace");
//    NSObject *workspace = [LSApplicationWorkspace_Class performSelector:NSSelectorFromString(@"defaultWorkspace")];
//    NSArray *appList = [workspace performSelector:NSSelectorFromString(@"allApplications")];
//    for (id app in appList) {
//        NSLog(@"-----App列表----%@", [app performSelector:NSSelectorFromString(@"applicationIdentifier")]);
//    }
//}

//iOS 11 上获取所有已安装应用接口被禁，但可以根据BundleId检查App是否存在
//- (BOOL)isInstalled:(NSString *)bundleId {
//    NSBundle *container = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/MobileContainerManager.framework"];
//    if ([container load]) {
//        Class appContainer = NSClassFromString(@"MCMAppContainer");
//#pragmaclang diagnostic push
//#pragmaclang diagnostic ignored "-Wundeclared-selector"
//        idcontainer = [appContainer performSelector:@selector(containerWithIdentifier:error:) withObject:bundleId withObject:nil];
//#pragmaclang diagnostic pop
//        NSLog(@"%@", [container performSelector:@selector(identifier)]);
//        if (container) {
//            return YES;
//        } else {
//            return NO;
//        }
//    }
//    return NO;
//}

@end
