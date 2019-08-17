//
//  ZCGrowView.h
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCGrowView.h"
#import "ZCMacro.h"

#pragma mark - ~~~~~~~~~~ ZCGrowInternalTextView ~~~~~~~~~~
@interface ZCGrowInternalTextView : UITextView

@property (nonatomic, assign) BOOL displayPlaceholder;

@property (nonatomic, strong) NSAttributedString *placeholderAttributedText;

@end

@implementation ZCGrowInternalTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTextDidChangeNotify)
                                                     name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

#pragma mark - override
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:) ||
        action == @selector(selectAll:)||
        action == @selector(cut:)||
        action == @selector(select:)||
        action == @selector(paste:)) {
        return[super canPerformAction:action withSender:sender];
    }
    return NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self updatePlaceholder];
}

- (void)setPlaceholderAttributedText:(NSAttributedString *)placeholderAttributedText {
    _placeholderAttributedText = placeholderAttributedText;
    [self setNeedsDisplay];
}

#pragma mark - private
- (void)setDisplayPlaceholder:(BOOL)displayPlaceholder {
    BOOL oldValue = _displayPlaceholder;
    _displayPlaceholder = displayPlaceholder;
    if (oldValue != self.displayPlaceholder) {
        [self setNeedsDisplay];
    }
}

- (void)updatePlaceholder {
    self.displayPlaceholder = self.text.length == 0;
}

- (void)receiveTextDidChangeNotify {
    [self updatePlaceholder];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (!self.displayPlaceholder) return;
    CGFloat wid = self.contentInset.left + self.contentInset.right + self.textContainerInset.left + self.textContainerInset.right;
    CGFloat hei = self.contentInset.top + self.contentInset.bottom + self.textContainerInset.top + self.textContainerInset.bottom;
    CGRect inRect = CGRectMake(self.contentInset.left + self.textContainerInset.left + ZSA(5),
                               self.contentInset.top + self.textContainerInset.top,
                               self.frame.size.width - wid - ZSA(10),
                               self.frame.size.height - hei);
    [self.placeholderAttributedText drawInRect:inRect];
}

@end


#pragma mark - ~~~~~~~~~~ ZCGrowView ~~~~~~~~~~
@interface ZCGrowView() <UITextViewDelegate>

@property (nonatomic, assign) CGFloat maxHeight;

@property (nonatomic, assign) CGFloat minHeight;

@property (nonatomic, assign) CGRect previousFrame;

@property (nonatomic, strong) ZCGrowInternalTextView *textView;

@property (nonatomic, strong) NSMutableDictionary *myAttributes;

@property (nonatomic, strong, readonly) NSMutableParagraphStyle *paragraphStyle;  /**< 段落样式 */

- (void)updateTypingAttributes;  /**< 更新typingAttributes */

@end

@implementation ZCGrowView

@synthesize paragraphStyle = _paragraphStyle;

#pragma mark - override
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.textView = [[ZCGrowInternalTextView alloc] initWithFrame:rect];
        self.previousFrame = frame;
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (ZFNotEqual(self.previousFrame.size.width, self.bounds.size.width)) {
        self.previousFrame = self.frame;
        [self rowHeiChange];
    }
}

- (CGSize)intrinsicContentSize {
    return [self measureFrame:self.measureTextViewSize].size;
}

#pragma mark - responder
//- (BOOL)isFirstResponder {
//    return self.textView.isFirstResponder;
//}
//
//- (BOOL)becomeFirstResponder {
//    return [self.textView becomeFirstResponder];
//}
//
//- (BOOL)resignFirstResponder {
//    return [self.textView resignFirstResponder];
//}

#pragma mark - set & get
//- (UIView *)inputView {
//    return self.textView.inputView;
//}
//
//- (void)setInputView:(UIView *)inputView {
//    self.textView.inputView = inputView;
//}
//
//- (UIView *)inputAccessoryView {
//    return self.textView.inputAccessoryView;
//}
//
//- (void)setInputAccessoryView:(UIView *)inputAccessoryView {
//    self.textView.inputAccessoryView = inputAccessoryView;
//}

- (void)setMinLines:(NSInteger)minLines {
    if (minLines < 1) {self.minHeight = 0; return;}
    self.minHeight = [self simulateHeight:minLines];
    _minLines = minLines;
    [self rowHeiChange];
}

- (void)setMaxLines:(NSInteger)maxLines {
    if (maxLines < 1) {self.maxHeight = 0; return;}
    self.maxHeight = [self simulateHeight:maxLines];
    _maxLines = maxLines;
}

