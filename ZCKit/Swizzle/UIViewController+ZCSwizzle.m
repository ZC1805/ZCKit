//
//  UIViewController+ZCSwizzle.m
//  ZCKit
//
//  Created by admin on 2018/10/22.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIViewController+ZCSwizzle.h"
#import "ZCSwizzleHeader.h"
#import "ZCKitBridge.h"
#import "UIView+ZC.h"

@implementation UIViewController (ZCSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL sel1 = @selector(initWithNibName:bundle:);
        SEL sel1x = @selector(swizzle1_vc_initWithNibName:bundle:);
        SEL sel2 = @selector(viewDidLoad);
        SEL sel2x = @selector(swizzle1_vc_viewDidLoad);
        SEL sel3 = @selector(viewWillAppear:);
        SEL sel3x = @selector(swizzle1_vc_viewWillAppear:);
        SEL sel4 = @selector(viewDidLayoutSubviews);
        SEL sel4x = @selector(swizzle1_vc_viewDidLayoutSubviews);
        SEL sel5 = @selector(viewWillDisappear:);
        SEL sel5x = @selector(swizzle1_vc_viewWillDisappear:);
        zc_swizzle_exchange_instance_selector(UIViewController.class, sel1, sel1x);
        zc_swizzle_exchange_instance_selector(UIViewController.class, sel2, sel2x);
        zc_swizzle_exchange_instance_selector(UIViewController.class, sel3, sel3x);
        zc_swizzle_exchange_instance_selector(UIViewController.class, sel4, sel4x);
        zc_swizzle_exchange_instance_selector(UIViewController.class, sel5, sel5x);
    });
}

- (instancetype)swizzle1_vc_initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    id instance = [self swizzle1_vc_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (instance) self.hidesBottomBarWhenPushed = YES; //如果希望值为NO的话，需要在init之后设置hidesBottomBarWhenPushed为NO;
    if (instance) self.modalPresentationStyle = UIModalPresentationFullScreen; //不显示层叠样式
    return instance;
}

- (void)swizzle1_vc_viewDidLoad {
    if (self.navigationController && self.parentViewController == self.navigationController) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    [self swizzle1_vc_viewDidLoad];
}

- (void)swizzle1_vc_viewWillAppear:(BOOL)animated {
    if (ZCKitBridge.isPrintLog) {
        if ([self isKindOfClass:UIViewController.class] && ![self isKindOfClass:UINavigationController.class]) {
            if (ZCKitBridge.isPrintLog) NSLog(@"\nZCKit: --------- %@ --------- appear\n", NSStringFromClass(self.class));
        }
    }
    [self swizzle1_vc_viewWillAppear:animated];
    for (UIView *view in self.view.containAllSubviews) {
        if ([view respondsToSelector:@selector(onControllerViewWillAppear)]) {
            [(id<ZCViewSyncLayoutProtocol>)view onControllerViewWillAppear];
        }
    }
}

- (void)swizzle1_vc_viewWillDisappear:(BOOL)animated {
    [self swizzle1_vc_viewWillDisappear:animated];
    for (UIView *view in self.view.containAllSubviews) {
        if ([view respondsToSelector:@selector(onControllerViewWillDisappear)]) {
            [(id<ZCViewSyncLayoutProtocol>)view onControllerViewWillDisappear];
        }
    }
}

- (void)swizzle1_vc_viewDidLayoutSubviews {
    [self swizzle1_vc_viewDidLayoutSubviews];
    for (UIView *view in self.view.containAllSubviews) {
        if ([view respondsToSelector:@selector(onControllerDidLayout)]) {
            [(id<ZCViewSyncLayoutProtocol>)view onControllerDidLayout];
        }
    }
}

@end
