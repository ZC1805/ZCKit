//
//  ZCTableViewCell.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCTableViewCell.h"
#import "UIView+ZC.h"
#import "ZCMacro.h"

@interface ZCTableViewCell ()

@property (nonatomic, strong) UIView *bottomSeparator;

@property (nonatomic, strong) UIView *topSeparator;

@property (nonatomic, strong) UIView *selectBKView;

@property (nonatomic, strong) UIView *lineOneView;

@property (nonatomic, strong) UIView *lineTwoView;

@property (nonatomic, strong) NSLayoutConstraint *lySpc1; //第一行左右间距约束

@property (nonatomic, strong) NSLayoutConstraint *lySpc2; //第二行左标签右间距约束

@property (nonatomic, strong) NSLayoutConstraint *lyTop1; //第一行顶部约束

@property (nonatomic, strong) NSLayoutConstraint *lyTop2; //第一行顶部约束

@property (nonatomic, strong) NSLayoutConstraint *lyBottom1; //第一行底部约束

@property (nonatomic, strong) NSLayoutConstraint *lyBottom2; //第二行底部约束

@property (nonatomic, strong) NSLayoutConstraint *lyAvatarCx; //avatar水平对齐约束

@property (nonatomic, assign) CGFloat avatarCR; //avatar下个view左端位置

@end

static NSString *layoutIdent = @"custom.layout.ident";

@implementation ZCTableViewCell

@synthesize bottomContainerView = _bottomContainerView;
@synthesize badgeView = _badgeView, bottomBadgeView = _bottomBadgeView;
@synthesize containerView = _containerView, switchControl = _switchControl;
@synthesize trailingLabel = _trailingLabel, describeLabel = _describeLabel;
@synthesize flagView = _flagView, inputField = _inputField, accessControl = _accessControl;
@synthesize selectButton = _selectButton, avatarControl = _avatarControl, leadingLabel = _leadingLabel;

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initStart];
        [self initComplete];
        [self resetConstraint];
    }
    return self;
}

- (void)initStart {
    _level = 0;
    _horSpacing = 10.0;
    _verSpacing = 10.0;
    _levelSpacing = 30.0;
    _selectBKColor = nil;
    _isAvatarBeCenter = NO;
    _separatorBKColor = ZCSPColor;
    _topSeparatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _marginInset = UIEdgeInsetsMake(15.0, 15.0, 15.0, 15.0);
    self.bottomSeparatorInset = UIEdgeInsetsMake(ZSSepHei, 15.0, 0, 0);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = ZCWhite;
}

- (void)initComplete {
    
}

- (void)resetConstraint {
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];
    if ([self isSeatView:_topSeparator]) {
        _topSeparator.origin = CGPointMake(_topSeparatorInset.left, _topSeparatorInset.top);
        _topSeparator.size = CGSizeMake(self.width - _topSeparatorInset.left - _topSeparatorInset.right, _topSeparatorInset.bottom);
    }
    if ([self isSeatView:_bottomSeparator]) {
        _bottomSeparator.size = CGSizeMake(self.width - _bottomSeparatorInset.left - _bottomSeparatorInset.right, _bottomSeparatorInset.top);
        _bottomSeparator.bottom = self.height - _bottomSeparatorInset.bottom;
        _bottomSeparator.left = _bottomSeparatorInset.left;
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    CGFloat maxOne = [self lineOneUpdateConstraints];
    CGFloat maxTwo = [self lineTwoUpdateConstraints];
    if (maxOne > -1 && maxTwo > -1) {
        _lyBottom1.active = NO;
        _lyTop1.active = YES;
        _lyTop2.active = YES;
        _lyBottom2.active = YES;
        _lyTop2.constant = _marginInset.top + maxOne + _verSpacing;
        _lyTop1.constant = _marginInset.top + (maxOne - _lineOneView.height) / 2.0;
        _lyBottom2.constant = -(_marginInset.bottom + (maxTwo - _lineTwoView.height) / 2.0);
        if (_isAvatarBeCenter && _lyAvatarCx) {
            _lyAvatarCx.constant = (maxOne + maxTwo + _verSpacing) / 2.0 - maxOne / 2.0;
        }
    } else if (maxOne > -1) {
        _lyTop2.active = NO;
        _lyBottom2.active = NO;
        _lyTop1.active = YES;
        _lyBottom1.active = YES;
        _lyTop1.constant = _marginInset.top + (maxOne - _lineOneView.height) / 2.0;
        _lyBottom1.constant = -(_marginInset.bottom + (maxOne - _lineOneView.height) / 2.0);
        if (_isAvatarBeCenter && _lyAvatarCx) {
            _lyAvatarCx.constant = 0;
        }
    } else if (maxTwo > -1) {
        _lyTop1.active = NO;
        _lyBottom1.active = NO;
        _lyTop2.active = YES;
        _lyBottom2.active = YES;
        _lyTop2.constant = _marginInset.top + (maxTwo - _lineTwoView.height) / 2.0;
        _lyBottom2.constant = -(_marginInset.bottom + (maxTwo - _lineTwoView.height) / 2.0);
    }
}

