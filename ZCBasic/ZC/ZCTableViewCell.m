//
//  ZCTableViewCell.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCTableViewCell.h"
#import "UIScrollView+ZC.h"
#import "UITextField+ZC.h"
#import "ZCKitBridge.h"
#import "UIFont+ZC.h"
#import "UIView+ZC.h"
#import "ZCMacro.h"

@interface ZCTableViewCell ()

@property (nonatomic, strong) UIView *bottomSeparator; //底部分割线视图

@property (nonatomic, strong) UIView *topSeparator; //顶部分割线视图

@property (nonatomic, strong) UIView *selectBKView; //选择的背景视图

@property (nonatomic, strong) UIView *insideView; //内部背景视图

@property (nonatomic, strong) UIView *coverMaskView; //顶部遮罩视图

@property (nonatomic, strong) UIView *lineOneReferView; //引用第一行参照视图

@property (nonatomic, strong) UIView *lineTwoReferView; //引用第二行参照视图

@property (nonatomic, strong) NSLayoutConstraint *lyTop1; //第一行顶部约束

@property (nonatomic, strong) NSLayoutConstraint *lyTop2; //第二行顶部约束

@property (nonatomic, strong) NSLayoutConstraint *lyBottom1; //第一行底部约束

@property (nonatomic, strong) NSLayoutConstraint *lyBottom2; //第二行底部约束

@property (nonatomic, strong) NSLayoutConstraint *lySelectCx; //selectButton水平对齐约束

@property (nonatomic, strong) NSLayoutConstraint *lyAvatarCx; //avatarControl水平对齐约束

@property (nonatomic, strong) NSLayoutConstraint *lyLeadingCx; //leadingLabel水平对齐约束

@property (nonatomic, strong) NSLayoutConstraint *lyAccessCx; //accessControl水平对齐约束

@property (nonatomic, strong) NSLayoutConstraint *lyBottomClickCx; //bottomClick水平对齐约束

@property (nonatomic, assign) CGFloat selectAvatarCR; //avatarControl或selectButton到下个view到左端的距离，将覆盖level

@property (nonatomic, assign) CGFloat leadingCR; //leadingLabel到下个view到左端的距离，将覆盖level

@property (nonatomic, assign) CGFloat accessCR; //accessControl到下个view到右端的距离

@property (nonatomic, assign) BOOL isTrailingLabel; //是否是设置avatarControl、selectButton、leadingLabel、accessControl而初始化的trailingLabel

@property (nonatomic, assign) BOOL isAttachLabel; //是否是设置bottomClickButton而初始化的attachLabel

@property (nonatomic, assign) CGFloat lineOneMinLeft; //第一行左侧label最小宽度(当右侧是trailingLabel有效)，kZSA(80)，可KVC赋值

@property (nonatomic, assign) CGFloat lineOneMinRight; //第一行右侧field最小宽度(当右侧是fitTextField有效)，kZSA(100)，可KVC赋值

@property (nonatomic, assign) CGFloat lineTwoMinLeft; //第二行左侧text/desc最小宽度(当右侧是bottomAttachLabel有效)，kZSA(80)，可KVC赋值

@property (nonatomic, copy) NSString *textViewCalText; //bottomTextView计算最小高度，默认三行，可外部KVC赋值

@property (nonatomic, assign) NSUInteger recordHiddenInt; //是否是resetAllItemHiddens设置的隐藏记录

@end

static NSString * const layoutIdent = @"custom.layout.ident"; //layout标识
static const CGFloat rowHideHei = 0.11; //行隐藏高度

@implementation ZCTableViewCell

@synthesize containerView = _containerView, switchControl = _switchControl;
@synthesize bottomAttachLabel = _bottomAttachLabel, clickButton = _clickButton;
@synthesize trailingLabel = _trailingLabel, bottomDescLabel = _bottomDescLabel;
@synthesize bottomClickButton = _bottomClickButton, accessControl = _accessControl;
@synthesize bottomContainerView = _bottomContainerView, bottomTextView = _bottomTextView;
@synthesize flagContainerView = _flagContainerView, inputTextField = _inputTextField;
@synthesize badgeView = _badgeView, bottomBadgeView = _bottomBadgeView, fitTextField = _fitTextField;
@synthesize selectButton = _selectButton, avatarControl = _avatarControl, leadingLabel = _leadingLabel;
@synthesize bottomTextField = _bottomTextField, bottomFlagContainerView = _bottomFlagContainerView;

#pragma mark - Init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initStart];
        [self initComplete];
        [self resetConstraint];
    }
    return self;
}

- (void)initValue {
    _level = 0;
    _levelSpacing = kZSA(30);
    _verticalSpacing = kZSA(3);
    _horizontalSpacing = kZSA(10);
    _marginInset = UIEdgeInsetsMake(kZSInvl, kZSInvl, kZSInvl, kZSInvl);
    _bottomClickOffsetY = 0;
    _isSelectAvatarBeCenter = NO;
    _isLeadingBeCenter = NO;
    _isAccessBeCenter = NO;
    _insideBKColor = kZCSplit;
    _insideMargin = UIEdgeInsetsZero;
    _separatorBKColor = kZCSplit;
    _topSeparatorInset = UIEdgeInsetsZero;
    _bottomSeparatorInset = UIEdgeInsetsMake(kZSPixel, kZSInvl, 0, 0);
    _selectBKColor = nil;
}

#pragma mark - Api
- (void)initStart {
    [self initValue];
    _lineOneMinLeft = kZSA(80);
    _lineTwoMinLeft = kZSA(80);
    _lineOneMinRight = kZSA(100);
    _textViewCalText = @" \n \n ";
    _recordHiddenInt = 0;
    self.bottomSeparator.backgroundColor = _separatorBKColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.editingAccessoryType = UITableViewCellAccessoryNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.backgroundColor = kZCWhite;
}

- (void)initComplete {
    //...
}

