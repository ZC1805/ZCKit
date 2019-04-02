//
//  JFNetworkParameter.m
//  ZCKit
//
//  Created by zjy on 2018/5/4.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFNetworkParameter.h"
#import <objc/runtime.h>

@interface JFNetworkParameter ()

@property (nonatomic, strong) NSArray <NSString *>*var_names;

@property (nonatomic, strong) NSArray <NSString *>*var_idTypes;

@property (nonatomic, copy) NSString *var_floatType;

@property (nonatomic, copy) NSString *var_longType;

@end

@implementation JFNetworkParameter

- (instancetype)init {
    if (self = [super init]) {
        [self allValidPropertyTypes];
        [self allValidPropertyNames];
    }
    return self;
}

- (NSMutableDictionary *)injectPropertyToParameter {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    for (NSString *ikey in self.var_names) {
        id value = [self valueForKey:ikey];
        if (value == nil || value == NULL || [value isKindOfClass:[NSNull class]]) {
            continue;
        }
        if ([value isKindOfClass:[NSString class]]) {
            if ([ikey isEqualToString:@"Id"]) {
                [parameters setObject:value forKey:@"id"];
            } else {
                [parameters setObject:value forKey:ikey];
            }
        } else if ([value isKindOfClass:[NSNumber class]]) {
            if ([value longValue] == static_ignore_value || ZFEqual([value floatValue], static_ignore_value)) {
                continue;
            } else {
                [parameters setObject:value forKey:ikey];
            }
        } else if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray *arr = [NSMutableArray array];
            for (id item in (NSArray *)value) {
                if ([item isKindOfClass:[JFNetworkParameter class]]) {
                    [arr addObject:[(JFNetworkParameter *)item injectPropertyToParameter]];
                } else {
                    [arr addObject:item];
                }
            }
            [parameters setObject:arr forKey:ikey];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [(NSDictionary *)value enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[JFNetworkParameter class]]) {
                    [dic setObject:[(JFNetworkParameter *)obj injectPropertyToParameter] forKey:key];
                } else {
                    [dic setObject:obj forKey:key];
                }
            }];
            [parameters setObject:dic forKey:ikey];
        } else if ([value isKindOfClass:[JFNetworkParameter class]]) {
            [parameters setObject:[(JFNetworkParameter *)value injectPropertyToParameter] forKey:ikey];
        } else {
            NSAssert(0, @"parameter type is mistake");
        }
    }
    return parameters;
}

#pragma mark - Private
- (void)allValidPropertyNames {
    unsigned int propertyCount = 0;
    NSMutableArray *ipa_names = [NSMutableArray array];
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    for (int i = 0; i < propertyCount; i ++) {
        objc_property_t property = propertys[i];
        const char *propertyName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        if (name && name.length && ![name hasPrefix:@"var_"]) {
            NSString *ipa_type = [self obtainPropertyType:property];
            if ([ipa_type isEqualToString:self.var_longType]) {
                [self setValue:[NSNumber numberWithLong:static_ignore_value] forKey:name];
                [ipa_names addObject:name];
            } else if ([ipa_type isEqualToString:self.var_floatType]) {
                [self setValue:[NSNumber numberWithFloat:static_ignore_value] forKey:name];
                [ipa_names addObject:name];
            } else if ([self.var_idTypes containsObject:ipa_type]) {
                [ipa_names addObject:name];
            } else {
                NSAssert(0, @"parameter type is mistake");
            }
        }
    }
    free(propertys);
    self.var_names = [ipa_names copy];
}

- (void)allValidPropertyTypes {
    self.var_longType = [NSString stringWithCString:@encode(long) encoding:NSASCIIStringEncoding];
    self.var_floatType = [NSString stringWithCString:@encode(float) encoding:NSASCIIStringEncoding];
    self.var_idTypes = @[NSStringFromClass([JFNetworkParameter class]),
                         NSStringFromClass([NSArray class]), NSStringFromClass([NSMutableArray class]),
                         NSStringFromClass([NSString class]), NSStringFromClass([NSMutableString class]),
                         NSStringFromClass([NSDictionary class]), NSStringFromClass([NSMutableDictionary class])];
}

- (NSString *)obtainPropertyType:(objc_property_t)property {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    NSString *type = @"";
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (strlen(attribute) < 2) continue;
        if (attribute[0] == 'T') {
            if (attribute[1] != '@') {
                type = [[NSString alloc] initWithBytes:(attribute + 1) length:(strlen(attribute) - 1) encoding:NSASCIIStringEncoding];
            } else if (strlen(attribute) > 4) {
                type = [[NSString alloc] initWithBytes:(attribute + 3) length:(strlen(attribute) - 4) encoding:NSASCIIStringEncoding];
            }
            break;
        }
    }
    return type;
}

@end
