//
//  JFIncrControl.m
//  ZCKit
//
//  Created by zjy on 2018/6/4.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFIncrControl.h"
#import "JFDecimalKeyboardView.h"

#define incr_log_check           NO
#define incr_red_color           ZCRGB(0xff0000)  /**< 红色 */
#define incr_normal_color        ZCRGB(0x333333)  /**< 灰色 */
#define incr_disable_color       ZCRGB(0xcacaca)  /**< 失效色 */
#define incr_tint_color          ZCRGB(0x4ab620)  /**< 光标颜色 */
#define incr_line_color          ZCRGB(0xdcdcdc)  /**< 线颜色 */
#define incr_disable_line_color  ZCRGB(0xececec)  /**< 失效线色 */

typedef NS_ENUM (NSInteger, JFEnumIncrItemState) {
    JFEnumIncrItemStateNormal  = 0,   /**< 通常状态 */
    JFEnumIncrItemStateWarning = 1,   /**< 警告状态 */
    JFEnumIncrItemStateDisable = 2,   /**< 失效状态，灰色，不可点击 */
    JFEnumIncrItemStateInvalid = 3,   /**< 无效状态，不是灰色，但是也不可点击 */
};


#pragma mark - Protocol - JFIncrItemProtocol
@protocol JFIncrItemProtocol <NSObject>

@property (nonatomic, assign) JFEnumIncrItemState itemState;  /**< 默认点击状态，默认JFIncrButtonStateNormal状态 */

@property (nonatomic, assign) JFEnumIncrControlStyle itemStyle;  /**< 默认JFEnumIncrControlStyleNormal风格 */

@property (nonatomic, assign, readonly) JFEnumIncrControlType itemType;  /**< 默认JFEnumIncrControlTypeGray类型 */

@end


#pragma mark - Class - JFIncrField
@interface JFIncrField : UITextField <JFIncrItemProtocol>

@property (nonatomic, assign) BOOL forbidVisibleMenu;   /**< 是否禁止长按弹出菜单框，默认NO，不禁止 */

@property (nonatomic, strong, readonly) NSArray <UIColor *>*stateColors;  /**< 根据ControlType状态得到的TextColor */

@property (nonatomic, strong, readonly) NSArray <NSArray < NSArray <UIColor *>*>*>*itemColorMapping;  /**< ControlType状态和TextColor映射 */

@end

@implementation JFIncrField

@synthesize itemState = _itemState, itemType = _itemType, itemStyle = _itemStyle;

#pragma mark - State
- (instancetype)initWithFrame:(CGRect)frame style:(JFEnumIncrControlStyle)style type:(JFEnumIncrControlType)type {
    if (self = [super initWithFrame:frame]) {
        _itemType = type;   /**< 1.normal 2.warning 3.disable */
        _itemColorMapping = @[@[@[incr_normal_color, incr_normal_color, incr_disable_color],
                                @[incr_normal_color, incr_normal_color, incr_disable_color],
                                @[incr_red_color, incr_red_color, incr_disable_color],
                                @[incr_normal_color, incr_normal_color, incr_disable_color]],
                              @[@[incr_normal_color, incr_normal_color, incr_disable_color],
                                @[incr_normal_color, incr_normal_color, incr_disable_color],
                                @[incr_red_color, incr_red_color, incr_disable_color],
                                @[incr_normal_color, incr_normal_color, incr_disable_color]]];
        self.itemStyle = style;
        self.itemState = JFEnumIncrItemStateNormal;
    }
    return self;
}

- (void)setItemStyle:(JFEnumIncrControlStyle)itemStyle {
    _itemStyle = itemStyle;
    _stateColors = [[_itemColorMapping objectAtIndex:_itemStyle] objectAtIndex:_itemType];
}

- (void)setItemState:(JFEnumIncrItemState)itemState {
    _itemState = itemState;
    switch (itemState) {
        case JFEnumIncrItemStateNormal:{
            self.userInteractionEnabled = YES;
            self.textColor = self.stateColors[itemState];
        } break;
        case JFEnumIncrItemStateWarning:{
            self.userInteractionEnabled = YES;
            self.textColor = self.stateColors[itemState];
        } break;
        case JFEnumIncrItemStateDisable:{
            self.userInteractionEnabled = NO;
            self.textColor = self.stateColors[itemState];
        } break;
        case JFEnumIncrItemStateInvalid:{
            self.userInteractionEnabled = NO;
        } break;
    }
}

#pragma mark - Touch
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.forbidVisibleMenu) {
        if ([UIMenuController sharedMenuController]) {
            [UIMenuController sharedMenuController].menuVisible = NO;
        }
        return NO;
    } else {
        return [super canPerformAction:action withSender:sender];
    }
}

@end


#pragma mark - Class - JFIncrButton
@interface JFIncrButton : ZCButton <JFIncrItemProtocol>

@property (nonatomic, assign) NSTimeInterval myMinimumTouchInterval;  /**< 用这个给重复点击加间隔，默认0.2s，小于等于0时也为默认值 */

@property (nonatomic, assign, readonly) BOOL myIsIgnoreTouch;  /**< YES不允许点击，NO允许点击 */

@property (nonatomic, strong, readonly) NSArray <UIImage *>*stateImages;  /**< 0.normal 1.warning 2.disable 3.norHig 4.warHig */

@property (nonatomic, strong, readonly) NSArray <NSArray <NSArray <NSString *>*>*>*itemImageMapping;  /**< ControlType状态和TextColor映射 */

@end

@implementation JFIncrButton

@synthesize itemState = _itemState, itemType = _itemType, itemStyle = _itemStyle;

