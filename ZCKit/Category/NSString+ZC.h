//
//  NSString+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018年 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZC)

/** ----- usually ----- */
- (NSString *)md5String;

- (NSString *)base64EncodedString;

- (CGFloat)widthForFont:(UIFont *)font;

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;

- (nullable NSNumber *)numberObject;

- (nullable NSData *)dataObject;

- (nullable id)jsonObject;

- (NSUInteger)charCount;   /**< 字符长度 */

- (NSUInteger)bytesCount;   /**< 字节长度 */

- (NSString *)preciseString;   /**< 精确浮点数 */

- (NSString *)formatterPrice;   /**< 保留两位有效数字 */

- (NSString *)stringByTrim;   /**< 去掉两端空格和换行符 */

- (NSString *)deletePictureResolution;   /**< 删除图片尾缀@2x、@3x */

/** ----- usually ----- */
- (BOOL)isPureFloat;
- (BOOL)isPureNumber;
- (BOOL)isEasyPasswordShield:(NSString *)shield;

@end

NS_ASSUME_NONNULL_END










