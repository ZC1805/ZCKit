//
//  ZCKeychain.m
//  ZCKit
//
//  Created by admin on 2018/2/29.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCKeychain.h"
#import "ZCKitBridge.h"

@implementation ZCKeychain

+ (NSMutableDictionary *)keyChainItemDictionaryWithService:(NSString *)service {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    if (service.length) {
        [dic setObject:service forKey:(__bridge id)kSecAttrService];
        [dic setObject:service forKey:(__bridge id)kSecAttrAccount];
    }
    return dic;
}

+ (BOOL)addData:(id)data service:(NSString *)service {
    NSMutableDictionary *query = [self keyChainItemDictionaryWithService:service];
    SecItemDelete((CFDictionaryRef)query);
    [query setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    OSStatus status = SecItemAdd((CFDictionaryRef)query, NULL);
    return status == noErr;
}

+ (BOOL)updateData:(id)data service:(NSString *)service {
    NSMutableDictionary *search = [self keyChainItemDictionaryWithService:service];
    NSMutableDictionary *update = [NSMutableDictionary dictionary];
    [update setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    OSStatus status = SecItemUpdate((CFDictionaryRef)search, (CFDictionaryRef)update);
    return status == errSecSuccess;
}

+ (BOOL)deleteDataWithService:(NSString *)service {
    NSMutableDictionary *delete = [self keyChainItemDictionaryWithService:service];
    OSStatus status = SecItemDelete((CFDictionaryRef)delete);
    return status == noErr;
}

+ (id)queryDataWithService:(NSString *)service {
    NSMutableDictionary *query = [self keyChainItemDictionaryWithService:service];
    [query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [query setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    id result; CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&keyData) == noErr) {
        @try {
            result = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *exception) {
            if (ZCKitBridge.isPrintLog) NSLog(@"ZCKit: key chain no existent data");
        }
        @finally {
            
        }
    }
    if (keyData) {
        CFRelease(keyData);
    }
    return result;
}

@end
