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

#pragma mark - usually
- (nullable NSString *)md5String;

- (nullable NSString *)base64EncodedString;

- (nullable NSNumber *)numberObject;

- (nullable NSData *)dataObject;

- (nullable id)jsonObject;

- (CGFloat)widthForFont:(nullable UIFont *)font;

- (CGFloat)heightForFont:(nullable UIFont *)font width:(CGFloat)width;

- (NSUInteger)charCount;   /**< 字符长度 */

- (NSUInteger)bytesCount;   /**< 字节长度 */

- (NSString *)preciseString;   /**< 精确浮点数 */

- (NSString *)formatterPrice;   /**< 保留两位有效数字 */

- (NSString *)stringByTrim;   /**< 去掉两端空格和换行符 */

- (NSString *)deletePictureResolution;   /**< 删除图片尾缀@2x、@3x */


#pragma mark - usually
- (BOOL)isPureInteger;   /**< 是否是整形 */

- (BOOL)isPureFloat;   /**< 是否是浮点型 (0.2f不算) */

- (BOOL)isPureNumber;   /**< 是否是全数字 */

- (BOOL)isPureAlpha;   /**< 是否是全字母 */

- (BOOL)isPureChinese;   /**< 是否是全中文 */

- (BOOL)isContainNumber;   /**< 是否包含数字 */

- (BOOL)isContainAlpha;   /**< 是否包含字母 */

- (BOOL)isContainChinese;   /**< 是否包含字母 */

- (BOOL)isPhone;   /**< 是否是手机号 */

- (BOOL)isUrl;   /**< 是否是网址 */

- (BOOL)isPostalcode;   /**< 是否是邮政编码 */

- (BOOL)isEmail;   /**< 是否是邮箱 */

- (BOOL)isTaxNo;   /**< 是否是工商税号 */

- (BOOL)isIP;   /**< 是否是IP地址xxx.xxx.xxx.xxx */

- (BOOL)isCorrect;   /**< 是否是身份证号码 */

- (BOOL)isBankCard;   /**< 是否是银行卡号 */

- (BOOL)isUserName;   /**< 是否是用户姓名，1-20位的中文或英文 */

- (BOOL)isPasswordAllowAdmitSpecialCharacter:(BOOL)specialChar mustAllContain:(BOOL)allContain allowSimple:(BOOL)allowSimple
                                   shieldStr:(nullable NSString *)shieldStr min:(int)min max:(int)max;  /**< 是否是规范的密码 */

- (BOOL)isNotBlank;   /**< 是否不是空白，nil，@""，@"  "，@"\n" will Returns NO */

- (BOOL)isContainAdmitSpecialCharacter;   /**< 是否包含承认的特殊字符 */

- (BOOL)isContainsCharacterSet:(nullable NSCharacterSet *)set;   /**< 是否包含字符集 */

- (BOOL)isEqualIgnoreCase:(nullable NSString *)str;   /**< 不区分大小写比对字符串相等 */


#pragma mark - class
+ (NSString *)stringWithUUID;

+ (nullable NSString *)stringWithBase64EncodedString:(nullable NSString *)base64EncodedString;


#pragma mark - expand
- (NSString *)stringByURLEncode;

- (NSString *)stringByURLDecode;

- (NSString *)stringByEscapingHTML;

- (BOOL)matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options;

- (void)enumerateRegexMatches:(NSString *)regex
                      options:(NSRegularExpressionOptions)options
                   usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block;

- (NSString *)stringByReplacingRegex:(NSString *)regex
                             options:(NSRegularExpressionOptions)options
                          withString:(NSString *)replacement;

@end

NS_ASSUME_NONNULL_END








