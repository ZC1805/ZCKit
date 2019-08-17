//
//  ZCFixLabel.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCFixLabel.h"

@interface ZCFixLabel ()

@property (nonatomic, assign) CGFloat verticalAlignmentOffset; //水平对齐缩进量

@property (nonatomic, assign) int verticalAlignmentType; //0.水平居中对齐 1.水平居上s对齐 2.水平居下对齐

@property (nonatomic, assign) CGFloat leftIndentDistance; //左右缩进距离

@property (nonatomic, assign) CGFloat rightIndentDistance; //左右缩进距离

@end

@implementation ZCFixLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _fixSize = CGSizeZero;
        _verticalAlignmentType = 0;
        _verticalAlignmentOffset = 0;
        _leftIndentDistance = 0;
        _rightIndentDistance = 0;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (CGSizeEqualToSize(_fixSize, CGSizeZero)) {
        return [super sizeThatFits:size];
    } else {
        return _fixSize;
    }
}

#pragma mark - override
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    if (!_verticalAlignmentType && !_verticalAlignmentOffset && !_leftIndentDistance && !_rightIndentDistance) {
        return [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    }
    if (_leftIndentDistance) {
        bounds.size.width = bounds.size.width - _leftIndentDistance;
    }
    if (_rightIndentDistance) {
        bounds.size.width = bounds.size.width - _rightIndentDistance;
    }
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
    if (_leftIndentDistance) {
        textRect.origin.x = bounds.origin.x + _leftIndentDistance;
    }
    return textRect;
}

- (void)drawTextInRect:(CGRect)requestedRect {
    if (!_verticalAlignmentType && !_verticalAlignmentOffset && !_leftIndentDistance && !_rightIndentDistance) {
        [super drawTextInRect:requestedRect];
    } else {
        CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
        [super drawTextInRect:actualRect];
    }
}

#pragma mark - api
- (void)resetVerticalCenterAlignmentOffsetTop:(CGFloat)offset {
    if (_verticalAlignmentType != 0 || _verticalAlignmentOffset != offset) {
        _verticalAlignmentType = 0;
        _verticalAlignmentOffset = offset;
        [self setNeedsDisplay];
    }
}

- (void)resetVerticalTopAlignmentOffsetBottom:(CGFloat)offset {
    if (_verticalAlignmentType != 1 || _verticalAlignmentOffset != offset) {
        _verticalAlignmentType = 1;
        _verticalAlignmentOffset = offset;
        [self setNeedsDisplay];
    }
}

- (void)resetVerticalBottomAlignmentOffsetTop:(CGFloat)offset {
    if (_verticalAlignmentType != 2 || _verticalAlignmentOffset != offset) {
        _verticalAlignmentType = 2;
        _verticalAlignmentOffset = offset;
        [self setNeedsDisplay];
    }
}

- (void)resetLeftIndent:(CGFloat)leftIndent rightIndent:(CGFloat)rightIndent {
    if (_leftIndentDistance != leftIndent || _rightIndentDistance != rightIndent) {
        _leftIndentDistance = leftIndent;
        _rightIndentDistance = rightIndent;
        [self setNeedsDisplay];
    }
}

- (void)setText:(NSString *)text matchText:(NSString *)mText isReverse:(BOOL)isReverse
     attributes:(NSDictionary<NSAttributedStringKey, id> *)attributes rowSpacing:(CGFloat)rSpacing {
    if (!text.length || !mText.length) {self.text = text; return;}
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

@end
