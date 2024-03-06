//
//  NSString+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "NSString+ZC.h"
#import "NSNumber+ZC.h"
#import "NSData+ZC.h"
#import "ZCMacro.h"

NSString * const ZCFlagStr = @"^.~!*.^";

#pragma mark - ~ NSString ~
@implementation NSString (ZC)

#pragma mark - Usually
- (NSData *)dataObject {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return data ? data : [NSData data];
}

- (const char *)charString {
    const char *s = [self cStringUsingEncoding:NSUTF8StringEncoding];
    return s == NULL ? "" : s;
}

- (NSString *)base64EncodedString {
    return [[self dataObject] base64EncodedString];
}

- (NSNumber *)numberObject {
    return [NSNumber numberWithString:self];
}

- (NSString *)md5String {
    return [[self dataObject] md5String];
}

- (NSString *)URLAllowString {
    NSString *urlStr = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return kZStrNonnil(urlStr);
}

- (id)jsonObject {
    return [[self dataObject] jsonObject];
}

- (NSDictionary *)jsonDictionaryObject {
    id object = [self jsonObject];
    if (object && [object isKindOfClass:NSDictionary.class]) {
        return object;
    }
    return [NSDictionary dictionary];
}

- (NSArray *)jsonArrayObject {
    id object = [self jsonObject];
    if (object && [object isKindOfClass:NSArray.class]) {
        return object;
    }
    return [NSArray array];
}

- (CGFloat)widthForFont:(UIFont *)font isSystemStyle:(BOOL)isSystemStyle {
    CGSize size = [self sizeForFont:font size:CGSizeMake(MAXFLOAT, MAXFLOAT) mode:NSLineBreakByWordWrapping isCalculateLineSpacing:!isSystemStyle];
    return ceilf(size.width);
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width isSystemStyle:(BOOL)isSystemStyle {
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, MAXFLOAT) mode:NSLineBreakByWordWrapping isCalculateLineSpacing:!isSystemStyle];
    return ceilf(size.height);
}

- (CGSize)sizeFitLabelForFont:(UIFont *)font width:(CGFloat)width alignment:(NSTextAlignment)alignment spacing:(CGFloat)spacing {
    if (!self.length || width < 0.01) return CGSizeZero;
    static NSMutableParagraphStyle *kStyle = nil;
    static UILabel *kCalSpacLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kCalSpacLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        kCalSpacLabel.adjustsFontSizeToFitWidth = NO;
        kCalSpacLabel.numberOfLines = 0;
        kStyle = [[NSMutableParagraphStyle alloc] init];
        kStyle.lineBreakMode = NSLineBreakByWordWrapping;
    });
    kStyle.alignment = alignment;
    kStyle.lineSpacing = MAX(spacing, 0);
    UIFont *kFont = font ? font : [UIFont fontWithName:@"HelveticaNeue" size:12];
    NSDictionary *attri = @{NSFontAttributeName:kFont, NSParagraphStyleAttributeName:kStyle.copy};
    kCalSpacLabel.frame = CGRectMake(0, 0, width, MAXFLOAT);
    kCalSpacLabel.attributedText = [[NSAttributedString alloc] initWithString:self.copy attributes:attri];
    [kCalSpacLabel sizeToFit];
    return CGSizeMake(ceilf(kCalSpacLabel.frame.size.width), ceilf(kCalSpacLabel.frame.size.height));
}

- (NSArray <NSString *>*)charStrings {
    NSMutableArray *charStrs = [NSMutableArray array];
    for (NSInteger i = 0; i < self.length; i++) {
        NSString *charStr = [self substringWithRange:NSMakeRange(i, 1)];
        [charStrs addObject:charStr];
    }
    return charStrs.copy;
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

- (NSString *)saveCacheString {
    NSString *md5s = self.copy;
    NSMutableString * s = [[NSMutableString alloc] init];
    for (int i = 0; i < md5s.length; i++) {
        unichar x = [md5s characterAtIndex:i];
        NSInteger y = (NSInteger)x;
        y = y ^ (1080*(i%2 ? -i-320 : i+320) + i);
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"%ld",ABS(y)];
        NSString *c4 = [str substringWithRange:NSMakeRange(4, 1)];
        NSString *c5 = [str substringWithRange:NSMakeRange(5, 1)];
        [str replaceCharactersInRange:NSMakeRange(0, 1) withString:c4];
        [str replaceCharactersInRange:NSMakeRange(4, 1) withString:c5];
        NSString *tar = [str substringToIndex:5];
        [s appendString:tar];
    }
    return s;
}

