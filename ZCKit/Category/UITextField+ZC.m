//
//  UITextField+ZC.m
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UITextField+ZC.h"
#import "UIView+ZC.h"

@implementation UITextField (ZC)

- (void)setLeftSpace:(float)leftSpace {
    if (leftSpace > 0) {
        if (self.leftView) {
            if (self.leftView.tag == 189001) {
                self.leftView.width = leftSpace;
            }
        } else {
            self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftSpace, 1) color:[UIColor clearColor]];
            self.leftView.tag = 189001;
            self.leftViewMode = UITextFieldViewModeAlways;
        }
    } else {
        if (self.leftView && self.leftView.tag == 189001) {
            self.leftView = nil;
        }
    }
}

- (float)leftSpace {
    if (self.leftView && self.leftView.tag == 189001) {
        return self.leftView.width;
    }
    return 0;
}

- (UIImage *)leftImage {
    if (self.leftView && [self.leftView isKindOfClass:[UIImageView class]]) {
        return [(UIImageView *)self.leftView image];
    }
    return nil;
}

- (void)setLeftImage:(UIImage *)leftImage {
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = leftImage;
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.contentMode = UIViewContentModeCenter;
    imageView.frame = CGRectMake(0, 0, 40.0, 60.0);
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = imageView;
}

- (NSInteger)currentOffset {
    return [self offsetFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];
}

- (NSRange)currentSelectRange {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    return NSMakeRange(location, length);
}

- (void)selectAllText {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

- (void)setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

- (void)makeOffsetPosition:(NSInteger)position {
    UITextPosition *begin = self.beginningOfDocument;
    UITextPosition *start = [self positionFromPosition:begin offset:position];
    UITextRange *range = [self textRangeFromPosition:start toPosition:start];
    [self setSelectedTextRange:range];
}

- (void)makeOffset:(NSInteger)offset {
    UITextRange *selectedRange = [self selectedTextRange];
    NSInteger currentOffset = [self offsetFromPosition:self.endOfDocument toPosition:selectedRange.end];
    currentOffset += offset;
    UITextPosition *newPos = [self positionFromPosition:self.endOfDocument offset:currentOffset];
    self.selectedTextRange = [self textRangeFromPosition:newPos toPosition:newPos];
}

- (void)makeOffsetFromBeginning:(NSInteger)offset {
    UITextPosition *begin = self.beginningOfDocument;
    UITextPosition *start = [self positionFromPosition:begin offset:0];
    UITextRange *range = [self textRangeFromPosition:start toPosition:start];
    [self setSelectedTextRange:range];
    [self makeOffset:offset];
}

- (instancetype)initWithFrame:(CGRect)frame holder:(NSString *)holder font:(UIFont *)font color:(UIColor *)color {
    if (self = [self initWithFrame:frame]) {
        if (holder) self.placeholder = holder;
        if (color) self.textColor = color;
        if (font) self.font = font;
    }
    return self;
}

@end