#pragma mark - State
- (instancetype)initWithFrame:(CGRect)frame style:(JFEnumIncrControlStyle)style type:(JFEnumIncrControlType)type incr:(BOOL)incr {
    if (self = [super initWithFrame:frame]) {
        _myIsIgnoreTouch = NO;
        _myMinimumTouchInterval = 0.2;
        _itemType = type;
        if (incr) {   /**< 1.normal 2.warning 3.disable */
            _itemImageMapping = @[@[@[@"image_common_incr_gray", @"image_common_incr_warn", @"image_common_incr_gray"],
                                    @[@"image_common_incr_cyan", @"image_common_incr_warn", @"image_common_incr_gray"],
                                    @[@"image_common_incr_warn", @"image_common_incr_warn", @"image_common_incr_gray"],
                                    @[@"image_common_incr_arrow"]],
                                  @[@[@"image_common_plus"],
                                    @[@"image_common_incr_cyan", @"image_common_incr_warn"],
                                    @[@"image_common_incr_warn", @"image_common_incr_warn"],
                                    @[@"image_common_incr_arrow"]]];
        } else {
            _itemImageMapping = @[@[@[@"image_common_decr_gray", @"image_common_decr_warn", @"image_common_decr_gray"],
                                    @[@"image_common_decr_cyan", @"image_common_decr_warn", @"image_common_decr_gray"],
                                    @[@"image_common_decr_warn", @"image_common_decr_warn", @"image_common_decr_gray"],
                                    @[@"image_common_decr_arrow"]],
                                  @[@[@"image_common_minus"],
                                    @[@"image_common_decr_cyan", @"image_common_decr_warn"],
                                    @[@"image_common_decr_warn", @"image_common_decr_warn"],
                                    @[@"image_common_decr_arrow"]]];
        }
        self.itemStyle = style;
        self.itemState = JFEnumIncrItemStateNormal;
    }
    return self;
}

- (void)setItemStyle:(JFEnumIncrControlStyle)itemStyle {
    _itemStyle = itemStyle;
    NSMutableArray <UIImage *>*images = [NSMutableArray array];
    NSArray *mapping = [[_itemImageMapping objectAtIndex:_itemStyle] objectAtIndex:_itemType];
    for (int i = 0; i < 5; i ++) {
        if (i == 0) [images addObject:ZCImage(mapping[i])];
        else if (i == 1) {
            if (mapping.count > 1) {
                [images addObject:ZCImage(mapping[i])];
            } else {
                [images addObject:[images[0] imageToColor:incr_red_color alpha:1]];
            }
        } else if (i == 2) {
            if (mapping.count > 2) {
                if ([mapping[i] isEqualToString:@"image_common_incr_gray"] || [mapping[i] isEqualToString:@"image_common_decr_gray"]) {
                    [images addObject:[ZCImage(mapping[i]) imageWithAlpha:0.6]];
                } else {
                    [images addObject:ZCImage(mapping[i])];
                }
            } else {
                [images addObject:[images[0] imageToColor:incr_disable_color alpha:1]];
            }
        } else if (i == 3) {
            [images addObject:[images[0] imageWithAlpha:0.3]];
        } else {
            [images addObject:[images[1] imageWithAlpha:0.3]];
        }
    }
    _stateImages = images;
}

- (void)setItemState:(JFEnumIncrItemState)itemState {
    _itemState = itemState;
    switch (itemState) {
        case JFEnumIncrItemStateNormal:{
            [self setImage:_stateImages[0] forState:UIControlStateNormal];
            [self setImage:_stateImages[3] forState:UIControlStateHighlighted];
            self.userInteractionEnabled = YES;
        } break;
        case JFEnumIncrItemStateWarning:{
            [self setImage:_stateImages[1] forState:UIControlStateNormal];
            [self setImage:_stateImages[4] forState:UIControlStateHighlighted];
            self.userInteractionEnabled = YES;
        } break;
        case JFEnumIncrItemStateDisable:{
            [self setImage:_stateImages[2] forState:UIControlStateNormal];
            [self setImage:_stateImages[2] forState:UIControlStateHighlighted];
            self.userInteractionEnabled = NO;
        } break;
        case JFEnumIncrItemStateInvalid:{   //此状态只印象是否可交互
            self.userInteractionEnabled = NO;
        } break;
    }
}

#pragma mark - Touch
- (void)resetIgnoreTouchState {
    _myIsIgnoreTouch = NO;
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (_myMinimumTouchInterval <= 0) {
        [super sendAction:action to:target forEvent:event];
    } else {
        if (_myIsIgnoreTouch) return;
        _myIsIgnoreTouch = YES;
        [self performSelector:@selector(resetIgnoreTouchState) withObject:nil afterDelay:_myMinimumTouchInterval];
        [super sendAction:action to:target forEvent:event];
    }
}

@end


#pragma mark - Class - JFIncrControl
@interface JFIncrControl () <UITextFieldDelegate> {
    short _length;
    short _decimal;
    BOOL _isEfcSec;
    BOOL _isCancel;
    BOOL _isIncrWarning;
    BOOL _isDecrWarning;
    BOOL _isIncrDisable;
    BOOL _isDecrDisable;
    BOOL _displayingKeykoard;
    float _incr_hei_wid;
    float _incr_whole_hei;
    JFEnumIncrControlType _type;
    NSTimeInterval _aTime;
    NSDecimalNumber *_zero;
    NSDecimalNumber *_nOne;
    NSDecimalNumber *_maxCalValue;
    NSDecimalNumber *_minCalValue;
    NSDecimalNumber *_originMinValue;
    NSDecimalNumber *_originMaxValue;
    NSDecimalNumber *_originBisValue;
}

@property (nonatomic, strong) UIView *signLine;

@property (nonatomic, strong) UILabel *unitLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *decrline;

@property (nonatomic, strong) UIView *incrline;

@property (nonatomic, strong) UIControl *accessMask;

@property (nonatomic, strong) JFIncrField *inputField;

@property (nonatomic, strong) JFIncrButton *incrButton;

@property (nonatomic, strong) JFIncrButton *decrButton;

@property (nonatomic, strong) NSDecimalNumber *recordNumber;

@end

@implementation JFIncrControl

#pragma mark - Init
- (instancetype)initWithType:(JFEnumIncrControlType)type length:(short)length decimal:(short)decimal {
    if (self = [super initWithFrame:CGRectZero]) {
        _type = type;
        _length = length > 0 ? length : 7;
        _decimal = decimal < 0 ? 0 : (decimal < length ? decimal : (length - 1));
        [self initialDefault];
        [self initInterface];
        [self initVariable];
        [self initProperty];
    }
    return self;
}

