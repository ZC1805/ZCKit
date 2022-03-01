//
//  UINavigationItem+ZCSwizzle.m
//  ZCKit
//
//  Created by admin on 2019/1/9.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import "UINavigationItem+ZCSwizzle.h"
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
    ZCLabel *titleLabel = (ZCLabel *)self.titleView;
    if (!titleLabel) {
        titleLabel = [[ZCLabel alloc] initWithFrame:CGRectZero];
        titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
        titleLabel.textColor = kZCS(ZCKitBridge.naviBarTitleColor);
        self.titleView = titleLabel;
    }
    if ([titleLabel isKindOfClass:ZCLabel.class]) {
        titleLabel.text = title;
    }
    [titleLabel sizeToFit];
    [titleLabel.superview setNeedsLayout];
}

- (NSString *)swizzle1_item_title {
    NSString *title = [self swizzle1_item_title];
    if (title.length) return title;
    ZCLabel *titleLabel = (ZCLabel *)self.titleView;
    if ([titleLabel isKindOfClass:ZCLabel.class]) {
        return titleLabel.text;
    }
    return nil;
}

@end