- (CGFloat)lineOneUpdateConstraints {
    CGFloat max = -1;
    CGFloat right = _marginInset.right;
    CGFloat left = _marginInset.left + _level * _levelSpacing;
    UIView *leftView = nil, *rightView = nil;
    
    if ([self isSeatView:_selectButton]) {
        left = [self resetLeftConstraint:_selectButton left:left];
        max = MAX(_selectButton.height, max);
        leftView = _selectButton;
    }
    if ([self isSeatView:_avatarControl]) {
        left = [self resetLeftConstraint:_avatarControl left:left];
        if (!_isAvatarBeCenter) max = MAX(_avatarControl.height, max);
        leftView = _avatarControl;
        _avatarCR = left;
    }
    if ([self isSeatView:_leadingLabel]) {
        left = [self resetLeftConstraint:_leadingLabel left:left];
        max = MAX(_leadingLabel.height, max);
        leftView = _leadingLabel;
    }
    if ([self isSeatView:_flagView]) {
        left = [self resetLeftConstraint:_flagView left:left];
        max = MAX(_flagView.height, max);
        leftView = _flagView;
    }
    if ([self isSeatView:_inputField]) {
        left = [self resetLeftConstraint:_inputField left:left];
        max = MAX(_inputField.height, max);
        leftView = _inputField;
    }
    
    if ([self isSeatView:_accessControl]) {
        right = [self resetRightConstraint:_accessControl right:right];
        max = MAX(_accessControl.height, max);
        rightView = _accessControl;
    }
    if ([self isSeatView:_badgeView]) {
        right = [self resetRightConstraint:_badgeView right:right];
        max = MAX(_badgeView.height, max);
        rightView = _badgeView;
    }
    if ([self isSeatView:_containerView]) {
        right = [self resetRightConstraint:_containerView right:right];
        max = MAX(_containerView.height, max);
        rightView = _containerView;
    }
    if ([self isSeatView:_switchControl]) {
        right = [self resetRightConstraint:_switchControl right:right];
        max = MAX(_switchControl.height, max);
        rightView = _switchControl;
    }
    if ([self isSeatView:_trailingLabel]) {
        right = [self resetRightConstraint:_trailingLabel right:right];
        max = MAX(_trailingLabel.height, max);
        rightView = _trailingLabel;
    }
    
    if (_lySpc1) {
        [self.contentView removeConstraint:_lySpc1];
    }
    if (leftView && rightView) {
        _lySpc1 = [self injectConstraint:rightView comp:leftView cons:_horSpacing];
    } else if (leftView) {
        _lySpc1 = [self injectConstraint:leftView isRight:YES relation:NSLayoutRelationLessThanOrEqual cons:-right];
    } else if (rightView) {
        _lySpc1 = [self injectConstraint:rightView isRight:NO relation:NSLayoutRelationGreaterThanOrEqual cons:left];
    }
    return max;
}

