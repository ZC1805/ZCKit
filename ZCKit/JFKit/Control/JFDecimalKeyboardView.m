//
//  JFDecimalKeyboardView.m
//  ZCKit
//
//  Created by zjy on 2018/7/23.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFDecimalKeyboardView.h"
#import "UIButton+ZC.h"

#pragma mark - Class - JFDecimalField
@interface JFDecimalField : UITextField

@property (nonatomic, assign) BOOL isAllowPaste;  /**< 是否允许粘贴等，默认NO */

@end

@implementation JFDecimalField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.isAllowPaste) {
        NSString *selector = NSStringFromSelector(action);
        if ([selector isEqualToString:@"copy:"]) return YES;
        if ([selector isEqualToString:@"paste:"]) return YES;
        if ([selector isEqualToString:@"select:"]) return YES;
        if ([selector isEqualToString:@"selectAll:"]) return YES;
        return NO;
    }
    return NO;
}

@end


#pragma mark - Class - JFDecimalKeyboardView
@interface JFDecimalKeyboardView () <UITextFieldDelegate>

@property (nonatomic, strong) UIVisualEffectView *visualView;

@property (nonatomic, strong) JFDecimalField *fieldView;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, copy) NSString *dot;  /**< @"." */

@property (nonatomic, copy) BOOL(^hide)(NSDecimalNumber *decimal, BOOL activeHide);  /**< 点击确定时回调，返回是可否隐藏键盘，activeHide.YES隐藏按钮触发.NO遮罩触发 */

@property (nonatomic, copy) BOOL(^done)(NSDecimalNumber *decimal);  /**< 点击确定时回调，返回是否可隐藏键盘 */

@property (nonatomic, copy) BOOL(^check)(NSDecimalNumber *futureDecimal);  /**< 检查值是否可行，返回此次输入是否允许，@""会解析成0 */

@property (nonatomic, copy) NSString *(^prompt)(NSString *max, NSString *min, NSString *moq);  /**< 返回提示文案，谁有值说明要提示谁，返回@""则不弹出提示 */

@end

@implementation JFDecimalKeyboardView

+ (void)display:(void(^)(JFDecimalKeyboardView *decimalView))initSet
         prompt:(NSString *(^)(NSString *max, NSString *min, NSString *moq))prompt
          check:(BOOL(^)(NSDecimalNumber *futureDecimal))check
           done:(BOOL(^)(NSDecimalNumber *decimal))done
           hide:(BOOL(^)(NSDecimalNumber *decimal, BOOL activeHide))hide {
    JFDecimalKeyboardView *lastKeyboard = [self displayingKeyboard];
    if (lastKeyboard) [lastKeyboard onHide:NO active:NO];
    NSTimeInterval delay = lastKeyboard ? 0.3 : 0;
    JFDecimalKeyboardView *decimalView = [[JFDecimalKeyboardView alloc] init];
    [decimalView initProperty];
    if (initSet) initSet(decimalView);
    [decimalView checkSet];
    [decimalView interface];
    decimalView.prompt = prompt;
    decimalView.check = check;
    decimalView.done = done;
    decimalView.hide = hide;
    [decimalView performSelector:@selector(onShow) withObject:nil afterDelay:delay];  //暂时未处理还有在等待中没显示的没给他移除
}

+ (void)display:(void(^)(JFDecimalKeyboardView *decimalView))initSet
         prompt:(NSString *(^)(NSString *max, NSString *min, NSString *moq))prompt
           done:(BOOL(^)(NSDecimalNumber *decimal))done {
    [self display:initSet prompt:prompt check:nil done:done hide:nil];
}

+ (JFDecimalKeyboardView *)displayingKeyboard {
    JFDecimalKeyboardView *oldview = nil;
    NSArray *subviews = [UIApplication sharedApplication].delegate.window.subviews;
    for (UIView *view in subviews) {
        if ([view isMemberOfClass:self]) {
            oldview = (JFDecimalKeyboardView *)view;
            break;
        }
    }
    return oldview;
}

+ (void)dismissKeyboard {
    JFDecimalKeyboardView *current = [self displayingKeyboard];
    if (current) [current onHide:NO active:NO];
}

