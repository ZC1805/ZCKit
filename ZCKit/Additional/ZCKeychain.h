//
//  ZCKeychain.h
//  ZCKit
//
//  Created by admin on 2018/2/29.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCKeychain : NSObject  /**< 供操作keychain */

+ (BOOL)updateData:(id)data service:(NSString *)service;

+ (BOOL)addData:(id)data service:(NSString *)service;

+ (BOOL)deleteDataWithService:(NSString *)service;

+ (id)queryDataWithService:(NSString *)service;

@end

NS_ASSUME_NONNULL_END
