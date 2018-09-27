//
//  NSString+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018年 Squat in house. All rights reserved.
//

#import "NSString+ZC.h"
#import "NSData+ZC.h"
#import "NSNumber+ZC.h"

@implementation NSString (ZC)

#pragma mark - usually
- (NSString *)md5String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5String];
}

- (NSString *)base64EncodedString {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
}

- (NSString *)stringByTrim {  //去除空格换行符
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (CGFloat)widthForFont:(UIFont *)font {
    CGSize size = [self sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

- (NSNumber *)numberObject {
    return [NSNumber numberWithString:self];
}

- (NSData *)dataObject {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (id)jsonObject {
    return [[self dataObject] jsonObject];
}

- (NSUInteger)charCount {
    NSUInteger strlength = 0;
    char *p = (char *)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++; strlength++;
        } else {
            p++;
        }
    }
    return strlength;
}

- (NSUInteger)bytesCount {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self lengthOfBytesUsingEncoding:enc];
}

- (NSString *)preciseString {
    if ([self isPureFloat]) {
        double doubleValue = [self doubleValue];
        NSString *doubleString = [NSString stringWithFormat:@"%lf", doubleValue];
        NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
        return [decNumber stringValue];
    }
    return self;
}

- (NSString *)formatterPrice {
    if ([self isPureFloat]) {
        double doubleValue = [self doubleValue];
        NSString *doubleString = [NSString stringWithFormat:@"%.2lf", doubleValue];
        return doubleString;
    }
    return self;
}

- (NSString *)deletePictureResolution {  //删除图片尾缀@2x、@3x
    NSString *doubleResolution = @"@2x";
    NSString *tribleResolution = @"@3x";
    NSString *fileName = self.stringByDeletingPathExtension;
    NSString *res = [self copy];
    if ([fileName hasSuffix:doubleResolution] || [fileName hasSuffix:tribleResolution]) {
        res = [fileName substringToIndex:fileName.length - 3];
        if (self.pathExtension.length) {
            res = [res stringByAppendingPathExtension:self.pathExtension];
        }
    }
    return res;
}

#pragma mark - judge
- (BOOL)isPureInteger {  //是否是整形
    NSScanner *scan = [NSScanner scannerWithString:self];
    NSInteger val;
    return [scan scanInteger:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat {  //是否是浮点型 (0.2f不属于)
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

- (BOOL)isPureNumber {  //是否是全数字
    NSString *regex = @"^[0-9]+$";
    return [self matchRegex:regex];
}

- (BOOL)isPureAlpha {  //是否是全字母
    NSString *regex = @"^[a-zA-Z]+$";
    return [self matchRegex:regex];
}

- (BOOL)isPureChinese {  //是否是全中文
    NSString *regex = @"^[\u4e00-\u9fa5]+$";
    return [self matchRegex:regex];
}

- (BOOL)isContainNumber {  //是否包含数字
    NSRegularExpressionOptions options = NSRegularExpressionCaseInsensitive;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:options error:nil];
    if (!regular) return NO;
    return ([regular numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)] > 0);
}

- (BOOL)isContainAlpha {  //是否包含字母
    NSRegularExpressionOptions options = NSRegularExpressionCaseInsensitive;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:options error:nil];
    if (!regular) return NO;
    return ([regular numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)] > 0);
}

- (BOOL)isContainChinese {  //是否包含字母
    NSRegularExpressionOptions options = NSRegularExpressionCaseInsensitive;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[\u4e00-\u9fa5]" options:options error:nil];
    if (!regular) return NO;
    return ([regular numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)] > 0);
}

- (BOOL)isPhone {  //是否是手机号
    NSString *regex = @"^1+[3578]+\\d{9}";
    return [self matchRegex:regex];
}

- (BOOL)isUrl {  //是否是网址
    NSString *regex = @"^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
    return [self matchRegex:regex];
}

- (BOOL)isPostalcode {  //是否是邮政编码
    NSString *regex = @"^[0-8]\\d{5}(?!\\d)$";
    return [self matchRegex:regex];
}

- (BOOL)isEmail {  //是否是邮箱
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self matchRegex:regex];
}

- (BOOL)isTaxNo {  //是否是工商税号
    NSString *regex = @"[0-9]\\d{13}([0-9]|X)$";
    return [self matchRegex:regex];
}

- (BOOL)isIP {  //是否是IP地址，xxx.xxx.xxx.xxx
    NSString *regex = [NSString stringWithFormat:@"^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL rc = [pred evaluateWithObject:self];
    if (rc) {
        NSArray *componds = [self componentsSeparatedByString:@","];
        BOOL v = YES;
        for (NSString *s in componds) {
            if (s.integerValue > 255) {
                v = NO; break;
            }
        }
        return v;
    }
    return NO;
}

- (BOOL)isCorrect {  //是否是身份证号码
    if (![self isPureNumber] || self.length != 18) return NO;
    NSString *regex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:self]) return NO;
    NSMutableArray *Ids = [NSMutableArray array];
    for (int i = 0; i < 18; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        [Ids addObject:subString];
    }
    NSArray *carr = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    NSArray *rarr = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    int sum = 0;
    for (int i= 0; i < 17; i++) {
        int coe = [carr[i] intValue];
        int Id = [Ids[i] intValue];
        sum += coe * Id;
    }
    NSString *str = rarr[(sum % 11)];
    NSString *string = [self substringFromIndex:17];
    if ([str isEqualToString:@"10"]) {  //不区分大小写
        return ([string isEqualToString:@"X"] || [string isEqualToString:@"x"]);
    }
    return [str isEqualToString:string];
}

