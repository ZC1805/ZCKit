//
//  NSString+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018年 Squat in house. All rights reserved.
//

#import "NSString+ZC.h"
#import <UIKit/UIKit.h>

@implementation NSString (ZC)

//- (CGSize)sizeWithFont:(UIFont *)font limitSize:(CGSize)limitSize {
//    NSDictionary *attribute = @{NSFontAttributeName:font};
//    NSStringDrawingOptions options = (NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin);
//    return [self boundingRectWithSize:limitSize options:options attributes:attribute context:nil].size;
//}
//
//
//
//- (CGSize)stringWidthWithHeight:(CGFloat)height font:(UIFont *)font{
//    NSDictionary *attribute = @{NSFontAttributeName : font};
//    CGSize size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attribute context:nil].size;
//    return size;
//}
//
//- (CGSize)stringHeightWithWidth:(CGFloat)width font:(UIFont *)font{
//    NSDictionary *attribute = @{NSFontAttributeName : font};
//    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin) attributes:attribute context:nil].size;
//    return size;
//}
//
//- (NSString *)toPrecise {
//    double doubleValue = [self doubleValue];
//    NSString *doubleString = [NSString stringWithFormat:@"%lf", doubleValue];
//    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
//    return [decNumber stringValue];
//}
//
//- (NSString *)formatterPrice {
//    double doubleValue = [self doubleValue];
//    NSString *doubleString = [NSString stringWithFormat:@"%.2lf", doubleValue];
//    return doubleString;
//}
//
//- (NSString *)toChangeDecimal{
//    NSUInteger maxDecimalLength = 2;
//    NSString *changeNumStr = ((self.length) ? (self) : (@"0"));
//    NSRange range = [changeNumStr rangeOfString:@"."];
//    if (range.location != NSNotFound) {
//        NSArray *tempArr = [self componentsSeparatedByString:@"."];
//        NSString *lastNumStr = ((NSString *)tempArr.lastObject);
//        if (lastNumStr.length > maxDecimalLength) {
//            changeNumStr = [changeNumStr substringWithRange:NSMakeRange(0, ((range.location+1) + (maxDecimalLength + 0)))];
//            NSString *lastElement = [lastNumStr substringWithRange:NSMakeRange(maxDecimalLength, 1)];
//            if (lastElement.integerValue >= 5) { //四舍五入
//                NSDecimalNumber *addDecNumber = [[NSDecimalNumber decimalNumberWithString:@"1"] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)pow(10, maxDecimalLength)]]];
//                NSDecimalNumber *decNumber = [[NSDecimalNumber decimalNumberWithString:changeNumStr] decimalNumberByAdding:addDecNumber];
//                return [decNumber stringValue];
//            }
//        }
//    }
//    return changeNumStr;
//}
//
//- (NSString *)removeFloatZero {
//    NSString *testNumber = self;
//    NSString *outNumber = [NSString stringWithFormat:@"%@", @(testNumber.floatValue)];
//    return outNumber;
//}
//
//- (BOOL)isPureInteger {
//    NSScanner *scan = [NSScanner scannerWithString:self];
//    NSInteger val;
//    return [scan scanInteger:&val] && [scan isAtEnd];
//}
//
//- (BOOL)isPureFloat {
//    NSScanner *scan = [NSScanner scannerWithString:self];
//    float val;
//    return [scan scanFloat:&val] && [scan isAtEnd];
//}
//
//
//
//- (id)jsonObject {
//    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
//    if (data) {
//        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        return object;
//    }
//    return nil;
//}
//
//- (CGSize)calculateTextSizeWithContainerViewWidth:(CGFloat)width font:(UIFont *)font {
//    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil].size;
//    return size;
//}
//
//- (CGSize)calculateTextSizeWithFont:(UIFont *)font {
//    return [self sizeWithAttributes:@{NSFontAttributeName : font}];
//}
//
//- (NSString *)md5String {
//    const char *cstr = [self UTF8String];
//    unsigned char result[16];
//    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
//    return [NSString stringWithFormat:
//            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//            result[0], result[1], result[2], result[3],
//            result[4], result[5], result[6], result[7],
//            result[8], result[9], result[10], result[11],
//            result[12], result[13], result[14], result[15]
//            ];
//}
//
//- (NSUInteger)getBytesLength {
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    return [self lengthOfBytesUsingEncoding:enc];
//}
//
//- (NSString *)stringByDeletingPictureResolution {
//    NSString *doubleResolution  = @"@2x";
//    NSString *tribleResolution = @"@3x";
//    NSString *fileName = self.stringByDeletingPathExtension;
//    NSString *res = [self copy];
//    if ([fileName hasSuffix:doubleResolution] || [fileName hasSuffix:tribleResolution]) {
//        res = [fileName substringToIndex:fileName.length - 3];
//        if (self.pathExtension.length) {
//            res = [res stringByAppendingPathExtension:self.pathExtension];
//        }
//    }
//    return res;
//}
//
//- (BOOL)isChinese {
//    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
//    return [predicate evaluateWithObject:self];
//}
//
//- (BOOL)isEqualIgnoreCase:(NSString *)str {
//    if (!str) return NO;
//    return ([self compare:str options:NSCaseInsensitiveSearch] == NSOrderedSame);
//}
//
////方法一
//- (int)calculateStringCharLength {
//    int strlength = 0;
//    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
//    for (int i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
//        if (*p) {
//            p++;
//            strlength++;
//        } else {
//            p++;
//        }
//    }
//    return strlength;
//}
//
////方法二
//- (NSUInteger)calculateStrCharLength {
//    NSUInteger asciiLength = 0;
//    for (NSUInteger i = 0; i < self.length; i++) {
//        unichar uc = [self characterAtIndex: i];
//        asciiLength += isascii(uc) ? 1 : 2;
//    }
//    return asciiLength;
//}
//
//@end
//
//
//#pragma mark - Category Number
//@implementation NSString (Number)
//
//- (BOOL)isPureInt {   //整形
//    if (!self.length) return NO;
//    NSScanner *scan = [NSScanner scannerWithString:self];
//    int val;
//    return [scan scanInt:&val] && [scan isAtEnd];
//}
//
//- (BOOL)isPureFloat {   //浮点型 (0.2f不属于)
//    if (!self.length) return NO;
//    NSScanner *scan = [NSScanner scannerWithString:self];
//    float val;
//    return[scan scanFloat:&val] && [scan isAtEnd];
//}
//
//- (BOOL)isPureNumber {    //全数字
//    NSString *regex = @"^[0-9]+$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    return [pred evaluateWithObject:self];
//}
//
//- (BOOL)isPureAlpha {    //全字母
//    NSString *regex = @"^[a-zA-Z]+$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    return [pred evaluateWithObject:self];
//}
//
//- (BOOL)isPureChinese {    //全中文
//    NSString *regex = @"^[\u4e00-\u9fa5]+$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    return [pred evaluateWithObject:self];
//}
//
////- (BOOL)isAdmitSpecialCharacter {
////    //NSString *regex = @"[~`!@#$%^&*()_+-=[]|{};':\",./<>?]{,}/";    //承认的特殊字符
////    NSString *regex = @"~!@#$%^&*()_+-=\"/[]{}<>?.|";    //承认的特殊字符
////    //计算字符串长度
////    NSInteger str_length = [string length];
////
////    NSInteger allIndex = 0;
////    for (int i = 0; i<str_length; i++) {
////        //取出i
////        NSString *subStr = [string substringWithRange:NSMakeRange(i, 1)];
////        if([regex rangeOfString:subStr].location != NSNotFound)
////        {  //存在
////            allIndex++;
////        }
////    }
////    if (str_length == allIndex) {
////        //纯特殊字符
////        return YES;
////    } else {
////        //非纯特殊字符
////        return NO;
////    }
////}
////
////+ (BOOL)password:(NSString *)password {
////    NSString *pattern = @"^[a-zA-Z0-9]{6,18}+$";
////    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
////    BOOL isMatch = [pred evaluateWithObject:password];
////    if (isMatch) {
////        int count = 0;
////        NSString *newPassword = [password substringToIndex:1];
////        for (int i = 0; i < password.length; i++) {
////            NSString *newPassword1;
////            if (i == 0) {
////                newPassword1 = [password substringToIndex:i + 1];
////            } else {
////                newPassword1 = [[password substringToIndex:i + 1] substringFromIndex:i];
////            }
////            if ([newPassword1 isEqualToString:newPassword]) {
////                count++;
////            }
////        }
////        if (count == password.length) return NO;
////        if ([password isEqualToString:@"123456"] ||
////            [password isEqualToString:@"qwerty"] ||
////            [password isEqualToString:@"654321"]) return NO;
////
////    }
////    return isMatch;
////}
////
////#pragma 正则匹配手机号
////+ (BOOL)checkTelNumber:(NSString *) telNumber
////{
////    NSString *pattern = @"^1+[3578]+\\d{9}";
////    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
////    BOOL isMatch = [pred evaluateWithObject:telNumber];
////    return isMatch;
////}
////
////
////#pragma 正则匹配用户密码6-18位数字和字母组合
////+ (BOOL)checkPassword:(NSString *) password
////{
////    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
////    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
////    BOOL isMatch = [pred evaluateWithObject:password];
////    return isMatch;
////
////}
////
////#pragma 正则匹配用户姓名,20位的中文或英文
////+ (BOOL)checkUserName : (NSString *) userName
////{
////    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5]{1,20}";
////    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
////    BOOL isMatch = [pred evaluateWithObject:userName];
////    return isMatch;
////
////}
////
////
////#pragma 正则匹配用户身份证号15或18位
////+ (BOOL)checkUserIdCard: (NSString *) idCard
////{
////    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
////    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
////    BOOL isMatch = [pred evaluateWithObject:idCard];
////    return isMatch;
////}
////
////#pragma 正则匹员工号,12位的数字
////+ (BOOL)checkEmployeeNumber : (NSString *) number
////{
////    NSString *pattern = @"^[0-9]{12}";
////
////    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
////    BOOL isMatch = [pred evaluateWithObject:number];
////    return isMatch;
////
////}
////
////#pragma 正则匹配URL
////+ (BOOL)checkURL : (NSString *) url
////{
////    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
////    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
////    BOOL isMatch = [pred evaluateWithObject:url];
////    return isMatch;
////}
////
//
//@end
//
//
//#pragma mark - Category Hash
//@implementation NSString (Hash)
//
//- (NSString *)md5String {
//    const char *string = self.UTF8String;
//    int length = (int)strlen(string);
//    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(string, length, bytes);
//    return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
//}
//
//- (NSString *)sha1String {
//    const char *string = self.UTF8String;
//    int length = (int)strlen(string);
//    unsigned char bytes[CC_SHA1_DIGEST_LENGTH];
//    CC_SHA1(string, length, bytes);
//    return [self stringFromBytes:bytes length:CC_SHA1_DIGEST_LENGTH];
//}
//
//- (NSString *)sha256String {
//    const char *string = self.UTF8String;
//    int length = (int)strlen(string);
//    unsigned char bytes[CC_SHA256_DIGEST_LENGTH];
//    CC_SHA256(string, length, bytes);
//    return [self stringFromBytes:bytes length:CC_SHA256_DIGEST_LENGTH];
//}
//
//- (NSString *)sha512String {
//    const char *string = self.UTF8String;
//    int length = (int)strlen(string);
//    unsigned char bytes[CC_SHA512_DIGEST_LENGTH];
//    CC_SHA512(string, length, bytes);
//    return [self stringFromBytes:bytes length:CC_SHA512_DIGEST_LENGTH];
//}
//
//- (NSString *)hmacSHA1StringWithKey:(NSString *)key {
//    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
//    NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
//    CCHmac(kCCHmacAlgSHA1, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
//    return [self stringFromBytes:(unsigned char *)mutableData.bytes length:mutableData.length];
//}
//
//- (NSString *)hmacSHA256StringWithKey:(NSString *)key {
//    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
//    NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
//    CCHmac(kCCHmacAlgSHA256, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
//    return [self stringFromBytes:(unsigned char *)mutableData.bytes length:mutableData.length];
//}
//
//- (NSString *)hmacSHA512StringWithKey:(NSString *)key {
//    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
//    NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
//    CCHmac(kCCHmacAlgSHA512, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
//    return [self stringFromBytes:(unsigned char *)mutableData.bytes length:mutableData.length];
//}
//
//- (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length {
//    NSMutableString *mutableString = @"".mutableCopy;
//    for (int i = 0; i < length; i++)
//        [mutableString appendFormat:@"%02x", bytes[i]];
//    return [NSString stringWithString:mutableString];
//}