- (void)resetConstraint {
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

- (void)resetAllItemHiddenAndProperty {
    [self initValue];
    _insideView.hidden = YES;
    _topSeparator.hidden = YES;
    self.bottomSeparator.hidden = NO;
    self.bottomSeparator.backgroundColor = _separatorBKColor;
    _selectBKView.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.selectedBackgroundView = nil;
    self.editingAccessoryType = UITableViewCellAccessoryNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.backgroundColor = kZCWhite;
    [self resetCellBaseProperty];
    
    _selectButton.hidden = YES;
    _avatarControl.hidden = YES;
    _leadingLabel.hidden = YES;
    _flagContainerView.hidden = YES;
    _inputTextField.hidden = YES;
    _accessControl.hidden = YES;
    _badgeView.hidden = YES;
    _switchControl.hidden = YES;
    _clickButton.hidden = YES;
    _containerView.hidden = YES;
    _fitTextField.hidden = YES;
    _trailingLabel.hidden = YES;
    _bottomDescLabel.hidden = YES;
    _bottomTextView.hidden = YES;
    _bottomFlagContainerView.hidden = YES;
    _bottomTextField.hidden = YES;
    _bottomAttachLabel.hidden = YES;
    _bottomContainerView.hidden = YES;
    _bottomClickButton.hidden = YES;
    _bottomBadgeView.hidden = YES;
    _recordHiddenInt = (1 << 20) - 1;
    
    [self initZCButtonProperty:_selectButton];
    [self initZCAvatarControlProperty:_avatarControl];
    [self initZCLabelProperty:_leadingLabel];
    [self initUIViewProperty:_flagContainerView];
    [self initZCTextFieldProperty:_inputTextField];
    [self initZCAvatarControlProperty:_accessControl];
    [self initZCBadgeViewProperty:_badgeView];
    [self initZCSwitchProperty:_switchControl];
    [self initZCButtonProperty:_clickButton];
    [self initUIViewProperty:_containerView];
    [self initZCTextFieldProperty:_fitTextField];
    [self initZCLabelProperty:_trailingLabel];
    [self initZCLabelProperty:_bottomDescLabel];
    [self initZCTextViewProperty:_bottomTextView];
    [self initUIViewProperty:_bottomFlagContainerView];
    [self initZCTextFieldProperty:_bottomTextField];
    [self initZCLabelProperty:_bottomAttachLabel];
    [self initUIViewProperty:_bottomContainerView];
    [self initZCButtonProperty:_bottomClickButton];
    [self initZCBadgeViewProperty:_bottomBadgeView];    
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    if ([self isSeatView:_topSeparator]) {
        _topSeparator.frame = CGRectMake(_topSeparatorInset.left,
                                         _topSeparatorInset.top,
                                         self.zc_width - _topSeparatorInset.left - _topSeparatorInset.right,
                                         _topSeparatorInset.bottom);
    }
    if ([self isSeatView:_bottomSeparator]) {
        _bottomSeparator.frame = CGRectMake(_bottomSeparatorInset.left,
                                            self.zc_height - _bottomSeparatorInset.bottom - _bottomSeparatorInset.top,
                                            self.zc_width - _bottomSeparatorInset.left - _bottomSeparatorInset.right,
                                            _bottomSeparatorInset.top);
    }
    if ([self isSeatView:_insideView]) {
        _insideView.frame = CGRectMake(_insideMargin.left,
                                       _insideMargin.top,
                                       self.zc_width - _insideMargin.left - _insideMargin.right,
                                       self.zc_height - _insideMargin.top - _insideMargin.bottom);
    }
    if ([self isSeatView:_coverMaskView]) {
        _coverMaskView.frame = self.bounds;
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    [self setCoverMaskHidden:YES];
    CGFloat maxOne = [self lineOneUpdateConstraints];
    CGFloat maxTwo = [self lineTwoUpdateConstraints];
    if (maxOne > 0 && maxTwo > 0) {
        CGFloat spac = _verticalSpacing, extra = 0, calTwo = maxTwo;
        if (maxOne == rowHideHei) {maxOne = 0; spac = 0;}
        if (_lyBottomClickCx && [self isSeatView:_bottomClickButton]) {
            if (maxTwo == rowHideHei) {
                extra = _bottomClickOffsetY; spac = 0; calTwo = 0;
                maxTwo = MAX(maxTwo, _bottomClickButton.zc_height);
                _lyBottomClickCx.constant = _bottomClickOffsetY;
            } else if (_bottomClickOffsetY) {
                extra = _bottomClickOffsetY + _bottomClickButton.zc_height;
                _lyBottomClickCx.constant = maxTwo / 2.0 + _bottomClickOffsetY + _bottomClickButton.zc_height / 2.0;
            } else {
                _lyBottomClickCx.constant = 0;
            }
        }
        _lyBottom1.active = NO;
        _lyTop1.active = YES;
        _lyTop2.active = YES;
        _lyBottom2.active = YES;
        _lyTop1.constant = _marginInset.top + (maxOne - _lineOneReferView.zc_height) / 2.0;
        _lyTop2.constant = _marginInset.top + maxOne + spac + (maxTwo - _lineTwoReferView.zc_height) / 2.0;
        _lyBottom2.constant = -(_marginInset.bottom + extra + (maxTwo - _lineTwoReferView.zc_height) / 2.0);
        if (_lySelectCx && [self isSeatView:_selectButton]) {
            _lySelectCx.constant = _isSelectAvatarBeCenter ? ((maxOne + calTwo + spac) / 2.0 - maxOne / 2.0) : 0;
        }
        if (_lyAvatarCx && [self isSeatView:_avatarControl]) {
            _lyAvatarCx.constant = _isSelectAvatarBeCenter ? ((maxOne + calTwo + spac) / 2.0 - maxOne / 2.0) : 0;
        }
        if (_lyLeadingCx && [self isSeatView:_leadingLabel]) {
            _lyLeadingCx.constant = _isLeadingBeCenter ? ((maxOne + calTwo + spac) / 2.0 - maxOne / 2.0) : 0;
        }
        if (_lyAccessCx && [self isSeatView:_accessControl]) {
            _lyAccessCx.constant = _isAccessBeCenter ? ((maxOne + calTwo + spac) / 2.0 - maxOne / 2.0) : 0;
        }
    } else if (maxOne > 0) {
        if (_lySelectCx && [self isSeatView:_selectButton]) {
            _lySelectCx.constant = 0;
            if (maxOne == rowHideHei) maxOne = MAX(maxOne, _selectButton.zc_height);
        }
        if (_lyAvatarCx && [self isSeatView:_avatarControl]) {
            _lyAvatarCx.constant = 0;
            if (maxOne == rowHideHei) maxOne = MAX(maxOne, _avatarControl.zc_height);
        }
        if (_lyLeadingCx && [self isSeatView:_leadingLabel]) {
            _lyLeadingCx.constant = 0;
            if (maxOne == rowHideHei) maxOne = MAX(maxOne, _leadingLabel.zc_height);
        }
        if (_lyAccessCx && [self isSeatView:_accessControl]) {
            _lyAccessCx.constant = 0;
            if (maxOne == rowHideHei) maxOne = MAX(maxOne, _accessControl.zc_height);
        }
        _lyTop2.active = NO;
        _lyBottom2.active = NO;
        _lyTop1.active = YES;
        _lyBottom1.active = YES;
        _lyTop1.constant = _marginInset.top + (maxOne - _lineOneReferView.zc_height) / 2.0;
        _lyBottom1.constant = -(_marginInset.bottom + (maxOne - _lineOneReferView.zc_height) / 2.0);
    } else if (maxTwo > 0) {
        CGFloat extra = 0;
        if (_lyBottomClickCx && [self isSeatView:_bottomClickButton]) {
            if (maxTwo == rowHideHei) {
                maxTwo = MAX(maxTwo, _bottomClickButton.zc_height);
                _lyBottomClickCx.constant = 0;
            } else if (_bottomClickOffsetY) {
                extra = _bottomClickOffsetY + _bottomClickButton.zc_height;
                _lyBottomClickCx.constant = maxTwo / 2.0 + _bottomClickOffsetY + _bottomClickButton.zc_height / 2.0;
            } else {
                _lyBottomClickCx.constant = 0;
            }
        }
        _lyTop1.active = NO;
        _lyBottom1.active = NO;
        _lyTop2.active = YES;
        _lyBottom2.active = YES;
        _lyTop2.constant = _marginInset.top + (maxTwo - _lineTwoReferView.zc_height) / 2.0;
        _lyBottom2.constant = -(_marginInset.bottom + extra + (maxTwo - _lineTwoReferView.zc_height) / 2.0);
    } else {
        [self setCoverMaskHidden:NO];
        if (_lineOneReferView) {
            _lyTop2.active = NO;
            _lyBottom2.active = NO;
            _lyTop1.active = YES;
            _lyBottom1.active = YES;
            _lyTop1.constant = 0.3 - _lineOneReferView.zc_height / 2.0;
            _lyBottom1.constant = _lineOneReferView.zc_height / 2.0 - 0.3;
        } else if (_lineTwoReferView) {
            _lyTop1.active = NO;
            _lyBottom1.active = NO;
            _lyTop2.active = YES;
            _lyBottom2.active = YES;
            _lyTop2.constant = 0.3 - _lineTwoReferView.zc_height / 2.0;
            _lyBottom2.constant = _lineTwoReferView.zc_height / 2.0 - 0.3;
        } else {
            NSAssert(0, @"ZCKit: not container subviews");
        }
    }
}

- (CGFloat)lineOneUpdateConstraints {
    CGFloat max = -1;
    CGFloat right = _marginInset.right;
    CGFloat left = _marginInset.left + _level * _levelSpacing;
    
    CGFloat leftMax = left; CGFloat rightMax = right;
    //左侧最小宽度
    if ([self isSeatView:_selectButton]) {
        leftMax = leftMax + _selectButton.zc_width + _horizontalSpacing;
    }
    if ([self isSeatView:_avatarControl]) {
        leftMax = leftMax + _avatarControl.zc_width + _horizontalSpacing;
    }
    if ([self isSeatView:_leadingLabel]) {
        leftMax = leftMax + _lineOneMinLeft + _horizontalSpacing;
    }
    if ([self isSeatView:_flagContainerView]) {
        leftMax = leftMax + _flagContainerView.zc_width + _horizontalSpacing;
    }
    if ([self isSeatView:_inputTextField]) {
        leftMax = leftMax + _inputTextField.zc_width + _horizontalSpacing;
    }
    //右侧最大宽度
    if ([self isSeatView:_accessControl]) {
        rightMax = rightMax + _accessControl.zc_width + _horizontalSpacing;
    }
    if ([self isSeatView:_badgeView]) {
        rightMax = rightMax + _badgeView.zc_width + _horizontalSpacing;
    }
    if ([self isSeatView:_switchControl]) {
        rightMax = rightMax + _switchControl.zc_width + _horizontalSpacing;
    }
    if ([self isSeatView:_clickButton]) {
        rightMax = rightMax + _clickButton.zc_width + _horizontalSpacing;
    }
    if ([self isSeatView:_containerView]) {
        rightMax = rightMax + _containerView.zc_width + _horizontalSpacing;
    }
    if ([self isSeatView:_trailingLabel]) {
        CGFloat maxWid = self.zc_width - rightMax - leftMax;
        CGSize size = [_trailingLabel sizeThatFits:CGSizeMake(maxWid, MAXFLOAT)];
        size = CGSizeMake(ceilf(size.width), ceilf(size.height));
        size.width = MIN(maxWid, size.width);
        rightMax = rightMax + size.width + _horizontalSpacing;
        _trailingLabel.zc_size = size;
        if ([self isSeatView:_fitTextField]) {
            NSAssert(0, @"ZCKit: trailingLabel and fitTextField coexistence");
        }
    } else if ([self isSeatView:_fitTextField]) {
        CGFloat fitMaxWid = self.zc_width - rightMax - leftMax;
        if ([self isSeatView:_leadingLabel]) {
            CGFloat rightMax1 = rightMax + _lineOneMinRight + _horizontalSpacing;
            CGFloat maxWid1 = self.zc_width - rightMax1 - leftMax + _lineOneMinLeft + _horizontalSpacing;
            CGSize size = [_leadingLabel sizeThatFits:CGSizeMake(maxWid1, MAXFLOAT)];
            size = CGSizeMake(ceilf(size.width), ceilf(size.height));
            fitMaxWid = self.zc_width - rightMax - leftMax + _lineOneMinLeft - MIN(maxWid1, size.width);
        }
        rightMax = rightMax + fitMaxWid + _horizontalSpacing;
        _fitTextField.zc_size = CGSizeMake(fitMaxWid, _fitTextField.font.fontSize + kZSA(4));
    }
    //重算左侧宽度
    if ([self isSeatView:_leadingLabel]) {
        CGFloat maxWid = self.zc_width - rightMax - leftMax + _lineOneMinLeft + _horizontalSpacing;
        CGSize size = [_leadingLabel sizeThatFits:CGSizeMake(maxWid, MAXFLOAT)];
        size = CGSizeMake(ceilf(size.width), ceilf(size.height));
        size.width = MIN(maxWid, size.width);
        _leadingLabel.zc_size = size;
    }
    
    //重新布局位置
    if ([self isSeatView:_selectButton]) {
        [self resetLeftConstraint:_selectButton left:left];
        left = left + _selectButton.zc_width + _horizontalSpacing;
        if (!_isSelectAvatarBeCenter) max = MAX(_selectButton.zc_height, max);
        else {_selectAvatarCR = left; max = MAX(rowHideHei, max);}
    }
    if ([self isSeatView:_avatarControl]) {
        [self resetLeftConstraint:_avatarControl left:left];
        left = left + _avatarControl.zc_width + _horizontalSpacing;
        if (!_isSelectAvatarBeCenter) max = MAX(_avatarControl.zc_height, max);
        else {_selectAvatarCR = left; max = MAX(rowHideHei, max);}
    }
    if ([self isSeatView:_leadingLabel]) {
        [self resetLeftConstraint:_leadingLabel left:left];
        left = left + _leadingLabel.zc_width + _horizontalSpacing;
        if (!_isLeadingBeCenter) max = MAX(_leadingLabel.zc_height, max);
        else {_leadingCR = left; max = MAX(rowHideHei, max);}
    }
    if ([self isSeatView:_flagContainerView]) {
        [self resetLeftConstraint:_flagContainerView left:left];
        left = left + _flagContainerView.zc_width + _horizontalSpacing;
        max = MAX(_flagContainerView.zc_height, max);
    }
    if ([self isSeatView:_inputTextField]) {
        [self resetLeftConstraint:_inputTextField left:left];
        //left = left + _inputTextField.width + _horizontalSpacing;
        max = MAX(_inputTextField.zc_height, max);
    }
    
    if ([self isSeatView:_accessControl]) {
        [self resetRightConstraint:_accessControl right:right];
        right = right + _accessControl.zc_width + _horizontalSpacing;
        if (!_isAccessBeCenter) max = MAX(_accessControl.zc_height, max);
        else {_accessCR = right; max = MAX(rowHideHei, max);}
    }
    if ([self isSeatView:_badgeView]) {
        [self resetRightConstraint:_badgeView right:right];
        right = right + _badgeView.zc_width + _horizontalSpacing;
        max = MAX(_badgeView.zc_height, max);
    }
    if ([self isSeatView:_switchControl]) {
        [self resetRightConstraint:_switchControl right:right];
        right = right + _switchControl.zc_width + _horizontalSpacing;
        max = MAX(_switchControl.zc_height, max);
    }
    if ([self isSeatView:_clickButton]) {
        [self resetRightConstraint:_clickButton right:right];
        right = right + _clickButton.zc_width + _horizontalSpacing;
        max = MAX(_clickButton.zc_height, max);
    }
    if ([self isSeatView:_containerView]) {
        [self resetRightConstraint:_containerView right:right];
        right = right + _containerView.zc_width + _horizontalSpacing;
        max = MAX(_containerView.zc_height, max);
    }
    if ([self isSeatView:_trailingLabel]) {
        [self resetRightConstraint:_trailingLabel right:right];
        //right = right + _trailingLabel.zc_width + _horizontalSpacing;
        max = MAX(_trailingLabel.zc_height, max);
    } else if ([self isSeatView:_fitTextField]) {
        [self resetRightConstraint:_fitTextField right:right];
        //right = right + _fitTextField.zc_width + _horizontalSpacing;
        max = MAX(_fitTextField.zc_height, max);
    }
    
    //重新刷新参照视图约束
    if (_lineOneReferView && ![self isSeatView:_lineOneReferView]) {
        [self resetSizeConstraint:_lineOneReferView];
    }
    return max;
}

- (CGFloat)lineTwoUpdateConstraints {
    CGFloat max = -1;
    CGFloat right = _marginInset.right;
    CGFloat left = _marginInset.left + (_level + 1) * _levelSpacing;
    if (_isSelectAvatarBeCenter && ([self isSeatView:_selectButton] || [self isSeatView:_avatarControl])) {
        left = _selectAvatarCR;
    }
    if (_isLeadingBeCenter && [self isSeatView:_leadingLabel]) {
        left = _leadingCR;
    }
    if (_isAccessBeCenter && [self isSeatView:_accessControl]) {
        right = _accessCR;
    }
    
    CGFloat leading = left;
    if ([self isSeatView:_bottomDescLabel]) {
        leading = leading + _lineTwoMinLeft + _horizontalSpacing;
        if ([self isSeatView:_bottomTextView]) {
            NSAssert(0, @"ZCKit: bottomDescLabel and bottomTextView coexistence");
        }
    } else if ([self isSeatView:_bottomTextView]) {
        leading = leading + _lineTwoMinLeft + _horizontalSpacing;
    }
    if ([self isSeatView:_bottomFlagContainerView]) {
        leading = leading + _bottomFlagContainerView.zc_width + _horizontalSpacing;
    }
    if ([self isSeatView:_bottomTextField]) {
        leading = leading + _bottomTextField.zc_width + _horizontalSpacing;
    }
    
    if ([self isSeatView:_bottomBadgeView]) {
        [self resetRightConstraint:_bottomBadgeView right:right];
        right = right + _bottomBadgeView.zc_width + _horizontalSpacing;
        max = MAX(_bottomBadgeView.zc_height, max);
    }
    if ([self isSeatView:_bottomClickButton]) {
        if (_bottomClickOffsetY) {
            [self resetRightConstraint:_bottomClickButton right:(self.zc_width - _bottomClickButton.zc_width) / 2.0];
            max = MAX(rowHideHei, max);
        } else {
            [self resetRightConstraint:_bottomClickButton right:right];
            right = right + _bottomClickButton.zc_width + _horizontalSpacing;
            max = MAX(_bottomClickButton.zc_height, max);
        }
    }
    if ([self isSeatView:_bottomContainerView]) {
        [self resetRightConstraint:_bottomContainerView right:right];
        right = right + _bottomContainerView.zc_width + _horizontalSpacing;
        max = MAX(_bottomContainerView.zc_height, max);
    }
    if ([self isSeatView:_bottomAttachLabel]) {
        CGFloat maxWid = self.zc_width - right - leading;
        CGSize size = [_bottomAttachLabel sizeThatFits:CGSizeMake(maxWid, MAXFLOAT)];
        size = CGSizeMake(ceilf(size.width), ceilf(size.height));
        size.width = MIN(maxWid, size.width);
        _bottomAttachLabel.zc_size = size;
        [self resetRightConstraint:_bottomAttachLabel right:right];
        right = right + _bottomAttachLabel.zc_width + _horizontalSpacing;
        max = MAX(_bottomAttachLabel.zc_height, max);
    }
    
    if ([self isSeatView:_bottomDescLabel]) {
        CGFloat maxWid = self.zc_width - right - leading + _lineTwoMinLeft + _horizontalSpacing;
        CGSize size = [_bottomDescLabel sizeThatFits:CGSizeMake(maxWid, MAXFLOAT)];
        size = CGSizeMake(ceilf(size.width), ceilf(size.height));
        size.width = MIN(maxWid, size.width);
        _bottomDescLabel.zc_size = size;
        [self resetLeftConstraint:_bottomDescLabel left:left];
        left = left + _bottomDescLabel.zc_width + _horizontalSpacing;
        max = MAX(_bottomDescLabel.zc_height, max);
    } else if ([self isSeatView:_bottomTextView]) {
        CGFloat maxWid = self.zc_width - right - leading + _lineTwoMinLeft + _horizontalSpacing;
        CGSize size1 = [_bottomTextView sizeThatFits:CGSizeMake(maxWid, MAXFLOAT)];
        size1 = CGSizeMake(ceilf(size1.width), ceilf(size1.height));
        NSString *tempText = _bottomTextView.text;
        _bottomTextView.text = _textViewCalText;
        CGSize size2 = [_bottomTextView sizeThatFits:CGSizeMake(maxWid, MAXFLOAT)];
        size2 = CGSizeMake(ceilf(size2.width), ceilf(size2.height));
        _bottomTextView.text = tempText;
        _bottomTextView.zc_size = CGSizeMake(maxWid, MAX(size1.height, size2.height));
        [self resetLeftConstraint:_bottomTextView left:left];
        left = left + _bottomTextView.zc_width + _horizontalSpacing;
        max = MAX(_bottomTextView.zc_height, max);
    }
    if ([self isSeatView:_bottomFlagContainerView]) {
        [self resetLeftConstraint:_bottomFlagContainerView left:left];
        left = left + _bottomFlagContainerView.zc_width + _horizontalSpacing;
        max = MAX(_bottomFlagContainerView.zc_height, max);
    }
    if ([self isSeatView:_bottomTextField]) {
        [self resetLeftConstraint:_bottomTextField left:left];
        //left = left + _bottomTextField.zc_width + _horizontalSpacing;
        max = MAX(_bottomTextField.zc_height, max);
    }
    
    if (_lineTwoReferView && ![self isSeatView:_lineTwoReferView]) {
        [self resetSizeConstraint:_lineTwoReferView];
    }
    return max;
}

#pragma mark - Misc1
- (void)resetLeftConstraint:(UIView *)subview left:(CGFloat)left {
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
}

- (void)resetRightConstraint:(UIView *)subview right:(CGFloat)right {
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
}

- (void)resetSizeConstraint:(UIView *)subview {
    if (subview == _switchControl) {
        [subview layoutIfNeeded]; return;
    }
    CGSize size = subview.zc_size;
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

#pragma mark - Misc2
- (BOOL)isSeatView:(UIView *)subview {
    if (subview && !subview.hidden) {
        if (subview == _trailingLabel && _isTrailingLabel) {
            return NO;
        }
        if (subview == _bottomAttachLabel && _isAttachLabel) {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (void)injectBasicConstraint:(UIView *)subview lineOne:(BOOL)lineOne {
    UIView *compareView = lineOne ? _lineOneReferView : _lineTwoReferView;
    if (compareView) {
        NSLayoutConstraint *layout = [self injectConstraint:subview att:NSLayoutAttributeCenterY comp:compareView cons:0];
        if (subview == _avatarControl) _lyAvatarCx = layout;
        if (subview == _selectButton) _lySelectCx = layout;
        if (subview == _leadingLabel) _lyLeadingCx = layout;
        if (subview == _accessControl) _lyAccessCx = layout;
        if (subview == _bottomClickButton) _lyBottomClickCx = layout;
    } else {
        if (lineOne) {
            _lineOneReferView = subview;
            _lyTop1 = [self injectConstraint:subview att:NSLayoutAttributeTop comp:self.contentView cons:0];
            _lyBottom1 = [self injectConstraint:subview att:NSLayoutAttributeBottom comp:self.contentView cons:0];
        } else {
            _lineTwoReferView = subview;
            _lyTop2 = [self injectConstraint:subview att:NSLayoutAttributeTop comp:self.contentView cons:0];
            _lyBottom2 = [self injectConstraint:subview att:NSLayoutAttributeBottom comp:self.contentView cons:0];
        }
    }
}

- (NSLayoutConstraint *)injectConstraint:(UIView *)refer att:(NSLayoutAttribute)att comp:(UIView *)comp cons:(CGFloat)cons {
    CGFloat mult = 1.0;
    NSLayoutAttribute att1 = att;
    NSLayoutRelation relation = NSLayoutRelationEqual;
    BOOL isSizeConstraint = (att == NSLayoutAttributeWidth || att == NSLayoutAttributeHeight);
    if (isSizeConstraint) {att1 = NSLayoutAttributeNotAnAttribute; mult = 0;}
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:refer attribute:att relatedBy:relation toItem:comp
                                                              attribute:att1 multiplier:mult constant:cons];
    layout.identifier = layoutIdent;
    layout.priority = UILayoutPriorityRequired;
    if (isSizeConstraint) {
        [refer addConstraint:layout];
    } else {
        [self.contentView addConstraint:layout];
    }
    return layout;
}

#pragma mark - Set
- (void)setLevel:(NSInteger)level {
    _level = level;
    [self resetConstraint];
}

- (void)setLevelSpacing:(CGFloat)levelSpacing {
    _levelSpacing = levelSpacing;
    [self resetConstraint];
}

- (void)setVerticalSpacing:(CGFloat)verticalSpacing {
    _verticalSpacing = verticalSpacing;
    [self resetConstraint];
}

- (void)setHorizontalSpacing:(CGFloat)horizontalSpacing {
    _horizontalSpacing = horizontalSpacing;
    [self resetConstraint];
}

- (void)setMarginInset:(UIEdgeInsets)marginInset {
    _marginInset = marginInset;
    [self resetConstraint];
}

- (void)setTopSeparatorInset:(UIEdgeInsets)topSeparatorInset {
    _topSeparatorInset = topSeparatorInset;
    if (UIEdgeInsetsEqualToEdgeInsets(_topSeparatorInset, UIEdgeInsetsZero)) {
        _topSeparator.hidden = YES;
    } else {
        self.topSeparator.hidden = NO;
        self.topSeparator.backgroundColor = _separatorBKColor;
    }
    [self resetConstraint];
}

- (void)setBottomSeparatorInset:(UIEdgeInsets)bottomSeparatorInset {
    _bottomSeparatorInset = bottomSeparatorInset;
    if (UIEdgeInsetsEqualToEdgeInsets(_bottomSeparatorInset, UIEdgeInsetsZero)) {
        _bottomSeparator.hidden = YES;
    } else {
        self.bottomSeparator.hidden = NO;
        self.bottomSeparator.backgroundColor = _separatorBKColor;
    }
    [self resetConstraint];
}

- (void)setInsideMargin:(UIEdgeInsets)insideMargin {
    _insideMargin = insideMargin;
    if (UIEdgeInsetsEqualToEdgeInsets(_insideMargin, UIEdgeInsetsZero)) {
        _insideView.hidden = YES;
    } else {
        self.insideView.hidden = NO;
        self.insideView.backgroundColor = _insideBKColor;
    }
    [self resetConstraint];
}

- (void)setBottomClickOffsetY:(CGFloat)bottomClickOffsetY {
    _bottomClickOffsetY = bottomClickOffsetY;
    [self resetConstraint];
}

- (void)setIsSelectAvatarBeCenter:(BOOL)isSelectAvatarBeCenter {
    _isSelectAvatarBeCenter = isSelectAvatarBeCenter;
    [self resetConstraint];
}

- (void)setIsLeadingBeCenter:(BOOL)isLeadingBeCenter {
    _isLeadingBeCenter = isLeadingBeCenter;
    [self resetConstraint];
}

- (void)setIsAccessBeCenter:(BOOL)isAccessBeCenter {
    _isAccessBeCenter = isAccessBeCenter;
    [self resetConstraint];
}

- (void)setSeparatorBKColor:(UIColor *)separatorBKColor {
    _separatorBKColor = separatorBKColor;
    _topSeparator.backgroundColor = _separatorBKColor;
    _bottomSeparator.backgroundColor = _separatorBKColor;
}

- (void)setInsideBKColor:(UIColor *)insideBKColor {
    _insideBKColor = insideBKColor;
    _insideView.backgroundColor = _insideBKColor;
}

- (void)setSelectBKColor:(UIColor *)selectBKColor {
    _selectBKColor = selectBKColor;
    if (selectBKColor) {
        self.selectBKView.hidden = NO;
        self.selectBKView.backgroundColor = _selectBKColor;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.selectedBackgroundView = self.selectBKView;
    } else {
        _selectBKView.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectedBackgroundView = nil;
    }
}

- (void)setCoverMaskHidden:(BOOL)hidden {
    if (hidden) {
        _coverMaskView.hidden = YES;
    } else {
        self.coverMaskView.hidden = NO;
        self.coverMaskView.backgroundColor = self.backgroundColor;
        [self bringSubviewToFront:self.coverMaskView];
    }
}

#pragma mark - Get
- (UIView *)insideView {
    if (!_insideView) {
        _insideView = [[UIView alloc] initWithFrame:CGRectZero];
        [self insertSubview:_insideView atIndex:0];
    }
    return _insideView;
}

- (UIView *)selectBKView {
    if (!_selectBKView) {
        _selectBKView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _selectBKView;
}

- (UIView *)topSeparator {
    if (!_topSeparator) {
        _topSeparator = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_topSeparator];
    }
    return _topSeparator;
}

- (UIView *)bottomSeparator {
    if (!_bottomSeparator) {
        _bottomSeparator = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_bottomSeparator];
    }
    return _bottomSeparator;
}

- (UIView *)coverMaskView {
    if (!_coverMaskView) {
        _coverMaskView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_coverMaskView];
    }
    return _coverMaskView;
}

#pragma mark - Get
- (ZCButton *)selectButton {
    if (!_selectButton) {
        if (!_lineOneReferView && !_trailingLabel) {self.trailingLabel.hidden = YES; _isTrailingLabel = YES;}
        _selectButton = [[ZCButton alloc] initWithFrame:CGRectZero color:nil];
        _selectButton.zc_size = CGSizeMake(kZSA(20), kZSA(20));
        _selectButton.titleLabel.font = kZFR(16);
        _selectButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _selectButton.titleLabel.minimumScaleFactor = 0.5;
        _selectButton.responseAreaExtend = UIEdgeInsetsMake(kZSA(5), kZSA(5), kZSA(5), kZSA(5));
        _selectButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_selectButton setTitleColor:kZCBlack30 forState:UIControlStateNormal];
        [self.contentView addSubview:_selectButton];
        [self injectBasicConstraint:_selectButton lineOne:YES];
    }
    if (_recordHiddenInt & (1 << 0)) {
        _recordHiddenInt ^= 1 << 0;
        _selectButton.hidden = NO;
    }
    return _selectButton;
}

- (ZCAvatarControl *)avatarControl {
    if (!_avatarControl) {
        if (!_lineOneReferView && !_trailingLabel) {self.trailingLabel.hidden = YES; _isTrailingLabel = YES;}
        _avatarControl = [[ZCAvatarControl alloc] initWithFrame:CGRectZero];
        _avatarControl.translatesAutoresizingMaskIntoConstraints = NO;
        _avatarControl.zc_size = CGSizeMake(kZSA(40), kZSA(40));
        _avatarControl.userInteractionEnabled = YES;
        [self.contentView addSubview:_avatarControl];
        [self injectBasicConstraint:_avatarControl lineOne:YES];
    }
    if (_recordHiddenInt & (1 << 1)) {
        _recordHiddenInt ^= 1 << 1;
        _avatarControl.hidden = NO;
    }
    return _avatarControl;
}

- (ZCLabel *)leadingLabel {
    if (!_leadingLabel) {
        if (!_lineOneReferView && !_trailingLabel) {self.trailingLabel.hidden = YES; _isTrailingLabel = YES;}
        _leadingLabel = [[ZCLabel alloc] initWithFrame:CGRectZero];
        _leadingLabel.textAlignment = NSTextAlignmentLeft;
        _leadingLabel.textColor = kZCBlack30;
        _leadingLabel.numberOfLines = 0;
        _leadingLabel.font = kZFR(16);
        _leadingLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_leadingLabel];
        [self injectBasicConstraint:_leadingLabel lineOne:YES];
    }
    if (_recordHiddenInt & (1 << 2)) {
        _recordHiddenInt ^= 1 << 2;
        _leadingLabel.hidden = NO;
    }
    return _leadingLabel;
}

- (UIView *)flagContainerView {
    if (!_flagContainerView) {
        _flagContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _flagContainerView.zc_size = CGSizeMake(kZSA(20), kZSA(20));
        _flagContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_flagContainerView];
        [self injectBasicConstraint:_flagContainerView lineOne:YES];
    }
    if (_recordHiddenInt & (1 << 3)) {
        _recordHiddenInt ^= 1 << 3;
        _flagContainerView.hidden = NO;
    }
    return _flagContainerView;
}