- (NSString *)obtainCacheString {
    NSString *pass = self.copy;
    NSMutableString * s = [[NSMutableString alloc] init];
    NSInteger length = pass.length / 5;
    for (int i = 0; i < length; i++) {
        NSMutableString *str = [[pass substringWithRange:NSMakeRange(i*5, 5)] mutableCopy];
        NSString *c1 = [str substringWithRange:NSMakeRange(0, 1)];
        [str insertString:c1 atIndex:4];
        [str replaceCharactersInRange:NSMakeRange(0, 1) withString:@"3"];
        NSInteger x = i%2 ? -[str integerValue] : [str integerValue];
        NSInteger y = x ^ (1080*(i%2 ? -i-320 : i+320) + i);
        [s appendFormat:@"%c",(unichar)y];
    }
    return s;
}

- (NSString *)preciseString {
    if ([self isPureDouble]) {
        double doubleValue = [self doubleValue];
        NSString *doubleString = [NSString stringWithFormat:@"%lf", doubleValue];
        NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
        return [decNumber stringValue];
    }
    return self;
}

- (NSString *)formatterPrice {
    if ([self isPureDouble]) {
        double doubleValue = [self doubleValue];
        NSString *doubleString = [NSString stringWithFormat:@"%.2lf", doubleValue];
        return doubleString;
    }
    return self;
}

- (NSString *)stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSString *)stringByRemoveSpaceAndReturn {
    NSString *str = self.copy;
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str;
}

- (NSString *)stringByFormatSpace:(BOOL)ignoreLastSpace {
    NSString *str = self.copy;
    NSString *lastSpace = nil;
    if (ignoreLastSpace && self.length > 1 && [str hasSuffix:@" "]) { //是否可以空格结尾且不能空格开头
        lastSpace = [str substringFromIndex:str.length - 1];
        str = [str substringToIndex:str.length - 1];
    }
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *comps = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    comps = [comps filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    NSString *final = [comps componentsJoinedByString:@" "];
    if (lastSpace) final = [final stringByAppendingString:lastSpace];
    return final;
}

- (NSString *)stringByDiacritics {
    if (!self.length) return self;
    NSMutableString *note = [self mutableCopy];
    if (CFStringTransform((__bridge CFMutableStringRef)note, NULL, kCFStringTransformStripDiacritics, NO)) {
        return note.copy;
    }
    return self;
}

- (NSString *)arabiaDgitalToChinese {
    if (![self isPureInteger]) return @"";
    NSString *str = self;
    NSArray *arabic_numerals = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"];
    NSArray *chinese_numerals = @[@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"零"];
    NSArray *digits = @[@"个", @"十", @"百", @"千", @"万", @"十", @"百", @"千", @"亿", @"十", @"百", @"千", @"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length - i - 1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]]) {
            if ([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]]) {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]]) {
                    [sums removeLastObject];
                }
            } else {
                sum = chinese_numerals[9];
            }
            if ([[sums lastObject] isEqualToString:sum]) {
                continue;
            }
        }
        [sums addObject:sum];
    }
    NSString *sumStr = [sums componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length - 1];
    return chinese;
}

- (NSString *)deletePictureResolution { //删除图片尾缀@2x、@3x
    NSString *doubleResolution = @"@2x";
    NSString *tribleResolution = @"@3x";
    NSString *fileName = self.stringByDeletingPathExtension;
    NSString *res = self.copy;
    if ([fileName hasSuffix:doubleResolution] || [fileName hasSuffix:tribleResolution]) {
        res = [fileName substringToIndex:fileName.length - 3];
        if (self.pathExtension.length) {
            res = [res stringByAppendingPathExtension:self.pathExtension];
        }
    }
    return res;
}

