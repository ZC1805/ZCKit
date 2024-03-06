//
//  NSString+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ZCFlagStr;

@interface NSString (ZC)

#pragma mark - Usually
- (nullable NSString *)base64EncodedString;  /**< base64数据 */

- (nullable NSNumber *)numberObject;  /**< number数据 */

- (const char *)charString;  /**< 转换为C字符串 */

- (nullable id)jsonObject;  /**< json数据，可能为dictionary、array、string、number等 */

- (NSDictionary *)jsonDictionaryObject;  /**< jsos字符串转dict，可能为空dictionary */

- (NSArray *)jsonArrayObject;  /**< jsos字符串转arr，可能为空array */

- (NSString *)md5String;  /**< md5大写加密 */

- (NSString *)URLAllowString;  /**< Get请求参数编码 */

- (NSData *)dataObject;  /**< data数据 */

- (CGFloat)widthForFont:(UIFont *)font isSystemStyle:(BOOL)isSystemStyle;  /**< 计算宽度，NSLineBreakByWordWrapping，isSystemStyle计算label和button最好设为YES */

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width isSystemStyle:(BOOL)isSystemStyle;  /**< 计算高度，NSLineBreakByWordWrapping，isSystemStyle计算label和button最好设为YES */

- (CGSize)sizeFitLabelForFont:(UIFont *)font width:(CGFloat)width alignment:(NSTextAlignment)alignment spacing:(CGFloat)spacing;  /**< 取Label自适应高度 */

- (NSArray <NSString *>*)charStrings;  /**< 转成字符数组 */

- (NSUInteger)charCount;  /**< 字符长度 */

- (NSUInteger)bytesCount;  /**< 字节长度 */

- (NSString *)saveCacheString;

- (NSString *)obtainCacheString;

- (NSString *)preciseString;  /**< 精确浮点数 & 去除无效数字 */

- (NSString *)formatterPrice;  /**< 保留两位有效数字 */

- (NSString *)stringByTrim;  /**< 去掉首尾空格和换行符 */

- (NSString *)stringByRemoveSpaceAndReturn;  /**< 去掉空格、换行、回车字符 */

- (NSString *)stringByFormatSpace:(BOOL)ignoreLastSpace;  /**< 格式化字符串中的空格，去首尾空格并且合并空格，是否不校验最后一个空格 */

- (NSString *)stringByDiacritics;  /**< 去除字符串变音符，错误返回@"" */

- (NSString *)arabiaDgitalToChinese;  /**< 阿拉伯数字转中文格式，只限整数，其余返回@"" */

- (NSString *)deletePictureResolution;  /**< 删除图片尾缀@2x、@3x */

- (NSString *)prefixForFlag:(NSString *)flag;  /**< 返回匹配到的第一个标记符前面字符串，flag不为空且至少包含有一个匹配结果，否则返回@"" */

- (NSString *)suffixForFlag:(NSString *)flag;  /**< 返回匹配到的第一个标记符后面字符串，flag不为空且至少包含有一个匹配结果，否则返回@"" */

- (NSString *)subStringValueForRange:(NSRange)range;  /**< 返回子字符串，异常返回@"" */

- (NSString *)formatLast:(long)charCount separationCount:(long)separationCount separationStr:(NSString *)separationStr;  /**< 返回字符串格式化处理 */

- (NSString *)matchString:(NSString *)matchString replace:(NSString *)replaceString;  /**< 替换字符串，递归处理 */

- (NSString *)replaceCharStrings:(NSString *)charStrings withString:(NSString *)aString reverse:(BOOL)isReverse;  /**< 使用字符串替换字符集中的每项 */

- (NSString *)regroupStringFromCharStrings:(NSString *)charStrings;  /**< 返回由当前字符集合按顺序组成的字符串，其余都替换成@"" */

- (NSString *)replaceStringArray:(NSArray <NSString *>*)strings withString:(NSString *)aString;  /**< 将数组中字符串都匹配替换 */