- (ZCTextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[ZCTextField alloc] initWithFrame:CGRectZero];
        _inputTextField.zc_size = CGSizeMake(kZSA(160), kZSA(30));
        _inputTextField.textAlignment = NSTextAlignmentLeft;
        _inputTextField.keyboardType = UIKeyboardTypeDefault;
        _inputTextField.borderStyle = UITextBorderStyleNone;
        _inputTextField.returnKeyType = UIReturnKeyDone;
        _inputTextField.adjustsFontSizeToFitWidth = YES;
        _inputTextField.isForbidVisibleMenu = YES;
        _inputTextField.minimumFontSize = kZSA(10);
        _inputTextField.textColor = kZCBlack30;
        _inputTextField.font = kZFR(16);
        _inputTextField.responseAreaExtend = UIEdgeInsetsMake(kZSA(5), kZSA(5), kZSA(5), kZSA(5));
        _inputTextField.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_inputTextField];
        [self injectBasicConstraint:_inputTextField lineOne:YES];
    }
    if (_recordHiddenInt & (1 << 4)) {
        _recordHiddenInt ^= 1 << 4;
        _inputTextField.hidden = NO;
    }
    return _inputTextField;
}

- (ZCAvatarControl *)accessControl {
    if (!_accessControl) {
        if (!_lineOneReferView && !_trailingLabel) {self.trailingLabel.hidden = YES; _isTrailingLabel = YES;}
        _accessControl = [[ZCAvatarControl alloc] initWithFrame:CGRectZero];
        _accessControl.translatesAutoresizingMaskIntoConstraints = NO;
        //_accessControl.localImage = ZCKitBridge.sideArrowImage;
        
        ///MARK: xxx
        
        
        
        _accessControl.zc_size = CGSizeMake(kZSA(6), kZSA(12));
        _accessControl.userInteractionEnabled = NO;
        [self.contentView addSubview:_accessControl];
        [self injectBasicConstraint:_accessControl lineOne:YES];
    }
    if (_recordHiddenInt & (1 << 5)) {
        _recordHiddenInt ^= 1 << 5;
        _accessControl.hidden = NO;
    }
    return _accessControl;
}

