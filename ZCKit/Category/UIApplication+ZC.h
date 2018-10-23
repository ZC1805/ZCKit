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

@property (nonatomic, readonly) NSURL *documentsURL;  /**< "Documents" 沙盒路径 */

@property (nonatomic, readonly) NSString *documentsPath;  /**< "Documents" 沙盒路径 */

@property (nonatomic, readonly) NSURL *cachesURL;  /**< "Caches" 沙盒路径 */

@property (nonatomic, readonly) NSString *cachesPath;  /**< "Caches" 沙盒路径 */

@property (nonatomic, readonly) NSURL *libraryURL;  /**< "Library" 沙盒路径 */

@property (nonatomic, readonly) NSString *libraryPath;  /**< "Library" 沙盒路径 */

@property (nonatomic, readonly) NSString *appBundleName;  /**< 应用 Bundle Name (show in SpringBoard) */

@property (nonatomic, readonly) NSString *appBundleID;  /**< 应用 Bundle ID "com.ibireme.MyApp" */

@property (nonatomic, readonly) NSString *appVersion;  /**< 应用 Version "1.2.0" */

@property (nonatomic, readonly) NSString *appBuildVersion;  /**< 应用 Build number "123" */

@end

NS_ASSUME_NONNULL_END

