//
//  JFNetworkModel.m
//  ZCKit
//
//  Created by zjy on 2018/4/28.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFNetworkModel.h"

@implementation JFNetworkModel

- (instancetype)initWithJsonDic:(nullable NSDictionary *)jsonDic {
    if (self = [super init]) {
        _refreshStep = 0;
        if (!ZCDicIsValid(jsonDic))  {
            jsonDic = [NSDictionary dictionary];
        }
        if ([self respondsToSelector:@selector(propertyAssignmentFromJsonDic:)]) {
            [self propertyAssignmentFromJsonDic:jsonDic];
        }
        if ([self respondsToSelector:@selector(propertyAssignmentFinish)]) {
            [self propertyAssignmentFinish];
        }
    }
    return self;
}

- (instancetype)initWithJsonArr:(nullable NSArray *)jsonArr {
    if (self = [super init]) {
        _refreshStep = 0;
        if (!ZCArrIsValid(jsonArr))  {
            jsonArr = [NSArray array];
        }
        if ([self respondsToSelector:@selector(propertyAssignmentFromJsonArr:)]) {
            [self propertyAssignmentFromJsonArr:jsonArr];
        }
        if ([self respondsToSelector:@selector(propertyAssignmentFinish)]) {
            [self propertyAssignmentFinish];
        }
    }
    return self;
}

@end