- (ZCBadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [[ZCBadgeView alloc] initWithFrame:CGRectZero];
        _badgeView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_badgeView];
        [self injectBasicConstraint:_badgeView lineOne:YES];
    }
    if (_recordHiddenInt & (1 << 6)) {
        _recordHiddenInt ^= 1 << 6;
        _badgeView.hidden = NO;
    }
    return _badgeView;
}

- (ZCSwitch *)switchControl {
    if (!_switchControl) {
        _switchControl = [[ZCSwitch alloc] initWithFrame:CGRectZero];
        _switchControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_switchControl];
        [self injectBasicConstraint:_switchControl lineOne:YES];
    }
    if (_recordHiddenInt & (1 << 7)) {
        _recordHiddenInt ^= 1 << 7;
        _switchControl.hidden = NO;
    }
    return _switchControl;
}

- (ZCButton *)clickButton {
    if (!_clickButton) {
        _clickButton = [[ZCButton alloc] initWithFrame:CGRectZero color:nil];
        _clickButton.zc_size = CGSizeMake(kZSA(30), kZSA(30));
        _clickButton.titleLabel.font = kZFR(16);
        _clickButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _clickButton.titleLabel.minimumScaleFactor = 0.5;
        _clickButton.responseAreaExtend = UIEdgeInsetsMake(kZSA(5), kZSA(5), kZSA(5), kZSA(5));
        _clickButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_clickButton setTitleColor:kZCBlack30 forState:UIControlStateNormal];
        [self.contentView addSubview:_clickButton];
        [self injectBasicConstraint:_clickButton lineOne:YES];
    }
    if (_recordHiddenInt & (1 << 8)) {
        _recordHiddenInt ^= 1 << 8;
        _clickButton.hidden = NO;
    }
    return _clickButton;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.zc_size = CGSizeMake(kZSA(30), kZSA(30));
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_containerView];
        [self injectBasicConstraint:_containerView lineOne:YES];
    }
    if (_recordHiddenInt & (1 << 9)) {
        _recordHiddenInt ^= 1 << 9;
        _containerView.hidden = NO;
    }
    return _containerView;
}

