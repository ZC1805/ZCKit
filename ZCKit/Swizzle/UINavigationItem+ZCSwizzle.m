//
//  UINavigationItem+ZCSwizzle.m
//  ZCKit
//
//  Created by admin on 2019/1/9.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import "UINavigationItem+ZCSwizzle.h"
#import "ZCViewController.h"
#import "ZCSwizzleHeader.h"
#import "ZCKitBridge.h"
#import "ZCMacro.h"
#import "ZCLabel.h"

@implementation UINavigationItem (ZCSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL sel1 = @selector(setTitle:);
        SEL sel1x = @selector(swizzle1_item_setTitle:);
        SEL sel2 = @selector(title);
        SEL sel2x = @selector(swizzle1_item_title);
        zc_swizzle_exchange_instance_selector(UINavigationItem.class, sel1, sel1x);
        zc_swizzle_exchange_instance_selector(UINavigationItem.class, sel2, sel2x);
    });
}

- (void)swizzle1_item_setTitle:(NSString *)title {
    UIViewController *vc = [ZCGlobal currentController];
    if ([vc isKindOfClass:NSClassFromString(@"ZCViewController")] && vc.navigationItem == self) {
        ZCLabel *titleLabel = (ZCLabel *)self.titleView;
        if (!titleLabel) {
            titleLabel = [[ZCLabel alloc] initWithFrame:CGRectZero];
            titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
            self.titleView = titleLabel;
        }
        if ([titleLabel isKindOfClass:ZCLabel.class]) {
            ZCViewControllerCustomPageSet *customPageSet = [vc valueForKey:@"customPageSet"];
            titleLabel.text = title;
            UIColor *titleColor = kZCS(ZCKitBridge.naviBarTitleColor);
            if (customPageSet.naviUseCustomTitleColor.length) { titleColor = kZCS(customPageSet.naviUseCustomTitleColor); }
            titleLabel.textColor = titleColor;
        }
        [titleLabel sizeToFit];
        [titleLabel.superview setNeedsLayout];
    } else {
        [self swizzle1_item_setTitle:title];
    }
}

- (NSString *)swizzle1_item_title {
    UIViewController *vc = [ZCGlobal currentController];
    if ([vc isKindOfClass:NSClassFromString(@"ZCViewController")] && vc.navigationItem == self) {
        ZCLabel *titleLabel = (ZCLabel *)self.titleView;
        if ([titleLabel isKindOfClass:ZCLabel.class]) {
            return titleLabel.text;
        } else {
            return [self swizzle1_item_title];
        }
    } else {
        return [self swizzle1_item_title];
    }
}

@end
