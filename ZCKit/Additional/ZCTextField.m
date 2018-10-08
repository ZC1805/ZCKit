//
//  ZCTextField.m
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCTextField.h"

@implementation ZCTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.forbidVisibleMenu) {
        if ([UIMenuController sharedMenuController]) {
            [UIMenuController sharedMenuController].menuVisible = NO;
        }
        return NO;
    } else {
        if (self.onlyAllowCopyPasteSelect) {
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

- (void)setLimitLength:(NSUInteger)limitLength {
    if (limitLength < 1) {NSAssert(0, @"limit length mast then 0"); return;}
    _limitLength = limitLength;
    [self removeNotificationObserver];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limitHandle:) name:UITextFieldTextDidEndEditingNotification object:self];
}

- (void)removeNotificationObserver {
    if (self.limitLength > 0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:self];
    }
}

- (void)limitHandle:(id)sender {
    if (self.limitLength > 0 && self.text.length > self.limitLength) {
        BOOL handle = YES;
        if (self.limitTip) handle = self.limitTip([self.text copy]);
        if (handle) self.text = [self.text substringToIndex:self.limitLength];
    }
}

- (void)dealloc {
    [self removeNotificationObserver];
}

@end









