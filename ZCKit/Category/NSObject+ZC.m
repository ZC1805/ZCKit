//
//  NSObject+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/6.
//  Copyright © 2018年 Squat in house. All rights reserved.
//

#import "NSObject+ZC.h"

@implementation NSObject (ZC)

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSAssert(0, @"kvc set value for key fail -> key: %@", key);
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSAssert(0, @"kvc get value for key fail -> key: %@", key);
    return nil;
}

@end
