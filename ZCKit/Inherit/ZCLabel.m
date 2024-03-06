//
//  ZCLabel.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCLabel.h"
#import "ZCMacro.h"
#import "UIView+ZC.h"

@interface ZCLabel ()

@property (nonatomic, assign) CGFloat verticalAlignmentOffset; //水平对齐缩进量

@property (nonatomic, assign) int verticalAlignmentType; //0.水平居中对齐 1.水平居上对齐 2.水平居下对齐

@property (nonatomic, strong) UITapGestureRecognizer *zcTapGes; //点击手势

@property (nonatomic, strong) UIFont *manualFont; //手动设置的font

@property (nonatomic, strong) UIColor *manualColor; //手动设置的color

@end

@implementation ZCLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self resetInitProperty];
        self.backgroundColor = kZCClear;
        self.lineBreakMode = NSLineBreakByTruncatingTail;
        self.minimumScaleFactor = 0.5;
        self.numberOfLines = 1;
        self.adjustsFontSizeToFitWidth = YES;
        self.textAlignment = NSTextAlignmentLeft;
        self.textColor = kZCBlack30;
        self.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    }
    return self;
}

- (instancetype)initWithColor:(UIColor *)color font:(UIFont *)font alignment:(NSTextAlignment)alignment adjustsSize:(BOOL)adjustsSize {
    if (self = [self initWithFrame:CGRectZero]) {
        self.adjustsFontSizeToFitWidth = adjustsSize;
        self.textAlignment = alignment;
        self.textColor = color;
        self.font = font;
    }
    return self;
}

- (instancetype)initWithColor:(UIColor *)color font:(UIFont *)font {
    if (self = [self initWithFrame:CGRectZero]) {
        self.textColor = color;
        self.font = font;
    }
    return self;
}

- (void)resetInitProperty {
    _lineSpacing = 0;
    _headIndent = 0;
    _fixSize = CGSizeZero;
    _verticalAlignmentType = 0;
    _verticalAlignmentOffset = 0;
    _insideInsets = UIEdgeInsetsZero;
    _manualColor = nil;
    _manualFont = nil;
    self.touchAction = nil;
    [self layoutSubviews];
}

- (void)setFont:(UIFont *)font {
    _manualFont = font;
    [super setFont:font];
}

- (void)setTextColor:(UIColor *)textColor {
    _manualColor = textColor;
    [super setTextColor:textColor];
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (CGSizeEqualToSize(_fixSize, CGSizeZero)) {
        return [super sizeThatFits:size];
    } else {
        return _fixSize;
    }
}

- (void)setTouchAction:(void (^)(ZCLabel * _Nonnull))touchAction {
    _touchAction = touchAction;
    if (_zcTapGes) {
        [self removeGestureRecognizer:_zcTapGes];
        _zcTapGes = nil;
    }
    if (touchAction) {
        self.userInteractionEnabled = YES;
        _zcTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchActionZC:)];
        [self addGestureRecognizer:_zcTapGes];
    } else {
        self.userInteractionEnabled = NO;
    }
}

#pragma mark - Private
- (void)onTouchActionZC:(id)sender {
    if (_touchAction) _touchAction(self);
}

