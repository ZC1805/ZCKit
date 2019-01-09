//
//  UINavigationController+ZCSwizzle.m
//  ZCKit
//
//  Created by admin on 2019/1/9.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import "UINavigationController+ZCSwizzle.h"
#import "ZCSwizzleHeader.h"
#import "ZCKitBridge.h"

@implementation UINavigationController (ZCSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zc_swizzle_exchange_selector([UINavigationController class], @selector(viewDidLoad),
                                 @selector(swizzle_navi_viewDidLoad));
        zc_swizzle_exchange_selector([UINavigationController class], @selector(viewWillAppear:),
                                 @selector(swizzle_navi_viewWillAppear:));
        zc_swizzle_exchange_selector([UINavigationController class], @selector(supportedInterfaceOrientations),
                                 @selector(swizzle_navi_supportedInterfaceOrientations));
    });
}

- (void)swizzle_navi_viewDidLoad {
    [self swizzle_navi_viewDidLoad];
    UIImage *image = [[UIImage imageNamed:ZCKitBridge.naviBackImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.backIndicatorImage = image;
    self.navigationBar.backIndicatorTransitionMaskImage = image;
}

- (void)swizzle_navi_viewWillAppear:(BOOL)animated {
    [self swizzle_navi_viewWillAppear:animated];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationBar.topItem.backBarButtonItem = item;
}

- (UIInterfaceOrientationMask)swizzle_navi_supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

#pragma mark - Set & Get
- (void)setIsNormalBar:(BOOL)isNormalBar {
    objc_setAssociatedObject(self, @selector(isNormalBar), [NSNumber numberWithBool:isNormalBar], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isNormalBar {
    NSNumber *value = objc_getAssociatedObject(self, _cmd);
    if (value && [value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    } else {
        return NO;
    }
}

@end
