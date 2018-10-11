//
//  ZCMiscManager.h
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCMiscManager : NSObject

+ (long long)calculateFileSizeAtPath:(NSString *)path;   /**< 文件大小 */

+ (long long)calculateFolderSizeAtPath:(NSString *)path;   /**< 文件夹大小 */

@end

NS_ASSUME_NONNULL_END

