//
//  VCIdManager.m
//  ZCTest
//
//  Created by zjy on 2021/7/29.
//

#import "VCIdManager.h"

@implementation VCIdManager

+ (instancetype)share {
    static dispatch_once_t onceToken;
    static VCIdManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[VCIdManager alloc] init];
        instance.vcs = [NSMutableArray array];
    });
    return instance;
}

@end