- (NSMutableParagraphStyle *)paragraphStyle {
    if (!_paragraphStyle) {
        _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        _paragraphStyle.lineSpacing = ZSA(3); //行间距
        _paragraphStyle.lineHeightMultiple = 0; //行倍数间距(设置0无效，总间距为行间距+行倍数间距)
        _paragraphStyle.paragraphSpacing = ZSA(0); //段间距(\n换行)(总间距为行间距+段间距)
        _paragraphStyle.paragraphSpacingBefore = 0; //段首留空白(\n换行)
        _paragraphStyle.firstLineHeadIndent = ZSA(0); //首行缩进
        _paragraphStyle.headIndent = ZSA(0); //整体缩进(首行除外)
        _paragraphStyle.tailIndent = ZSA(0); //尾部缩进(右侧缩进或显示宽度)
        _paragraphStyle.hyphenationFactor = 0.3; //连字符属性
        _paragraphStyle.minimumLineHeight = 0; //最低行高
        _paragraphStyle.maximumLineHeight = 0; //最大行高
        _paragraphStyle.alignment = NSTextAlignmentLeft; //(两端对齐的)文本对齐方式(两端对齐，自然)
        _paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping; //结尾部分的内容以……方式省略
        _paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight; //书写方向
        _paragraphStyle.allowsDefaultTighteningForTruncation = NO; //换行问题
    }
    return _paragraphStyle;
}

