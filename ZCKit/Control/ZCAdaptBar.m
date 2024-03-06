//
//  ZCAdaptBar.m
//  ZCKit
//
//  Created by admin on 2019/1/22.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import "ZCAdaptBar.h"
#import "UIView+ZC.h"
#import "ZCMacro.h"

@interface ZCAdaptBar ()

@property (nonatomic, assign) CGFloat recordHei;

@property (nonatomic, assign) CGFloat reserveHei;

@property (nonatomic, strong) UIView *topSepline1;

@property (nonatomic, strong) UIView *midSepline1;

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, assign) ZCEnumAdaptBarPosition adaptPosition;

@end

@implementation ZCAdaptBar

@synthesize contentView = _contentView, reserveView = _reserveView;

- (instancetype)initWithFrame:(CGRect)frame position:(ZCEnumAdaptBarPosition)position {
    if (self = [super initWithFrame:frame]) {
        _recordHei = -1;
        _isShowLine = YES;
        _isShowMidLine = NO;
        _isVagueBackground = NO;
        _adaptPosition = position;
        _reserveHei = position ? kZSBomResHei : kZSStuBarHei;
        self.backgroundColor = kZCClear;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [self initWithFrame:frame position:ZCEnumAdaptBarPositionTop]) {
    } return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.reserveHei != 0 && self.zc_height != (self.recordHei + self.reserveHei)) {
        self.recordHei = self.zc_height;
        if (self.adaptPosition) {
            self.frame = CGRectMake(0, self.zc_bottom - self.recordHei - self.reserveHei, kZSWid, self.recordHei + self.reserveHei);
            self.reserveView.frame = CGRectMake(0, self.recordHei, kZSWid, self.reserveHei);
            self.contentView.frame = CGRectMake(0, 0, kZSWid, self.recordHei);
        } else {
            self.frame = CGRectMake(0, 0, kZSWid, self.recordHei + self.reserveHei);
            self.contentView.frame = CGRectMake(0, self.reserveHei, kZSWid, self.recordHei);
            self.reserveView.frame = CGRectMake(0, 0, kZSWid, self.reserveHei);
        }
    } else if (self.reserveHei == 0) {
        self.contentView.frame = self.bounds;
        self.reserveView.frame = CGRectZero;
    }
    if (self.isVagueBackground) self.effectView.frame = self.bounds;
    if (self.adaptPosition) {
        if (self.isShowLine) self.topSepline1.frame = CGRectMake(0, 0, kZSWid, kZSPixel);
        if (self.isShowMidLine) self.midSepline1.frame = CGRectMake(0, self.contentView.zc_height - kZSPixel, kZSWid, kZSPixel);
    } else {
        if (self.isShowLine) self.topSepline1.frame = CGRectMake(0, self.zc_height - kZSPixel, kZSWid, kZSPixel);
        if (self.isShowMidLine) self.midSepline1.frame = CGRectMake(0, self.reserveView.zc_height, kZSWid, kZSPixel);
    }
}

#pragma mark - Set
- (void)setIsVagueBackground:(BOOL)isVagueBackground {
    _isVagueBackground = isVagueBackground;
    _effectView.hidden = !isVagueBackground;
}

- (void)setIsShowLine:(BOOL)isShowLine {
    _isShowLine = isShowLine;
    _topSepline1.hidden = !isShowLine;
    [self layoutSubviews];
    [self layoutIfNeeded];
}

- (void)setIsShowMidLine:(BOOL)isShowMidLine {
    _isShowMidLine = isShowMidLine;
    _midSepline1.hidden = !isShowMidLine;
    [self layoutSubviews];
    [self layoutIfNeeded];
}

#pragma mark - Get
- (UIView *)topSepline1 {
    if (!_topSepline1) {
        _topSepline1 = [[UIView alloc] initWithFrame:CGRectZero];
        _topSepline1.backgroundColor = kZCSplit;
        [self addSubview:_topSepline1];
    }
    return _topSepline1;
}

- (UIView *)midSepline1 {
    if (!_midSepline1) {
        _midSepline1 = [[UIView alloc] initWithFrame:CGRectZero];
        _midSepline1.backgroundColor = kZCSplit;
        [self addSubview:_midSepline1];
    }
    return _midSepline1;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = kZCClear;
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (UIView *)reserveView {
    if (!_reserveView) {
        _reserveView = [[UIView alloc] initWithFrame:CGRectZero];
        _reserveView.backgroundColor = kZCClear;
        [self addSubview:_reserveView];
    }
    return _reserveView;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        _effectView.backgroundColor = kZCClear;
        [self insertSubview:_effectView atIndex:0];
    }
    return _effectView;
}

@end
