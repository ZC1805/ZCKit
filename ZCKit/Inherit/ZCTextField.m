//
//  ZCTextField.m
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCTextField.h"
#import "UIView+ZC.h"
#import "ZCMacro.h"

@interface ZCTextField () <UITextFieldDelegate>

@property (nonatomic, copy) BOOL(^shouldChangeChar1)(ZCTextField *field, NSRange range, NSString *string);

@property (nonatomic, copy) BOOL(^shouldBeginEdit1)(ZCTextField *field);

@property (nonatomic, copy) BOOL(^shouldEndEdit1)(ZCTextField *field);

@property (nonatomic, copy) BOOL(^shouldEndReturn1)(ZCTextField *field);

@property (nonatomic, copy) void(^didBeginEdit1)(ZCTextField *field);

@property (nonatomic, copy) void(^didEndEdit1)(ZCTextField *field);

@end

@implementation ZCTextField

@synthesize underlineView = _underlineView;

#pragma mark - System
- (instancetype)initWithHolder:(nullable NSString *)holder font:(nullable UIFont *)font color:(nullable UIColor *)color {
    if (self = [self initWithFrame:CGRectZero]) {
        if (holder) self.placeholder = holder;
        if (color) self.textColor = color;
        if (font) self.font = font;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _fixSize = CGSizeZero;
        _cursorSize = CGSizeZero;
        _cursorOffset = UIOffsetZero;
        _responseAreaExtend = UIEdgeInsetsZero;
        _underlineEdgeInsets = UIEdgeInsetsZero;
        self.backgroundColor = kZCClear;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(_responseAreaExtend, UIEdgeInsetsZero)) {
        return [super pointInside:point withEvent:event];
    }
    if (self.hidden || self.alpha < 0.01 || !self.enabled || !self.userInteractionEnabled) {
        return NO;
    }
    CGRect hit = CGRectMake(self.bounds.origin.x - _responseAreaExtend.left,
                            self.bounds.origin.y - _responseAreaExtend.top,
                            self.bounds.size.width + _responseAreaExtend.left + _responseAreaExtend.right,
                            self.bounds.size.height + _responseAreaExtend.top + _responseAreaExtend.bottom);
    return CGRectContainsPoint(hit, point);
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

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_underlineView) {
        _underlineView.frame = CGRectMake(_underlineEdgeInsets.left,
                                          self.zc_height - _underlineEdgeInsets.top - _underlineEdgeInsets.bottom,
                                          self.zc_width - _underlineEdgeInsets.left - _underlineEdgeInsets.right,
                                          _underlineEdgeInsets.top);
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (CGSizeEqualToSize(_fixSize, CGSizeZero)) {
        return [super sizeThatFits:size];
    } else {
        return _fixSize;
    }
}

- (void)dealloc {
    [self removeNotificationObserver];
    [self removeNotificationTextObserver];
}

#pragma mark - override
- (CGRect)caretRectForPosition:(UITextPosition *)position {
    if (CGSizeEqualToSize(_cursorSize, CGSizeZero) && UIOffsetEqualToOffset(_cursorOffset, UIOffsetZero)) {
        return [super caretRectForPosition:position];
    } else {
        CGRect or = [super caretRectForPosition:position];
        if (CGSizeEqualToSize(_cursorSize, CGSizeZero)) {
            return CGRectMake(or.origin.x + _cursorOffset.horizontal, or.origin.y + _cursorOffset.vertical, or.size.width, or.size.height);
        } else if (UIOffsetEqualToOffset(_cursorOffset, UIOffsetZero)) {
            return CGRectMake(or.origin.x + (or.size.width - _cursorSize.width)/2.0, or.origin.y + (or.size.height - _cursorSize.height)/2.0, _cursorSize.width, _cursorSize.height);
        } else {
            CGFloat x = or.origin.x + _cursorOffset.horizontal + (or.size.width - _cursorSize.width)/2.0;
            CGFloat y = or.origin.y + _cursorOffset.vertical + (or.size.height - _cursorSize.height)/2.0;
            return CGRectMake(x, y, _cursorSize.width, _cursorSize.height);
        }
    }
}

#pragma mark - Set
- (void)setUnderlineEdgeInsets:(UIEdgeInsets)underlineEdgeInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(underlineEdgeInsets, _underlineEdgeInsets)) {
        _underlineEdgeInsets = underlineEdgeInsets;
        if (UIEdgeInsetsEqualToEdgeInsets(underlineEdgeInsets, UIEdgeInsetsZero)) {
            [_underlineView removeFromSuperview];
        } else {
            if (![self.underlineView isDescendantOfView:self]) [self addSubview:_underlineView];
            [self setNeedsLayout];
        }
    }
}

