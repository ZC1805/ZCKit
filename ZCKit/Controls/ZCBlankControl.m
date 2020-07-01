//
//  ZCBlankControl.h
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCBlankControl.h"
#import "UIImage+ZC.h"
#import "UILabel+ZC.h"
#import "UIView+ZC.h"
#import "ZCMacro.h"

@interface ZCBlankControl ()

@property (nonatomic, strong) UIImageView *originImageView;

@end

@implementation ZCBlankControl

@synthesize headerLabel = _headerLabel, imageView = _imageView, contentLabel = _contentLabel;
@synthesize handleButton = _handleButton, footerLabel = _footerLabel, containerView = _containerView;

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([self isSeatView:_originImageView]) {
        _originImageView.frame = self.bounds;
    }
    CGFloat allHei = 0, space = ZSA(23);
    if ([self isSeatView:_headerLabel]) {
        _headerLabel.size = [_headerLabel sizeThatFits:CGSizeMake(self.width - 2 * ZSMInvl, MAXFLOAT)];
        _headerLabel.centerX = self.width / 2.0;
        allHei = allHei + _headerLabel.height + space;
    }
    if ([self isSeatView:_imageView]) {
        if (CGSizeEqualToSize(_imageView.size, CGSizeZero)) _imageView.size = _imageView.image.size;
        _imageView.centerX = self.width / 2.0;
        allHei = allHei + _imageView.height + space;
    }
    if ([self isSeatView:_contentLabel]) {
        _contentLabel.size = [_contentLabel sizeThatFits:CGSizeMake(self.width - 2 * ZSMInvl, MAXFLOAT)];
        _contentLabel.centerX = self.width / 2.0;
        allHei = allHei + _contentLabel.height + space;
    }
    if ([self isSeatView:_handleButton]) {
        if (CGSizeEqualToSize(_handleButton.size, CGSizeZero)) {
            CGFloat height = _handleButton.imageView.image.size.height;
            CGFloat width = _handleButton.imageView.image.size.width;
            width = width + ZSA(20);
            CGFloat calwid = self.width - 2 * ZSMInvl - width;
            CGSize size = [_handleButton.titleLabel sizeThatFits:CGSizeMake(calwid, MAXFLOAT)];
            width = width + size.width;
            height = MAX(height, size.height) + ZSA(20);
            _handleButton.size = CGSizeMake(width, height);
        }
        _handleButton.centerX = self.width / 2.0;
        allHei = allHei + _handleButton.height + space;
    }
    if ([self isSeatView:_footerLabel]) {
        _footerLabel.size = [_footerLabel sizeThatFits:CGSizeMake(self.width - 2 * ZSMInvl, MAXFLOAT)];
        _footerLabel.centerX = self.width / 2.0;
        allHei = allHei + _footerLabel.height + space;
    }
    if ([self isSeatView:_containerView]) {
        _containerView.size = [_containerView minContainerRect].size;
        _containerView.centerX = self.width / 2.0;
        allHei = allHei + _containerView.height + space;
    }
    
    CGFloat top = self.height / 2.0 - allHei / 2.0 - ZSA(30);
    if ([self isSeatView:_headerLabel]) {
        _headerLabel.top = top;
        top = _headerLabel.bottom + space;
    }
    if ([self isSeatView:_imageView]) {
        _imageView.top = top;
        top = _imageView.bottom + space;
    }
    if ([self isSeatView:_contentLabel]) {
        _contentLabel.top = top;
        top = _contentLabel.bottom + space;
    }
    if ([self isSeatView:_handleButton]) {
        _handleButton.top = top;
        top = _handleButton.bottom + space;
    }
    if ([self isSeatView:_footerLabel]) {
        _footerLabel.top = top;
        top = _footerLabel.bottom + space;
    }
    if ([self isSeatView:_containerView]) {
        _containerView.top = top;
    }
}

#pragma mark - Get
- (UILabel *)headerLabel {
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectZero font:ZCFS(16) color:ZCBlack30];
        _headerLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.numberOfLines = 0;
        [self addSubview:_headerLabel];
    }
    return _headerLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.userInteractionEnabled = NO;
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero font:ZCFS(16) color:ZCBlack80];
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (ZCButton *)handleButton {
    if (!_handleButton) {
        _handleButton = [ZCButton buttonWithType:UIButtonTypeCustom];
        _handleButton.titleLabel.font = ZCFS(15);
        [_handleButton setCorner:ZSA(3) color:ZCClear width:ZSA(0)];
        [self addSubview:_handleButton];
    }
    return _handleButton;
}