- (NSMutableAttributedString *)matchText:(nullable NSString *)matchText matchAtt:(nullable NSDictionary *)matchAtt otherAtt:(nullable NSDictionary *)otherAtt alignment:(NSTextAlignment)alignment spacing:(CGFloat)spacing;  /**< 富文本 */

- (NSMutableAttributedString *)matchTexts:(nullable NSArray <NSString *>*)matchTexts matchAtt:(nullable NSDictionary *)matchAtt otherAtt:(nullable NSDictionary *)otherAtt alignment:(NSTextAlignment)alignment spacing:(CGFloat)spacing;  /**< 富文本 */

#pragma mark - Judge
@property (nonatomic, readonly) BOOL isPureInteger;  /**< 是否是整形 */

@property (nonatomic, readonly) BOOL isPureFloat;  /**< 是否是浮点型 */

@property (nonatomic, readonly) BOOL isPureDouble;  /**< 是否是浮点型 */

@property (nonatomic, readonly) BOOL isPureNumber;  /**< 是否是全数字 */

@property (nonatomic, readonly) BOOL isPureAlpha;  /**< 是否是全字母 */

@property (nonatomic, readonly) BOOL isPureChinese;  /**< 是否是全中文 */

@property (nonatomic, readonly) BOOL isContainNumber;  /**< 是否包含数字 */

@property (nonatomic, readonly) BOOL isContainAlpha;  /**< 是否包含字母 */

@property (nonatomic, readonly) BOOL isContainChinese;  /**< 是否包含汉字 */

@property (nonatomic, readonly) BOOL isContainEmoji;  /**< 是否有emoji */

@property (nonatomic, readonly) BOOL isPhone;  /**< 是否是手机号 */

@property (nonatomic, readonly) BOOL isUrl;  /**< 是否是网址 */

@property (nonatomic, readonly) BOOL isPostalcode;  /**< 是否是邮政编码 */

@property (nonatomic, readonly) BOOL isEmail;  /**< 是否是邮箱 */

@property (nonatomic, readonly) BOOL isTaxNo;  /**< 是否是工商税号 */

@property (nonatomic, readonly) BOOL isIP;  /**< 是否是IP地址xxx.xxx.xxx.xxx */

@property (nonatomic, readonly) BOOL isCorrect;  /**< 是否是身份证号码 */

@property (nonatomic, readonly) BOOL isBankCard;  /**< 是否是银行卡号 */

@property (nonatomic, readonly) BOOL isNotBlank;  /**< 是否不是空白，nil，@""，@"  "，@"\n" will Returns NO */

- (BOOL)isCompositionFromCharactersInString:(NSString *)aString;  /**< 字符串是否由当前字符集组成，self为@""时返回YES */

- (BOOL)isContainAdmitSpecialCharacter;  /**< 是否包含承认的特殊字符 */

- (BOOL)isContainsCharacterSet:(NSCharacterSet *)set;  /**< 是否包含字符集 */

- (BOOL)isEqualIgnoreCase:(NSString *)str;  /**< 不区分大小写比对字符串相等 */

#pragma mark - Class
+ (NSString *)stringWithUUID;  /**< 生成唯一个的UUID */

+ (NSString *)emojiWithIntCode:(int)intCode;  /**< 将十六进制的编码转为emoji字符 */

+ (NSString *)emojiWithStringCode:(NSString *)stringCode;  /**< 将十六进制的编码转为emoji字符 */

+ (nullable NSString *)stringWithBase64EncodedString:(nullable NSString *)base64EncodedString;  /**< 解码base64字符串 */

#pragma mark - Expand
- (NSString *)stringByURLEncode;

- (NSString *)stringByURLDecode;

- (NSString *)stringByEscapingHTML;

@end


@interface NSAttributedString (ZC)

- (CGSize)sizeFitLabelForWidth:(CGFloat)width;  /**< 取Label自适应高度 */

@end

NS_ASSUME_NONNULL_END