- (ZCTextField *)fitTextField {
    if (!_fitTextField) {
        _fitTextField = [[ZCTextField alloc] initWithFrame:CGRectZero];
        _fitTextField.textAlignment = NSTextAlignmentRight;
        _fitTextField.keyboardType = UIKeyboardTypeDefault;
        _fitTextField.borderStyle = UITextBorderStyleNone;
        _fitTextField.returnKeyType = UIReturnKeyDone;
        _fitTextField.adjustsFontSizeToFitWidth = NO;
        _fitTextField.isForbidVisibleMenu = YES;
        _fitTextField.textColor = kZCBlack30;
        _fitTextField.font = kZFR(16);
        _fitTextField.responseAreaExtend = UIEdgeInsetsMake(kZSA(5), kZSA(5), kZSA(5), kZSA(5));
        _fitTextField.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_fitTextField];
        [self injectBasicConstraint:_fitTextField lineOne:YES];
    }
    if (_recordHiddenInt & (1 << 10)) {
        _recordHiddenInt ^= 1 << 10;
        _fitTextField.hidden = NO;
    }
    return _fitTextField;
}

- (ZCLabel *)trailingLabel {
    if (_isTrailingLabel) {
        _isTrailingLabel = NO;
        _trailingLabel.hidden = NO;
    }
    if (!_trailingLabel) {
        _trailingLabel = [[ZCLabel alloc] initWithFrame:CGRectZero];
        _trailingLabel.textAlignment = NSTextAlignmentRight;
        _trailingLabel.textColor = kZCBlackA8;
        _trailingLabel.numberOfLines = 0;
        _trailingLabel.font = kZFR(16);
        _trailingLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_trailingLabel];
        [self injectBasicConstraint:_trailingLabel lineOne:YES];
    }
    if (_recordHiddenInt & (1 << 11)) {
        _recordHiddenInt ^= 1 << 11;
        _trailingLabel.hidden = NO;
    }
    return _trailingLabel;
}

- (ZCLabel *)bottomDescLabel {
    if (!_bottomDescLabel) {
        _bottomDescLabel = [[ZCLabel alloc] initWithFrame:CGRectZero];
        _bottomDescLabel.textAlignment = NSTextAlignmentLeft;
        _bottomDescLabel.textColor = kZCBlack80;
        _bottomDescLabel.numberOfLines = 0;
        _bottomDescLabel.font = kZFR(14);
        _bottomDescLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_bottomDescLabel];
        [self injectBasicConstraint:_bottomDescLabel lineOne:NO];
    }
    if (_recordHiddenInt & (1 << 12)) {
        _recordHiddenInt ^= 1 << 12;
        _bottomDescLabel.hidden = NO;
    }
    return _bottomDescLabel;
}

- (ZCTextView *)bottomTextView {
    if (!_bottomTextView) { //调用时注意在ios9会提前updateConstraints
        _bottomTextView = [[ZCTextView alloc] initWithFrame:CGRectZero];
        CGFloat linePad = _bottomTextView.textContainer.lineFragmentPadding;
        _bottomTextView.textContainerInset = UIEdgeInsetsMake(0, -linePad, 0, -linePad);
        _bottomTextView.textAlignment = NSTextAlignmentLeft;
        _bottomTextView.keyboardType = UIKeyboardTypeDefault;
        _bottomTextView.returnKeyType = UIReturnKeyDefault;
        _bottomTextView.showsHorizontalScrollIndicator = NO;
        _bottomTextView.showsVerticalScrollIndicator = NO;
        _bottomTextView.placeholderTextColor = nil;
        _bottomTextView.textColor = kZCBlack30;
        _bottomTextView.font = kZFR(16);
        _bottomTextView.bounces = NO;
        _bottomTextView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_bottomTextView];
        [self injectBasicConstraint:_bottomTextView lineOne:NO];
    }
    if (_recordHiddenInt & (1 << 13)) {
        _recordHiddenInt ^= 1 << 13;
        _bottomTextView.hidden = NO;
    }
    return _bottomTextView;
}

