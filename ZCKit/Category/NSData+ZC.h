//
//  NSData+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/6.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (ZC)

- (NSString *)md5String;

- (NSString *)hexString;

- (nullable id)jsonObject;

- (nullable NSString *)utf8String;

- (nullable NSString *)base64EncodedString;

+ (nullable NSData *)dataWithBase64EncodedString:(nullable NSString *)base64EncodedString;

@end

NS_ASSUME_NONNULL_END

