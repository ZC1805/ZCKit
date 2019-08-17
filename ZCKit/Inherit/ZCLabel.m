//
//  ZCLabel.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCLabel.h"
#import "ZCMacro.h"
#import "UIFont+ZC.h"

@interface ZCLabel ()

@property (nonatomic, assign) BOOL isSelfSetAttriStr;

@property (nonatomic, strong) NSMutableAttributedString *attriStr;

//@property (nonatomic, assign) CGFloat verticalAlignmentOffset; //水平对齐缩进量
//
//@property (nonatomic, assign) int verticalAlignmentType; //0.水平居中对齐 1.水平居上s对齐 2.水平居下对齐

@end

@implementation ZCLabel

@synthesize pStyle = _pStyle;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initAttriSet];
    }
    return self;
}

- (void)initAttriSet {
    _rowSpacing = 0;
    _wordSpacing = 0;
    _headTailIndent = 0;
//    _verticalAlignmentType = 0;
//    _verticalAlignmentOffset = 0;
    _isSelfSetAttriStr = NO;
    self.numberOfLines = 0;
}

//#pragma mark - override
//- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
//    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
//    switch (self.verticalAlignmentType) {
//        case 1:{
//            textRect.origin.y = bounds.origin.y - (bounds.size.height - textRect.size.height) / 2.0;
//        } break;
//        case 2:{
//            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height - self.verticalAlignmentOffset;
//        } break;
//        default:{
//            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0 - self.verticalAlignmentOffset;
//        } break;
//    }
//    return textRect;
//}
//
//- (void)drawTextInRect:(CGRect)requestedRect {
//    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
//    [super drawTextInRect:actualRect];
//}
//
//- (void)resetVerticalCenterAlignmentOffset:(CGFloat)offset {
//    _verticalAlignmentType = 1;
//    _verticalAlignmentOffset = 0;
//    [self setNeedsDisplay];
//}

#pragma mark - pubilc
- (CGFloat)calculateTextHeight:(CGFloat)maxWidth {
    return [self calculateSize:CGSizeMake(maxWidth, MAXFLOAT)].height;
}

- (CGFloat)calculateTextWidth {
    return [self calculateSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
}

- (CGSize)calculateSize:(CGSize)size {
    NSRange range = NSMakeRange(0, self.attriStr.length);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *att = [self.attriStr attributesAtIndex:0 effectiveRange:&range];
    return [self.attriStr.string boundingRectWithSize:size options:options attributes:att context:nil].size;
}

- (void)updateTextAttributeOrParagraphStyle {
    [self resetAttriStr:self.attriStr.string];
}

#pragma mark - private
- (void)resetAttriStr:(NSString *)text {
    NSAttributedStringEnumerationOptions ops = NSAttributedStringEnumerationLongestEffectiveRangeNotRequired;
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:ZCStrNonnil(text)];
    NSRange oriRange = NSMakeRange(0, self.attriStr.length);
    NSRange newRange = NSMakeRange(0, attriStr.length);
    
    [self.attriStr removeAttribute:NSKernAttributeName range:oriRange];
    [self.attriStr removeAttribute:NSFontAttributeName range:oriRange];
    [self.attriStr removeAttribute:NSParagraphStyleAttributeName range:oriRange];
    [self.attriStr removeAttribute:NSForegroundColorAttributeName range:oriRange];
    [self.attriStr removeAttribute:NSBaselineOffsetAttributeName range:oriRange];
    
    [self.attriStr enumerateAttributesInRange:oriRange options:ops
                                   usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
                                       if (attrs.count && (range.location + range.length <= newRange.location + newRange.length)) {
                                           [attriStr addAttributes:attrs range:range];
                                       }
    }];
    
    UIFont *font = self.font ? self.font : ZCFS(16);
    UIColor *color = self.textColor ? self.textColor : ZCBlack30;
    CGFloat lineOffset = font.fontSize * (self.pStyle.lineHeightMultiple - 1) / 2;
    [attriStr addAttribute:NSKernAttributeName value:@(self.wordSpacing) range:newRange];
    [attriStr addAttribute:NSFontAttributeName value:font range:newRange];
    [attriStr addAttribute:NSParagraphStyleAttributeName value:self.pStyle range:newRange];
    [attriStr addAttribute:NSForegroundColorAttributeName value:color range:newRange];
    [attriStr addAttribute:NSBaselineOffsetAttributeName value:@(lineOffset) range:newRange];
    
    self.attriStr = attriStr;
    self.isSelfSetAttriStr = YES;
    self.attributedText = attriStr;
}

#pragma mark - get
- (NSAttributedString *)attributedText {
    return nil;
}

