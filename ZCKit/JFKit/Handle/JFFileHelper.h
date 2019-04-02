//
//  JFFileHelper.h
//  gobe
//
//  Created by zjy on 2019/3/20.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFFileHelper : NSObject

+ (NSString *)appDocumentPath;  //主目录

+ (NSString *)appTempPath;  //l临时目录

+ (NSString *)userDirectory;  //用户目录

+ (NSString *)genFilenameWithExt:(NSString *)ext;  //返回文件名

+ (NSString *)filepathForVideo:(NSString *)filename;

+ (NSString *)filepathForImage:(NSString *)filename;

@end