- (CGFloat)lineTwoUpdateConstraints {
    CGFloat max = -1;
    CGFloat right = _marginInset.right;
    CGFloat left = _marginInset.left + (_level + 1) * _levelSpacing;
    if (_isAvatarBeCenter && [self isSeatView:_avatarControl]) {
        left = _avatarCR;
    }
    if ([self isSeatView:_describeLabel]) {
        [self resetLeftConstraint:_describeLabel left:left];
        max = MAX(_describeLabel.height, max);
    }
    if ([self isSeatView:_bottomBadgeView]) {
        right = [self resetRightConstraint:_bottomBadgeView right:right];
        max = MAX(_bottomBadgeView.height, max);
    }
    if ([self isSeatView:_bottomContainerView]) {
        right = [self resetRightConstraint:_bottomContainerView right:right];
        max = MAX(_bottomContainerView.height, max);
    }
    if (_lySpc2) {
        _lySpc2.constant = -right;
    }
    return max;
}

#pragma mark - misc1
- (BOOL)isSeatView:(UIView *)subview {
    if (subview && !subview.hidden) {
        return YES;
    }
    return NO;
}

- (CGFloat)resetLeftConstraint:(UIView *)subview left:(CGFloat)left {
    NSLayoutConstraint *lefly = nil;
    for (NSLayoutConstraint *layout in self.contentView.constraints) {
        if ([layout.identifier isEqualToString:layoutIdent]) {
            if (layout.firstItem == subview && layout.firstAttribute == NSLayoutAttributeLeft) {
                lefly = layout; break;
            }
        }
    }
    if (lefly) {
        lefly.constant = left;
    } else {
        [self injectConstraint:subview att:NSLayoutAttributeLeft comp:self.contentView cons:left];
    }
    [self resetSizeConstraint:subview];
    return left + subview.width + _horSpacing;
}

- (CGFloat)resetRightConstraint:(UIView *)subview right:(CGFloat)right {
    NSLayoutConstraint *rigly = nil;
    for (NSLayoutConstraint *layout in self.contentView.constraints) {
        if ([layout.identifier isEqualToString:layoutIdent]) {
            if (layout.firstItem == subview && layout.firstAttribute == NSLayoutAttributeRight) {
                rigly = layout; break;
            }
        }
    }
    if (rigly) {
        rigly.constant = -right;
    } else {
        [self injectConstraint:subview att:NSLayoutAttributeRight comp:self.contentView cons:-right];
    }
    [self resetSizeConstraint:subview];
    return right + subview.width + _horSpacing;
}

- (void)resetSizeConstraint:(UIView *)subview {
    if (subview == _leadingLabel || subview == _trailingLabel || subview == _describeLabel) {
        UILayoutPriority pri1 = subview == _leadingLabel ? UILayoutPriorityDefaultLow : UILayoutPriorityRequired;
        [subview setContentCompressionResistancePriority:pri1 forAxis:UILayoutConstraintAxisHorizontal];
        [subview layoutIfNeeded];
        return;
    }
    if (subview == _switchControl) {
        [subview layoutIfNeeded];
        return;
    }
    CGSize size = subview.size;
    NSLayoutConstraint *widly = nil, *heily = nil;
    for (NSLayoutConstraint *layout in subview.constraints) {
        if ([layout.identifier isEqualToString:layoutIdent]) {
            if (layout.firstAttribute == NSLayoutAttributeWidth) {
                widly = layout;
            } else if (layout.firstAttribute == NSLayoutAttributeHeight) {
                heily = layout;
            }
        }
    }
    if (widly) {
        widly.constant = size.width;
    } else {
        [self injectConstraint:subview att:NSLayoutAttributeWidth comp:nil cons:size.width];
    }
    if (heily) {
        heily.constant = size.height;
    } else {
        [self injectConstraint:subview att:NSLayoutAttributeHeight comp:nil cons:size.height];
    }
}