- (void)initialDefault {
    _aTime = 0.35;
    _isEfcSec = NO;
    _isCancel = NO;
    _hiddenText = NO;
    _hiddenLine = NO;
    _autoDisable = NO;
    _dynamicSize = NO;
    _disableState = NO;
    _disableInput = NO;
    _isIncrWarning = NO;
    _isDecrWarning = NO;
    _isIncrDisable = NO;
    _isDecrDisable = NO;
    _interceptTouch = NO;
    _decimalKeyboard = NO;
    _disableAutoCancel = NO;
    _displayingKeykoard = NO;
    _numberAutoAdaption = NO;
    _numberAutoValidate = NO;
    _numberAutoThreshold = NO;
    _keyboardDoneValidate = NO;
    _keyboardPeripheryHide = NO;
    _fontUnitSize = 14;
    _fontTextSize = 12;
    _incr_hei_wid = ZSA(25);
    _incr_whole_hei = ZSA(40);
    _minClickInterval = 0.35;
    _defaultSize = CGSizeZero;
    _zero = [NSDecimalNumber zero];
    _nOne = [NSDecimalNumber nOne];
    _warningSection = @[_zero, _zero];
    _style = JFEnumIncrControlStyleNormal;
}

- (void)initVariable {
    _basisOrder = _zero;
    _originBisValue = _zero;
    _minOrder = _zero;
    _originMinValue = _zero;
    _minCalValue = [[NSDecimalNumber one] mltiplyPower10:(-_decimal)];
    _maxCalValue = [[[NSDecimalNumber one] mltiplyPower10:(_length - _decimal)] minus:_minCalValue];
    _stepOrder = _minCalValue;
    _maxOrder = _maxCalValue;
    _originMaxValue = _maxCalValue;
}

- (void)initProperty {
    self.number = _zero;
    self.clipsToBounds = YES;
    [self matchKeyboardType];
    [self resetSize];
}

- (void)initInterface {
    self.unitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.unitLabel.font = ZCFont(self.fontUnitSize);
    self.unitLabel.textColor = [self textDecideColor];
    self.unitLabel.text = self.unit;
    [self.unitLabel sizeToFit];
    [self addSubview:self.unitLabel];

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = ZCFont(self.fontUnitSize);
    self.titleLabel.textColor = [self textDecideColor];
    self.titleLabel.text = self.title;
    [self.titleLabel sizeToFit];
    [self addSubview:self.titleLabel];

    self.incrButton = [[JFIncrButton alloc] initWithFrame:CGRectZero style:self.style type:_type incr:YES];
    self.incrButton.frame = CGRectMake(0, 0, _incr_hei_wid, _incr_hei_wid);
    self.incrButton.responseAreaExtend = UIEdgeInsetsMake(ZSA(8), 0, ZSA(8), ZSA(15));
    self.incrButton.myMinimumTouchInterval = self.minClickInterval;
    self.incrButton.backgroundColor = [UIColor clearColor];
    [self.incrButton setTitle:nil forState:UIControlStateNormal];
    [self.incrButton addTarget:self action:@selector(onIncrease:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.incrButton];

    self.decrButton = [[JFIncrButton alloc] initWithFrame:CGRectZero style:self.style type:_type incr:NO];
    self.decrButton.frame = CGRectMake(0, 0, _incr_hei_wid, _incr_hei_wid);
    self.decrButton.responseAreaExtend = UIEdgeInsetsMake(ZSA(8), ZSA(15), ZSA(8), 0);
    self.decrButton.myMinimumTouchInterval = self.minClickInterval;
    self.decrButton.backgroundColor = [UIColor clearColor];
    [self.decrButton setTitle:nil forState:UIControlStateNormal];
    [self.decrButton addTarget:self action:@selector(onDecrease:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.decrButton];

    self.inputField = [[JFIncrField alloc] initWithFrame:CGRectMake(0, 0, 0, _incr_hei_wid) style:self.style type:_type];
    self.inputField.forbidVisibleMenu = YES;
    self.inputField.returnKeyType = UIReturnKeyDone;
    self.inputField.delegate = self;
    self.inputField.tintColor = incr_tint_color;
    self.inputField.textAlignment = NSTextAlignmentCenter;
    self.inputField.font = ZCFont(self.fontTextSize);
    [self addSubview:self.inputField];

    self.signLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, ZSSepHei)];
    self.signLine.backgroundColor = [self lineDecideColor];
    [self addSubview:self.signLine];
    [self bringSubviewToFront:self.incrButton];
}

#pragma mark - Sys
- (BOOL)canBecomeFirstResponder {
    return [self.inputField canBecomeFirstResponder];
}

- (BOOL)becomeFirstResponder {
    return [self.inputField becomeFirstResponder];
}

