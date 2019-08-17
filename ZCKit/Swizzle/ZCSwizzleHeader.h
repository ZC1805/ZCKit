//
//  ZCSwizzleHeader.h
//  ZCKit
//
//  Created by admin on 2019/1/8.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#ifndef ZCSwizzleHeader_h
#define ZCSwizzleHeader_h

#import <objc/runtime.h>

static inline void zc_swizzle_exchange_selector(Class clazz, SEL originalSelector, SEL swizzledSelector) {  /**< 替换实例方法 */
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector);
    BOOL success = class_addMethod(clazz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#endif /* ZCSwizzleHeader_h */