#pragma mark - Override
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    if (!UIEdgeInsetsEqualToEdgeInsets(_insideInsets, UIEdgeInsetsZero)) {
        CGRect textRect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, _insideInsets) limitedToNumberOfLines:numberOfLines];
        if (textRect.size.width != 0 || textRect.size.height != 0) {
            textRect.origin.x = textRect.origin.x - _insideInsets.left;
            textRect.origin.y = textRect.origin.y - _insideInsets.top;
            textRect.size.width = textRect.size.width + _insideInsets.left + _insideInsets.right;
            textRect.size.height = textRect.size.height + _insideInsets.top + _insideInsets.bottom;
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
    if (!UIEdgeInsetsEqualToEdgeInsets(_insideInsets, UIEdgeInsetsZero)) {
        if (requestedRect.size.width != 0 || requestedRect.size.height != 0) {
            [super drawTextInRect:UIEdgeInsetsInsetRect(requestedRect, _insideInsets)];
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
    if ((_lineSpacing != 0 || _headIndent != 0) && text.length) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = self.lineBreakMode;
        style.alignment = self.textAlignment;
        style.lineSpacing = _lineSpacing;
        style.firstLineHeadIndent = _headIndent;
        style.headIndent = _headIndent; //整体缩进(首行除外)
        UIFont *font = self.font ? self.font : [UIFont fontWithName:@"HelveticaNeue" size:12];
        NSDictionary *att = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
        self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:att];
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

- (void)setInsideInsets:(UIEdgeInsets)insideInsets {
    insideInsets = UIEdgeInsetsMake(ceilf(insideInsets.top), ceilf(insideInsets.left), ceilf(insideInsets.bottom), ceilf(insideInsets.right));
    if (!UIEdgeInsetsEqualToEdgeInsets(_insideInsets, insideInsets)) {
        _insideInsets = insideInsets;
        NSString *text = self.text;
        NSAttributedString *aText = self.attributedText;
        self.text = nil;
        self.attributedText = nil;
        self.text = text;
        self.attributedText = aText;
        [self setNeedsDisplay];
    }
}

- (void)setText:(NSString *)text matchText:(NSString *)mText isReverse:(BOOL)isReverse font:(UIFont *)font color:(UIColor *)color spacing:(CGFloat)spacing {
    if (!text.length) {
        self.attributedText = [[NSAttributedString alloc] initWithString:@""];
    } else if (!mText.length || (font == nil && color == nil)) {
        if (spacing != 0) {
            NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:text];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineBreakMode = self.lineBreakMode;
            style.alignment = self.textAlignment;
            style.lineSpacing = spacing;
            [attriText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attriText.length)];
            self.attributedText = attriText;
        } else {
            self.attributedText = [[NSAttributedString alloc] initWithString:text];
        }
    } else {
        NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:text];
        NSRange mRange = [text rangeOfString:mText]; NSRange maxRange = NSMakeRange(0, attriText.length);
        if (spacing != 0) {
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineBreakMode = self.lineBreakMode;
            style.alignment = self.textAlignment;
            style.lineSpacing = spacing;
            [attriText addAttribute:NSParagraphStyleAttributeName value:style range:maxRange];
        }
        if (mRange.location != NSNotFound && mRange.length) {
            UIFont *ofont = self.manualFont ? self.manualFont : [UIFont fontWithName:@"HelveticaNeue" size:12];
            UIColor *ocolor = self.manualColor ? self.manualColor : kZCWhite;
            NSDictionary *dicAtt = @{NSFontAttributeName:(font?font:ofont),NSForegroundColorAttributeName:(color?color:ocolor)};
            NSDictionary *oriAtt = @{NSFontAttributeName:ofont,NSForegroundColorAttributeName:ocolor};
            if (isReverse) {
                NSRange leadingRange = NSMakeRange(0, mRange.location);
                NSRange trailingRange = NSMakeRange(mRange.location + mRange.length, maxRange.length - mRange.location - mRange.length);
                if (leadingRange.length) {
                    [attriText addAttributes:dicAtt range:leadingRange];
                }
                if (trailingRange.length) {
                    [attriText addAttributes:dicAtt range:trailingRange];
                }
                if (mRange.length) {
                    [attriText addAttributes:oriAtt range:mRange];
                }
            } else {
                NSRange leadingRange = NSMakeRange(0, mRange.location);
                NSRange trailingRange = NSMakeRange(mRange.location + mRange.length, maxRange.length - mRange.location - mRange.length);
                if (leadingRange.length) {
                    [attriText addAttributes:oriAtt range:leadingRange];
                }
                if (trailingRange.length) {
                    [attriText addAttributes:oriAtt range:trailingRange];
                }
                if (mRange.length) {
                    [attriText addAttributes:dicAtt range:mRange];
                }
            }
        } self.attributedText = attriText;
    }
}

- (CGSize)autoAdaptToSize {
    return [self autoToSizeIsLimitLines:NO isRichText:NO];
}

- (CGSize)autoToSizeIsLimitLines:(BOOL)isLimitLines isRichText:(BOOL)isRichText {
    CGFloat initWid = self.zc_width;
    CGFloat initHei = self.zc_height;
    
    if (!CGSizeEqualToSize(self.fixSize, CGSizeZero)) {
        self.frame = CGRectMake(self.zc_left, self.zc_top, self.fixSize.width, self.fixSize.height);
        return self.fixSize;
    }

    static ZCLabel *kSpacLabelX = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kSpacLabelX = [[ZCLabel alloc] initWithFrame:CGRectZero];
        kSpacLabelX.adjustsFontSizeToFitWidth = NO;
    });
    kSpacLabelX.numberOfLines = isLimitLines ? self.numberOfLines : 0;
    kSpacLabelX.frame = CGRectMake(0, 0, (initWid == 0 ? MAXFLOAT : initWid), MAXFLOAT);
    if (isRichText) {
        kSpacLabelX.font = self.font;
        kSpacLabelX.textAlignment = self.textAlignment;
        kSpacLabelX.insideInsets = self.insideInsets;
        kSpacLabelX.lineSpacing = 0;
        kSpacLabelX.headIndent = 0;
        [kSpacLabelX setText:nil];
        [kSpacLabelX setAttributedText:self.attributedText.copy];
    } else {
        kSpacLabelX.font = self.font;
        kSpacLabelX.textAlignment = self.textAlignment;
        kSpacLabelX.insideInsets = self.insideInsets;
        kSpacLabelX.lineSpacing = self.lineSpacing;
        kSpacLabelX.headIndent = self.headIndent;
        [kSpacLabelX setAttributedText:nil];
        [kSpacLabelX setText:self.text.copy];
    }
    [kSpacLabelX setNeedsDisplay];
    [kSpacLabelX sizeToFit];
    
    CGFloat newWid = ceilf(kSpacLabelX.zc_width);
    CGFloat newHei = ceilf(kSpacLabelX.zc_height);
    if (initHei == 0 && initWid == 0) {
        self.frame = CGRectMake(self.zc_left, self.zc_top, newWid, newHei);
    } else if (initHei == 0) {
        self.frame = CGRectMake(self.zc_left, self.zc_top, initWid, newHei);
    } else if (initWid == 0) {
        self.frame = CGRectMake(self.zc_left, self.zc_top, newWid, initHei);
    } else if (newHei > initHei) {
        self.frame = CGRectMake(self.zc_left, self.zc_top, initWid, newHei);
    } else if (newWid < initWid) {
        self.frame = CGRectMake(self.zc_left, self.zc_top, newWid, initHei);
    } else {
        self.frame = CGRectMake(self.zc_left, self.zc_top, newWid, newHei);
    }
    return CGSizeMake(newWid, newHei);
}

@end
