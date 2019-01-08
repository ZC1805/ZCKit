//
//  ZCTextField.m
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCTextField.h"
#import "ZCMacro.h"

@interface ZCTextField ()

@property (nonatomic, strong) UIView *underlineView;

@end

@implementation ZCTextField

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

- (void)setIsShowUnderline:(BOOL)isShowUnderline {
    _isShowUnderline = isShowUnderline;
    if (isShowUnderline) {
        _underlineView = [[UIView alloc] initWithFrame:CGRectZero];
        _underlineView.backgroundColor = ZCSPColor;
        [self addSubview:_underlineView];
    } else {
        [_underlineView removeFromSuperview];
        _underlineView = nil;
    }
}

- (void)layoutSubviews {
    if (_underlineView) {
        _underlineView.frame = CGRectMake(0, self.frame.size.height - ZSSepHei, self.frame.size.width, ZSSepHei);
    }
}

- (void)setLimitLength:(NSUInteger)limitLength {
    if (limitLength < 1) return;
    _limitLength = limitLength;
    [self removeNotificationObserver];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limitHandle:)
                                                 name:UITextFieldTextDidEndEditingNotification object:self];
}

- (void)removeNotificationObserver {
    if (_limitLength > 0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:self];
    }
}

- (void)limitHandle:(id)sender {
    if (_limitLength > 0) {
        [self removeNotificationObserver];
        if (self.text.length > _limitLength) {
            BOOL handle = YES;
            if (_limitTipBlock) handle = _limitTipBlock([self.text copy]);
            if (handle) self.text = [self.text substringToIndex:_limitLength];
        }
    }
}

- (void)setTextChangeBlock:(void (^)(NSString * _Nonnull))textChangeBlock {
    _textChangeBlock = textChangeBlock;
    [self removeNotificationTextObserver];
    if (textChangeBlock) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fieldTextChange:)
                                                     name:UITextFieldTextDidChangeNotification object:self];
    }
}
        
- (void)removeNotificationTextObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:self];
}

- (void)fieldTextChange:(id)sender {
    if (_textChangeBlock) {
        _textChangeBlock(self.text);
    }
}

- (void)dealloc {
    [self removeNotificationObserver];
    [self removeNotificationTextObserver];
}

@end

