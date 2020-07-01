//
//  ZCFixLabel.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCFixLabel.h"
#import "UILabel+ZC.h"

@interface ZCFixLabel ()

@property (nonatomic, assign) CGFloat verticalAlignmentOffset; //水平对齐缩进量

@property (nonatomic, assign) int verticalAlignmentType; //0.水平居中对齐 1.水平居上s对齐 2.水平居下对齐

@end

@implementation ZCFixLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self resetInitProperty];
    }
    return self;
}

- (instancetype)initWithColor:(UIColor *)color font:(UIFont *)font alignment:(NSTextAlignment)alignment adjustsSize:(BOOL)adjustsSize {
    if (self = [super initWithFrame:CGRectZero]) {
        [self resetInitProperty];
        self.lineBreakMode = NSLineBreakByTruncatingTail;
        self.adjustsFontSizeToFitWidth = adjustsSize;
        self.minimumScaleFactor = 0.5;
        self.textAlignment = alignment;
        self.textColor = color;
        self.numberOfLines = 1;
        self.font = font;
    }
    return self;
}

- (void)resetInitProperty {
    _lineSpace = 0;
    _fixSize = CGSizeZero;
    _verticalAlignmentType = 0;
    _verticalAlignmentOffset = 0;
    _insideRect = UIEdgeInsetsZero;
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (CGSizeEqualToSize(_fixSize, CGSizeZero)) {
        return [super sizeThatFits:size];
    } else {
        return _fixSize;
    }
}

#pragma mark - Override
//- (CGSize)intrinsicContentSize { //只适合居中对齐
//    CGSize originalSize = [super intrinsicContentSize];
//    CGSize size = CGSizeMake(originalSize.width + 20, originalSize.height + 8);
//    return size;
//}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    if (!UIEdgeInsetsEqualToEdgeInsets(_insideRect, UIEdgeInsetsZero)) {
        CGRect textRect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, _insideRect) limitedToNumberOfLines:numberOfLines];
        if (textRect.size.width != 0 || textRect.size.height != 0) {
            textRect.origin.x = textRect.origin.x - _insideRect.left;
            textRect.origin.y = textRect.origin.y - _insideRect.top;
            textRect.size.width = textRect.size.width + _insideRect.left + _insideRect.right;
            textRect.size.height = textRect.size.height + _insideRect.top + _insideRect.bottom;
        }
        return textRect;
    } else if (_verticalAlignmentType || _verticalAlignmentOffset) {
        CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
        switch (_verticalAlignmentType) {
            case 1:{
                textRect.origin.y = bounds.origin.y + _verticalAlignmentOffset;
            } break;
            case 2:{
                textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height - _verticalAlignmentOffset;
            } break;
            default:{
                textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0 - _verticalAlignmentOffset;
            } break;
        }
        return textRect;
    } else {
        return [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    }
}

- (void)drawTextInRect:(CGRect)requestedRect {
    if (!UIEdgeInsetsEqualToEdgeInsets(_insideRect, UIEdgeInsetsZero)) {
        if (requestedRect.size.width != 0 || requestedRect.size.height != 0) {
            [super drawTextInRect:UIEdgeInsetsInsetRect(requestedRect, _insideRect)];
        } else {
            [super drawTextInRect:requestedRect];
        }
    } else if (_verticalAlignmentType || _verticalAlignmentOffset) {
        [super drawTextInRect:[self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines]];
    } else {
        [super drawTextInRect:requestedRect];
    }
}

- (void)setText:(NSString *)text {
    if (_lineSpace > 0) {
        [super setText:text lineSpacing:_lineSpace];
    } else {
        [super setText:text];
    }
}

#pragma mark - Api
- (void)resetVerticalCenterAlignmentOffsetTop:(CGFloat)offset {
    offset = ceilf(offset);
    if (_verticalAlignmentType != 0 || _verticalAlignmentOffset != offset) {
        _verticalAlignmentType = 0;
        _verticalAlignmentOffset = offset;
        [self setNeedsDisplay];
    }
}

- (void)resetVerticalTopAlignmentOffsetBottom:(CGFloat)offset {
    offset = ceilf(offset);
    if (_verticalAlignmentType != 1 || _verticalAlignmentOffset != offset) {
        _verticalAlignmentType = 1;
        _verticalAlignmentOffset = offset;
        [self setNeedsDisplay];
    }
}

- (void)resetVerticalBottomAlignmentOffsetTop:(CGFloat)offset {
    offset = ceilf(offset);
    if (_verticalAlignmentType != 2 || _verticalAlignmentOffset != offset) {
        _verticalAlignmentType = 2;
        _verticalAlignmentOffset = offset;
        [self setNeedsDisplay];
    }
}

- (void)setInsideRect:(UIEdgeInsets)insideRect {
    insideRect = UIEdgeInsetsMake(ceilf(insideRect.top), ceilf(insideRect.left), ceilf(insideRect.bottom), ceilf(insideRect.right));
    if (!UIEdgeInsetsEqualToEdgeInsets(_insideRect, insideRect)) {
        _insideRect = insideRect;
        NSString *text = self.text;
        NSAttributedString *aText = self.attributedText;
        self.text = nil;
        self.attributedText = nil;
        self.text = text;
        self.attributedText = aText;
        [self setNeedsDisplay];
    }
}

- (void)setText:(NSString *)text matchText:(NSString *)mText isReverse:(BOOL)isReverse
     attributes:(NSDictionary<NSAttributedStringKey, id> *)attributes rowSpacing:(CGFloat)rSpacing {
    if (!text.length) {
        self.text = text ? text : @"";
    } else if (!mText.length || !attributes.count) {
        if (!rSpacing) {
            self.text = text;
        } else {
            NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:text];
            NSRange maxRange = NSMakeRange(0, attriText.length);
            NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
            [pStyle setLineSpacing:rSpacing];
            [attriText addAttribute:NSParagraphStyleAttributeName value:pStyle range:maxRange];
            self.attributedText = attriText;
        }
    } else {
        NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:text];
        NSRange mRange = [text rangeOfString:mText]; NSRange maxRange = NSMakeRange(0, attriText.length);
        if (rSpacing) {
            NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
            [pStyle setLineSpacing:rSpacing];
            [attriText addAttribute:NSParagraphStyleAttributeName value:pStyle range:maxRange];
        }
        if (mRange.location != NSNotFound && mRange.length) {
            if (isReverse) {
                NSRange leadingRange = NSMakeRange(0, mRange.location);
                NSRange trailingRange = NSMakeRange(mRange.location + mRange.length, maxRange.length - mRange.location - mRange.length);
                if (leadingRange.length) {
                    [attriText addAttributes:attributes range:leadingRange];
                }
                if (trailingRange.length) {
                    [attriText addAttributes:attributes range:trailingRange];
                }
            } else {
                [attriText addAttributes:attributes range:mRange];
            }
        }
        self.attributedText = attriText;
    }
}

@end
