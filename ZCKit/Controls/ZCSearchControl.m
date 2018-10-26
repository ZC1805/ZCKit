//
//  ZCSearchControl.m
//  ZCKit
//
//  Created by admin on 2018/10/26.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCSearchControl.h"
#import "UIView+ZC.h"
#import "ZCMacro.h"

@interface ZCSearchControl ()

@property (nonatomic, assign) CGFloat itemH;

@property (nonatomic, assign) CGFloat itemE;

@property (nonatomic, strong) UIButton *eventButton;

@end

@implementation ZCSearchControl

- (instancetype)initWithFrame:(CGRect)frame holder:(NSString *)holder {
    if (self = [self initWithFrame:CGRectZero]) {
        self.holderText = holder;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _itemH = 30.0;
        _itemE = 12.0;
        _isCenterAlignment = YES;
        [self obtainUI];
        [self setIsGrayStyle:YES];
    }
    return self;
}

- (void)obtainUI {
    self.eventButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.eventButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.eventButton setTitle:self.holderText forState:UIControlStateNormal];
    [self.eventButton addTarget:self action:@selector(onTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.eventButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5.0)];
    self.eventButton.layer.cornerRadius = 4.0;
    self.eventButton.adjustsImageWhenHighlighted = NO;
    [self addSubview:self.eventButton];
}

- (void)onTouch:(id)sender {
    
}

#pragma mark - Setter
- (void)setBarColor:(UIColor *)barColor {
    _barColor = barColor;
    self.eventButton.backgroundColor = barColor;
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self.eventButton setTitleColor:tintColor forState:UIControlStateNormal];
}

- (void)setHolderText:(NSString *)holderText {
    _holderText = holderText;
    [self.eventButton setTitle:self.holderText forState:UIControlStateNormal];
}

- (void)setIsCenterAlignment:(BOOL)isCenterAlignment {
    _isCenterAlignment = isCenterAlignment;
    if (_isCenterAlignment) {
        self.eventButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    } else {
        self.eventButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    [self layoutSubviews];
}

- (void)setIsGrayStyle:(BOOL)isGrayStyle {
    _isGrayStyle = isGrayStyle;
    _barColor = _isGrayStyle ? ZCBKColor : ZCClear;
    _tintColor = _isGrayStyle ? ZCRGB(0xababab) : ZCWhite;
    UIImage *image = [UIImage imageNamed:self.isGrayStyle ? @"zc_image_search_grey" : @"zc_image_search_white"];
    self.eventButton.titleLabel.font = [UIFont systemFontOfSize:self.isGrayStyle ? 13.0 : 15.0];
    self.eventButton.backgroundColor = _barColor;
    [self.eventButton setImage:image forState:UIControlStateNormal];
    [self.eventButton setTitleColor:_tintColor forState:UIControlStateNormal];
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.eventButton.frame = CGRectMake(self.itemE, (self.height - self.itemH) / 2.0, self.width - 2.0 * self.itemE, self.itemH);
}

@end
