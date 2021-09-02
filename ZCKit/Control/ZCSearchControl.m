//
//  ZCSearchControl.m
//  ZCKit
//
//  Created by admin on 2018/10/26.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCSearchControl.h"
#import "UIView+ZC.h"
#import "ZCButton.h"
#import "ZCMacro.h"

@interface ZCSearchControl ()

@property (nonatomic, assign) CGFloat itemH;

@property (nonatomic, assign) CGFloat itemE;

@property (nonatomic, strong) ZCButton *eventButton;

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
    self.eventButton = [ZCButton buttonWithType:UIButtonTypeCustom];
    self.eventButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.eventButton setTitle:self.holderText forState:UIControlStateNormal];
    [self.eventButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5.0)];
    self.eventButton.layer.cornerRadius = 4.0;
    self.eventButton.adjustsImageWhenHighlighted = NO;
    [self addSubview:self.eventButton];
}

- (void)setTouchAction:(void (^)(ZCSearchControl * _Nonnull))touchAction {
    _touchAction = touchAction;
    if ([self.allTargets containsObject:self] && (self.allControlEvents & UIControlEventTouchUpInside)) {
        if ([[self actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] containsObject:NSStringFromSelector(@selector(onTouchActionZC:))]) {
            [self removeTarget:self action:@selector(onTouchActionZC:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (touchAction) {
        [self addTarget:self action:@selector(onTouchActionZC:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)onTouchActionZC:(id)sender {
    if (_touchAction) _touchAction(self);
}

#pragma mark - Set
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
    _barColor = _isGrayStyle ? kZCPad : kZCClear;
    _tintColor = _isGrayStyle ? kZCBlackA8 : kZCWhite;
    UIImage *image = [ZCGlobal ZCImageName:(self.isGrayStyle ? @"zc_image_search_grey" : @"zc_image_search_white")];
    self.eventButton.titleLabel.font = self.isGrayStyle ? [UIFont fontWithName:@"HelveticaNeue" size:13] : [UIFont fontWithName:@"HelveticaNeue" size:15];
    self.eventButton.backgroundColor = _barColor;
    [self.eventButton setImage:image forState:UIControlStateNormal];
    [self.eventButton setTitleColor:_tintColor forState:UIControlStateNormal];
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.eventButton.frame = CGRectMake(self.itemE, (self.zc_height - self.itemH) / 2.0, self.zc_width - 2.0 * self.itemE, self.itemH);
}

@end
