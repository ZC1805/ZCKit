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
    UIImage *arrowImage = ZCKitBridge.naviBackImage;
    if (arrowImage) arrowImage = [arrowImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationBar.backIndicatorImage = arrowImage;
    self.navigationBar.backIndicatorTransitionMaskImage = arrowImage;
    [self swizzle1_navi_viewDidLoad];
}

- (void)swizzle1_navi_viewWillAppear:(BOOL)animated {
    self.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self swizzle1_navi_viewWillAppear:animated];
}

@end