- (UIView *)bottomFlagContainerView {
    if (!_bottomFlagContainerView) {
        _bottomFlagContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomFlagContainerView.zc_size = CGSizeMake(kZSA(20), kZSA(20));
        _bottomFlagContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_bottomFlagContainerView];
        [self injectBasicConstraint:_bottomFlagContainerView lineOne:NO];
    }
    if (_recordHiddenInt & (1 << 19)) {
        _recordHiddenInt ^= 1 << 19;
        _bottomFlagContainerView.hidden = NO;
    }
    return _bottomFlagContainerView;
}

- (ZCTextField *)bottomTextField {
    if (!_bottomTextField) {
        _bottomTextField = [[ZCTextField alloc] initWithFrame:CGRectZero];
        _bottomTextField.zc_size = CGSizeMake(kZSA(160), kZSA(30));
        _bottomTextField.textAlignment = NSTextAlignmentLeft;
        _bottomTextField.keyboardType = UIKeyboardTypeDefault;
        _bottomTextField.borderStyle = UITextBorderStyleNone;
        _bottomTextField.returnKeyType = UIReturnKeyDone;
        _bottomTextField.adjustsFontSizeToFitWidth = YES;
        _bottomTextField.isForbidVisibleMenu = YES;
        _bottomTextField.minimumFontSize = kZSA(10);
        _bottomTextField.textColor = kZCBlack30;
        _bottomTextField.font = kZFR(16);
        _bottomTextField.responseAreaExtend = UIEdgeInsetsMake(kZSA(5), kZSA(5), kZSA(5), kZSA(5));
        _bottomTextField.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_bottomTextField];
        [self injectBasicConstraint:_bottomTextField lineOne:NO];
    }
    if (_recordHiddenInt & (1 << 18)) {
        _recordHiddenInt ^= 1 << 18;
        _bottomTextField.hidden = NO;
    }
    return _bottomTextField;
}

- (ZCLabel *)bottomAttachLabel {
    if (_isAttachLabel) {
        _isAttachLabel = NO;
        _bottomAttachLabel.hidden = NO;
    }
    if (!_bottomAttachLabel) {
        _bottomAttachLabel = [[ZCLabel alloc] initWithFrame:CGRectZero];
        _bottomAttachLabel.textAlignment = NSTextAlignmentRight;
        _bottomAttachLabel.textColor = kZCBlackA8;
        _bottomAttachLabel.numberOfLines = 0;
        _bottomAttachLabel.font = kZFR(13);
        _bottomAttachLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_bottomAttachLabel];
        [self injectBasicConstraint:_bottomAttachLabel lineOne:NO];
    }
    if (_recordHiddenInt & (1 << 14)) {
        _recordHiddenInt ^= 1 << 14;
        _bottomAttachLabel.hidden = NO;
    }
    return _bottomAttachLabel;
}

- (UIView *)bottomContainerView {
    if (!_bottomContainerView) {
        _bottomContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomContainerView.zc_size = CGSizeMake(kZSA(30), kZSA(30));
        _bottomContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_bottomContainerView];
        [self injectBasicConstraint:_bottomContainerView lineOne:NO];
    }
    if (_recordHiddenInt & (1 << 15)) {
        _recordHiddenInt ^= 1 << 15;
        _bottomContainerView.hidden = NO;
    }
    return _bottomContainerView;
}

- (ZCButton *)bottomClickButton {
    if (!_bottomClickButton) {
        if (!_lineTwoReferView && !_bottomAttachLabel) {self.bottomAttachLabel.hidden = YES; _isAttachLabel = YES;}
        _bottomClickButton = [[ZCButton alloc] initWithFrame:CGRectZero color:nil];
        _bottomClickButton.zc_size = CGSizeMake(kZSA(30), kZSA(30));
        _bottomClickButton.titleLabel.font = kZFR(16);
        _bottomClickButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _bottomClickButton.titleLabel.minimumScaleFactor = 0.5;
        _bottomClickButton.responseAreaExtend = UIEdgeInsetsMake(kZSA(5), kZSA(5), kZSA(5), kZSA(5));
        _bottomClickButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_bottomClickButton setTitleColor:kZCBlack30 forState:UIControlStateNormal];
        [self.contentView addSubview:_bottomClickButton];
        [self injectBasicConstraint:_bottomClickButton lineOne:NO];
    }
    if (_recordHiddenInt & (1 << 16)) {
        _recordHiddenInt ^= 1 << 16;
        _bottomClickButton.hidden = NO;
    }
    return _bottomClickButton;
}

- (ZCBadgeView *)bottomBadgeView {
    if (!_bottomBadgeView) {
        _bottomBadgeView = [[ZCBadgeView alloc] initWithFrame:CGRectZero];
        _bottomBadgeView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_bottomBadgeView];
        [self injectBasicConstraint:_bottomBadgeView lineOne:NO];
    }
    if (_recordHiddenInt & (1 << 17)) {
        _recordHiddenInt ^= 1 << 17;
        _bottomBadgeView.hidden = NO;
    }
    return _bottomBadgeView;
}

#pragma mark - Prt
- (void)initUIViewProperty:(UIView *)view {
    if (view) {
        [self resetViewBaseProperty:view];
        [view removeAllSubviews];
        
        if (view == _flagContainerView) {
            view.zc_size = CGSizeMake(kZSA(20), kZSA(20));
        } else if (view == _containerView) {
            view.zc_size = CGSizeMake(kZSA(30), kZSA(30));
        } else if (view == _bottomContainerView) {
            view.zc_size = CGSizeMake(kZSA(30), kZSA(30));
        } else if (view == _bottomFlagContainerView) {
            view.zc_size = CGSizeMake(kZSA(20), kZSA(20));
        }
    }
}

- (void)initZCSwitchProperty:(ZCSwitch *)switchv {
    if (switchv) {
        [self resetViewBaseProperty:switchv];
        [switchv sizeToFit];
        switchv.thumbTintColor = nil;
        switchv.onTintColor = nil;
        switchv.tintColor = nil;
        switchv.offImage = nil;
        switchv.onImage = nil;
        switchv.on = NO;
        switchv.touchAction = nil;
        
        if (switchv == _switchControl) {
            //...
        }
    }
}

- (void)initZCBadgeViewProperty:(ZCBadgeView *)badge {
    if (badge) {
        [self resetViewBaseProperty:badge];
        SEL sel = @selector(resetInitProperty);
        if ([badge respondsToSelector:sel]) { kZSuppressLeakWarn([badge performSelector:sel]); }
        
        if (badge == _badgeView) {
            //...
        } else if (badge == _bottomBadgeView) {
            //...
        }
    }
}

- (void)initZCAvatarControlProperty:(ZCAvatarControl *)avatar {
    if (avatar) {
        [self resetViewBaseProperty:avatar];
        SEL sel = @selector(resetInitProperty);
        if ([avatar respondsToSelector:sel]) { kZSuppressLeakWarn([avatar performSelector:sel]); }
        
        if (avatar == _avatarControl) {
            avatar.userInteractionEnabled = YES;
            avatar.zc_size = CGSizeMake(kZSA(40), kZSA(40));
        } else if (avatar == _accessControl) {
            avatar.userInteractionEnabled = NO;
            avatar.zc_size = CGSizeMake(kZSA(6), kZSA(12));
            //avatar.localImage = ZCKitBridge.sideArrowImage;
            
            ///MARK: xxx
        }
    }
}

- (void)initZCLabelProperty:(ZCLabel *)label {
    if (label) {
        [self resetViewBaseProperty:label];
        SEL sel = @selector(resetInitProperty);
        if ([label respondsToSelector:sel]) { kZSuppressLeakWarn([label performSelector:sel]); }
        
        label.adjustsFontForContentSizeCategory = NO;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.textAlignment = NSTextAlignmentLeft;
        label.adjustsFontSizeToFitWidth = NO;
        label.userInteractionEnabled = NO;
        label.attributedText = nil;
        label.numberOfLines = 1;
        label.textColor = nil;
        label.font = nil;
        label.text = nil;
        
        if (label == _leadingLabel) {
            label.font = kZFR(16);
            label.numberOfLines = 0;
            label.textColor = kZCBlack30;
            label.textAlignment = NSTextAlignmentLeft;
        } else if (label == _trailingLabel) {
            label.font = kZFR(16);
            label.numberOfLines = 0;
            label.textColor = kZCBlackA8;
            label.textAlignment = NSTextAlignmentRight;
        } else if (label == _bottomDescLabel) {
            label.font = kZFR(14);
            label.numberOfLines = 0;
            label.textColor = kZCBlack80;
            label.textAlignment = NSTextAlignmentLeft;
        } else if (label == _bottomAttachLabel) {
            label.font = kZFR(13);
            label.numberOfLines = 0;
            label.textColor = kZCBlackA8;
            label.textAlignment = NSTextAlignmentRight;
        }
    }
}

