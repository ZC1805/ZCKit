//
//  UINavigationItem+ZCSwizzle.m
//  ZCKit
//
//  Created by admin on 2019/1/9.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import "UINavigationItem+ZCSwizzle.h"
#import "ZCSwizzleHeader.h"

@implementation UINavigationItem (ZCSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zc_swizzle_exchange_selector([UINavigationItem class], @selector(setTitle:), @selector(swizzle_setTitle:));
        zc_swizzle_exchange_selector([UINavigationItem class], @selector(title), @selector(swizzle_title));
    });
}

- (void)swizzle_setTitle:(NSString *)title {
    UILabel *titleLabel = (UILabel *)self.titleView;
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:18.0];
        titleLabel.textColor = [UIColor blackColor];
        self.titleView = titleLabel;
    }
    if ([titleLabel isKindOfClass:[UILabel class]]) {
        titleLabel.text = title;
    }
    [titleLabel sizeToFit];
    [titleLabel.superview setNeedsLayout];
}

- (NSString *)swizzle_title {
    if (self.swizzle_title.length) {
        return self.swizzle_title;
    }
    UILabel *titleLabel = (UILabel *)self.titleView;
    if ([titleLabel isKindOfClass:[UILabel class]]) {
        return titleLabel.text;
    }
    return nil;
}

@end