//+ (NSData *)dataWithBase64EncodedString:(NSString *)base64EncodedString {
//    if (!base64EncodedString) return nil;
//    NSInteger length = base64EncodedString.length;
//    const char *string = [base64EncodedString cStringUsingEncoding:NSASCIIStringEncoding];
//    if (string == NULL) return nil;
//
//    while (length > 0 && string[length - 1] == '=') {
//        length--;
//    }
//
//    NSInteger outputLength = length * 3 / 4;
//    NSMutableData *data = [NSMutableData dataWithLength:outputLength];
//    if (data == nil) return nil;
//    if (length == 0) return data;
//
//    uint8_t *output = data.mutableBytes;
//    NSInteger inputPoint = 0;
//    NSInteger outputPoint = 0;
//    while (inputPoint < length) {
//        char i0 = string[inputPoint++];
//        char i1 = string[inputPoint++];
//        char i2 = inputPoint < length ? string[inputPoint++] : 'A';
//        char i3 = inputPoint < length ? string[inputPoint++] : 'A';
//
//        output[outputPoint++] = (base64DecodingTable[i0] << 2) | (base64DecodingTable[i1] >> 4);
//        if (outputPoint < outputLength) {
//            output[outputPoint++] = ((base64DecodingTable[i1] & 0xf) << 4) | (base64DecodingTable[i2] >> 2);
//        }
//        if (outputPoint < outputLength) {
//            output[outputPoint++] = ((base64DecodingTable[i2] & 0x3) << 6) | base64DecodingTable[i3];
//        }
//    }
//    return data;
//}





@end