#pragma mark - Instace
- (void)initProperty {
    self.dot = @".";
    self.maskHide = NO;
    self.maskClear = NO;
    self.midwayCheck = NO;
    self.forbidPaste = NO;
    self.showMistakeTip = YES;
    self.canonicalInput = YES;
    self.doneTitle = NSLocalizedString(@"确定", nil);
    self.hideTitle = NSLocalizedString(@"隐藏", nil);
    self.holderText = @"";
    self.clearText = @"";
    self.decimal = 2;
    self.maxNumber = [NSDecimalNumber nOne];
    self.minNumber = [NSDecimalNumber nOne];
    self.moqNumber = [NSDecimalNumber nOne];
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wnonnull"
     self.number = nil;
    #pragma clang diagnostic pop
}

- (void)checkSet {
    if (self.decimal > 6) {self.decimal = 6; NSAssert(0, @"decimal keyboard set mistake");}
    if (!self.doneTitle.length) {self.doneTitle = NSLocalizedString(@"确定", nil); NSAssert(0, @"decimal keyboard set mistake");}
    if (!self.hideTitle.length) {self.hideTitle = NSLocalizedString(@"隐藏", nil); NSAssert(0, @"decimal keyboard set mistake");}
    if (!self.clearText || (self.clearText.length && ![self.clearText isPureInteger] && ![self.clearText isPureFloat])) {
        self.clearText = @""; NSAssert(0, @"decimal keyboard set mistake");
    }
    if ((self.number == [NSDecimalNumber notANumber]) || (self.number && [self.number less:[NSDecimalNumber zero]])) {
        self.number = [NSDecimalNumber zero]; NSAssert(0, @"decimal keyboard set mistake");
    }
    if (!self.maxNumber || (self.maxNumber == [NSDecimalNumber notANumber]) ||
        (![self.maxNumber equal:[NSDecimalNumber nOne]] && [self.maxNumber less:[NSDecimalNumber zero]])) {
        self.maxNumber = [NSDecimalNumber nOne]; NSAssert(0, @"decimal keyboard set mistake");
    }
    if (!self.minNumber || (self.minNumber == [NSDecimalNumber notANumber]) ||
        (![self.minNumber equal:[NSDecimalNumber nOne]] && [self.minNumber less:[NSDecimalNumber zero]])) {
        self.minNumber = [NSDecimalNumber nOne]; NSAssert(0, @"decimal keyboard set mistake");
    }
    if (!self.moqNumber || (self.moqNumber == [NSDecimalNumber notANumber]) ||
        (![self.moqNumber equal:[NSDecimalNumber nOne]] && [self.moqNumber less:[NSDecimalNumber zero]])) {
        self.moqNumber = [NSDecimalNumber nOne]; NSAssert(0, @"decimal keyboard set mistake");
    }
}