- (NSMutableAttributedString *)attriStr {
    if (!_attriStr) {
        _attriStr = [[NSMutableAttributedString alloc] initWithString:@""];
        [_attriStr addAttribute:NSKernAttributeName value:@(0) range:NSMakeRange(0, 0)];
        [_attriStr addAttribute:NSFontAttributeName value:ZCFS(16) range:NSMakeRange(0, 0)];
        [_attriStr addAttribute:NSParagraphStyleAttributeName value:self.pStyle range:NSMakeRange(0, 0)];
        [_attriStr addAttribute:NSForegroundColorAttributeName value:ZCBlack30 range:NSMakeRange(0, 0)];
        [_attriStr addAttribute:NSBaselineOffsetAttributeName value:@(ZSA(2)) range:NSMakeRange(0, 0)];
    }
    return _attriStr;
}

- (NSMutableParagraphStyle *)pStyle {
    if (!_pStyle) {
        _pStyle = [[NSMutableParagraphStyle alloc] init];
        _pStyle.lineSpacing = _rowSpacing; //行间距
        _pStyle.lineHeightMultiple = 1.25; //行倍数间距(设置0无效，总间距为行间距+行倍数间距)
        _pStyle.paragraphSpacing = 0; //段间距(\n换行)(总间距为行间距+段间距)
        _pStyle.paragraphSpacingBefore = 0; //段首留空白(\n换行)
        _pStyle.firstLineHeadIndent = _headTailIndent; //首行缩进
        _pStyle.headIndent = _headTailIndent; //整体缩进(首行除外)
        _pStyle.tailIndent = -_headTailIndent; //尾部缩进(右侧缩进或显示宽度)
        
        _pStyle.hyphenationFactor = 0.3; //连字符属性
        _pStyle.minimumLineHeight = 0; //最低行高
        _pStyle.maximumLineHeight = 0; //最大行高
        _pStyle.alignment = NSTextAlignmentLeft; //(两端对齐的)文本对齐方式(两端对齐，自然)
        _pStyle.lineBreakMode = NSLineBreakByWordWrapping; //结尾部分的内容以……方式省略
        _pStyle.baseWritingDirection = NSWritingDirectionLeftToRight; //书写方向
        _pStyle.allowsDefaultTighteningForTruncation = NO; //换行问题
    }
    return _pStyle;
}

#pragma mark - set1
- (void)setText:(NSString *)text {
    [self resetAttriStr:text];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    if (_isSelfSetAttriStr) {
        [super setAttributedText:attributedText];
    } else {
        [self resetAttriStr:attributedText.string];
    }
    _isSelfSetAttriStr = NO;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self updateTextAttributeOrParagraphStyle];
}

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    [self updateTextAttributeOrParagraphStyle];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    self.pStyle.alignment = textAlignment;
    [self updateTextAttributeOrParagraphStyle];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    self.pStyle.lineBreakMode = lineBreakMode;
    [self updateTextAttributeOrParagraphStyle];
}

- (void)setAllowsDefaultTighteningForTruncation:(BOOL)allowsDefaultTighteningForTruncation {
    self.pStyle.allowsDefaultTighteningForTruncation = allowsDefaultTighteningForTruncation;
    [self updateTextAttributeOrParagraphStyle];
}

#pragma mark - set2
- (void)setWordSpacing:(CGFloat)wordSpacing {
    if (wordSpacing < 0) wordSpacing = 0;
    _wordSpacing = wordSpacing;
    [self updateTextAttributeOrParagraphStyle];
}

- (void)setRowSpacing:(CGFloat)rowSpacing {
    if (rowSpacing < 0) rowSpacing = 0;
    _rowSpacing = rowSpacing;
    self.pStyle.lineSpacing = _rowSpacing;
    [self updateTextAttributeOrParagraphStyle];
}

- (void)setHeadTailIndent:(CGFloat)headTailIndent {
    if (headTailIndent < 0) headTailIndent = 0;
    _headTailIndent = headTailIndent;
    self.pStyle.headIndent = _headTailIndent;
    self.pStyle.tailIndent = -_headTailIndent;
    self.pStyle.firstLineHeadIndent = _headTailIndent;
    [self updateTextAttributeOrParagraphStyle];
}

#pragma mark - set3
- (void)setNumberOfLines:(NSInteger)numberOfLines {
    [super setNumberOfLines:numberOfLines];
    [self updateTextAttributeOrParagraphStyle];
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    [super setAdjustsFontSizeToFitWidth:adjustsFontSizeToFitWidth];
    [self updateTextAttributeOrParagraphStyle];
}

- (void)setBaselineAdjustment:(UIBaselineAdjustment)baselineAdjustment {
    [super setBaselineAdjustment:baselineAdjustment];
    [self updateTextAttributeOrParagraphStyle];
}

- (void)setMinimumScaleFactor:(CGFloat)minimumScaleFactor {
    [super setMinimumScaleFactor:minimumScaleFactor];
    [self updateTextAttributeOrParagraphStyle];
}

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
    [super setPreferredMaxLayoutWidth:preferredMaxLayoutWidth];
    [self updateTextAttributeOrParagraphStyle];
}

@end
