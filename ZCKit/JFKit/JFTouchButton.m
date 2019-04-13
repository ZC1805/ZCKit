//
//  JFTouchButton.m
//  gobe
//
//  Created by zjy on 2019/3/23.
//  Copyright © 2019 com.jinfeng.credit. All rights reserved.
//

#import "JFTouchButton.h"

@interface JFTouchButton ()

@property (nonatomic, strong) UIColor *bcorlr;

@property (nonatomic, assign) JFEnumTouchButtonStyle touchButtonStyle; 

@end

@implementation JFTouchButton

+ (instancetype)style:(JFEnumTouchButtonStyle)style title:(nullable NSString *)title obj:(nullable id)obj sel:(nullable SEL)sel {
    JFTouchButton *button = [JFTouchButton button:CGRectZero title:nil image:nil target:obj action:sel];
    button.frame = CGRectMake(ZSMInvl, 0, ZSWid - 2 * ZSMInvl, ZSA(46));
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTouchButtonStyle:style];
    return button;
}

- (void)setTouchButtonStyle:(JFEnumTouchButtonStyle)touchButtonStyle {
    _touchButtonStyle = touchButtonStyle;
    switch (touchButtonStyle) {
        case JFEnumTouchButtonStyleYellow:{
            [self.titleLabel setFont:ZCFBS(16)];
            [self joinShadow:YES radius:ZSA(23) boc:ZCClear bkc:ZCRGBA(0xFF8B00, 0.5)];
            [self setTitleColor:ZCRGB(0xFFFFFF) forState:UIControlStateNormal];
            [self setTitleColor:ZCRGB(0xF8F8F8) forState:UIControlStateDisabled];
            [self setTitleColor:ZCRGB(0xF2F2F2) forState:UIControlStateHighlighted];
            [self setBackgroundImage:[UIImage imageWithColor:ZCRGB(0xFF8B00)] forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageWithColor:ZCRGBA(0xF0F0F0, 0.3)] forState:UIControlStateDisabled];
            [self setBackgroundImage:[UIImage imageWithColor:ZCRGBA(0xFF8B00, 0.2)] forState:UIControlStateHighlighted];
        } break;
        case JFEnumTouchButtonStyleTint:{
            [self.titleLabel setFont:ZCFS(15)];
            [self joinShadow:NO radius:ZSA(4) boc:ZCRGBA(0xFF8B00, 0.3) bkc:ZCRGBA(0xFF8B00, 0.4)];
            [self setTitleColor:ZCRGB(0xFF8B00) forState:UIControlStateNormal];
            [self setTitleColor:ZCRGB(0xFFFFFF) forState:UIControlStateSelected];
            [self setTitleColor:ZCRGB(0xD2D2D2) forState:UIControlStateDisabled|UIControlStateNormal];
            [self setTitleColor:ZCRGB(0xD2D2D2) forState:UIControlStateDisabled|UIControlStateSelected];
            [self setTitleColor:ZCRGBA(0xFF8B00, 0.5) forState:UIControlStateHighlighted|UIControlStateNormal];
            [self setTitleColor:ZCRGBA(0xFFFFFF, 0.5) forState:UIControlStateHighlighted|UIControlStateSelected];
            [self setBackgroundImage:[UIImage imageWithColor:ZCRGB(0xFFFFFF)] forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageWithColor:ZCRGB(0xFF8B00)] forState:UIControlStateSelected];
            [self setBackgroundImage:[UIImage imageWithColor:ZCRGB(0xF0F0F0)]
                            forState:UIControlStateDisabled|UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageWithColor:ZCRGB(0xF0F0F0)]
                            forState:UIControlStateDisabled|UIControlStateSelected];
            [self setBackgroundImage:[UIImage imageWithColor:ZCRGBA(0xFFFFFF, 0.5)]
                            forState:UIControlStateHighlighted|UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageWithColor:ZCRGBA(0xFF8B00, 0.5)]
                            forState:UIControlStateHighlighted|UIControlStateSelected];
        } break;
        case JFEnumTouchButtonStyleGray:{
            [self.titleLabel setFont:ZCFBS(16)];
            [self joinShadow:NO radius:ZSA(23) boc:ZCClear bkc:ZCRGB(0x808080)];
            [self setTitleColor:ZCRGB(0xFFFFFF) forState:UIControlStateNormal];
            [self setTitleColor:ZCRGB(0xE8E8E8) forState:UIControlStateHighlighted];
            [self setBackgroundImage:[UIImage imageWithColor:ZCRGB(0x808080)] forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageWithColor:ZCRGB(0xC2C2C2)] forState:UIControlStateHighlighted];
        } break;
        case JFEnumTouchButtonStyleLightGray:{
            [self.titleLabel setFont:ZCFS(16)];
            [self joinShadow:NO radius:ZSA(23) boc:ZCClear bkc:ZCRGB(0xC8C8C8)];
            [self setTitleColor:ZCRGB(0x303030) forState:UIControlStateNormal];
            [self setTitleColor:ZCRGB(0x909090) forState:UIControlStateHighlighted];
            [self setBackgroundImage:[UIImage imageWithColor:ZCRGB(0xC8C8C8)] forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageWithColor:ZCRGB(0xE0E0E0)] forState:UIControlStateHighlighted];
        } break;
    }
    self.enabled = self.enabled;
    self.selected = self.selected;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.superview) {
        if (self.shadowlayer.superlayer) {
            [self.shadowlayer removeFromSuperlayer];
        }
        if (self.shadowlayer.opacity > 0) {
            [self.superview.layer insertSublayer:self.shadowlayer below:self.layer];
        }
    } else {
        [self.shadowlayer removeFromSuperlayer];
    }
    self.shadowlayer.hidden = self.hidden;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.shadowlayer.frame = self.layer.frame;
    self.shadowlayer.cornerRadius = self.layer.cornerRadius;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    self.shadowlayer.hidden = self.hidden;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (_touchButtonStyle == JFEnumTouchButtonStyleTint) {
        self.shadowlayer.shadowOpacity = self.enabled ? (self.selected ? 0.8 : 0.3) : 0.1;
        self.layer.borderColor = self.enabled ? (self.selected ? [UIColor clearColor].CGColor
                                              : self.bcorlr.CGColor) : ZCRGB(0xF0F0F0).CGColor;
    }
    if (_touchButtonStyle == JFEnumTouchButtonStyleYellow) {
        self.shadowlayer.shadowOpacity = self.enabled ? 0.8 : 0.5;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (_touchButtonStyle == JFEnumTouchButtonStyleTint) {
        self.shadowlayer.shadowOpacity = self.enabled ? (self.selected ? 0.8 : 0.3) : 0.1;
        self.layer.borderColor = self.enabled ? (self.selected ? [UIColor clearColor].CGColor
                                              : self.bcorlr.CGColor) : ZCRGB(0xF0F0F0).CGColor;
    }
}

- (void)joinShadow:(BOOL)isShadow radius:(CGFloat)radius boc:(UIColor *)boColor bkc:(UIColor *)bkColor {
    self.bcorlr = boColor;
    self.layer.borderColor = boColor.CGColor;
    self.layer.borderWidth = ZSA(1);
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    _shadowlayer = [CALayer layer];
    _shadowlayer.cornerRadius = radius;
    _shadowlayer.masksToBounds = NO;
    _shadowlayer.backgroundColor = bkColor.CGColor;
    _shadowlayer.shadowColor = bkColor.CGColor;
    _shadowlayer.shadowOffset = CGSizeMake(ZSA(1), ZSA(2));
    _shadowlayer.shadowOpacity = 0.8;
    _shadowlayer.shadowRadius = ZSA(4);
    _shadowlayer.opacity = isShadow ? 1.0 : 0;
}

@end