- (void)interface {
    CGFloat contentHei = 0.75 * ZSWid;
    CGFloat itemHei = contentHei / 5.0;
    CGFloat itemWid = ZSWid / 4.0;
    contentHei = contentHei + ZSBomResHei;
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, ZSWid, ZSHei + contentHei);
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZSWid, ZSHei)];
    self.maskView.backgroundColor = self.maskClear ? [UIColor clearColor] : [ZCRGB(0x000000) colorWithAlphaComponent:0.3];
    [self addSubview:self.maskView];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    self.visualView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.visualView.frame = CGRectMake(0, ZSHei, ZSWid, contentHei);
    self.visualView.backgroundColor = [UIColor clearColor];
    self.visualView.contentView.backgroundColor = [ZCRGB(0xffffff) colorWithAlphaComponent:0.9];
    [self addSubview:self.visualView];
    
    self.fieldView = [[JFDecimalField alloc] initWithFrame:CGRectZero];
    self.fieldView.frame = CGRectMake(0, 0, ZSWid, itemHei);
    self.fieldView.inputView = [[UIView alloc] init];
    self.fieldView.inputAccessoryView = [[UIView alloc] init];
    self.fieldView.returnKeyType = UIReturnKeyDone;
    self.fieldView.isAllowPaste = !self.forbidPaste;
    self.fieldView.delegate = self;
    self.fieldView.font = ZCFont(18);
    self.fieldView.textColor = ZCRGB(0x313131);
    self.fieldView.tintColor = ZCRGB(0x23a363);
    self.fieldView.placeholder = self.holderText;
    self.fieldView.backgroundColor = [UIColor clearColor];
    self.fieldView.textAlignment = NSTextAlignmentLeft;
    self.fieldView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.fieldView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZSA(20), 0) color:[UIColor clearColor]];
    self.fieldView.rightView = [UIButton button:CGRectMake(0, 0, itemWid, itemHei) title:nil
                                          image:@"image_common_keyboard_clear" target:self action:@selector(onClear:)];
    self.fieldView.leftViewMode = UITextFieldViewModeAlways;
    self.fieldView.rightViewMode = UITextFieldViewModeAlways;
    self.fieldView.clearButtonMode = UITextFieldViewModeNever;
    [self.visualView.contentView addSubview:self.fieldView];
    [self onSeptal:self.fieldView right:NO bottom:YES];
    
    for (int i = 0; i < 12; i ++) {
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.frame = CGRectMake((i % 3) * itemWid, (i / 3 + 1) * itemHei, itemWid, itemHei);
        item.backgroundColor = [UIColor clearColor];
        item.titleLabel.font = ZCBoldFont(20);
        NSString *title = nil;
        if (i == 9) {title = self.decimal > 0 ? self.dot : @"";}
        else if (i == 10) {title = @"0";}
        else if (i == 11) {title = self.hideTitle; item.titleLabel.font = ZCFont(17);}
        else title = [NSString stringWithFormat:@"%d", (i + 1)];
        [item setTitle:title forState:UIControlStateNormal];
        [item setTitleColor:[((i == 11) ? ZCRGB(0x181818) : ZCRGB(0x313131)) colorWithAlphaComponent:1.0] forState:UIControlStateNormal];
        [item setTitleColor:[ZCRGB(0x313131) colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [item addTarget:self action:@selector(onItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.visualView.contentView addSubview:item];
        [self onSeptal:item right:YES bottom:YES];
    }
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    delete.frame = CGRectMake(3 * itemWid, itemHei, itemWid, 2 * itemHei);
    delete.backgroundColor = [UIColor clearColor];
    [delete setImage:ZCImage(@"image_common_keyboard_back") forState:UIControlStateNormal];
    [delete setImage:[ZCImage(@"image_common_keyboard_back") imageWithAlpha:0.3] forState:UIControlStateHighlighted];
    [delete addTarget:self action:@selector(onDelete:) forControlEvents:UIControlEventTouchUpInside];
    [self.visualView.contentView addSubview:delete];
    [self onSeptal:delete right:NO bottom:YES];
    
    UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
    done.frame = CGRectMake(3 * itemWid, 3 * itemHei, itemWid, 2 * itemHei);
    done.backgroundColor = ZCRGB(0x23a363);
    done.titleLabel.font = ZCBoldFont(18);
    [done setTitle:self.doneTitle forState:UIControlStateNormal];
    [done setTitleColor:[ZCRGB(0xffffff) colorWithAlphaComponent:1.0] forState:UIControlStateNormal];
    [done setTitleColor:[ZCRGB(0xffffff) colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
    [done addTarget:self action:@selector(onDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.visualView.contentView addSubview:done];
    [self onSeptal:done right:NO bottom:YES];
}

- (void)onShow {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    self.fieldView.text = !self.number ? @"" : [self.number stringValue];
    self.alpha = 0;
    [UIView animateWithDuration:0.28 animations:^{
        self.top = -self.visualView.height;
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.top = -self.visualView.height;
        self.alpha = 1.0;
        [self.fieldView becomeFirstResponder];
    }];
}

- (void)onHide:(BOOL)done active:(BOOL)active {
    BOOL isCanHide = YES;
    if (!done) {
        NSString *text = [self.fieldView.text copy];
        NSString *format = [self format:text];
        if (self.hide) isCanHide = self.hide([NSDecimalNumber decimalString:format], active);
    }
    if (isCanHide) {
        if (self.done) self.done = nil;
        if (self.hide) self.hide = nil;
        if (self.check) self.check = nil;
        if (self.prompt) self.prompt = nil;
        [UIView animateWithDuration:0.28 animations:^{
            self.top = 0;
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self.fieldView resignFirstResponder];
            [self.visualView.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.visualView removeFromSuperview];
            [self.maskView removeFromSuperview];
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - Misc
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.maskHide) {
        UITouch *touch = touches.anyObject;
        CGPoint point = [touch locationInView:self];
        if (CGRectContainsPoint(self.maskView.frame, point)) {
            [self onHide:NO active:NO];
        }
    }
}

- (void)onSeptal:(UIView *)view right:(BOOL)right bottom:(BOOL)bottom {
    CGFloat sepline = (1.0 / [UIScreen mainScreen].scale);
    if (right) {
        [view addSubview:[[UIView alloc] initWithFrame:CGRectMake(view.width - sepline, 0, sepline, view.height) color:ZCRGB(0xc9c9c9)]];
    }
    if (bottom) {
        [view addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, view.height - sepline, view.width, sepline) color:ZCRGB(0xc9c9c9)]];
    }
}

- (NSString *)format:(NSString *)str {
    double doubleValue = [str doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", doubleValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

- (BOOL)isNotNumberStr:(NSString *)str {
    return (str.length && ![str isEqualToString:self.dot] && ![str isPureFloat] && ![str isPureInteger]);
}

- (NSString *)canonical:(NSString *)str origin:(NSString *)org {  //格式化 .2 002 00.1 0.222 输入过程中检查是否超出范围
    if (!self.canonicalInput || !str.length) return str;
    if ([str containsString:self.dot]) {
        NSRange range = [str rangeOfString:self.dot];
        if ((str.length > self.decimal + 1) && (range.location < str.length - self.decimal - 1)) return org;
        if ([str hasPrefix:@"0"] && str.length > 1 && ![str hasPrefix:[NSString stringWithFormat:@"0%@", self.dot]]) return [self format:str];
        if ([str hasPrefix:self.dot] && str.length > 1) return [self format:str];
    } else {
        if ([str hasPrefix:@"0"] && str.length > 1) return [self format:str];
    }
    return str;
}

- (void)str:(NSString *)str muStr:(NSString *)muStr start:(UITextPosition *)start off:(NSInteger)off dir:(UITextLayoutDirection)dir last:(BOOL)last {
    BOOL allowInput = YES;
    NSString *final = [self canonical:muStr origin:str];
    if (self.midwayCheck) allowInput = [self checkMax:final];
    if (allowInput && self.check) allowInput = self.check([NSDecimalNumber decimalString:final]);
    if (allowInput) {
        self.fieldView.text = final;
        if (last) {
            self.fieldView.selectedTextRange = [self.fieldView textRangeFromPosition:self.fieldView.endOfDocument toPosition:self.fieldView.endOfDocument];
        } else if (final.length == str.length) {
            //不动
        } else if ([final isEqualToString:muStr]) {
            UITextPosition *end = [self.fieldView positionFromPosition:start inDirection:dir offset:off];
            self.fieldView.selectedTextRange = [self.fieldView textRangeFromPosition:end toPosition:end];
        } else {
            self.fieldView.selectedTextRange = [self.fieldView textRangeFromPosition:self.fieldView.endOfDocument toPosition:self.fieldView.endOfDocument];
        }
    }
}

- (BOOL)checkMax:(NSString *)final {
    NSString *tip = nil;
    NSDecimalNumber *decimal = [NSDecimalNumber decimalString:final];
    if (![self.maxNumber equal:[NSDecimalNumber nOne]] && [decimal more:self.maxNumber]) {
        if (self.prompt) tip = self.prompt([self.maxNumber stringValue], nil, nil);
        if (!tip) tip = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"最大值为", nil), [self.maxNumber stringValue]];
        if (tip && tip.length) [self.window showToastWithTip:tip];
        return NO;
    }
    if (![self.moqNumber equal:[NSDecimalNumber nOne]] && [decimal less:self.moqNumber]) {
        if (self.prompt) tip = self.prompt(nil, nil, [self.moqNumber stringValue]);
        if (!tip) tip = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"起订量为", nil), [self.moqNumber stringValue]];
        if (tip && tip.length) [self.window showToastWithTip:tip];
        return NO;
    }
    if (![self.minNumber equal:[NSDecimalNumber nOne]] && [decimal less:self.minNumber]) {
        if (self.prompt) tip = self.prompt(nil, [self.minNumber stringValue], nil);
        if (!tip) tip = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"最小值为", nil), [self.minNumber stringValue]];
        if (tip && tip.length) [self.window showToastWithTip:tip];
        return NO;
    }
    return YES;
}