- (BOOL)isBankCard:(NSString *)cardNumber {  //是否是银行卡号
    if (cardNumber.length == 0) return NO;
    NSString *digitsOnly = @""; char c;
    for (int i = 0; i < cardNumber.length; i++) {
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c)) {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c", c];
        }
    }
    BOOL timesTwo = false;
    int sum = 0; int digit = 0; int addend = 0;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--) {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo) {
            addend = digit * 2;
            if (addend >9) {addend -= 9;}
        } else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

- (BOOL)isUserName {  //是否是用户姓名，20位的中文或英文
    NSString *regex = @"^[a-zA-Z\u4E00-\u9FA5]{1,20}";
    return [self matchRegex:regex];
}

- (BOOL)isContainAdmitSpecialCharacter {  //是否包含承认的特殊字符
    if (self.length == 0) return NO;
    NSString *regex = @"`-=~!@#$%^&*()_+[]\\;',./{}|:\"<>?";
    NSInteger allIndex = 0;
    for (int i = 0; i < self.length; i++) {
        NSString *subStr = [self substringWithRange:NSMakeRange(i, 1)];
        if ([regex rangeOfString:subStr].location != NSNotFound) {
            allIndex ++;
        }
    }
    return (allIndex > 0);
}

- (BOOL)isPasswordAllowAdmitSpecialCharacter:(BOOL)specialChar mustAllContain:(BOOL)allContain allowSimple:(BOOL)allowSimple min:(int)min max:(int)max {
    if (self.length < min || self.length > max) return NO;  //是否是规范的密码
    NSString *admitStr = self;
    if (specialChar) {
        NSString *regex = @"`-=~!@#$%^&*()_+[]\\;',./{}|:\"<>?";
        NSCharacterSet *filter = [NSCharacterSet characterSetWithCharactersInString:regex];
        admitStr = [[self componentsSeparatedByCharactersInSet:filter] componentsJoinedByString:@""];
    }
    if (allContain && admitStr.length == self.length) return NO;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-zA-Z0-9]+$"];
    if ([pred evaluateWithObject:admitStr]) {
        if (allContain && (![admitStr isContainNumber] || ![admitStr isContainAlpha])) {
            return NO;
        }
        if (!allowSimple && [admitStr isEasyPasswordShield:nil]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (BOOL)isNotBlank {  //是否不是空白，nil，@""，@"  "，@"\n" will Returns NO
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containsCharacterSet:(NSCharacterSet *)set {  //是否包含字符集
    if (!set) return NO;
    return [self rangeOfCharacterFromSet:set].location != NSNotFound;
}

- (BOOL)isEqualIgnoreCase:(NSString *)str {  //不区分大小写比对字符串相等
    if (!str) return NO;
    return ([self compare:str options:NSCaseInsensitiveSearch] == NSOrderedSame);
}


#pragma mark - class
+ (NSString *)stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

+ (NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString {
    NSData *data = [NSData dataWithBase64EncodedString:base64EncodedString];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - private
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGRect rect = [self boundingRectWithSize:size options:options attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (BOOL)matchRegex:(NSString *)regex {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isEasyPasswordShield:(NSString *)shield {  //规则:不含汉字，连续数或递增数不超过6位
    if (self.length < 6) return YES;
    if ([self isContainChinese]) return YES;
    if (shield && [self containsString:shield]) return YES;
    if ([self stringByTrim].length != self.length) return YES;
    int same = 0, incr = 0, decr = 0;
    NSMutableString *chars = [NSMutableString string];
    unichar lastC = [self characterAtIndex:0];
    for (int i = 0; i < self.length; i++) {
        unichar iC = [self characterAtIndex:i];
        NSString *ics = [NSString stringWithFormat:@"%c", iC];
        if (![chars containsString:ics]) [chars appendString:ics];
        if (iC == lastC) same ++;
        if (decr == 0 && iC == lastC + 1) incr ++;
        if (incr == 0 && iC == lastC - 1) decr ++;
        lastC = iC;
    }
    if (same > 5) return YES;  //此处错误和下面都错误
    if (incr > 4 || decr > 4) return YES;
    if (chars.length < 4) return YES;
    return NO;
}



#pragma mark - expand
- (NSString *)stringByURLEncode {
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@";
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(__bridge CFStringRef)self,NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)stringByURLDecode {
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)decoded,CFSTR(""),en);
        return decoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)stringByEscapingHTML {
    NSUInteger len = self.length;
    if (!len) return self;
    unichar *buf = malloc(sizeof(unichar) * len);
    if (!buf) return self;
    [self getCharacters:buf range:NSMakeRange(0, len)];
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < len; i++) {
        unichar c = buf[i];
        NSString *esc = nil;
        switch (c) {
            case 34: esc = @"&quot;"; break;
            case 38: esc = @"&amp;"; break;
            case 39: esc = @"&apos;"; break;
            case 60: esc = @"&lt;"; break;
            case 62: esc = @"&gt;"; break;
            default: break;
        }
        if (esc) {
            [result appendString:esc];
        } else {
            CFStringAppendCharacters((CFMutableStringRef)result, &c, 1);
        }
    }
    free(buf);
    return result;
}

- (BOOL)matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options {
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:NULL];
    if (!pattern) return NO;
    return ([pattern numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0);
}

- (void)enumerateRegexMatches:(NSString *)regex
                      options:(NSRegularExpressionOptions)options
                   usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block {
    if (regex.length == 0 || !block) return;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!regex) return;
    [pattern enumerateMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length)
                           usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        block([self substringWithRange:result.range], result.range, stop);
    }];
}

- (NSString *)stringByReplacingRegex:(NSString *)regex
                             options:(NSRegularExpressionOptions)options
                          withString:(NSString *)replacement; {
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!pattern) return self;
    return [pattern stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:replacement];
}

































@end