- (NSString *)prefixForFlag:(NSString *)flag {
    if (self.length && flag.length) {
        if ([self hasPrefix:flag]) return @"";
        NSRange range = [self rangeOfString:flag];
        if (range.length && range.location != NSNotFound) {
            return [self substringToIndex:range.location];
        }
    }
    return @"";
}

- (NSString *)suffixForFlag:(NSString *)flag {
    if (self.length && flag.length) {
        if ([self hasSuffix:flag]) return @"";
        NSRange range = [self rangeOfString:flag];
        if (range.length && range.location != NSNotFound) {
            return [self substringFromIndex:(range.location + range.length)];
        }
    }
    return @"";
}

- (NSString *)subStringValueForRange:(NSRange)range {
    if (range.length > 0 && range.location >= 0 && self.length > 0) {
        if (range.location + range.length <= self.length && range.location <= INT32_MAX && range.length <= INT32_MAX) {
            return [self substringWithRange:range];
        } else if (range.location < self.length) {
            return [self substringWithRange:NSMakeRange(range.location, self.length - range.location)];
        }
    } return @"";
}

- (NSString *)formatLast:(long)charCount separationCount:(long)separationCount separationStr:(NSString *)separationStr {
    if (charCount <= 0 || separationCount <= 0 || charCount <= separationCount || self.length <= separationCount) return self;
    NSString *subStr = self.copy;
    if (self.length > charCount) {
        subStr = [self substringFromIndex:(self.length - charCount)];
    }
    NSMutableString *newStr = [NSMutableString string];
    for (int i = 0; i < subStr.length; i ++) {
        if (i * separationCount >= subStr.length) {
            break;
        } else if (i * separationCount + separationCount >= subStr.length) {
            [newStr appendString:[subStr substringFromIndex:(i * separationCount)]];
        } else {
            [newStr appendString:[subStr substringWithRange:NSMakeRange(i * separationCount, separationCount)]];
            if (kZStrNonnil(separationStr).length) [newStr appendString:separationStr];
        }
    } return newStr.copy;
}

- (NSString *)matchString:(NSString *)matchString replace:(NSString *)replaceString {
    if (self.length) {
        if (!matchString.length) return self;
        NSRange range = [self rangeOfString:matchString];
        if (range.length && range.location != NSNotFound) {
            if (!replaceString) replaceString = @"";
            NSString *text = [self stringByReplacingCharactersInRange:range withString:replaceString];
            return [text matchString:matchString replace:replaceString];
        } else {
            return self;
        } 
    } else {
        if (!matchString.length) {
            return replaceString ? replaceString : @"";
        } else {
            return self;
        }
    }
}

- (NSString *)replaceCharStrings:(NSString *)charStrings withString:(NSString *)aString reverse:(BOOL)isReverse {
    if (!charStrings.length) return self;
    if (!aString) aString = @"";
    NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:charStrings];
    if (isReverse) cSet = [cSet invertedSet];
    return kZStrNonnil([[self componentsSeparatedByCharactersInSet:cSet] componentsJoinedByString:aString]);
}

- (NSString *)regroupStringFromCharStrings:(NSString *)charStrings {
    if (!self.length || !charStrings.length) return self;
    NSCharacterSet *cSet = [[NSCharacterSet characterSetWithCharactersInString:charStrings] invertedSet];
    return kZStrNonnil([[self componentsSeparatedByCharactersInSet:cSet] componentsJoinedByString:@""]);
}

- (NSString *)replaceStringArray:(NSArray <NSString *>*)strings withString:(NSString *)aString {
    if (!strings.count) return self;
    if (!aString) aString = @"";
    NSString *str = self.copy;
    for (NSString *iStr in strings) {
        if (iStr.length && str.length) { str = [str stringByReplacingOccurrencesOfString:iStr withString:aString]; }
    }
    return kZStrNonnil(str);
}