- (void)setBasicConstraint:(UIView *)subview lineOne:(BOOL)lineOne {
    UIView *compareView = lineOne ? _lineOneView : _lineTwoView;
    if (compareView) {
        NSLayoutConstraint *layout = [self injectConstraint:subview att:NSLayoutAttributeCenterY comp:compareView cons:0];
        if (subview == _avatarControl) _lyAvatarCx = layout;
    } else {
        if (lineOne) {
            _lineOneView = subview;
            _lyTop1 = [self injectConstraint:subview att:NSLayoutAttributeTop comp:self.contentView cons:0];
            _lyBottom1 = [self injectConstraint:subview att:NSLayoutAttributeBottom comp:self.contentView cons:0];
        } else {
            _lineTwoView = subview;
            _lyTop2 = [self injectConstraint:subview att:NSLayoutAttributeTop comp:self.contentView cons:0];
            _lyBottom2 = [self injectConstraint:subview att:NSLayoutAttributeBottom comp:self.contentView cons:0];
        }
    }
    if (subview == _describeLabel) {
        _lySpc2 = [self injectConstraint:subview isRight:YES relation:NSLayoutRelationLessThanOrEqual cons:0];
    }
}

#pragma mark - misc2
- (NSLayoutConstraint *)injectConstraint:(UIView *)refer att:(NSLayoutAttribute)att comp:(UIView *)comp cons:(CGFloat)cons {
    CGFloat mult = 1.0;
    NSLayoutAttribute att1 = att;
    NSLayoutRelation relation = NSLayoutRelationEqual;
    BOOL isSizeConstraint = (att == NSLayoutAttributeWidth || att == NSLayoutAttributeHeight);
    if (isSizeConstraint) {att1 = NSLayoutAttributeNotAnAttribute; mult = 0;}
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:refer attribute:att
                                                              relatedBy:relation toItem:comp
                                                              attribute:att1 multiplier:mult constant:cons];
    layout.identifier = layoutIdent;
    if (att == NSLayoutAttributeBottom && (refer == _lineOneView || refer == _lineTwoView)) {
        layout.priority = UILayoutPriorityFittingSizeLevel;
    } else {
        layout.priority = UILayoutPriorityRequired;
    }
    if (isSizeConstraint) {
        [refer addConstraint:layout];
    } else {
        [self.contentView addConstraint:layout];
    }
    return layout;
}

- (NSLayoutConstraint *)injectConstraint:(UIView *)refer isRight:(BOOL)isRight relation:(NSLayoutRelation)rela cons:(CGFloat)cons {
    NSLayoutAttribute att = isRight ? NSLayoutAttributeRight : NSLayoutAttributeLeft;
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:refer attribute:att
                                                              relatedBy:rela toItem:self.contentView
                                                              attribute:att multiplier:1.0 constant:cons];
    layout.priority = UILayoutPriorityRequired;
    [self.contentView addConstraint:layout];
    return layout;
}

- (NSLayoutConstraint *)injectConstraint:(UIView *)refer comp:(UIView *)comp cons:(CGFloat)cons {
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:refer attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:comp
                                                              attribute:NSLayoutAttributeRight multiplier:1.0 constant:cons];
    layout.priority = UILayoutPriorityRequired;
    [self.contentView addConstraint:layout];
    return layout;
}

#pragma mark - set
- (void)setLevel:(NSInteger)level {
    _level = level;
    [self resetConstraint];
}

- (void)setHorSpacing:(CGFloat)horSpacing {
    _horSpacing = horSpacing;
    [self resetConstraint];
}

- (void)setVerSpacing:(CGFloat)verSpacing {
    _verSpacing = verSpacing;
    [self resetConstraint];
}

- (void)setLevelSpacing:(CGFloat)levelSpacing {
    _levelSpacing = levelSpacing;
    [self resetConstraint];
}

- (void)setMarginInset:(UIEdgeInsets)marginInset {
    _marginInset = marginInset;
    [self resetConstraint];
}

- (void)setTopSeparatorInset:(UIEdgeInsets)topSeparatorInset {
    _topSeparatorInset = topSeparatorInset;
    if (UIEdgeInsetsEqualToEdgeInsets(_topSeparatorInset, UIEdgeInsetsZero)) {
        [_topSeparator removeFromSuperview]; _topSeparator = nil;
    } else {
        self.topSeparator.backgroundColor = _separatorBKColor;
    }
    [self resetConstraint];
}

