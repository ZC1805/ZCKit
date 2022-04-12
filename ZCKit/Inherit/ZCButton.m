//
//  ZCButton.m
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCButton.h"
#import "ZCMacro.h"

@interface ZCButton ()

@property (nonatomic, assign) BOOL isIgnoreTouch;

@property (nonatomic, assign) BOOL isManualSize;

@property (nonatomic, assign) CGSize titleRectSize;

@property (nonatomic, assign) CGFloat imageRectSpace;

@property (nonatomic, assign) SEL ignoreFlagSelector; //只能设置一个sel

@end

@implementation ZCButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self resetInitProperty];
        self.backgroundColor = kZCClear;
        self.adjustsImageWhenDisabled = NO;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color image:(UIImage *)image target:(id)target action:(SEL)action {
    if (self = [self initWithFrame:CGRectZero]) {
        if (font) self.titleLabel.font = font;
        if (image) [self setImage:image forState:UIControlStateNormal];
        if (title) [self setTitle:title forState:UIControlStateNormal];
        if (color) [self setTitleColor:color forState:UIControlStateNormal];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.minimumScaleFactor = 0.6;
        if (target && action && [target respondsToSelector:action]) {
            [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

- (instancetype)initWithBKColor:(UIColor *)color target:(id)target action:(SEL)action {
    if (self = [self initWithFrame:CGRectZero]) {
        if (color) self.backgroundColor = color;
        if (target && action && [target respondsToSelector:action]) {
            [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

- (void)resetInitProperty {
    _isManualSize = NO;
    _isUseGrayImage = NO;
    _fixSize = CGSizeZero;
    _imageViewSize = CGSizeZero;
    _centerAlignmentSpace = 0;
    _isVerticalCenterAlignment = NO;
    _responseAreaExtend = UIEdgeInsetsZero;
    _responseTouchInterval = 0.3;
    _delayResponseTime = 0;
    _ignoreFlagSelector = nil;
    _ignoreConstraintSelector = nil;
    self.touchAction = nil;
    [self layoutSubviews];
}

#pragma mark - Override
- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    if (self.isUseGrayImage && image) image = [image imageToGray];
    [super setImage:image forState:state];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(_responseAreaExtend, UIEdgeInsetsZero)) {
        return [super pointInside:point withEvent:event];
    }
    if (self.hidden || self.alpha < 0.01 || !self.enabled || !self.userInteractionEnabled) {
        return NO;
    }
    CGRect hit = CGRectMake(self.bounds.origin.x - _responseAreaExtend.left,
                            self.bounds.origin.y - _responseAreaExtend.top,
                            self.bounds.size.width + _responseAreaExtend.left + _responseAreaExtend.right,
                            self.bounds.size.height + _responseAreaExtend.top + _responseAreaExtend.bottom);
    return CGRectContainsPoint(hit, point);
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (_ignoreConstraintSelector && _ignoreConstraintSelector.length && action) {
        if ([_ignoreConstraintSelector isEqualToString:NSStringFromSelector(action)]) {
            [super sendAction:action to:target forEvent:event];
        }
    }
    if (_ignoreFlagSelector && action && _ignoreFlagSelector == action) {
        [super sendAction:action to:target forEvent:event];
    }
    if (_isIgnoreTouch) return;
    if (_responseTouchInterval <= 0) {
        if (_delayResponseTime > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_delayResponseTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [super sendAction:action to:target forEvent:event];
            });
        } else {
            [super sendAction:action to:target forEvent:event];
        }
    } else {
        [self performSelector:@selector(resetNotIgnoreTouch) withObject:nil afterDelay:_responseTouchInterval];
        _isIgnoreTouch = YES;
        if (_delayResponseTime > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_delayResponseTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [super sendAction:action to:target forEvent:event];
            });
        } else {
            [super sendAction:action to:target forEvent:event];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (CGSizeEqualToSize(_fixSize, CGSizeZero)) {
        return [super sizeThatFits:size];
    } else {
        return _fixSize;
    }
}

#pragma mark - Set
- (void)setImageViewSize:(CGSize)imageViewSize {
    _imageViewSize = imageViewSize;
    _isManualSize = !(CGSizeEqualToSize(_imageViewSize, CGSizeZero));
    [self layoutSubviews];
}

- (void)setCenterAlignmentSpace:(CGFloat)centerAlignmentSpace {
    _centerAlignmentSpace = centerAlignmentSpace;
    [self layoutSubviews];
}

- (void)setIsVerticalCenterAlignment:(BOOL)isVerticalCenterAlignment {
    _isVerticalCenterAlignment = isVerticalCenterAlignment;
    [self layoutSubviews];
}

- (void)setTouchAction:(void (^)(ZCButton * _Nonnull))touchAction {
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

#pragma mark - Private
- (void)onTouchActionZC:(id)sender {
    if (_touchAction) _touchAction(self);
}

- (void)resetNotIgnoreTouch {
    _isIgnoreTouch = NO;
}

#pragma mark - Override
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect rect = [super imageRectForContentRect:contentRect];
    if (!self.isManualSize) {
        if (self.centerAlignmentSpace || self.isVerticalCenterAlignment) {
            _imageViewSize = [self imageForState:UIControlStateNormal].size;
        } else {
            _imageViewSize = CGSizeZero;
        }
    }
    if (CGSizeEqualToSize(self.imageViewSize, CGSizeZero)) return rect;
    if ([self titleForState:UIControlStateNormal].length) {
        CGFloat left = 0, space = 0;
        if (self.isVerticalCenterAlignment) {
            CGFloat restHei = contentRect.size.height - self.imageViewSize.height - self.centerAlignmentSpace;
            CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(contentRect.size.width, restHei)];
            left = (contentRect.size.width - self.imageViewSize.width) / 2.0;
            space = (contentRect.size.height - self.imageViewSize.height - self.centerAlignmentSpace - titleSize.height) / 2.0;
            self.titleRectSize = titleSize;
            self.imageRectSpace = space;
        } else {
            CGFloat restWid = contentRect.size.width - self.imageViewSize.width - self.centerAlignmentSpace;
            CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(restWid, contentRect.size.height)];
            space = (contentRect.size.height - self.imageViewSize.height) / 2.0;
            left = (contentRect.size.width - self.imageViewSize.width - self.centerAlignmentSpace - titleSize.width) / 2.0;
            self.titleRectSize = titleSize;
            self.imageRectSpace = left;
        }
        return CGRectMake(left + contentRect.origin.x, space + contentRect.origin.y, self.imageViewSize.width, self.imageViewSize.height);
    } else {
        CGFloat top = rect.origin.y - (self.imageViewSize.height - rect.size.height) / 2.0;
        CGFloat left = rect.origin.x - (self.imageViewSize.width - rect.size.width) / 2.0;
        return CGRectMake(left, top, self.imageViewSize.width, self.imageViewSize.height);
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect rect = [super titleRectForContentRect:contentRect];
    if (CGSizeEqualToSize(self.imageViewSize, CGSizeZero)) return rect;
    if ([self titleForState:UIControlStateNormal].length) {
        CGFloat left = 0, space = 0;
        if (self.isVerticalCenterAlignment) {
            left = (contentRect.size.width - self.titleRectSize.width) / 2.0;
            space = contentRect.size.height - self.imageRectSpace - self.titleRectSize.height;
        } else {
            space = (contentRect.size.height - self.titleRectSize.height) / 2.0;
            left = contentRect.size.width - self.imageRectSpace - self.titleRectSize.width;
        }
        return CGRectMake(left + contentRect.origin.x, space + contentRect.origin.y, self.titleRectSize.width, self.titleRectSize.height);
    } else {
        return CGRectZero;
    }
}

@end
