//
//  ZCModel.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCModel.h"
#import "NSArray+ZC.h"
#import "NSDictionary+ZC.h"

@implementation ZCModel

- (void)willPropertyAssignment:(NSDictionary *)jsonDic {
    
}

- (instancetype)initWithJsonDic:(nullable NSDictionary *)jsonDic {
    if (self = [super init]) {
        if (!jsonDic || ![jsonDic isKindOfClass:NSDictionary.class])  {
            jsonDic = [NSDictionary dictionary];
        }
        [self willPropertyAssignment:jsonDic];
        if ([self respondsToSelector:@selector(propertyAssignmentFromJsonDic:)]) {
            [self propertyAssignmentFromJsonDic:jsonDic];
        }
        if ([self respondsToSelector:@selector(propertyAssignmentFinish)]) {
            [self propertyAssignmentFinish];
        }
    }
    return self;
}

+ (NSArray *)instancesWithJsonDicArr:(nullable NSArray *)jsonDicArr {
    if (!jsonDicArr || ![jsonDicArr isKindOfClass:NSArray.class]) {
        jsonDicArr = [NSArray array];
    }
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:jsonDicArr.count];
    for (int i = 0; i < jsonDicArr.count; i ++) {
        [items addObject:[[self alloc] initWithJsonDic:[jsonDicArr dictionaryValueForIndex:i]]];
    }
    return items.copy;
}

@end
