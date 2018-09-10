//
//  NSData+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/6.
//  Copyright © 2018年 Squat in house. All rights reserved.
//

#import "NSData+ZC.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (ZC)

- (NSString *)md5String {
    const char *cstr = [self bytes];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)[self length], result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0],  result[1],  result[2],  result[3],
            result[4],  result[5],  result[6],  result[7],
            result[8],  result[9],  result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

@end
