//
//  UIFont+ZC.m
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIFont+ZC.h"
#import <CoreText/CoreText.h>

@implementation UIFont (ZC)

- (BOOL)isBold {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return NO;
    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold) > 0;
}

- (BOOL)isItalic {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return NO;
    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitItalic) > 0;
}

- (BOOL)isMonoSpace {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return NO;
    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitMonoSpace) > 0;
}

- (BOOL)isColorGlyphs {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return NO;
    return (CTFontGetSymbolicTraits((__bridge CTFontRef)self) & kCTFontTraitColorGlyphs) != 0;
}

- (CGFloat)fontWeight {
    NSDictionary *traits = [self.fontDescriptor objectForKey:UIFontDescriptorTraitsAttribute];
    return [traits[UIFontWeightTrait] floatValue];
}

- (UIFont *)fontWithBold {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return self;
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:self.pointSize];
}

- (UIFont *)fontWithItalic {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return self;
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:self.pointSize];
}

- (UIFont *)fontWithBoldItalic {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return self;
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic] size:self.pointSize];
}

- (UIFont *)fontWithNormal {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return self;
    return [UIFont fontWithDescriptor:[self.fontDescriptor fontDescriptorWithSymbolicTraits:0] size:self.pointSize];
}

#pragma mark - class
+ (UIFont *)fontSize:(CGFloat)size weight:(NSInteger)weight {
    return [UIFont fontFamily:@"Helvetica Neue" size:size weight:weight slant:0];
}

+ (UIFont *)fontSize:(CGFloat)size weight:(NSInteger)weight slant:(CGFloat)slant {
    return [UIFont fontFamily:@"Helvetica Neue" size:size weight:weight slant:slant];
}

+ (UIFont *)fontFamily:(NSString *)family size:(CGFloat)size weight:(NSInteger)weight slant:(CGFloat)slant {
    CGFloat w_f = weight * 0.25 - 1.25;
    NSDictionary *traits = @{UIFontWeightTrait : @(w_f), UIFontSlantTrait : @(slant)};
    NSDictionary *attr = @{UIFontDescriptorFamilyAttribute : (family ? family : @"Helvetica Neue"),
                           UIFontDescriptorSizeAttribute   : @(size),
                           UIFontDescriptorTraitsAttribute : traits};
    UIFontDescriptor *descriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:attr];
    return [UIFont fontWithDescriptor:descriptor size:0];
}

@end

