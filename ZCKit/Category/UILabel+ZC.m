//
//  UILabel+ZC.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UILabel+ZC.h"

@implementation UILabel (ZC)

- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font color:(UIColor *)color {
    if (self = [self initWithFrame:frame]) {
        self.textColor = color;
        self.font = font;
    }
    return self;
}

- (void)setText:(NSString *)text lineSpacing:(CGFloat)lineSpacing {
    if (lineSpacing < 0.01 || !text.length) {self.text = text; return;}
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = NSMakeRange(0, attStr.length);
    [attStr addAttribute:NSFontAttributeName value:self.font range:range];
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    [pStyle setLineSpacing:lineSpacing];
    [pStyle setLineBreakMode:self.lineBreakMode];
    [pStyle setAlignment:self.textAlignment];
    [attStr addAttribute:NSParagraphStyleAttributeName value:pStyle range:range];
    self.attributedText = attStr;
}

+ (CGFloat)heiText:(NSString *)text font:(UIFont *)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    static UILabel *kSpacLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kSpacLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        kSpacLabel.numberOfLines = 0;
    });
    kSpacLabel.font = font;
    kSpacLabel.frame = CGRectMake(0, 0, width, MAXFLOAT);
    [kSpacLabel setText:text lineSpacing:lineSpacing];
    [kSpacLabel sizeToFit];
    return kSpacLabel.frame.size.height;
}

@end
