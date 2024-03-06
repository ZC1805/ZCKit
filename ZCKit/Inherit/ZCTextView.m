//
//  ZCTextView.h
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCTextView.h"
#import "UIView+ZC.h"
#import "ZCMacro.h"
#import "ZCLabel.h"

@interface ZCTextView () <UITextViewDelegate>

@property (nonatomic, strong) ZCLabel *placeholderLabel;

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _fixSize = CGSizeZero;
        self.backgroundColor = kZCClear;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshIPlaceholder:) name:UITextViewTextDidChangeNotification object:self];
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

- (void)refreshIPlaceholder:(NSNotification *)notify {
    if (notify && notify.object == self) {
        if (_textChangeBlock) {
            _textChangeBlock(self);
        }
    }
    if (self.text.length || self.attributedText.length) {
        if (_placeholderLabel.alpha != 0) {
            _placeholderLabel.alpha = 0;
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }
    } else {
        if (_placeholderLabel.alpha != 1) {
            _placeholderLabel.alpha = 1;
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }
    }
}

#pragma mark - Override
- (void)setText:(NSString *)text {
    [super setText:text];
    [self refreshIPlaceholder:nil];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self refreshIPlaceholder:nil];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    _placeholderLabel.font = self.font;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    _placeholderLabel.textAlignment = textAlignment;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _placeholderLabel.frame = [self placeholderExpectedFrame];
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
    [self refreshIPlaceholder:nil];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    _attributedPlaceholder = attributedPlaceholder;
    self.placeholderLabel.attributedText = attributedPlaceholder;
    [self refreshIPlaceholder:nil];
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
    if (!placeholderTextColor) placeholderTextColor = kZCA(kZCBlackA6, 0.7);
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
    CGFloat maxWidth = self.zc_width - placeholderInsets.left - placeholderInsets.right;
    CGSize size = CGSizeMake(maxWidth, self.zc_height - placeholderInsets.top - placeholderInsets.bottom);
    CGSize expectedSize = [_placeholderLabel sizeThatFits:size];
    return CGRectMake(placeholderInsets.left, placeholderInsets.top, maxWidth, expectedSize.height);
}

- (ZCLabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[ZCLabel alloc] initWithFrame:CGRectZero];
        _placeholderLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.font = self.font;
        _placeholderLabel.textAlignment = self.textAlignment;
        _placeholderLabel.backgroundColor = kZCClear;
        _placeholderLabel.textColor = kZCA(kZCBlackA6, 0.7);
        _placeholderLabel.alpha = 0;
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (id<UITextViewDelegate>)delegate {
    [self refreshIPlaceholder:nil];
    return [super delegate];
}

#pragma mark - Delegate
- (BOOL)textViewShouldBeginEditing:(ZCTextView *)textView {
    if (textView == self && self.shouldBeginEdit1) {
        return self.shouldBeginEdit1((ZCTextView *)textView);
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(ZCTextView *)textView {
    if (textView == self && self.shouldEndEdit1) {
        return self.shouldEndEdit1((ZCTextView *)textView);
    }
    return YES;
}

- (BOOL)textView:(ZCTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == self && self.shouldChangeText1) {
        return self.shouldChangeText1((ZCTextView *)textView, range, text);
    }
    return YES;
}

- (void)textViewDidBeginEditing:(ZCTextView *)textView {
    if (textView == self && self.didBeginEdit1) {
        self.didBeginEdit1((ZCTextView *)textView);
    }
}

- (void)textViewDidEndEditing:(ZCTextView *)textView {
    if (textView == self && self.didEndEdit1) {
        self.didEndEdit1((ZCTextView *)textView);
    }
}

- (void)textViewDidChange:(ZCTextView *)textView {
    if (textView == self && self.didChangeText1) {
        self.didChangeText1((ZCTextView *)textView);
    }
}

- (void)textViewDidChangeSelection:(ZCTextView *)textView {
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
