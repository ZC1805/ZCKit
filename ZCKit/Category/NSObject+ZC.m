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

#pragma mark - kvc
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSAssert(0, @"kvc set value for key fail -> key: %@", key);
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSAssert(0, @"kvc get value for key fail -> key: %@", key);
    return nil;
}

#pragma mark - swizzle
+ (BOOL)swizzleInstanceMethod:(SEL)originSel with:(SEL)newSel {
    Method originMethod = class_getInstanceMethod(self, originSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originMethod || !newMethod) {NSAssert(0, @"find method is fail"); return NO;}
    if (class_addMethod(self, originSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(self, newSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, newMethod);
    }
    return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)originSel with:(SEL)newSel {
    Class class = object_getClass(self);
    Method originMethod = class_getInstanceMethod(class, originSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originMethod || !newMethod) {NSAssert(0, @"find method is fail"); return NO;}
    method_exchangeImplementations(originMethod, newMethod);
    return YES;
}




//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//NSString *docPath = [paths objectAtIndex:0];
//
//作者：devRen
//链接：https://www.jianshu.com/p/a8251c8c0298
//來源：简书
//简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。

#pragma mark - misc
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

#pragma mark - class test
+ (NSArray *)allProperiesName {
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

+ (NSArray *)allIvarsName {
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

- (NSDictionary *)allIvarsKeysValus {
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