- (void)setBottomSeparatorInset:(UIEdgeInsets)bottomSeparatorInset {
    _bottomSeparatorInset = bottomSeparatorInset;
    if (UIEdgeInsetsEqualToEdgeInsets(_bottomSeparatorInset, UIEdgeInsetsZero)) {
        [_bottomSeparator removeFromSuperview]; _bottomSeparator = nil;
    } else {
        self.bottomSeparator.backgroundColor = _separatorBKColor;
    }
    [self resetConstraint];
}

- (void)setIsAvatarBeCenter:(BOOL)isAvatarBeCenter {
    _isAvatarBeCenter = isAvatarBeCenter;
    [self resetConstraint];
}

- (void)setSeparatorBKColor:(UIColor *)separatorBKColor {
    _separatorBKColor = separatorBKColor;
    _topSeparator.backgroundColor = _separatorBKColor;
    _bottomSeparator.backgroundColor = _separatorBKColor;
}

- (void)setSelectBKColor:(UIColor *)selectBKColor {
    _selectBKColor = selectBKColor;
    if (selectBKColor) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.selectedBackgroundView = self.selectBKView;
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.selectedBackgroundView removeFromSuperview];
        self.selectedBackgroundView = nil;
        _selectBKView = nil;
    }
}

#pragma mark - get
- (UIView *)topSeparator {
    if (!_topSeparator) {
        _topSeparator = [[UIView alloc] initWithFrame:CGRectZero];
        _topSeparator.backgroundColor = _separatorBKColor;
        [self addSubview:_topSeparator];
    }
    return _topSeparator;
}

- (UIView *)bottomSeparator {
    if (!_bottomSeparator) {
        _bottomSeparator = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomSeparator.backgroundColor = _separatorBKColor;
        [self addSubview:_bottomSeparator];
    }
    return _bottomSeparator;
}

- (UIView *)selectBKView {
    if (!_selectBKView) {
        _selectBKView = [[UIView alloc] initWithFrame:CGRectZero];
        _selectBKView.backgroundColor = _selectBKColor;
    }
    return _selectBKView;
}

- (ZCButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [ZCButton buttonWithType:UIButtonTypeCustom];
        _selectButton.backgroundColor = ZCClear;
        _selectButton.size = CGSizeMake(20.0, 20.0);
        _selectButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _selectButton.responseAreaExtend = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
        _selectButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_selectButton setTitleColor:ZCBlack30 forState:UIControlStateNormal];
        [_selectButton setTitleColor:ZCBlack30 forState:UIControlStateSelected];
        [_selectButton setTitleColor:ZCColorA(ZCBlack30, 0.3) forState:UIControlStateHighlighted];
        [_selectButton setImage:ZCImage(@"zc_image_unselect_grey") forState:UIControlStateNormal];
        [_selectButton setImage:ZCImage(@"zc_image_select_cyan") forState:UIControlStateSelected];
        [_selectButton setImage:ZCImageA(ZCImage(@"zc_image_unselect_grey"), 0.3) forState:UIControlStateNormal|UIControlStateHighlighted];
        [_selectButton setImage:ZCImageA(ZCImage(@"zc_image_select_cyan"), 0.3) forState:UIControlStateSelected|UIControlStateHighlighted];
        [self.contentView addSubview:_selectButton];
        [self setBasicConstraint:_selectButton lineOne:YES];
    }
    return _selectButton;
}

- (ZCAvatarControl *)avatarControl {
    if (!_avatarControl) {
        if (!_leadingLabel) self.leadingLabel.userInteractionEnabled = NO; 
        _avatarControl = [[ZCAvatarControl alloc] initWithFrame:CGRectZero];
        _avatarControl.translatesAutoresizingMaskIntoConstraints = NO;
        _avatarControl.size = CGSizeMake(40.0, 40.0);
        [self.contentView addSubview:_avatarControl];
        [self setBasicConstraint:_avatarControl lineOne:YES];
    }
    return _avatarControl;
}

