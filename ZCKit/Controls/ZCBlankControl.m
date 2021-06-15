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
    CGFloat allHei = 0, space = 23;
    if ([self isSeatView:_headerLabel]) {
        _headerLabel.zc_size = [_headerLabel sizeThatFits:CGSizeMake(self.zc_width - 2 * 15, MAXFLOAT)];
        _headerLabel.zc_centerX = self.zc_width / 2.0;
        allHei = allHei + _headerLabel.zc_height + space;
    }
    if ([self isSeatView:_imageView]) {
        if (CGSizeEqualToSize(_imageView.zc_size, CGSizeZero)) _imageView.zc_size = _imageView.image.size;
        _imageView.zc_centerX = self.zc_width / 2.0;
        allHei = allHei + _imageView.zc_height + space;
    }
    if ([self isSeatView:_contentLabel]) {
        _contentLabel.zc_size = [_contentLabel sizeThatFits:CGSizeMake(self.zc_width - 2 * 15, MAXFLOAT)];
        _contentLabel.zc_centerX = self.zc_width / 2.0;
        allHei = allHei + _contentLabel.zc_height + space;
    }
    if ([self isSeatView:_handleButton]) {
        if (CGSizeEqualToSize(_handleButton.zc_size, CGSizeZero)) {
            CGFloat height = _handleButton.imageView.image.size.height;
            CGFloat width = _handleButton.imageView.image.size.width;
            width = width + 20;
            CGFloat calwid = self.zc_width - 2 * 15 - width;
            CGSize size = [_handleButton.titleLabel sizeThatFits:CGSizeMake(calwid, MAXFLOAT)];
            width = width + size.width;
            height = MAX(height, size.height) + 20;
            _handleButton.zc_size = CGSizeMake(width, height);
        }
        _handleButton.zc_centerX = self.zc_width / 2.0;
        allHei = allHei + _handleButton.zc_height + space;
    }
    if ([self isSeatView:_footerLabel]) {
        _footerLabel.zc_size = [_footerLabel sizeThatFits:CGSizeMake(self.zc_width - 2 * 15, MAXFLOAT)];
        _footerLabel.zc_centerX = self.zc_width / 2.0;
        allHei = allHei + _footerLabel.zc_height + space;
    }
    if ([self isSeatView:_containerView]) {
        _containerView.zc_size = [_containerView minContainerRect].size;
        _containerView.zc_centerX = self.zc_width / 2.0;
        allHei = allHei + _containerView.zc_height + space;
    }
    
    CGFloat top = self.zc_height / 2.0 - allHei / 2.0 - 30;
    if ([self isSeatView:_headerLabel]) {
        _headerLabel.zc_top = top;
        top = _headerLabel.zc_bottom + space;
    }
    if ([self isSeatView:_imageView]) {
        _imageView.zc_top = top;
        top = _imageView.zc_bottom + space;
    }
    if ([self isSeatView:_contentLabel]) {
        _contentLabel.zc_top = top;
        top = _contentLabel.zc_bottom + space;
    }
    if ([self isSeatView:_handleButton]) {
        _handleButton.zc_top = top;
        top = _handleButton.zc_bottom + space;
    }
    if ([self isSeatView:_footerLabel]) {
        _footerLabel.zc_top = top;
        top = _footerLabel.zc_bottom + space;
    }
    if ([self isSeatView:_containerView]) {
        _containerView.zc_top = top;
    }
}

#pragma mark - Get
- (UILabel *)headerLabel {
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectZero font:[UIFont fontWithName:@"HelveticaNeue" size:16] color:ZCBlack30];
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
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero font:[UIFont fontWithName:@"HelveticaNeue" size:16] color:ZCBlack80];
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
        _handleButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        [_handleButton setCorner:3 color:ZCClear width:0];
        [self addSubview:_handleButton];
    }
    return _handleButton;
}

- (UILabel *)footerLabel {
    if (!_footerLabel) {
        _footerLabel = [[UILabel alloc] initWithFrame:CGRectZero font:[UIFont fontWithName:@"HelveticaNeue" size:14] color:ZCBlack80];
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
        if ([[self actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] containsObject:NSStringFromSelector(@selector(onTouchActionZC:))]) {
            [self removeTarget:self action:@selector(onTouchActionZC:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (_touchAction) {
        [self addTarget:self action:@selector(onTouchActionZC:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([_handleButton.allTargets containsObject:self] && (_handleButton.allControlEvents & UIControlEventTouchUpInside)) {
        if ([[_handleButton actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] containsObject:NSStringFromSelector(@selector(onTouchActionZC:))]) {
            [_handleButton removeTarget:self action:@selector(onTouchActionZC:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (_touchAction) {
        [_handleButton addTarget:self action:@selector(onTouchActionZC:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - Misc
- (void)onTouchActionZC:(id)sender {
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
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
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