- (NSMutableDictionary *)myAttributes {
    if (!_myAttributes) {
        NSDictionary *dic = @{NSFontAttributeName:ZCFS(16), NSForegroundColorAttributeName:ZCBlack30,
                              NSKernAttributeName:@(ZSA(0)), NSParagraphStyleAttributeName:self.paragraphStyle};
        _myAttributes = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    return _myAttributes;
}

#pragma mark - public
- (void)updateTypingAttributes {
    self.textView.typingAttributes = self.myAttributes;
}

#pragma mark - private
- (void)setup {
    self.textView.bounces = NO;
    self.textView.delegate = self;
    self.textView.scrollEnabled = NO;
    self.textView.attributedText = nil;
    self.textView.clearsOnInsertion = NO;
    self.textView.linkTextAttributes = nil;
    self.textView.backgroundColor = ZCClear;
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.showsHorizontalScrollIndicator = NO;
    self.textView.allowsEditingTextAttributes = NO; //不允许编辑TextAttributes
    self.textView.enablesReturnKeyAutomatically = YES; //输入框有内容时候才能点击return
    self.textView.textAlignment = NSTextAlignmentLeft; //文本使用左侧对齐
    self.textView.dataDetectorTypes = UIDataDetectorTypeNone; //不检测输入的文本
    self.textView.textContainerInset = UIEdgeInsetsMake(ZSA(0), ZSA(3), ZSA(0), ZSA(3)); //内间距
    self.textView.typingAttributes = self.myAttributes;
    [self addSubview:self.textView];
    self.maxLines = 3;
    self.minLines = 1;
}

- (void)rowHeiChange {
    [self resetTextInset];
    [self setPlaceholderText:self.placeholderText];
    [self fitToScrollView];
}

- (CGFloat)simulateHeight:(NSInteger)lines {
    NSString *saveText = self.textView.text;
    NSMutableString *newText = [NSMutableString stringWithString:@"-"];
    self.textView.delegate = nil;
    self.textView.hidden = YES;
    for (NSInteger i = 0; i < lines - 1; i ++) {[newText appendString:@"\n|W|"];}
    self.textView.text = newText;
    CGFloat height = self.measureTextViewSize.height - self.textView.contentInset.top - self.textView.contentInset.bottom;
    self.textView.text = saveText;
    self.textView.delegate = self;
    self.textView.hidden = NO;
    return height;
}

- (void)resetTextInset {
    CGFloat dif = (self.previousFrame.size.height - self.minHeight) / 2.0;
    if (dif < ZSA(2)) return;
    UIEdgeInsets textInset = self.textView.textContainerInset;
    textInset.bottom = textInset.bottom + dif;
    textInset.top = textInset.top + dif;
    self.textView.textContainerInset = textInset;
    self.maxHeight = [self simulateHeight:self.maxLines];
    self.minHeight = [self simulateHeight:self.minLines];
}

///!!!:超过4行时点击滑动&换行时不滑到最底端
///!!!:输入框弹窗 & 两项选择框弹窗 & 最大输入设置ZDGuestBookView & NIMGrowingInternalTextView
- (void)fitToScrollView {
    //BOOL scrollToBottom = ZFNotEqual(self.contentOffset.y, self.contentSize.height - self.frame.size.height);
    CGSize actualTextViewSize = [self measureTextViewSize];
    CGRect oldScrollViewFrame = self.frame;
    CGRect frame = self.bounds;
    frame.origin = CGPointZero;
    frame.size.height = actualTextViewSize.height;
    self.textView.frame = frame;
    self.contentSize = frame.size;
    CGRect newScrollViewFrame = [self measureFrame:actualTextViewSize];
    BOOL isChangeHei = ZFNotEqual(oldScrollViewFrame.size.height, newScrollViewFrame.size.height);
    if (isChangeHei && ZFBelowEqual(newScrollViewFrame.size.height, self.maxHeight)) {
        [self flashScrollIndicators];
        if ([self.textDelegate respondsToSelector:@selector(growViewWillChangeHeight:)]) {
            [self.textDelegate growViewWillChangeHeight:newScrollViewFrame.size.height];
        }
    }
    self.frame = newScrollViewFrame;
    //if (scrollToBottom) [self fitScrollToBottom];
    [self fitScrollToBottom];
    if (isChangeHei && [self.textDelegate respondsToSelector:@selector(growViewDidChangeHeight:)]) {
        [self.textDelegate growViewDidChangeHeight:newScrollViewFrame.size.height];
    }
    [self invalidateIntrinsicContentSize];
}

- (void)fitScrollToBottom {
    CGPoint offset = self.contentOffset;
    [self setContentOffset:CGPointMake(offset.x, self.contentSize.height - self.frame.size.height) animated:YES];
}

- (CGRect)measureFrame:(CGSize)contentSize {
    CGFloat height = contentSize.height;
    if (ZFBelow(contentSize.height, self.minHeight) || !self.textView.hasText) {
        height = self.minHeight;
    } else if (ZFAbove(contentSize.height, self.maxHeight)) {
        height = self.maxHeight;
    }
    CGRect frame = self.frame;
    frame.size.height = height;
    return frame;
}

- (CGSize)measureTextViewSize {
    return [self.textView sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"] || [text isEqualToString:@"\r"]) {
        if ([self.textDelegate respondsToSelector:@selector(growViewDidSend:)]) {
            return ![self.textDelegate growViewDidSend:self];
        }
    }
    if ([self.textDelegate respondsToSelector:@selector(growViewShouldChangeTextInRange:replacementText:)]) {
        return [self.textDelegate growViewShouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    //[self fitScrollToBottom];
    if ([self.textDelegate respondsToSelector:@selector(growViewShouldBeginEditing:)]) {
        return [self.textDelegate growViewShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([self.textDelegate respondsToSelector:@selector(growViewShouldEndEditing:)]) {
        return [self.textDelegate growViewShouldEndEditing:self];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.textDelegate respondsToSelector:@selector(growViewDidBeginEditing:)]) {
        [self.textDelegate growViewDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.textDelegate respondsToSelector:@selector(growViewDidEndEditing:)]) {
        [self.textDelegate growViewDidEndEditing:self];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if ([self.textDelegate respondsToSelector:@selector(growViewDidChangeSelection:)]) {
        [self.textDelegate growViewDidChangeSelection:self];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([self.textDelegate respondsToSelector:@selector(growViewDidChange:)]) {
        [self.textDelegate growViewDidChange:self];
    }
    [self fitToScrollView];
}

@end


#pragma mark - ~~~~~~~~~~ ZCGrowView(TextView) ~~~~~~~~~~
@implementation ZCGrowView(TextView)

- (NSString *)placeholderText {
    return self.textView.placeholderAttributedText.string;
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    if (!placeholderText) return;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.myAttributes];
    [dic setObject:ZCBlackA2 forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:placeholderText attributes:dic];
    [self.textView setPlaceholderAttributedText:attributedText];
}

- (NSString *)text {
    return self.textView.text;
}

- (void)setText:(NSString *)text {
    self.textView.text = text;
    [self fitToScrollView];
}

- (UIFont *)font {
    return [self.myAttributes objectForKey:NSFontAttributeName];
}

- (void)setFont:(UIFont *)font {
    if (!font) return;
    [self.myAttributes setObject:font forKey:NSFontAttributeName];
    self.textView.typingAttributes = self.myAttributes;
    [self rowHeiChange];
}

- (UIColor *)textColor {
    return [self.myAttributes objectForKey:NSForegroundColorAttributeName];
}

- (void)setTextColor:(UIColor *)textColor {
    if (!textColor) return;
    [self.myAttributes setObject:textColor forKey:NSForegroundColorAttributeName];
    self.textView.typingAttributes = self.myAttributes;
}

- (BOOL)editable {
    return self.textView.editable;
}

- (void)setEditable:(BOOL)editable {
    self.textView.editable = editable;
}

- (BOOL)selectable {
    return self.textView.selectable;
}

- (void)setSelectable:(BOOL)selectable {
    self.textView.selectable = selectable;
}

- (NSRange)selectedRange {
    return self.textView.selectedRange;
}

- (void)setSelectedRange:(NSRange)selectedRange {
    self.textView.selectedRange = selectedRange;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType {
    [self.textView setReturnKeyType:returnKeyType];
}

- (UIReturnKeyType)returnKeyType {
    return self.textView.returnKeyType;
}

- (void)scrollRangeToVisible:(NSRange)range {
    [self.textView scrollRangeToVisible:range];
}

@end