#pragma mark - Action
- (void)onItem:(UIButton *)item {
    NSString *title = item.titleLabel.text;
    if ([title isEqualToString:self.hideTitle]) {
        [self onHide:NO active:YES];
    } else if ([title isEqualToString:self.dot]) {
        [self onDecimal];
    } else {
        [self onNumber:title];
    }
}

- (void)onNumber:(NSString *)numStr {
    if (numStr.length == 0) return;
    UITextPosition *beginning = self.fieldView.beginningOfDocument;
    UITextRange *selectedRange = self.fieldView.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    NSInteger location = [self.fieldView offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self.fieldView offsetFromPosition:selectionStart toPosition:selectionEnd];
    NSString *str = [self.fieldView.text copy];
    NSMutableString *muStr = [[NSMutableString alloc] initWithString:str];
    [muStr replaceCharactersInRange:NSMakeRange(location, length) withString:numStr];
    [self str:str muStr:muStr start:selectionStart off:1 dir:UITextLayoutDirectionRight last:NO];
}

- (void)onDecimal {
    if (self.decimal == 0) return;
    UITextPosition *beginning = self.fieldView.beginningOfDocument;
    UITextRange *selectedRange = self.fieldView.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    NSInteger location = [self.fieldView offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self.fieldView offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    NSString *str = [self.fieldView.text copy];
    NSMutableString *muStr = [[NSMutableString alloc] initWithString:str];
    [muStr replaceCharactersInRange:NSMakeRange(location, length) withString:self.dot];
    if ([self isNotNumberStr:muStr]) return;
    [self str:str muStr:muStr start:selectionStart off:1 dir:UITextLayoutDirectionRight last:NO];
}

- (void)onDelete:(UIButton *)item {
    if (self.fieldView.text.length == 0) return;
    UITextRange *selectedRange = self.fieldView.selectedTextRange;
    UITextPosition *beginning = self.fieldView.beginningOfDocument;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    NSInteger location = [self.fieldView offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self.fieldView offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    NSString *str = [self.fieldView.text copy];
    if (location == 0 && length == 0) return;
    NSMutableString *muStr = [[NSMutableString alloc] initWithString:str];
    if (length == 0) [muStr deleteCharactersInRange:NSMakeRange(location - 1, 1)];
    else [muStr deleteCharactersInRange:NSMakeRange(location, length)];
    [self str:str muStr:muStr start:selectionStart off:(length == 0 ? 1 : 0) dir:UITextLayoutDirectionLeft last:NO];
}

- (void)onDone:(UIButton *)item {
    NSString *text = [self.fieldView.text copy];
    BOOL mistakeInput = (!text.length || [text isEqualToString:self.dot]);  //只有一个.时、或者只为@""时 不显示tip时都校验成0，且键盘不收起，不触发回调
    if (self.showMistakeTip && mistakeInput) {[self.window showToastWithTip:NSLocalizedString(@"请正确输入！", nil)]; return;}
    NSString *format = [self format:text];
    if (![text isEqualToString:format]) {
        self.fieldView.text = format;
        self.fieldView.selectedTextRange = [self.fieldView textRangeFromPosition:self.fieldView.endOfDocument toPosition:self.fieldView.endOfDocument];
    }
    if (!self.showMistakeTip && mistakeInput) return;
    BOOL hideKeyboard = [self checkMax:format];
    if (hideKeyboard && self.done) hideKeyboard = self.done([NSDecimalNumber decimalString:format]);
    if (hideKeyboard) [self onHide:YES active:YES];
}

- (void)onClear:(UIButton *)sender {
    self.fieldView.text = self.clearText;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string) string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];  //首位空格
    if (!string.length) return NO;
    UITextPosition *start = textField.selectedTextRange.end;  //粘贴
    NSString *str = [textField.text copy];
    NSMutableString *muStr = [[NSMutableString alloc] initWithString:str];
    [muStr replaceCharactersInRange:range withString:string];
    if ([self isNotNumberStr:muStr]) return NO;
    [self str:str muStr:muStr start:start off:0 dir:UITextLayoutDirectionRight last:YES];  //粘贴完成位置移到最后
    return NO;
}

@end
