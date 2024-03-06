//
//  NSObject+ZCSwizzle.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "NSObject+ZCSwizzle.h"
#import "ZCSwizzleHeader.h"
#import "ZCKitBridge.h"

#pragma mark - ~ ZCMethodForwardObject ~
@interface ZCMethodForwardObject : NSObject

@end

@implementation ZCMethodForwardObject

- (id)forwardAllCustomInstanceMethod {
    return nil;
}

+ (id)forwardAllCustomClassMethod {
    return nil;
}

+ (BOOL)isHasAppointPrefix:(NSString *)className {
    static NSArray *kClassNamePrefixs = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *items = [ZCKitBridge.classNamePrefix componentsSeparatedByString:@","];
        if (!items.count) items = @[];
        kClassNamePrefixs = items;
    });
    BOOL isAppointClass = NO;
    for (NSString *subPrefix in kClassNamePrefixs) {
        if (className.length && subPrefix.length && [className hasPrefix:subPrefix]) {
            isAppointClass = YES; break;
        }
    }
    return isAppointClass;
}

@end


#pragma mark - ~ NSObject ~
@implementation NSObject (ZCSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL sel1 = @selector(methodSignatureForSelector:);
        SEL sel1x = @selector(swizzle1_methodSignatureForSelector:);
        SEL sel2 = @selector(forwardInvocation:);
        SEL sel2x = @selector(swizzle1_forwardInvocation:);
        zc_swizzle_exchange_instance_selector(NSObject.class, sel1, sel1x);
        zc_swizzle_exchange_instance_selector(NSObject.class, sel2, sel2x);
        zc_swizzle_exchange_class_selector(NSObject.class, sel1, sel1x);
        zc_swizzle_exchange_class_selector(NSObject.class, sel2, sel2x);
    });
}

- (NSMethodSignature *)swizzle1_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSign = [self swizzle1_methodSignatureForSelector:aSelector];
    if (methodSign == nil && [ZCMethodForwardObject isHasAppointPrefix:NSStringFromClass(self.class)]) {
        methodSign = [NSMethodSignature signatureWithObjCTypes:"@@:"];
        NSAssert(0, @"ZCKit: method forward undefined sel -> sel: %@", NSStringFromSelector(aSelector));
    }
    return methodSign;
}

- (void)swizzle1_forwardInvocation:(NSInvocation *)anInvocation {
    BOOL isCanForward = NO;
    if ([anInvocation.target isKindOfClass:NSObject.class] && ![anInvocation.target respondsToSelector:anInvocation.selector]) {
        if ([ZCMethodForwardObject isHasAppointPrefix:NSStringFromClass([((NSObject *)anInvocation.target) class])]) {
            ZCMethodForwardObject *forwardObject = [[ZCMethodForwardObject alloc] init];
            anInvocation.selector = @selector(forwardAllCustomInstanceMethod);
            anInvocation.target = forwardObject;
            [anInvocation invoke];
            isCanForward = YES;
        }
    }
    if (!isCanForward) {
        [self swizzle1_forwardInvocation:anInvocation];
    }
}

+ (NSMethodSignature *)swizzle1_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSign = [self swizzle1_methodSignatureForSelector:aSelector];
    if (methodSign == nil && [ZCMethodForwardObject isHasAppointPrefix:NSStringFromClass(self)]) {
        methodSign = [NSMethodSignature signatureWithObjCTypes:"@@:"];
        NSAssert(0, @"ZCKit: method forward undefined sel -> sel: %@", NSStringFromSelector(aSelector));
    }
    return methodSign;
}

+ (void)swizzle1_forwardInvocation:(NSInvocation *)anInvocation {
    BOOL isCanForward = NO;
    if ([anInvocation.target isSubclassOfClass:NSObject.class] && ![anInvocation.target respondsToSelector:anInvocation.selector]) {
        if ([ZCMethodForwardObject isHasAppointPrefix:NSStringFromClass((Class)anInvocation.target)]) {
            Class forwardClass = [ZCMethodForwardObject class];
            anInvocation.selector = @selector(forwardAllCustomClassMethod);
            anInvocation.target = forwardClass;
            [anInvocation invoke];
            isCanForward = YES;
        }
    }
    if (!isCanForward) {
        [self swizzle1_forwardInvocation:anInvocation];
    }
}

@end
