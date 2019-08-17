//
//  UILabel+ZC.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UILabel+ZC.h"

@implementation UILabel (ZC)

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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
    label.numberOfLines = 0;
    label.font = font;
    [label setText:text lineSpacing:lineSpacing];
    [label sizeToFit];
    return label.frame.size.height;
}

- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font color:(UIColor *)color {
    if (self = [self initWithFrame:frame]) {
        self.textColor = color;
        self.font = font;
    }
    return self;
}

@end

