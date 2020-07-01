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

@implementation UINavigationItem (ZCSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL sel1 = @selector(setTitle:);
        SEL sel1x = @selector(swizzle_setTitle:);
        SEL sel2 = @selector(title);
        SEL sel2x = @selector(swizzle_title);
        zc_swizzle_exchange_selector([UINavigationItem class], sel1, sel1x);
        zc_swizzle_exchange_selector([UINavigationItem class], sel2, sel2x);
    });
}

- (void)swizzle_setTitle:(NSString *)title {
    UILabel *titleLabel = (UILabel *)self.titleView;
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = ZCFMS(16);
        titleLabel.textColor = [UIColor colorFromHexString:ZCKitBridge.naviBarTitleColor];
        self.titleView = titleLabel;
    }
    if ([titleLabel isKindOfClass:[UILabel class]]) {
        titleLabel.text = title;
    }
    [titleLabel sizeToFit];
    [titleLabel.superview setNeedsLayout];
}

- (NSString *)swizzle_title {
    NSString *title = [self swizzle_title];
    if (title.length) return title;
    UILabel *titleLabel = (UILabel *)self.titleView;
    if ([titleLabel isKindOfClass:[UILabel class]]) {
        return titleLabel.text;
    }
    return nil;
}

@end