- (UIView *)underlineView {
    if (!_underlineView) {
        _underlineView = [[UIView alloc] initWithFrame:CGRectZero];
        _underlineView.backgroundColor = kZCSplit;
    }
    return _underlineView;
}

#pragma mark - Limit
- (void)setLimitTextLength:(NSUInteger)limitTextLength {
    [self removeNotificationObserver];
    _limitTextLength = limitTextLength;
    if (_limitTextLength > 0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limitHandle:) name:UITextFieldTextDidEndEditingNotification object:self];
    }
}

- (void)removeNotificationObserver {
    if (_limitTextLength > 0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:self];
    }
}

- (void)limitHandle:(id)sender {
    if (_limitTextLength > 0) {
        if (self.text.length > _limitTextLength) {
            BOOL handle = YES;
            if (_limitTipBlock) handle = _limitTipBlock(self.text);
            if (handle) self.text = [self.text substringToIndex:_limitTextLength];
        }
    }
}

#pragma mark - Change
- (void)setTextChangeBlock:(void (^)(ZCTextField *field))textChangeBlock {
    [self removeNotificationTextObserver];
    _textChangeBlock = textChangeBlock;
    if (_textChangeBlock) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange) name:UITextFieldTextDidChangeNotification object:self];
    }
}
        
- (void)removeNotificationTextObserver {
    if (_textChangeBlock) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
    }
}

- (void)textFieldTextChange {
    if (_textChangeBlock) {
        _textChangeBlock(self);
    }
}

#pragma mark - Touch
- (void)setTouchAction:(void (^)(ZCTextField * _Nonnull))touchAction {
    if ([self.allTargets containsObject:self] && (self.allControlEvents & UIControlEventAllEditingEvents)) {
        if ([[self actionsForTarget:self forControlEvent:UIControlEventAllEditingEvents] containsObject:NSStringFromSelector(@selector(onTouchActionZC:))]) {
            [self removeTarget:self action:@selector(onTouchActionZC:) forControlEvents:UIControlEventAllEditingEvents];
        }
    }
    if (touchAction) {
        [self addTarget:self action:@selector(onTouchActionZC:) forControlEvents:UIControlEventAllEditingEvents];
    }
}

- (void)onTouchActionZC:(id)sender {
    if (_touchAction) _touchAction(self);
}

#pragma mark - Delegate
- (BOOL)textFieldShouldBeginEditing:(ZCTextField *)textField {
    if (textField == self && self.shouldBeginEdit1) {
        return self.shouldBeginEdit1((ZCTextField *)textField);
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(ZCTextField *)textField {
    if (textField == self && self.shouldEndEdit1) {
        return self.shouldEndEdit1((ZCTextField *)textField);
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(ZCTextField *)textField {
    [textField endEditing:YES];
    if (textField == self && self.shouldEndReturn1) {
        return self.shouldEndReturn1((ZCTextField *)textField);
    }
    return YES;
}

- (BOOL)textField:(ZCTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self && self.shouldChangeChar1) {
        return self.shouldChangeChar1((ZCTextField *)textField, range, string);
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(ZCTextField *)textField {
    if (textField == self && self.didBeginEdit1) {
        return self.didBeginEdit1((ZCTextField *)textField);
    }
}

- (void)textFieldDidEndEditing:(ZCTextField *)textField {
    if (textField == self && self.didEndEdit1) {
        return self.didEndEdit1((ZCTextField *)textField);
    }
}

#pragma mark - Set
- (ZCTextField *)shouldBeginEdit:(nullable BOOL(^)(ZCTextField *field))block {
    if (self.delegate != self) self.delegate = self;
    self.shouldBeginEdit1 = block; return self;
}

- (ZCTextField *)shouldEndEdit:(nullable BOOL(^)(ZCTextField *field))block {
    if (self.delegate != self) self.delegate = self;
    self.shouldEndEdit1 = block; return self;
}

- (ZCTextField *)shouldEndReturn:(nullable BOOL(^)(ZCTextField *field))block {
    if (self.delegate != self) self.delegate = self;
    self.shouldEndReturn1 = block; return self;
}

- (ZCTextField *)shouldChangeChar:(nullable BOOL(^)(ZCTextField *field, NSRange range, NSString *string))block {
    if (self.delegate != self) self.delegate = self;
    self.shouldChangeChar1 = block; return self;
}

- (ZCTextField *)didBeginEdit:(nullable void(^)(ZCTextField *field))block {
    if (self.delegate != self) self.delegate = self;
    self.didBeginEdit1 = block; return self;
}

- (ZCTextField *)didEndEdit:(nullable void(^)(ZCTextField *field))block {
    if (self.delegate != self) self.delegate = self;
    self.didEndEdit1 = block; return self;
}

- (ZCTextField *)didTextChange:(nullable void(^)(ZCTextField *field))block {
    self.textChangeBlock = block; return self;
}

@end
