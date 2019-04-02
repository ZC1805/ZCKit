//
//  JFFileHelper.m
//  gobe
//
//  Created by zjy on 2019/3/20.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFFileHelper.h"

#define RDVideo  (@"video")
#define RDImage  (@"image")

@implementation JFFileHelper

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    assert([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:&error];
    NSAssert(success, @"excluding %@ from backup %@", [URL lastPathComponent], error);
    return success;
}

+ (NSString *)appTempPath {
    return NSTemporaryDirectory();
}

+ (NSString *)appDocumentPath {
    static NSString *appDocumentPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        appDocumentPath = [[NSString alloc] initWithFormat:@"%@/%@/", [paths objectAtIndex:0], [JFOfficer sharedOfficer].appkeyPath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:appDocumentPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:appDocumentPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
        [JFFileHelper addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:appDocumentPath]];
    });
    return appDocumentPath;
}

+ (NSString *)userDirectory {
    NSString *uid = [JFOfficer sharedOfficer].accountId;
    NSAssert(uid.length, @"current user accid is nil");
    NSString *documentPath = [JFFileHelper appDocumentPath];
    NSString *userDirectory= [NSString stringWithFormat:@"%@%@/", documentPath, uid];
    if (![[NSFileManager defaultManager] fileExistsAtPath:userDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:userDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return userDirectory;
}

+ (NSString *)filepathForVideo:(NSString *)filename {
    return [JFFileHelper filepathForDir:RDVideo filename:filename];
}

+ (NSString *)filepathForImage:(NSString *)filename {
    return [JFFileHelper filepathForDir:RDImage filename:filename];
}

+ (NSString *)genFilenameWithExt:(NSString *)ext {
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuid);
    CFRelease(uuid);
    NSString *uuidStr = [[uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    NSString *name = [NSString stringWithFormat:@"%@", uuidStr];
    return [ext length] ? [NSString stringWithFormat:@"%@.%@", name, ext] : name;
}

#pragma mark - 辅助方法
+ (NSString *)filepathForDir:(NSString *)dirname filename:(NSString *)filename {
    return [[JFFileHelper resourceDir:dirname] stringByAppendingPathComponent:filename];
}

+ (NSString *)resourceDir:(NSString *)resouceName {
    NSString *dir = [[JFFileHelper userDirectory] stringByAppendingPathComponent:resouceName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return dir;
}

@end