- (void)initZCButtonProperty:(ZCButton *)button {
    if (button) {
        [self resetViewBaseProperty:button];
        [self resetButtonBaseProperty:button];
        
        button.contentEdgeInsets = UIEdgeInsetsZero;
        button.titleEdgeInsets = UIEdgeInsetsZero;
        button.imageEdgeInsets = UIEdgeInsetsZero;
        button.reversesTitleShadowWhenHighlighted = NO;
        button.adjustsImageWhenHighlighted = YES;
        button.adjustsImageWhenDisabled = YES;
        button.showsTouchWhenHighlighted = NO;
        
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.adjustsFontForContentSizeCategory = NO;
        button.titleLabel.userInteractionEnabled = NO;
        button.titleLabel.numberOfLines = 1;
        button.titleLabel.font = nil;
        
        SEL sel = @selector(resetInitProperty);
        if ([button respondsToSelector:sel]) { kZSuppressLeakWarn([button performSelector:sel]); }
        
        if (button == _selectButton) {
            button.titleLabel.font = kZFR(16);
            button.zc_size = CGSizeMake(kZSA(20), kZSA(20));
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleLabel.minimumScaleFactor = 0.5;
            button.responseAreaExtend = UIEdgeInsetsMake(kZSA(5), kZSA(5), kZSA(5), kZSA(5));
            [button setTitleColor:kZCBlack30 forState:UIControlStateNormal];
        } else if (button == _clickButton) {
            button.titleLabel.font = kZFR(16);
            button.zc_size = CGSizeMake(kZSA(30), kZSA(30));
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleLabel.minimumScaleFactor = 0.5;
            button.responseAreaExtend = UIEdgeInsetsMake(kZSA(5), kZSA(5), kZSA(5), kZSA(5));
            [button setTitleColor:kZCBlack30 forState:UIControlStateNormal];
        } else if (button == _bottomClickButton) {
            button.titleLabel.font = kZFR(16);
            button.zc_size = CGSizeMake(kZSA(30), kZSA(30));
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleLabel.minimumScaleFactor = 0.5;
            button.responseAreaExtend = UIEdgeInsetsMake(kZSA(5), kZSA(5), kZSA(5), kZSA(5));
            [button setTitleColor:kZCBlack30 forState:UIControlStateNormal];
        }
    }
}

- (void)initZCTextFieldProperty:(ZCTextField *)field {
    if (field) {
        [field endEditing:YES];
        [self resetViewBaseProperty:field];
        [self resetTextFieldBaseProperty:field];
        
        field.textAlignment = NSTextAlignmentLeft;
        field.borderStyle = UITextBorderStyleNone;
        field.defaultTextAttributes = @{};
        field.attributedPlaceholder = nil;
        field.typingAttributes = nil;
        field.attributedText = nil;
        field.placeholder = nil;
        field.textColor = nil;
        field.text = nil;
        field.font = nil;
        
        field.adjustsFontForContentSizeCategory = NO;
        field.allowsEditingTextAttributes = NO;
        field.adjustsFontSizeToFitWidth = NO;
        field.clearsOnBeginEditing = NO;
        field.clearsOnInsertion = NO;
        field.disabledBackground = nil;
        field.minimumFontSize = 0;
        field.background = nil;
        field.delegate = nil;
        field.leftView = nil;
        field.rightView = nil;
        field.leftViewMode = UITextFieldViewModeNever;
        field.rightViewMode = UITextFieldViewModeNever;
        field.clearButtonMode = UITextFieldViewModeNever;
        field.inputAccessoryView = nil;
        field.inputView = nil;
        
        field.leftSpace = 0;
        field.leftImage = nil;
        field.fixSize = CGSizeZero;
        field.isForbidVisibleMenu = NO;
        field.responseAreaExtend = UIEdgeInsetsZero;
        field.underlineEdgeInsets = UIEdgeInsetsZero;
        field.isOnlyAllowCopyPasteSelect = NO;
        field.limitTextLength = 0;
        field.textChangeBlock = nil;
        field.limitTipBlock = nil;
        field.touchAction = nil;
        
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([field respondsToSelector:@selector(setLogEventControlId:)]) {
            [field setValue:nil forKey:@"logEventControlId"];
        }
        #pragma clang diagnostic pop
        
        if (field == _inputTextField) {
            field.zc_size = CGSizeMake(kZSA(160), kZSA(30));
            field.responseAreaExtend = UIEdgeInsetsMake(kZSA(5), kZSA(5), kZSA(5), kZSA(5));
            field.textAlignment = NSTextAlignmentLeft;
            field.keyboardType = UIKeyboardTypeDefault;
            field.borderStyle = UITextBorderStyleNone;
            field.adjustsFontSizeToFitWidth = YES;
            field.returnKeyType = UIReturnKeyDone;
            field.isForbidVisibleMenu = YES;
            field.minimumFontSize = kZSA(10);
            field.textColor = kZCBlack30;
            field.font = kZFR(16);
        } else if (field == _fitTextField) {
            field.responseAreaExtend = UIEdgeInsetsMake(kZSA(5), kZSA(5), kZSA(5), kZSA(5));
            field.textAlignment = NSTextAlignmentRight;
            field.keyboardType = UIKeyboardTypeDefault;
            field.borderStyle = UITextBorderStyleNone;
            field.returnKeyType = UIReturnKeyDone;
            field.adjustsFontSizeToFitWidth = NO;
            field.isForbidVisibleMenu = YES;
            field.textColor = kZCBlack30;
            field.font = kZFR(16);
        } else if (field == _bottomTextField) {
            field.zc_size = CGSizeMake(kZSA(160), kZSA(30));
            field.responseAreaExtend = UIEdgeInsetsMake(kZSA(5), kZSA(5), kZSA(5), kZSA(5));
            field.textAlignment = NSTextAlignmentLeft;
            field.keyboardType = UIKeyboardTypeDefault;
            field.borderStyle = UITextBorderStyleNone;
            field.adjustsFontSizeToFitWidth = YES;
            field.returnKeyType = UIReturnKeyDone;
            field.isForbidVisibleMenu = YES;
            field.minimumFontSize = kZSA(10);
            field.textColor = kZCBlack30;
            field.font = kZFR(16);
        }
    }
}

- (void)initZCTextViewProperty:(ZCTextView *)text {
    if (text) {
        [text endEditing:YES];
        [self resetViewBaseProperty:text];
        [self resetTextViewBaseProperty:text];
        
        text.textAlignment = NSTextAlignmentLeft;
        text.typingAttributes = @{};
        text.attributedText = nil;
        text.textColor = nil;
        text.delegate = nil;
        text.text = nil;
        text.font = nil;
        
        text.editable = YES;
        text.selectable = YES;
        text.allowsEditingTextAttributes = NO;
        text.adjustsFontForContentSizeCategory = NO;
        text.dataDetectorTypes = UIDataDetectorTypeNone;
        text.textContainerInset = UIEdgeInsetsZero;
        text.clearsOnInsertion = NO;
        text.linkTextAttributes = nil;
        text.inputAccessoryView = nil;
        text.inputView = nil;
        
        text.fixSize = CGSizeZero;
        text.placeholder = nil;
        text.placeholderTextColor = nil;
        text.attributedPlaceholder = nil;
        text.textChangeBlock = nil;
        text.isForbidVisibleMenu = NO;
        text.isOnlyAllowCopyPasteSelect = NO;
        
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([text respondsToSelector:@selector(setLogEventControlId:)]) {
            [text setValue:nil forKey:@"logEventControlId"];
        }
        #pragma clang diagnostic pop
        
        if (text == _bottomTextView) {
            CGFloat linePad = text.textContainer.lineFragmentPadding;
            text.textContainerInset = UIEdgeInsetsMake(0, -linePad, 0, -linePad);
            text.textAlignment = NSTextAlignmentLeft;
            text.keyboardType = UIKeyboardTypeDefault;
            text.returnKeyType = UIReturnKeyDefault;
            text.showsHorizontalScrollIndicator = NO;
            text.showsVerticalScrollIndicator = NO;
            text.placeholderTextColor = nil;
            text.textColor = kZCBlack30;
            text.font = kZFR(16);
            text.bounces = NO;
        }
    }
}

#pragma mark - Prt
- (void)resetCellBaseProperty {
    [self resetViewBaseProperty:self];
    self.editing = NO;
    self.selected = NO;
    self.highlighted = NO;
    self.backgroundView = nil;
    self.showsReorderControl = NO;
    self.shouldIndentWhileEditing = YES;
    self.multipleSelectionBackgroundView = nil;
    self.editingAccessoryView = nil;
    self.accessoryView = nil;
    self.indentationLevel = 0;
    self.indentationWidth = 10.0;
    self.separatorInset = UIEdgeInsetsZero;
    self.focusStyle = UITableViewCellFocusStyleDefault;
    if (@available(iOS 11.0, *)) {
        self.userInteractionEnabledWhileDragging = YES;
    }
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self respondsToSelector:@selector(setLogEventControlId:)]) {
        [self setValue:nil forKey:@"logEventControlId"];
    }
    #pragma clang diagnostic pop
}