- (NSMutableAttributedString *)matchText:(NSString *)matchText matchAtt:(NSDictionary *)matchAtt otherAtt:(NSDictionary *)otherAtt alignment:(NSTextAlignment)alignment spacing:(CGFloat)spacing {
    if (!self.length) return [[NSMutableAttributedString alloc] initWithString:self attributes:otherAtt];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange rang = [self rangeOfString:kZStrNonnil(matchText)];
    if (attStr.length) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        if (spacing != 0) style.lineSpacing = spacing;
        style.alignment = alignment;
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attStr.length)];
    }
    if (matchText.length && rang.location != NSNotFound && rang.length != 0) {
        NSRange rang1 = NSMakeRange(0, rang.location);
        NSRange rang2 = NSMakeRange(rang.location + rang.length, attStr.length - rang.location - rang.length);
        if (rang1.length != 0 && otherAtt.count) {
            [attStr addAttributes:otherAtt range:rang1];
        }
        if (rang2.length != 0 && otherAtt.count) {
            [attStr addAttributes:otherAtt range:rang2];
        }
        if (rang.length != 0 && matchAtt.count) {
            [attStr addAttributes:matchAtt range:rang];
        }
    } else {
        if (attStr.length && otherAtt.count) {
            [attStr addAttributes:otherAtt range:NSMakeRange(0, attStr.length)];
        }
    }
    return attStr;
}

- (NSMutableAttributedString *)matchTexts:(NSArray <NSString *>*)matchTexts matchAtt:(NSDictionary *)matchAtt otherAtt:(NSDictionary *)otherAtt alignment:(NSTextAlignment)alignment spacing:(CGFloat)spacing {
    if (!self.length) return [[NSMutableAttributedString alloc] initWithString:self attributes:kZDicNonnil(otherAtt)];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    [pStyle setLineSpacing:spacing];
    [pStyle setAlignment:alignment];
    [attStr addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, attStr.length)];
    [attStr addAttributes:kZDicNonnil(otherAtt) range:NSMakeRange(0, attStr.length)];
    for (NSString *matchText in kZArrNonnil(matchTexts)) {
        if (kZStrNonnil(matchText).length) {
            NSRange rang = [self rangeOfString:matchText options:NSCaseInsensitiveSearch];
            if (matchText.length && rang.location != NSNotFound && rang.length != 0 && matchAtt.count) {
                [attStr addAttributes:matchAtt range:rang];
            }
        }
    }
    return attStr;
}

#pragma mark - Judge
- (BOOL)isPureInteger { //是否是整形 (.1和1.都不属于，空字符串不属于，01属于)
    NSScanner *scan = [NSScanner scannerWithString:self];
    NSInteger val;
    return [scan scanInteger:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat { //是否是浮点型 (0.2f不属于，.1和1.都属于，整形也属于)
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

- (BOOL)isPureDouble { //是否是浮点型
    NSScanner *scan = [NSScanner scannerWithString:self];
    double val;
    return [scan scanDouble:&val] && [scan isAtEnd];
}

- (BOOL)isPureNumber { //是否是全数字
    NSString *regex = @"^[0-9]+$";
    return [self matchRegex:regex];
}

- (BOOL)isPureAlpha { //是否是全字母
    NSString *regex = @"^[a-zA-Z]+$";
    return [self matchRegex:regex];
}

- (BOOL)isPureChinese { //是否是全中文
    NSString *regex = @"^[\u4e00-\u9fa5]+$";
    return [self matchRegex:regex];
}

- (BOOL)isContainNumber { //是否包含数字
    NSRegularExpressionOptions options = NSRegularExpressionCaseInsensitive;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:options error:nil];
    if (!regular) return NO;
    return ([regular numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)] > 0);
}

- (BOOL)isContainAlpha { //是否包含字母
    NSRegularExpressionOptions options = NSRegularExpressionCaseInsensitive;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:options error:nil];
    if (!regular) return NO;
    return ([regular numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)] > 0);
}

- (BOOL)isContainChinese { //是否包含汉字
    NSRegularExpressionOptions options = NSRegularExpressionCaseInsensitive;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[\u4e00-\u9fa5]" options:options error:nil];
    if (!regular) return NO;
    return ([regular numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)] > 0);
}