- (BOOL)canResignFirstResponder {
    return [self.inputField canResignFirstResponder];
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    return [self.inputField resignFirstResponder];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return CGRectContainsPoint(CGRectInset(self.bounds, ZSA(-15), ZSA(-5)), point);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.interceptTouch) {
        [super touchesBegan:touches withEvent:event];
    } else {
        CGPoint point = [[touches anyObject] locationInView:self];
        CGRect rect = CGRectZero;
        if (self.hiddenText) {
            rect = CGRectInset(self.incrButton.frame, ZSA(-8), ZSA(-8));
        } else {
            rect = self.bounds;
        }
        if (CGRectContainsPoint(rect, point) == NO) {
            [super touchesBegan:touches withEvent:event];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.width;
    CGFloat offset = self.hiddenText ? (width - self.incrButton.width) : 0;
    if (ZCStrIsValid(self.unit)) width = width - self.unitLabel.width - ZSA(4);
    if (ZCStrIsValid(self.title)) width = width + self.titleLabel.width + ZSA(4);
    self.inputField.centerX = width / 2.0 + offset;
    self.incrButton.centerY = self.height / 2.0;
    self.decrButton.centerY = self.incrButton.centerY;
    self.inputField.centerY = self.incrButton.centerY;
    self.unitLabel.centerY = self.incrButton.centerY;
    self.titleLabel.centerY = self.incrButton.centerY;
    self.incrButton.left = self.inputField.right + ZSA(2) - offset;
    self.decrButton.right = self.inputField.left - ZSA(2);
    self.unitLabel.left = self.incrButton.right + ZSA(4);
    self.titleLabel.right = self.decrButton.left - ZSA(4);
    self.signLine.width = self.inputField.width - ZSA(3);
    self.signLine.centerX = self.inputField.centerX;
    self.signLine.top = self.inputField.bottom - ZSA(3 - (self.fontTextSize - 12.0) / 2.0);
    _incrline.left = 0;
    _incrline.centerY = self.incrButton.height / 2.0;
    _decrline.right = self.decrButton.width;
    _decrline.centerY = self.decrButton.height / 2.0;
}

- (CGSize)sizeThatFits:(CGSize)size {
    BOOL isCustomSize = CGSizeEqualToSize(self.defaultSize, CGSizeZero);
    if (isCustomSize) {
        CGFloat element = 8.0 / 11.0 * self.fontTextSize;
        if (self.dynamicSize) {
            CGFloat width = [self.text widthForFont:self.inputField.font];
            self.inputField.width = MAX(ZSA(element * 3 + ([self.stepOrder floatValue] < 1 ? 6 : 2)), width + 6);
        } else {
            self.inputField.width = ZSA(element * _length + ([self.minOrder floatValue] < 0 ? 6 : 2));
        }
        CGFloat width = ZSA(4) + self.incrButton.width + self.decrButton.width + self.inputField.width;
        if (ZCStrIsValid(self.unit)) {
            width = width + self.unitLabel.width + ZSA(4);
        }
        if (ZCStrIsValid(self.title)) {
            width = width + self.titleLabel.width + ZSA(4);
        }
        return CGSizeMake(width, _incr_whole_hei);
    } else {
        CGFloat width = self.defaultSize.width - ZSA(4) - self.incrButton.width - self.decrButton.width;
        if (ZCStrIsValid(self.unit)) {
            width = width - self.unitLabel.width - ZSA(4);
        }
        if (ZCStrIsValid(self.title)) {
            width = width - self.titleLabel.width - ZSA(4);
        }
        self.inputField.width = width;
        return self.defaultSize;
    }
}

#pragma mark - Get
- (UIView *)incrline {
    if (!_incrline) {
        _incrline = [[UIView alloc] initWithFrame:CGRectZero color:[self lineDecideColor]];
        _incrline.width = ZSSepHei;
    }
    return _incrline;
}

- (UIView *)decrline {
    if (!_decrline) {
        _decrline = [[UIView alloc] initWithFrame:CGRectZero color:[self lineDecideColor]];
        _decrline.width = ZSSepHei;
    }
    return _decrline;
}

- (UIControl *)accessMask {
    if (self.disableAutoCancel) return nil;
    if (!_accessMask) {
        _accessMask = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds color:[UIColor clearColor]];
        [_accessMask addTarget:self action:@selector(onMaskCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accessMask;
}

- (UIColor *)lineDecideColor {
    return _disableState ? incr_disable_line_color : incr_line_color;
}

- (UIColor *)textDecideColor {
    return _disableState ? incr_disable_color : incr_normal_color;
}

#pragma mark - Set
- (void)setUnit:(NSString *)unit {
    BOOL change = [unit isEqualToString:_unit] == NO;
    _unit = unit;
    if (change) {
        _unitLabel.text = _unit;
        [_unitLabel sizeToFit];
        [self resetSize];
    }
}

- (void)setTitle:(NSString *)title {
    BOOL change = [title isEqualToString:_title] == NO;
    _title = title;
    if (change) {
        _titleLabel.text = _title;
        [_titleLabel sizeToFit];
        [self resetSize];
    }
}

- (void)setStyle:(JFEnumIncrControlStyle)style {
    BOOL change = style != _style;
    if (style != JFEnumIncrControlStyleNormal) self.hiddenLine = YES;
    _style = style;
    if (change) {
        [_incrline removeFromSuperview];
        [_decrline removeFromSuperview];
        _incrline = nil;
        _decrline = nil;
        switch (_style) {
            case JFEnumIncrControlStyleNormal:{
                _incrButton.size = CGSizeMake(_incr_hei_wid, _incr_hei_wid);
                _decrButton.size = CGSizeMake(_incr_hei_wid, _incr_hei_wid);
            } break;
            case JFEnumIncrControlStyleWindow:{
                _incrButton.size = CGSizeMake(self.height, self.height);
                _decrButton.size = CGSizeMake(self.height, self.height);
                [_incrButton addSubview:self.incrline];
                [_decrButton addSubview:self.decrline];
                self.incrline.height = _incrButton.height;
                self.decrline.height = _decrButton.height;
            } break;
        }
        _inputField.itemStyle = _style;
        _incrButton.itemStyle = _style;
        _decrButton.itemStyle = _style;
        [self decideBorderColor];
        [self decideItemState:nil];
        [self resetSize];
    }
}

- (void)setDefaultSize:(CGSize)defaultSize {
    BOOL change = CGSizeEqualToSize(defaultSize, _defaultSize) == NO;
    _defaultSize = defaultSize;
    if (change) {
        [self resetSize];
    }
}

- (void)setFontUnitSize:(float)fontUnitSize {
    BOOL change = ZFNotEqual(fontUnitSize, _fontUnitSize);
    _fontUnitSize = fontUnitSize;
    if (change) {
        _unitLabel.font = ZCFont(_fontUnitSize);
        _titleLabel.font = ZCFont(_fontUnitSize);
        [_unitLabel sizeToFit];
        [_titleLabel sizeToFit];
        [self resetSize];
    }
}

- (void)setFontTextSize:(float)fontTextSize {
    BOOL change = ZFNotEqual(fontTextSize, _fontTextSize);
    _fontTextSize = fontTextSize;
    if (change) {
        _inputField.font = ZCFont(_fontTextSize);
        [self resetSize];
    }
}

- (void)setMinClickInterval:(float)minClickInterval {
    BOOL change = ZFNotEqual(minClickInterval, _minClickInterval);
    _minClickInterval = minClickInterval;
    if (change) {
        _incrButton.myMinimumTouchInterval = _minClickInterval;
        _decrButton.myMinimumTouchInterval = _minClickInterval;
    }
}

- (void)setHiddenLine:(BOOL)hiddenLine {
    if (self.style != JFEnumIncrControlStyleNormal) return;
    _hiddenLine = hiddenLine;
    _signLine.hidden = _hiddenLine;
}

- (void)setHiddenText:(BOOL)hiddenText {
    [self setHiddenText:hiddenText animate:NO];
}

- (void)setDisableInput:(BOOL)disableInput {
    BOOL change = disableInput != _disableInput;
    _disableInput = disableInput;
    if (change) {
        [self decideItemState:_inputField];
    }
}

- (void)setDisableState:(BOOL)disableState {
    BOOL change = disableState != _disableState;
    _disableState = disableState;
    if (change) {
        _unitLabel.textColor = [self textDecideColor];
        _titleLabel.textColor = [self textDecideColor];
        _signLine.backgroundColor = [self lineDecideColor];
        _incrline.backgroundColor = [self lineDecideColor];
        _decrline.backgroundColor = [self lineDecideColor];
        [self decideBorderColor];
        [self decideItemState:nil];
    }
}

- (void)setAutoDisable:(BOOL)autoDisable {
    BOOL change = autoDisable != _autoDisable;
    _autoDisable = autoDisable;
    if (change) {
        [self checkDisable:change];
    }
}

- (void)setDynamicSize:(BOOL)dynamicSize {
    _dynamicSize = dynamicSize;
    [self resetSize];
}

#pragma mark - Set
- (void)setNumber:(NSDecimalNumber *)number {
    number = [self validateInvalidNumber:number];
    [self resetText:number];
    [self resetNumber];
}

- (void)setNumberAutoAdaption:(BOOL)numberAutoAdaption {
    BOOL change = numberAutoAdaption != _numberAutoAdaption;
    _numberAutoAdaption = numberAutoAdaption;
    if (change) {
        [self resetNumber];
    }
}

- (void)setNumberAutoValidate:(BOOL)numberAutoValidate {
    BOOL change = numberAutoValidate != _numberAutoValidate;
    _numberAutoValidate = numberAutoValidate;
    if (change) {
        [self validateBasisOrder];
        [self resetNumber];
    }
}

- (void)setNumberAutoThreshold:(BOOL)numberAutoThreshold {
    BOOL change = numberAutoThreshold != _numberAutoThreshold;
    _numberAutoThreshold = numberAutoThreshold;
    if (change) {
        [self validateMaxOrder];
        [self validateMinOrder];
        [self validateBasisOrder];
        [self resetNumber];
    }
}

- (void)setBasisOrder:(NSDecimalNumber *)basisOrder {
    _originBisValue = basisOrder;
    [self validateBasisOrder];
    [self resetNumber];
}

- (void)setStepOrder:(NSDecimalNumber *)stepOrder {
    _stepOrder = stepOrder;
    [self validateSatpOrder];
    [self validateMaxOrder];
    [self validateMinOrder];
    [self validateBasisOrder];
    [self resetNumber];
}

- (void)setMaxOrder:(NSDecimalNumber *)maxOrder {
    _originMaxValue = maxOrder;
    [self validateMaxOrder];
    [self validateSatpOrder];
    [self validateBasisOrder];
    [self resetNumber];
}

- (void)setMinOrder:(NSDecimalNumber *)minOrder {
    _originMinValue = minOrder;
    [self validateMinOrder];
    [self matchKeyboardType];
    [self validateSatpOrder];
    [self validateBasisOrder];
    [self resetNumber];
}

- (void)setWarningSection:(NSArray<NSDecimalNumber *> *)warningSection {
    if (!warningSection || warningSection.count != 2 || [warningSection.firstObject more:warningSection.lastObject]) {
        if (incr_log_check) {NSAssert(0, @"warning section is mistake");}
    } else if ([warningSection.firstObject equal:_warningSection.firstObject] == NO ||
               [warningSection.lastObject equal:_warningSection.lastObject] == NO) {
        BOOL isEfcSec = ([warningSection.firstObject equal:_zero] && [warningSection.lastObject equal:_zero]) == NO;
        BOOL change = isEfcSec != _isEfcSec;
        _isEfcSec = isEfcSec;
        _warningSection = warningSection;
        [self checkWarning:change];
    }
}

#pragma mark - Val
- (void)validateBasisOrder {
    if (_numberAutoValidate == NO) return;
    if ([_originBisValue less:_minOrder]) {
        if (incr_log_check) {NSLog(@"basis order is mistake");}
        _basisOrder = _minOrder;
    } else if ([_originBisValue more:_maxOrder]) {
        if (incr_log_check) {NSLog(@"basis order is mistake");}
        _basisOrder = _maxOrder;
    } else {
        if ([self isIntegerTypeForFloat:_originBisValue] == NO) {
            if (incr_log_check) {NSLog(@"basis order is mistake");}
            _basisOrder = [_originBisValue decimalRound:_decimal mode:ZCEnumRoundTypeUp];
        } else {
            _basisOrder = _originBisValue;
        }
    }
    [self fitBasisOrdur];
}

- (void)validateSatpOrder {
    if ([_stepOrder less:_minCalValue]) {
        if (incr_log_check) {NSLog(@"step order is mistake");}
        _stepOrder = _minCalValue;
    } else if ([_stepOrder more:_maxCalValue]) {
        if (incr_log_check) {NSLog(@"step order is mistake");}
        _stepOrder = _maxCalValue;
    } else {
        if ([self isIntegerTypeForFloat:_stepOrder] == NO) {
            if (incr_log_check) {NSLog(@"step order is mistake");}
            _stepOrder = [_stepOrder decimalRound:_decimal mode:ZCEnumRoundTypeUp];
        }
    }
    if ([_stepOrder equal:_zero]) {
        if (incr_log_check) {NSAssert(0, @"step order is mistake");}
        _stepOrder = [NSDecimalNumber one];
    }
}

- (void)validateMaxOrder {
    if ([self isIntegerTypeForFloat:_originMaxValue] == NO) {
        if (incr_log_check) {NSLog(@"max order is mistake");}
        _originMaxValue = [_originMaxValue decimalRound:_decimal mode:ZCEnumRoundTypeUp];
    }
    if ([_originMaxValue more:_maxCalValue]) {
        if (incr_log_check) {NSLog(@"max order is mistake");}
        _maxOrder = _maxCalValue;
    } else {
        _maxOrder = _originMaxValue;
    }
    [self fitMaxOrdur];
    if (_numberAutoAdaption == NO) {
        [self checkDisable:NO];
    }
}

- (void)validateMinOrder {
    if ([self isIntegerTypeForFloat:_originMinValue] == NO) {
        if (incr_log_check) {NSLog(@"min order is mistake");}
        _originMinValue = [_originMinValue decimalRound:_decimal mode:ZCEnumRoundTypeDown];
    }
    if ([_originMinValue less:[_maxCalValue mltiply:_nOne]]) {
        if (incr_log_check) {NSLog(@"min order is mistake");}
        _minOrder = [_maxCalValue mltiply:_nOne];
    } else {
        _minOrder = _originMinValue;
    }
    [self fitMinOrdur];
    if (_numberAutoAdaption == NO) {
        [self checkDisable:NO];
    }
}

- (void)validateBasisLogic {   //暂未调用
    if ([_minOrder more:_maxOrder]) {
        if (incr_log_check) {NSLog(@"max value less min value");}
        _maxOrder = [_minOrder plus:_stepOrder];
    }
    if (_numberAutoValidate && [_basisOrder more:_maxOrder]) {
        if (incr_log_check) {NSLog(@"max value less min value");}
        _maxOrder = _basisOrder;
    }
    if (_numberAutoValidate && [_basisOrder less:_minOrder]) {
        if (incr_log_check) {NSLog(@"max value less min value");}
        _basisOrder = _minOrder;
    }
}

- (BOOL)validateIsNumber:(NSString *)number {   //验证是否是数字类型 暂未调用
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (NSDecimalNumber *)validateInvalidNumber:(NSDecimalNumber *)number {
    if (!number || [number isKindOfClass:[NSDecimalNumber class]] == NO || [number isEqualToNumber:[NSDecimalNumber notANumber]]) {
        if (incr_log_check) {NSAssert(0, @"number is must valid");}
        if ([_basisOrder more:_minOrder]) number = _basisOrder;   //在此赋值基本值或者最小值
        else number = _minOrder;
    } else {
        number = [number decimalRound:_decimal mode:ZCEnumRoundTypeRound];
    }
    return number;
}

- (void)validateNumber:(NSDecimalNumber *)number incr:(BOOL)incr decr:(BOOL)decr {
    if (incr) {
        if (self.numberAutoValidate == NO) {
            number = [number plus:self.stepOrder];
        } else if ([number less:self.basisOrder]) {
            number = self.basisOrder;
        } else {
            if ([number more:self.maxOrder] || [number equal:self.maxOrder]) {
                number = [number plus:self.stepOrder];
            } else {
                number = [number plus:self.stepOrder];
                if ([number more:self.maxOrder]) {
                    number = self.maxOrder;
                }
            }
        }
    } else if (decr) {
        if (self.numberAutoValidate == NO) {
            number = [number minus:self.stepOrder];
        } else if ([number more:self.minOrder] && ([number less:self.basisOrder] || [number equal:self.basisOrder])) {
            number = self.minOrder;
        } else {
            if ([number less:self.minOrder] || [number equal:self.minOrder]) {
                number = [number minus:self.stepOrder];
            } else {
                number = [number minus:self.stepOrder];
                if ([number less:self.basisOrder]) {
                    number = self.basisOrder;
                }
            }
        }
    } else {
        if (self.numberAutoValidate) {
            if ([number less:self.basisOrder] && [number more:self.minOrder]) {
                number = self.basisOrder;
            } else if ([number more:self.basisOrder]) {
                NSDecimalNumber *divide = [number divide:self.stepOrder];
                if ([[divide stringValue] isPureInteger] == NO) {
                    NSDecimalNumber *div = [divide decimalRound:0 mode:ZCEnumRoundTypeUp];
                    number = [self.stepOrder mltiply:div];
                }
            }
        }
    }

    BOOL limit = NO;
    if ([number less:self.minOrder]) {
        number = self.minOrder;
        limit = YES;
    } else if ([number more:self.maxOrder]) {
        number = self.maxOrder;
        limit = YES;
    }
    [self resetText:number];
    [self issueChangeLimitCallback:limit];
    [self issueNumberChangeCallback];
}

#pragma mark - Fit
- (void)fitMinOrdur {
    if (_numberAutoThreshold == NO || [_minOrder equal:_zero]) return;
    NSDecimalNumber *number = _minOrder;
    NSDecimalNumber *divide = [number divide:_stepOrder];
    if ([[divide stringValue] isPureInteger] == NO) {
        if (incr_log_check) {NSLog(@"min order is un zhengchu");}
        NSDecimalNumber *div = [divide decimalRound:0 mode:ZCEnumRoundTypeUp];
        _minOrder = [_stepOrder mltiply:div];
    }
}

- (void)fitMaxOrdur {
    if (_numberAutoThreshold == NO || [_maxOrder equal:_zero]) return;
    NSDecimalNumber *number = _maxOrder;
    NSDecimalNumber *divide = [number divide:_stepOrder];
    if ([[divide stringValue] isPureInteger] == NO) {
        if (incr_log_check) {NSLog(@"max order is un zhengchu");}
        NSDecimalNumber *div = [divide decimalRound:0 mode:ZCEnumRoundTypeDown];
        _maxOrder = [_stepOrder mltiply:div];
    }
}

- (void)fitBasisOrdur {
    if ([_basisOrder equal:_zero]) return;   //为0时候返回
    NSDecimalNumber *number = _basisOrder;
    NSDecimalNumber *divide = [number divide:_stepOrder];
    if ([[divide stringValue] isPureInteger] == NO) {
        if (incr_log_check) {NSLog(@"basis order is un zhengchu");}
        NSDecimalNumber *div = [divide decimalRound:0 mode:ZCEnumRoundTypeUp];
        _basisOrder = [_stepOrder mltiply:div];
    }
}

#pragma mark - Pri
- (void)resetSize {
    [self sizeToFit];
    if ([self superview]) [self setNeedsLayout];
}

- (void)resetNumber {
    if (_numberAutoAdaption) {
        if (_inputField.editing) [_inputField endEditing:YES];
        [self validateNumber:_number incr:NO decr:NO];
        [self resetSize];
    }
}

- (void)resetText:(NSDecimalNumber *)number {
    _number = number;
    _inputField.text = [number stringValue];
    if (_dynamicSize) [self resetSize];
    [self checkWarning:NO];
    [self checkDisable:NO];
}

- (BOOL)isIntegerTypeForFloat:(NSDecimalNumber *)number {
    if (_decimal == 0) {
        return [[number stringValue] isPureInteger];
    }
    return YES;
}

- (void)setHiddenText:(BOOL)hiddenText animate:(BOOL)animate {
    if (self.style != JFEnumIncrControlStyleNormal) return;
    BOOL change = hiddenText != _hiddenText;
    _hiddenText = hiddenText;
    if (change) {
        [self decideItemState:_inputField];
        [self decideItemState:_decrButton];
        [self resetSize];
        [UIView animateWithDuration:(animate ? _aTime : 0) animations:^{
            _signLine.alpha = _hiddenText ? 0 : 1;
            _titleLabel.alpha = _hiddenText ? 0 : 1;
            _inputField.alpha = _hiddenText ? 0 : 1;
            _decrButton.alpha = _hiddenText ? 0 : 1;
            [self layoutSubviews];
        }];
    }
}

- (void)matchKeyboardType {
    if ([_minOrder less:_zero]) {
        _inputField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    } else {
        if (_decimal == 0) {
            _inputField.keyboardType = UIKeyboardTypeNumberPad;
        } else {
            _inputField.keyboardType = UIKeyboardTypeDecimalPad;
        }
    }
}

- (void)checkWarning:(BOOL)change {
    BOOL warning = NO;
    if (_isEfcSec) {
        if (_isIncrWarning) {
            if ([_number less:_warningSection.lastObject] || [_number equal:_warningSection.lastObject]) {
                _isIncrWarning = NO;
                [self decideItemState:_incrButton];
                warning = YES;
            }
        } else if (_isDecrWarning) {
            if ([_number more:_warningSection.firstObject] || [_number equal:_warningSection.firstObject]) {
                _isDecrWarning = NO;
                [self decideItemState:_decrButton];
                warning = YES;
            }
        } else {
            if ([_number less:_warningSection.firstObject]) {
                _isDecrWarning = YES;
                [self decideItemState:_decrButton];
                warning = YES;
            } else if ([_number more:_warningSection.lastObject]) {
                _isIncrWarning = YES;
                [self decideItemState:_incrButton];
                warning = YES;
            }
        }
        if (warning) [self decideItemState:_inputField];
    } else if (change) {
        _isIncrWarning = NO;
        _isDecrWarning = NO;
        [self decideItemState:nil];
    }
    [self issueChangeWarningCallback:warning];
}

- (void)checkDisable:(BOOL)change {
    BOOL disable = NO;
    if (_autoDisable) {
        if (_isIncrDisable) {
            if ([_number less:_maxOrder]) {
                _isIncrDisable = NO;
                [self decideItemState:_incrButton];
                disable = YES;
            }
        } else if (_isDecrDisable) {
            if ([_number more:_minOrder]) {
                _isDecrDisable = NO;
                [self decideItemState:_decrButton];
                disable = YES;
            }
        } else {
            if ([_number equal:_minOrder] || [_number less:_minOrder]) {
                _isDecrDisable = YES;
                [self decideItemState:_decrButton];
                disable = YES;
            } else if ([_number equal:_maxOrder] || [_number more:_maxOrder]) {
                _isIncrDisable = YES;
                [self decideItemState:_incrButton];
                disable = YES;
            }
        }
    } else if (change) {
        _isIncrDisable = NO;
        _isDecrDisable = NO;
        [self decideItemState:_incrButton];
        [self decideItemState:_decrButton];
    }
    [self issueChangeDisableCallback:disable];
}

- (void)decideBorderColor {
    UIColor *color = nil;
    switch (_style) {
        case JFEnumIncrControlStyleNormal:{
            color = [UIColor clearColor];
        } break;
        case JFEnumIncrControlStyleWindow:{
            color = [self lineDecideColor];
        } break;
    }
    self.layer.borderWidth = ZSSepHei;
    self.layer.borderColor = color.CGColor;
}

- (void)decideItemState:(id<JFIncrItemProtocol>)incrItem {
    BOOL isAll = NO;
    if (incrItem == nil) isAll = YES;
    if (isAll || incrItem == _inputField) {
        if (_disableState || _hiddenText || _disableInput) {
            if (_displayingKeykoard) [JFDecimalKeyboardView dismissKeyboard];
            else if (_inputField.editing) [_inputField endEditing:YES];
        }
        if (_disableState) _inputField.itemState = JFEnumIncrItemStateDisable;
        else if (_isIncrWarning || _isDecrWarning) _inputField.itemState = JFEnumIncrItemStateWarning;
        else _inputField.itemState = JFEnumIncrItemStateNormal;
        if (_hiddenText || _disableInput) _inputField.itemState = JFEnumIncrItemStateInvalid;
    }
    if (isAll || incrItem == _incrButton) {
        if (_disableState || _isIncrDisable) _incrButton.itemState = JFEnumIncrItemStateDisable;
        else if (_isIncrWarning) _incrButton.itemState = JFEnumIncrItemStateWarning;
        else _incrButton.itemState = JFEnumIncrItemStateNormal;
    }
    if (isAll || incrItem == _decrButton) {
        if (_disableState || _isDecrDisable) _decrButton.itemState = JFEnumIncrItemStateDisable;
        else if (_isDecrWarning) _decrButton.itemState = JFEnumIncrItemStateWarning;
        else _decrButton.itemState = JFEnumIncrItemStateNormal;
        if (_hiddenText) _decrButton.itemState = JFEnumIncrItemStateInvalid;
    }
}

#pragma mark - Issue
- (void)issueChangeLimitCallback:(BOOL)limit {
    if (limit && self.delegate && [self.delegate respondsToSelector:@selector(incrControlTriggerTextLimit:)]) {
        [self.delegate incrControlTriggerTextLimit:self];
    }
}

- (void)issueChangeWarningCallback:(BOOL)warning {
    if (warning && self.delegate && [self.delegate respondsToSelector:@selector(incrControlTriggerWarning:incrWaring:decrWaring:)]) {
        [self.delegate incrControlTriggerWarning:self incrWaring:_isIncrWarning decrWaring:_isDecrWarning];
    }
}

- (void)issueChangeDisableCallback:(BOOL)disable {
    if (disable && self.delegate && [self.delegate respondsToSelector:@selector(incrControlTriggerDisable:incrDisable:decrDisable:)]) {
        [self.delegate incrControlTriggerDisable:self incrDisable:_isIncrDisable decrDisable:_isDecrDisable];
    }
}

- (void)issueNumberChangeCallback {
    if (self.delegate && [self.delegate respondsToSelector:@selector(incrControlNumberChange:)]) {
        [self.delegate incrControlNumberChange:self];
    }
}

- (void)issueInputEndCallback {
    if (self.delegate && [self.delegate respondsToSelector:@selector(incrControlOnInputEnd:)]) {
        [self.delegate incrControlOnInputEnd:self];
    }
}

- (void)issueIncreaseCallback {
    if (self.delegate && [self.delegate respondsToSelector:@selector(incrControlOnIncrease:)]) {
        [self.delegate incrControlOnIncrease:self];
    }
}

- (void)issueDecreaseCallback {
    if (self.delegate && [self.delegate respondsToSelector:@selector(incrControlOnDecrease:)]) {
        [self.delegate incrControlOnDecrease:self];
    }
}

- (BOOL)issueInputChangeCallback:(NSString *)text {
    if (self.delegate && [self.delegate respondsToSelector:@selector(incrControlInputChange:text:)]) {
        if (text) [self.delegate incrControlInputChange:self text:text];
        else return YES;
    }
    return NO;
}

#pragma mark - Api
- (void)cancelInputNumber {
    _isCancel = YES;
}

- (NSDecimalNumber *)copyNumber {
    return [self validateInvalidNumber:self.number];
}

- (UITextField *)inputTextField {
    return _inputField;
}

- (BOOL)warning {
    return (_isDecrWarning || _isIncrWarning);
}

- (NSString *)max {
    return [[_maxOrder decimalRound:_decimal mode:ZCEnumRoundTypeRound] stringValue];
}

- (NSString *)min {
    return [[_minOrder decimalRound:_decimal mode:ZCEnumRoundTypeRound] stringValue];
}

- (NSString *)text {
    return [[_number decimalRound:_decimal mode:ZCEnumRoundTypeRound] stringValue];
}

#pragma mark - Action
- (void)onIncrease:(id)sender {
    if (self.inputField.editing) [self.inputField endEditing:YES];  //TODO:没有覆盖mask时候此处结束编辑验证时候会改变值
    [self validateNumber:self.number incr:YES decr:NO];
    [self issueIncreaseCallback];
}

- (void)onDecrease:(id)sender {
    if (self.inputField.editing) [self.inputField endEditing:YES];  //TODO:没有覆盖mask时候此处结束编辑验证时候会改变值
    [self validateNumber:self.number incr:NO decr:YES];
    [self issueDecreaseCallback];
}

- (void)onMaskCancel:(id)sender {
    _isCancel = YES;
    [self.inputField endEditing:YES];
    [self.accessMask removeFromSuperview];
    _isCancel = NO;
}

#pragma mark - Keyboard
- (void)displayDecimalKeyboard {
    [JFDecimalKeyboardView display:^(JFDecimalKeyboardView *decimalView) {
        _displayingKeykoard = YES;
        if (self.keyboardDoneTitle) decimalView.doneTitle = self.keyboardDoneTitle;
        if (self.keyboardHideTitle) decimalView.hideTitle = self.keyboardHideTitle;
        if (self.keyboardClearText) decimalView.clearText = self.keyboardClearText;
        if (self.keyboardHolderText) decimalView.holderText = self.keyboardHolderText;
        decimalView.maskHide = self.keyboardPeripheryHide;
        decimalView.decimal = _decimal;
        decimalView.number = _number;
        decimalView.maxNumber = _maxOrder;
        decimalView.minNumber = _minOrder;
        decimalView.moqNumber = _basisOrder;
    } prompt:self.keyboardPrompt check:nil done:^BOOL(NSDecimalNumber *decimal) {
        NSDecimalNumber *number = [self validateInvalidNumber:decimal];
        if (self.keyboardDoneValidate) {
            [self validateNumber:number incr:NO decr:NO];
            [self issueInputEndCallback];
        } else {
            [self resetText:number];  //TODO:初始化不整除，点击加减也不会矫正，也不会触发changeNumber回调
            [self issueNumberChangeCallback];
            [self issueInputEndCallback];
        }
        _displayingKeykoard = NO;
        return YES;
    } hide:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_decimal != 0 && [_minOrder less:_zero] == NO && textField.text.length <= range.location) {
        if ([textField.text containsString:@"."]) {
            if ([string isEqualToString:@"."]) return NO;
            NSMutableString *temporary = [textField.text mutableCopy];
            [temporary replaceCharactersInRange:range withString:string];
            NSArray *elements = [temporary componentsSeparatedByString:@"."];
            NSString *decimalStr = elements.lastObject;
            if (decimalStr.length > _decimal) return NO;
        }
    } else if ([_minOrder less:_zero]) {
        NSMutableString *temptext = [NSMutableString stringWithString:textField.text];
        [temptext replaceCharactersInRange:range withString:string];
        if ([temptext isPureFloat] == NO) return NO;
        if ([temptext containsString:@"."]) {
            NSRange dotran = [temptext rangeOfString:@"."];
            if (temptext.length - dotran.location <= _decimal) return NO;
        }
    }
    if ([self issueInputChangeCallback:nil]) {
        NSMutableString *text = [NSMutableString stringWithString:textField.text];
        [text replaceCharactersInRange:range withString:string];
        [self issueInputChangeCallback:text];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.isFirstResponder == NO) {
        if (self.decimalKeyboard) {
            [self displayDecimalKeyboard];
            return NO;
        }
        if (self.accessMask) {
            [[UIApplication sharedApplication].delegate.window addSubview:self.accessMask];
            self.recordNumber = self.number;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.isFirstResponder && self.accessMask) [self.accessMask removeFromSuperview];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_isCancel) {
        NSDecimalNumber *number = self.recordNumber;
        if (!number) number = [self validateInvalidNumber:number];
        [self resetText:number];
        _isCancel = NO;
    } else {
        NSDecimalNumber *number = [NSDecimalNumber decimalString:textField.text];
        number = [self validateInvalidNumber:number];
        [self validateNumber:number incr:NO decr:NO];
        [self issueInputEndCallback];
    }
}

@end