- (void)resetViewBaseProperty:(UIView *)view {
    if (view) {
        view.tag = 0;
        view.alpha = 1;
        view.flagStr = nil;
        view.maskView = nil;
        view.clipsToBounds = NO;
        view.exclusiveTouch = NO;
        view.backgroundColor = nil;
        view.multipleTouchEnabled = NO;
        view.userInteractionEnabled = YES;
        view.transform = CGAffineTransformIdentity;
        view.contentMode = UIViewContentModeScaleToFill;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wnonnull"
        [view setTopLineInsets:UIEdgeInsetsZero color:nil];
        [view setLeftLineInsets:UIEdgeInsetsZero color:nil];
        [view setBottomLineInsets:UIEdgeInsetsZero color:nil];
        [view setRightLineInsets:UIEdgeInsetsZero color:nil];
        #pragma clang diagnostic pop
        
        if ([view isKindOfClass:UIControl.class]) {
            ((UIControl *)view).enabled = YES;
            ((UIControl *)view).selected = NO;
            ((UIControl *)view).highlighted = NO;
            ((UIControl *)view).contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            ((UIControl *)view).contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [((UIControl *)view) removeTarget:nil action:nil forControlEvents:UIControlEventValueChanged];
            [((UIControl *)view) removeTarget:nil action:nil forControlEvents:UIControlEventAllTouchEvents];
            [((UIControl *)view) removeTarget:nil action:nil forControlEvents:UIControlEventAllEditingEvents];
            [((UIControl *)view) removeTarget:nil action:nil forControlEvents:UIControlEventPrimaryActionTriggered];
            
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wundeclared-selector"
            if ([((UIControl *)view) respondsToSelector:@selector(setLogEventControlId:)]) {
                [((UIControl *)view) setValue:nil forKey:@"logEventControlId"];
            }
            if ([((UIControl *)view) respondsToSelector:@selector(setLogEventPageId:)]) {
                [((UIControl *)view) setValue:nil forKey:@"logEventPageId"];
            }
            #pragma clang diagnostic pop
        }
        
        if ([view isKindOfClass:UIScrollView.class]) {
            ((UIScrollView *)view).contentSize = CGSizeZero;
            ((UIScrollView *)view).contentOffset = CGPointZero;
            ((UIScrollView *)view).contentInset = UIEdgeInsetsZero;
            if (@available(iOS 11.0, *)) {
                ((UIScrollView *)view).contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
            }
            ((UIScrollView *)view).directionalLockEnabled = NO;
            ((UIScrollView *)view).alwaysBounceHorizontal = NO;
            ((UIScrollView *)view).alwaysBounceVertical = NO;
            ((UIScrollView *)view).scrollEnabled = YES;
            ((UIScrollView *)view).pagingEnabled = NO;
            ((UIScrollView *)view).delegate = nil;
            ((UIScrollView *)view).bounces = YES;
            ((UIScrollView *)view).showsVerticalScrollIndicator = YES;
            ((UIScrollView *)view).showsHorizontalScrollIndicator = YES;
            ((UIScrollView *)view).scrollIndicatorInsets = UIEdgeInsetsZero;
            ((UIScrollView *)view).indicatorStyle = UIScrollViewIndicatorStyleDefault;
            ((UIScrollView *)view).decelerationRate = UIScrollViewDecelerationRateNormal;
            ((UIScrollView *)view).indexDisplayMode = UIScrollViewIndexDisplayModeAutomatic;
            ((UIScrollView *)view).canCancelContentTouches = YES;
            ((UIScrollView *)view).delaysContentTouches = YES;
            ((UIScrollView *)view).minimumZoomScale = 1.0;
            ((UIScrollView *)view).maximumZoomScale = 1.0;
            ((UIScrollView *)view).zoomScale = 1.0;
            ((UIScrollView *)view).bouncesZoom = YES;
            ((UIScrollView *)view).scrollsToTop = YES;
            if (@available(iOS 10.0, *)) {
                ((UIScrollView *)view).refreshControl = nil;
            }
            ((UIScrollView *)view).keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
        }
    }
}

- (void)resetButtonBaseProperty:(ZCButton *)button {
    if (button) {
        [button setTitle:nil forState:UIControlStateNormal];
        [button setTitle:nil forState:UIControlStateSelected];
        [button setTitle:nil forState:UIControlStateHighlighted];
        [button setTitle:nil forState:UIControlStateNormal|UIControlStateHighlighted];
        [button setTitle:nil forState:UIControlStateSelected|UIControlStateHighlighted];
        [button setTitle:nil forState:UIControlStateDisabled];
        [button setTitle:nil forState:UIControlStateNormal|UIControlStateDisabled];
        [button setTitle:nil forState:UIControlStateSelected|UIControlStateDisabled];
        
        [button setTitleColor:nil forState:UIControlStateNormal];
        [button setTitleColor:nil forState:UIControlStateSelected];
        [button setTitleColor:nil forState:UIControlStateHighlighted];
        [button setTitleColor:nil forState:UIControlStateNormal|UIControlStateHighlighted];
        [button setTitleColor:nil forState:UIControlStateSelected|UIControlStateHighlighted];
        [button setTitleColor:nil forState:UIControlStateDisabled];
        [button setTitleColor:nil forState:UIControlStateNormal|UIControlStateDisabled];
        [button setTitleColor:nil forState:UIControlStateSelected|UIControlStateDisabled];
        
        [button setTitleShadowColor:nil forState:UIControlStateNormal];
        [button setTitleShadowColor:nil forState:UIControlStateSelected];
        [button setTitleShadowColor:nil forState:UIControlStateHighlighted];
        [button setTitleShadowColor:nil forState:UIControlStateNormal|UIControlStateHighlighted];
        [button setTitleShadowColor:nil forState:UIControlStateSelected|UIControlStateHighlighted];
        [button setTitleShadowColor:nil forState:UIControlStateDisabled];
        [button setTitleShadowColor:nil forState:UIControlStateNormal|UIControlStateDisabled];
        [button setTitleShadowColor:nil forState:UIControlStateSelected|UIControlStateDisabled];
        
        [button setImage:nil forState:UIControlStateNormal];
        [button setImage:nil forState:UIControlStateSelected];
        [button setImage:nil forState:UIControlStateHighlighted];
        [button setImage:nil forState:UIControlStateNormal|UIControlStateHighlighted];
        [button setImage:nil forState:UIControlStateSelected|UIControlStateHighlighted];
        [button setImage:nil forState:UIControlStateDisabled];
        [button setImage:nil forState:UIControlStateNormal|UIControlStateDisabled];
        [button setImage:nil forState:UIControlStateSelected|UIControlStateDisabled];
        
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setBackgroundImage:nil forState:UIControlStateSelected];
        [button setBackgroundImage:nil forState:UIControlStateHighlighted];
        [button setBackgroundImage:nil forState:UIControlStateNormal|UIControlStateHighlighted];
        [button setBackgroundImage:nil forState:UIControlStateSelected|UIControlStateHighlighted];
        [button setBackgroundImage:nil forState:UIControlStateDisabled];
        [button setBackgroundImage:nil forState:UIControlStateNormal|UIControlStateDisabled];
        [button setBackgroundImage:nil forState:UIControlStateSelected|UIControlStateDisabled];
        
        [button setAttributedTitle:nil forState:UIControlStateNormal];
        [button setAttributedTitle:nil forState:UIControlStateSelected];
        [button setAttributedTitle:nil forState:UIControlStateHighlighted];
        [button setAttributedTitle:nil forState:UIControlStateNormal|UIControlStateHighlighted];
        [button setAttributedTitle:nil forState:UIControlStateSelected|UIControlStateHighlighted];
        [button setAttributedTitle:nil forState:UIControlStateDisabled];
        [button setAttributedTitle:nil forState:UIControlStateNormal|UIControlStateDisabled];
        [button setAttributedTitle:nil forState:UIControlStateSelected|UIControlStateDisabled];
    }
}

- (void)resetTextFieldBaseProperty:(ZCTextField *)field {
    if (field) {
        field.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        field.autocorrectionType = UITextAutocorrectionTypeDefault;
        field.spellCheckingType = UITextSpellCheckingTypeDefault;
        if (@available(iOS 11.0, *)) {
            field.smartQuotesType = UITextSmartQuotesTypeDefault;
        }
        if (@available(iOS 11.0, *)) {
            field.smartDashesType = UITextSmartDashesTypeDefault;
        }
        if (@available(iOS 11.0, *)) {
            field.smartInsertDeleteType = UITextSmartInsertDeleteTypeDefault;
        }
        field.keyboardAppearance = UIKeyboardAppearanceDefault;
        field.keyboardType = UIKeyboardTypeDefault;
        field.returnKeyType = UIReturnKeyDefault;
        field.enablesReturnKeyAutomatically = NO;
        field.secureTextEntry = NO;
        if (@available(iOS 10.0, *)) {
            field.textContentType = nil;
        }
        if (@available(iOS 12.0, *)) {
            field.passwordRules = nil;
        }
    }
}

- (void)resetTextViewBaseProperty:(ZCTextView *)text {
    if (text) {
        text.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        text.autocorrectionType = UITextAutocorrectionTypeDefault;
        text.spellCheckingType = UITextSpellCheckingTypeDefault;
        if (@available(iOS 11.0, *)) {
            text.smartQuotesType = UITextSmartQuotesTypeDefault;
        }
        if (@available(iOS 11.0, *)) {
            text.smartDashesType = UITextSmartDashesTypeDefault;
        }
        if (@available(iOS 11.0, *)) {
            text.smartInsertDeleteType = UITextSmartInsertDeleteTypeDefault;
        }
        text.keyboardAppearance = UIKeyboardAppearanceDefault;
        text.keyboardType = UIKeyboardTypeDefault;
        text.returnKeyType = UIReturnKeyDefault;
        text.enablesReturnKeyAutomatically = NO;
        text.secureTextEntry = NO;
        if (@available(iOS 10.0, *)) {
            text.textContentType = nil;
        }
        if (@available(iOS 12.0, *)) {
            text.passwordRules = nil;
        }
    }
}

- (void)resetInitProperty {}

@end