- (UILabel *)leadingLabel {
    if (!_leadingLabel) {
        _leadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _leadingLabel.font = [UIFont systemFontOfSize:16.0];
        _leadingLabel.textColor = ZCBlack30;
        _leadingLabel.numberOfLines = 1;
        _leadingLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_leadingLabel];
        [self setBasicConstraint:_leadingLabel lineOne:YES];
    }
    return _leadingLabel;
}

- (UIView *)flagView {
    if (!_flagView) {
        _flagView = [[UIView alloc] initWithFrame:CGRectZero];
        _flagView.size = CGSizeMake(20.0, 20.0);
        _flagView.backgroundColor = ZCClear;
        _flagView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_flagView];
        [self setBasicConstraint:_flagView lineOne:YES];
    }
    return _flagView;
}

- (UITextField *)inputField {
    if (!_inputField) {
        _inputField = [[ZCTextField alloc] initWithFrame:CGRectZero];
        _inputField.font = [UIFont systemFontOfSize:16.0];
        _inputField.size = CGSizeMake(160.0, 30.0);
        _inputField.borderStyle = UITextBorderStyleNone;
        _inputField.returnKeyType = UIReturnKeyDone;
        _inputField.textColor = ZCBlack30;
        _inputField.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_inputField];
        [self setBasicConstraint:_inputField lineOne:YES];
    }
    return _inputField;
}

- (ZCAvatarControl *)accessControl {
    if (!_accessControl) {
        _accessControl = [[ZCAvatarControl alloc] initWithFrame:CGRectZero];
        _accessControl.translatesAutoresizingMaskIntoConstraints = NO;
        _accessControl.localImage = ZCImage(@"zc_image_common_side_arrow"); 
        _accessControl.size = CGSizeMake(6.0, 12.0);
        [self.contentView addSubview:_accessControl];
        [self setBasicConstraint:_accessControl lineOne:YES];
    }
    return _accessControl;
}

- (ZCBadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [[ZCBadgeView alloc] initWithFrame:CGRectZero];
        _badgeView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_badgeView];
        [self setBasicConstraint:_badgeView lineOne:YES];
    }
    return _badgeView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.size = CGSizeMake(30.0, 30.0);
        _containerView.backgroundColor = ZCClear;
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_containerView];
        [self setBasicConstraint:_containerView lineOne:YES];
    }
    return _containerView;
}

- (ZCSwitch *)switchControl {
    if (!_switchControl) {
        _switchControl = [[ZCSwitch alloc] initWithFrame:CGRectZero];
        _switchControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_switchControl];
        [self setBasicConstraint:_switchControl lineOne:YES];
    }
    return _switchControl;
}

- (UILabel *)trailingLabel {
    if (!_trailingLabel) {
        _trailingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _trailingLabel.font = [UIFont systemFontOfSize:14.0];
        _trailingLabel.textColor = ZCBlackA2;
        _trailingLabel.numberOfLines = 1;
        _trailingLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_trailingLabel];
        [self setBasicConstraint:_trailingLabel lineOne:YES];
    }
    return _trailingLabel;
}

- (UILabel *)describeLabel {
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _describeLabel.font = [UIFont systemFontOfSize:14.0];
        _describeLabel.textColor = ZCBlack80;
        _describeLabel.numberOfLines = 1;
        _describeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_describeLabel];
        [self setBasicConstraint:_describeLabel lineOne:NO];
    }
    return _describeLabel;
}

- (ZCBadgeView *)bottomBadgeView {
    if (!_bottomBadgeView) {
        _bottomBadgeView = [[ZCBadgeView alloc] initWithFrame:CGRectZero];
        _bottomBadgeView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_bottomBadgeView];
        [self setBasicConstraint:_bottomBadgeView lineOne:NO];
    }
    return _bottomBadgeView;
}

- (UIView *)bottomContainerView {
    if (!_bottomContainerView) {
        _bottomContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomContainerView.backgroundColor = ZCClear;
        _bottomContainerView.size = CGSizeMake(30.0, 30.0);
        _bottomContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_bottomContainerView];
        [self setBasicConstraint:_bottomContainerView lineOne:NO];
    }
    return _bottomContainerView;
}

@end
