//
//  UIApplication+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (ZC)

/** "Documents" 沙盒路径 */
@property (nonatomic, readonly) NSURL *documentsURL;
@property (nonatomic, readonly) NSString *documentsPath;

/** "Caches" 沙盒路径 */
@property (nonatomic, readonly) NSURL *cachesURL;
@property (nonatomic, readonly) NSString *cachesPath;

/** "Library" 沙盒路径 */
@property (nonatomic, readonly) NSURL *libraryURL;
@property (nonatomic, readonly) NSString *libraryPath;

/** 应用 Bundle Name (show in SpringBoard) */
@property (nullable, nonatomic, readonly) NSString *appBundleName;

/** 应用 Bundle ID "com.ibireme.MyApp" */
@property (nullable, nonatomic, readonly) NSString *appBundleID;

/** 应用 Version "1.2.0" */
@property (nullable, nonatomic, readonly) NSString *appVersion;

/** 应用 Build number "123" */
@property (nullable, nonatomic, readonly) NSString *appBuildVersion;

/** 当前是否是 App Extension */
+ (BOOL)isAppExtension;

/** 返回类似sharedApplication, 是App Extension返回nil */
+ (nullable UIApplication *)sharedExtensionApplication;

@end

NS_ASSUME_NONNULL_END










