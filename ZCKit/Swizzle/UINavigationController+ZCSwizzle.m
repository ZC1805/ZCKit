//
//  UINavigationController+ZCSwizzle.m
//  ZCKit
//
//  Created by admin on 2019/1/9.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import "UINavigationController+ZCSwizzle.h"
#import "UINavigationController+ZC.h"
#import "ZCSwizzleHeader.h"
#import "ZCKitBridge.h"
#import "ZCMacro.h"

@implementation UINavigationController (ZCSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL sel1 = @selector(viewDidLoad);
        SEL sel1x = @selector(swizzle1_navi_viewDidLoad);
        SEL sel2 = @selector(viewWillAppear:);
        SEL sel2x = @selector(swizzle1_navi_viewWillAppear:);
        zc_swizzle_exchange_instance_selector(UINavigationController.class, sel1, sel1x);
        zc_swizzle_exchange_instance_selector(UINavigationController.class, sel2, sel2x);
    });
}

- (void)swizzle1_navi_viewDidLoad {
    UIImage *image = [ZCKitBridge.naviBackImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.view.backgroundColor = kZCWhite;
    self.navigationBar.backIndicatorImage = image;
    self.navigationBar.backIndicatorTransitionMaskImage = image;
    [self swizzle1_navi_viewDidLoad];
}

- (void)swizzle1_navi_viewWillAppear:(BOOL)animated {
    if (self.backArrowImage) {
        UIImage *image = [self.backArrowImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationBar.backIndicatorImage = image;
        self.navigationBar.backIndicatorTransitionMaskImage = image;
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationBar.topItem.backBarButtonItem = item;
    if (self.isShowRootControllerBackArrow && self.viewControllers.count) {
        UIViewController *rootVc = self.viewControllers.firstObject;
        if (!rootVc.navigationItem.leftBarButtonItem) {
            [rootVc.navigationItem itemCustomBackTitle:nil color:nil image:self.navigationBar.backIndicatorImage];
        }
    }
    [self swizzle1_navi_viewWillAppear:animated];
}

#pragma mark - Set & Get
- (void)setIsNormalBar:(BOOL)isNormalBar {
    objc_setAssociatedObject(self, @selector(isNormalBar), [NSNumber numberWithBool:isNormalBar], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isNormalBar {
    NSNumber *value = objc_getAssociatedObject(self, _cmd);
    if (value && [value isKindOfClass:NSNumber.class]) {
        return [value boolValue];
    } else {
        return NO;
    }
}

@end
