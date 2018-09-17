//
//  NSObject+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/6.
//  Copyright © 2018年 Squat in house. All rights reserved.
//

#import "NSObject+ZC.h"
#import <objc/runtime.h>

@implementation NSObject (ZC)

#pragma mark - KVC
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSAssert(0, @"kvc set value for key fail -> key: %@", key);
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSAssert(0, @"kvc get value for key fail -> key: %@", key);
    return nil;
}

#pragma mark - Misc
- (id)voidProperty {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setVoidProperty:(id)voidProperty {
    objc_setAssociatedObject(self, @selector(voidProperty), voidProperty, OBJC_ASSOCIATION_ASSIGN);
}

- (id)performSelector:(SEL)selector arguments:(NSArray *)arguments {   /**< 执行顺序有问题，不立即返回 */
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:selector];
    if (methodSignature == nil) {
        @throw [NSException exceptionWithName:@"exception" reason:@"function name is mistake" userInfo:nil];
        return nil;
    } else {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        NSInteger argumentCount = methodSignature.numberOfArguments - 2;
        NSInteger resultParamCount = MIN(argumentCount, arguments.count);
        for (NSInteger i = 0; i < resultParamCount; i++) {
            id obj = arguments[i];
            if ([obj isKindOfClass:[NSNull class]]) continue;
            [invocation setArgument:&obj atIndex:(i + 2)];
        }
        [invocation invoke];
        id returnValue = nil;
        if (methodSignature.methodReturnLength) [invocation getReturnValue:&returnValue];
        return returnValue;
    }
}

#pragma mark - ClassTest
+ (NSArray *)allProperies {
    unsigned int count;
    objc_property_t *proprties = class_copyPropertyList(self, &count);
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(proprties[i])];
        [list addObject:name];
    }
    free(proprties);
    return list;
}

+ (NSArray *)allIvars {
    unsigned int icount = 0;
    Ivar *ivars = class_copyIvarList(self, &icount);
    NSMutableArray *list= [NSMutableArray array];
    for (int i = 0; i < icount; i++) {
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
        [list addObject:name];
    }
    free(ivars);
    return list;
}

+ (NSArray *)allSubclasses {
    unsigned int numOfClasses;
    Class myClass = [self class];
    NSMutableArray *mySubclasses = [NSMutableArray array];
    Class *classes = objc_copyClassList(&numOfClasses);
    for (unsigned int ci = 0; ci < numOfClasses; ci++) {
        Class superClass = classes[ci];
        do {superClass = class_getSuperclass(superClass);}
        while (superClass && superClass != myClass);
        if (superClass) [mySubclasses addObject: classes[ci]];
    }
    free(classes);
    return mySubclasses;
}

- (NSDictionary *)allKeysValus {
    unsigned int icount = 0;
    NSMutableDictionary *dictionaryFormat = [NSMutableDictionary dictionary];
    Ivar *ivars = class_copyIvarList(self.class, &icount);
    for (const Ivar *p = ivars; p < ivars + icount; ++p) {
        Ivar const ivar = *p;
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        id value = [self valueForKey:key];
        if (!value) value = @"nil";
        [dictionaryFormat setObject:value forKey:key];
    }
    free(ivars);
    return dictionaryFormat;
}

@end








