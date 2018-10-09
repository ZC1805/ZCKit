//
//  ZCMiscManager.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCMiscManager.h"

@implementation ZCMiscManager

+ (instancetype)instance {
    static ZCMiscManager *instacne = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instacne = [[ZCMiscManager alloc] init];
    });
    return instacne;
}

+ (long long)calculateFileSizeAtPath:(NSString *)path {
    if (!path) return 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}

+ (long long)calculateFolderSizeAtPath:(NSString *)path {
    if (!path) return 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    long long folderSize = 0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
            if ([fileManager fileExistsAtPath:fileAbsolutePath]) {
                long long size = [fileManager attributesOfItemAtPath:fileAbsolutePath error:nil].fileSize;
                folderSize += size;
            }
        }
    }
    return folderSize;
}


@end










