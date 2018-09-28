//
//  NSDictionary+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/28.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "NSDictionary+ZC.h"
#import "NSArray+ZC.h"
#import "NSData+ZC.h"

#pragma mark - NSDictionary
@implementation NSDictionary (ZC)

- (id)randomValue {
    return [self.allValues randomObject];
}

- (NSArray *)allKeysSorted {
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSArray *)allValuesSortedByKeys {
    NSArray *sortedKeys = [self allKeysSorted];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (id key in sortedKeys) {
        [arr addObject:self[key]];
    }
    return [arr copy];
}

- (NSDictionary *)dictionaryForKeys:(NSArray *)keys {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if (!keys || !keys.count) return [dic copy];
    for (id key in keys) {
        id value = self[key];
        if (value) dic[key] = value;
    }
    return [dic copy];
}

- (BOOL)containsObjectForKey:(id)key {
    if (!key) return NO;
    return self[key] != nil;
}

- (BOOL)containsObjectForValue:(id)value {
    if (!value) return NO;
    return [self.allValues containsObject:value];
}

- (NSString *)jsonString {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error && jsonStr) return jsonStr;
    }
    return nil;
}

- (NSData *)plistData {
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

- (NSString *)plistString {
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) return xmlData.utf8String;
    return nil;
}

+ (NSDictionary *)dictionaryWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([dictionary isKindOfClass:[NSDictionary class]]) return dictionary;
    return nil;
}

+ (NSDictionary *)dictionaryWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self dictionaryWithPlistData:data];
}

@end



#pragma mark - NSMutableDictionary
@implementation NSMutableDictionary (ZC)


@end












