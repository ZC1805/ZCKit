//
//  ZCTextView.h
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCTextView.h"
#import "ZCMacro.h"

@interface ZCTextView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, copy) BOOL(^shouldChangeText1)(ZCTextView *textView, NSRange range, NSString *string);

@property (nonatomic, copy) BOOL(^shouldBeginEdit1)(ZCTextView *textView);

@property (nonatomic, copy) BOOL(^shouldEndEdit1)(ZCTextView *textView);

@property (nonatomic, copy) void(^didBeginEdit1)(ZCTextView *textView);

@property (nonatomic, copy) void(^didEndEdit1)(ZCTextView *textView);

@property (nonatomic, copy) void(^didChangeText1)(ZCTextView *textView);

@property (nonatomic, copy) void(^didChangeSelect1)(ZCTextView *textView);

@end

@implementation ZCTextView

- (void)dealloc {
    [_placeholderLabel removeFromSuperview];
    _placeholderLabel = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [self removeNotificationTextObserver];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _fixSize = CGSizeZero;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPlaceholder)
                                                     name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (_isForbidVisibleMenu) {
        if ([UIMenuController sharedMenuController]) {
            [UIMenuController sharedMenuController].menuVisible = NO;
        }
        return NO;
    } else {
        if (_isOnlyAllowCopyPasteSelect) {
            NSString *selector = NSStringFromSelector(action);
            if ([selector isEqualToString:@"copy:"]) return YES;
            if ([selector isEqualToString:@"paste:"]) return YES;
            if ([selector isEqualToString:@"select:"]) return YES;
            if ([selector isEqualToString:@"selectAll:"]) return YES;
            return NO;
        } else {
            return [super canPerformAction:action withSender:sender];
        }
    }
}

- (void)refreshPlaceholder {
    if (self.text.length || self.attributedText.length) {
        [_placeholderLabel setAlpha:0];
    } else {
        [_placeholderLabel setAlpha:1];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Override
- (void)setText:(NSString *)text {
    [super setText:text];
    [self refreshPlaceholder];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self refreshPlaceholder];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = self.font;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    self.placeholderLabel.textAlignment = textAlignment;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.placeholderLabel.frame = [self placeholderExpectedFrame];
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (CGSizeEqualToSize(_fixSize, CGSizeZero)) {
        return [super sizeThatFits:size];
    } else {
        return _fixSize;
    }
}

#pragma mark - Set
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    [self refreshPlaceholder];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    _attributedPlaceholder = attributedPlaceholder;
    self.placeholderLabel.attributedText = attributedPlaceholder;
    [self refreshPlaceholder];
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
    if (!placeholderTextColor) placeholderTextColor = ZCCA(ZCBlackA8, 0.7);
    _placeholderTextColor = placeholderTextColor;
    self.placeholderLabel.textColor = placeholderTextColor;
}

#pragma mark - Location
- (UIEdgeInsets)placeholderInsets {
    return UIEdgeInsetsMake(self.textContainerInset.top,
                            self.textContainerInset.left + self.textContainer.lineFragmentPadding,
                            self.textContainerInset.bottom,
                            self.textContainerInset.right + self.textContainer.lineFragmentPadding);
}

- (CGRect)placeholderExpectedFrame {
    UIEdgeInsets placeholderInsets = [self placeholderInsets];
    CGFloat maxWidth = CGRectGetWidth(self.frame) - placeholderInsets.left - placeholderInsets.right;
    CGSize size = CGSizeMake(maxWidth, CGRectGetHeight(self.frame) - placeholderInsets.top - placeholderInsets.bottom);
    CGSize expectedSize = [self.placeholderLabel sizeThatFits:size];
    return CGRectMake(placeholderInsets.left, placeholderInsets.top, maxWidth, expectedSize.height);
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _placeholderLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.font = self.font;
        _placeholderLabel.textAlignment = self.textAlignment;
        _placeholderLabel.backgroundColor = ZCClear;
        _placeholderLabel.textColor = ZCCA(ZCBlackA8, 0.7);
        _placeholderLabel.alpha = 0;
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (id<UITextViewDelegate>)delegate {
    [self refreshPlaceholder];
    return [super delegate];
}

- (CGSize)intrinsicContentSize {
    if (self.hasText) return [super intrinsicContentSize];
    UIEdgeInsets placeholderInsets = [self placeholderInsets];
    CGSize newSize = [super intrinsicContentSize];
    newSize.height = [self placeholderExpectedFrame].size.height + placeholderInsets.top + placeholderInsets.bottom;
    return newSize;
}

#pragma mark - Change
- (void)setTextChangeBlock:(void (^)(ZCTextView *textView))textChangeBlock {
    [self removeNotificationTextObserver];
    _textChangeBlock = textChangeBlock;
    if (_textChangeBlock) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextChange)
                                                     name:UITextViewTextDidChangeNotification object:self];
    }
}

- (void)removeNotificationTextObserver {
    if (_textChangeBlock) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    }
}

- (void)textViewTextChange {
    if (_textChangeBlock) {
        _textChangeBlock(self);
    }
}

#pragma mark - Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == self && self.shouldBeginEdit1) {
        return self.shouldBeginEdit1((ZCTextView *)textView);
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView == self && self.shouldEndEdit1) {
        return self.shouldEndEdit1((ZCTextView *)textView);
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == self && self.shouldChangeText1) {
        return self.shouldChangeText1((ZCTextView *)textView, range, text);
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView == self && self.didBeginEdit1) {
        self.didBeginEdit1((ZCTextView *)textView);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == self && self.didEndEdit1) {
        self.didEndEdit1((ZCTextView *)textView);
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self && self.didChangeText1) {
        self.didChangeText1((ZCTextView *)textView);
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if (textView == self && self.didChangeSelect1) {
        self.didChangeSelect1((ZCTextView *)textView);
    }
}

#pragma mark - Set
- (ZCTextView *)shouldBeginEdit:(nullable BOOL(^)(ZCTextView *textView))block {
    if (self.delegate != self) self.delegate = self;
    self.shouldBeginEdit1 = block; return self;
}

- (ZCTextView *)shouldEndEdit:(nullable BOOL(^)(ZCTextView *textView))block {
    if (self.delegate != self) self.delegate = self;
    self.shouldEndEdit1 = block; return self;
}

- (ZCTextView *)shouldChangeText:(nullable BOOL(^)(ZCTextView *textView, NSRange range, NSString *string))block {
    if (self.delegate != self) self.delegate = self;
    self.shouldChangeText1 = block; return self;
}

- (ZCTextView *)didBeginEdit:(nullable void(^)(ZCTextView *textView))block {
    if (self.delegate != self) self.delegate = self;
    self.didBeginEdit1 = block; return self;
}

- (ZCTextView *)didEndEdit:(nullable void(^)(ZCTextView *textView))block {
    if (self.delegate != self) self.delegate = self;
    self.didEndEdit1 = block; return self;
}

- (ZCTextView *)didChangeText:(nullable void(^)(ZCTextView *textView))block {
    if (self.delegate != self) self.delegate = self;
    self.didChangeText1 = block; return self;
}

- (ZCTextView *)didChangeSelect:(nullable void(^)(ZCTextView *textView))block {
    if (self.delegate != self) self.delegate = self;
    self.didChangeSelect1 = block; return self;
}

@end
