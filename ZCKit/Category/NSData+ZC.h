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

- (NSString *)md5String;  /**< 大写的MD5字符串 */

- (NSString *)hexString;  /**< 十六进制字符串 */

- (nullable id)jsonObject;  /**< json对象可能返回nil或者@"10"这样的对象 */

- (nullable NSString *)utf8String;  /**< utf8字符串 */

- (nullable NSString *)base64EncodedString;  /**< base64字符串 */

+ (nullable NSData *)dataWithBase64EncodedString:(nullable NSString *)base64EncodedString;  /**< base64字符串转data */

@end

NS_ASSUME_NONNULL_END