- (UILabel *)footerLabel {
    if (!_footerLabel) {
        _footerLabel = [[UILabel alloc] initWithFrame:CGRectZero font:ZCFS(14) color:ZCBlack80];
        _footerLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _footerLabel.textAlignment = NSTextAlignmentCenter;
        _footerLabel.numberOfLines = 0;
        [self addSubview:_footerLabel];
    }
    return _footerLabel;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_containerView];
    }
    return _containerView;
}

- (UIImageView *)originImageView {
    if (!_originImageView) {
        _originImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _originImageView.contentMode = UIViewContentModeScaleAspectFit;
        _originImageView.userInteractionEnabled = NO;
        _originImageView.backgroundColor = self.backgroundColor;
        [self addSubview:_originImageView];
    }
    return _originImageView;
}

#pragma mark - Set
- (void)setTouchAction:(void (^)(BOOL))touchAction {
    _touchAction = touchAction;
    if ([self.allTargets containsObject:self] && (self.allControlEvents & UIControlEventTouchUpInside)) {
        if ([[self actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] containsObject:NSStringFromSelector(@selector(onTouchAction:))]) {
            [self removeTarget:self action:@selector(onTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (_touchAction) {
        [self addTarget:self action:@selector(onTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([_handleButton.allTargets containsObject:self] && (_handleButton.allControlEvents & UIControlEventTouchUpInside)) {
        if ([[_handleButton actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] containsObject:NSStringFromSelector(@selector(onTouchAction:))]) {
            [_handleButton removeTarget:self action:@selector(onTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (_touchAction) {
        [_handleButton addTarget:self action:@selector(onTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - Misc
- (void)onTouchAction:(id)sender {
    if (_touchAction) _touchAction(sender == self ? NO : YES);
}

- (BOOL)isSeatView:(UIView *)subview {
    if (subview && !subview.hidden) {
        return YES;
    }
    return NO;
}

#pragma mark - Api
- (void)resetSize {
    [self layoutSubviews];
    if (self.superview && !self.hidden) {
        [self.superview bringSubviewToFront:self];
    }
    if ([self isSeatView:_originImageView]) {
        [self bringSubviewToFront:_originImageView];
    }
}

- (void)setHidden:(BOOL)hidden {
    [self setHidden:hidden animated:YES];
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated {
    BOOL isShowHiddenAnim = YES;
    if ([self isSeatView:_originImageView]) {
        if (hidden && !_originImageView.hidden) isShowHiddenAnim = NO;
        if (isShowHiddenAnim) _originImageView.hidden = YES;
    }
    if (self.hidden != hidden) {
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                self.alpha = hidden ? 0 : 1;
            } completion:^(BOOL finished) {
                [super setHidden:hidden];
                [self resetSize];
                if (!isShowHiddenAnim) {
                    self->_originImageView.hidden = YES;
                }
            }];
        } else {
            self.alpha = hidden ? 0 : 1;
            [super setHidden:hidden];
            [self resetSize];
            if (!isShowHiddenAnim) {
                _originImageView.hidden = YES;
            }
        }
    }
}

- (void)setInitHidden {
    self.originImageView.hidden = NO;
    self.alpha = 1;
    [super setHidden:NO];
    [self resetSize];
}

- (void)resetImage:(UIImage *)image message:(NSString *)message {
    self.imageView.image = image;
    self.imageView.hidden = (image == nil);
    self.contentLabel.text = message;
    self.contentLabel.hidden = (message == nil || message.length == 0);
    [self resetSize];
}

- (void)resetImage:(UIImage *)image handleText:(NSString *)handleText {
    self.imageView.image = image;
    self.imageView.hidden = (image == nil);
    self.handleButton.hidden = (handleText == nil || handleText.length == 0);
    [self.handleButton setTitle:handleText forState:UIControlStateNormal];
    [self resetSize];
}

@end