- (BOOL)isContainEmoji { //是否有emoji
    __block BOOL isEomji = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) isEomji = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 ||
                       hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a) {
                isEomji = YES;
            }
            if (!isEomji && substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) isEomji = YES;
            }
        }
    }];
    return isEomji;
}

- (BOOL)isPhone { //是否是手机号
    NSString *regex = @"^1+[3578]+\\d{9}";
    return [self matchRegex:regex];
}

- (BOOL)isUrl { //是否是网址
    NSString *regex = @"^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
    return [self matchRegex:regex];
}

- (BOOL)isPostalcode { //是否是邮政编码
    NSString *regex = @"^[0-8]\\d{5}(?!\\d)$";
    return [self matchRegex:regex];
}

- (BOOL)isEmail { //是否是邮箱
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self matchRegex:regex];
}

- (BOOL)isTaxNo { //是否是工商税号
    NSString *regex = @"[0-9]\\d{13}([0-9]|X)$";
    return [self matchRegex:regex];
}

- (BOOL)isIP { //是否是IP地址，xxx.xxx.xxx.xxx
    NSString *regex = [NSString stringWithFormat:@"^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"];
    if ([self matchRegex:regex]) {
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

- (BOOL)isCorrect { //是否是身份证号码
    if (![self isPureNumber] || self.length != 18) return NO;
    NSString *regex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    if (![self matchRegex:regex]) return NO;
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
    if ([str isEqualToString:@"10"]) { //不区分大小写
        return ([string isEqualToString:@"X"] || [string isEqualToString:@"x"]);
    }
    return [str isEqualToString:string];
}

- (BOOL)isBankCard { //是否是银行卡号
    if (self.length == 0) return NO;
    NSString *digitsOnly = @""; char c;
    for (int i = 0; i < self.length; i++) {
        c = [self characterAtIndex:i];
        if (isdigit(c)) {
            digitsOnly = [digitsOnly stringByAppendingFormat:@"%c", c];
        }
    }
    BOOL timesTwo = false;
    int sum = 0; int digit = 0; int addend = 0;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--) {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo) {
            addend = digit * 2;
            if (addend > 9) { addend -= 9; }
        } else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

- (BOOL)isNotBlank { //是否不是空白，nil，@""，@"  "，@"\n" will Returns NO
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isCompositionFromCharactersInString:(NSString *)aString {
    if (!self.length) return YES;
    if (!aString || !aString.length) return NO;
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:aString] invertedSet];
    NSString *csstr = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [self isEqualToString:csstr];
}

- (BOOL)isContainAdmitSpecialCharacter { //是否包含承认的特殊字符
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

- (BOOL)isContainsCharacterSet:(NSCharacterSet *)set { //是否包含字符集
    if (!set) return NO;
    return [self rangeOfCharacterFromSet:set].location != NSNotFound;
}

- (BOOL)isEqualIgnoreCase:(NSString *)str { //不区分大小写比对字符串相等
    if (!str) return NO;
    return ([self compare:str options:NSCaseInsensitiveSearch] == NSOrderedSame);
}

- (BOOL)isPasswordAllowAdmitSpecialCharacter:(BOOL)specialChar mustAllContain:(BOOL)allContain allowSimple:(BOOL)allowSimple
                                   shieldStr:(NSString *)shieldStr min:(int)min max:(int)max {
    //1.是否可保护特殊字符 2.是否必须保护字符、字母、数字 3.是否做字符串太简单的判断 4.需要屏蔽的字符串(如账号) 5.最小长度 6.最大长度
    if (self.length < min || self.length > max) return NO; //是否是规范的密码
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
        if (!allowSimple && [admitStr isEasyPasswordShield:shieldStr]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

#pragma mark - Class
+ (NSString *)stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

+ (NSString *)emojiWithIntCode:(int)intCode {
    int symbol = ((((0x808080F0 | (intCode & 0x3F000) >> 4) | (intCode & 0xFC0) << 10) | (intCode & 0x1C0000) << 18) | (intCode & 0x3F) << 24);
    NSString *string = [[NSString alloc] initWithBytes:&symbol length:sizeof(symbol) encoding:NSUTF8StringEncoding];
    if (!string) string = [NSString stringWithFormat:@"%C", (unichar)intCode];
    return string;
}

+ (NSString *)emojiWithStringCode:(NSString *)stringCode {
    char *charCode = (char *)stringCode.UTF8String;
    int intCode = (int)strtol(charCode, NULL, 16);
    return [self emojiWithIntCode:intCode];
}

+ (NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString {
    NSData *data = [NSData dataWithBase64EncodedString:base64EncodedString];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - Private
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode isCalculateLineSpacing:(BOOL)isCalculateLineSpacing {
    if (!font) font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    [attr setObject:font forKey:NSFontAttributeName];
    if (lineBreakMode != NSLineBreakByWordWrapping) {
        NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
        pStyle.lineBreakMode = lineBreakMode;
        [attr setObject:pStyle forKey:NSParagraphStyleAttributeName];
    }
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    if (isCalculateLineSpacing) options = options | NSStringDrawingUsesFontLeading;
    CGRect rect = [self boundingRectWithSize:size options:options attributes:attr context:nil];
    return rect.size;
}

- (BOOL)matchRegex:(NSString *)regex {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isEasyPasswordShield:(NSString *)shield { //规则:不含汉字，连续数或递增数不超过6位
    if (self.length < 6) return YES;
    if ([self isContainChinese]) return YES;
    if (shield && [self containsString:shield]) return YES;
    if (shield && [shield containsString:self]) return YES;
    if ([self stringByTrim].length != self.length) return YES;
    int same = 0, incr = 0, incrMax = 0, decr = 0, decrMax = 0;
    NSMutableString *chars = [NSMutableString string];
    unichar last1C = [self characterAtIndex:0];
    unichar last2C = [self characterAtIndex:0];
    for (int i = 0; i < self.length; i++) {
        unichar iC = [self characterAtIndex:i];
        NSString *ics = [NSString stringWithFormat:@"%c", iC];
        if ([chars containsString:ics]) { same ++; }
        else { [chars appendString:ics]; }
        if (iC == last1C + 1) incr ++;
        else { incrMax = MAX(incrMax, incr); incr = 0; }
        if (iC == last2C - 1) decr ++;
        else { decrMax = MAX(decrMax, decr); decr = 0; }
        incrMax = MAX(incrMax, incr);
        decrMax = MAX(decrMax, decr);
        last1C = iC;
        last2C = iC;
    }
    if (chars.length < 4) return YES;
    if (same > self.length - 5) return YES;
    if (incrMax > self.length - 4) return YES;
    if (decrMax > self.length - 4) return YES;
    if (incrMax + same > self.length - 2) return YES;
    if (decrMax + same > self.length - 2) return YES;
    return NO;
}

#pragma mark - Expand
- (NSString *)stringByURLEncode {
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@";
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    NSMutableCharacterSet *allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    static NSUInteger const batchSize = 50;
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    while (index < self.length) {
        NSUInteger length = MIN(self.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);
        range = [self rangeOfComposedCharacterSequencesForRange:range];
        NSString *substring = [self substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        index += range.length;
    }
    return escaped;
}

- (NSString *)stringByURLDecode {
    return [self stringByRemovingPercentEncoding];
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

@end


#pragma mark - ~ NSAttributedString ~
@implementation NSAttributedString (ZC)

- (CGSize)sizeFitLabelForWidth:(CGFloat)width {
    if (!self.length || width < 0.01) return CGSizeZero;
    static UILabel *kCalAttLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kCalAttLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        kCalAttLabel.adjustsFontSizeToFitWidth = NO;
        kCalAttLabel.numberOfLines = 0;
    });
    kCalAttLabel.frame = CGRectMake(0, 0, width, MAXFLOAT);
    kCalAttLabel.attributedText = self.copy;
    [kCalAttLabel sizeToFit];
    return CGSizeMake(ceilf(kCalAttLabel.frame.size.width), ceilf(kCalAttLabel.frame.size.height));
}

@end
