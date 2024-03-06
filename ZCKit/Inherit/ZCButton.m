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

@property (nonatomic, assign) BOOL isManualImageSize;

@property (nonatomic, assign) BOOL isManualTitleSize;

@property (nonatomic, assign) SEL ignoreFlagSelector; //只能设置一个sel

@property (nonatomic, assign) BOOL isTopImageBottomTitle; //图片顶文字底布局，且水平方向居中对齐，默认NO

@property (nonatomic, assign) CGFloat topImageBottomTitleSpace; //图片顶文字底布局，且水平方向居中对齐，垂直方向的间距，默认0

@property (nonatomic, assign) BOOL isRightImageLeftTitle; //图片右文字左布局，且垂直方向居中对齐，默认NO

@property (nonatomic, assign) BOOL isLeftImageRightTitle; //图片左文字右布局，且垂直方向居中对齐，默认NO

@property (nonatomic, assign) CGFloat horImageTitleSpace; //图片右文字左布局，且垂直方向居中对齐，水平方向的间距，默认0

@property (nonatomic, assign) CGFloat horImageTitleOffset; //图片右文字左布局，且垂直方向居中对齐，水平方向整体偏移，默认0

@property (nonatomic, assign) CGFloat horImageTitleTopOffset; //图片右文字左布局，且垂直方向居中对齐，文字向上偏移量，默认0

@property (nonatomic, assign) CGSize imageViewSize; //自定义图片的size，默认zero

@property (nonatomic, assign) CGSize titleLabelSize; //自定义文本的size，默认zero

@end

@implementation ZCButton

- (instancetype)initWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color image:(id)image bgColor:(UIColor *)bgColor {
    if (self = [super initWithFrame:CGRectZero]) {
        [self resetInitProperty];
        self.backgroundColor = bgColor ? bgColor : kZCClear;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.minimumScaleFactor = 0.6;
        self.adjustsImageWhenHighlighted = NO;
        self.adjustsImageWhenDisabled = NO;
        self.highlighted = NO;
        self.selected = NO;
        self.enabled = YES;
        if (font) {
            self.titleLabel.font = font;
        }
        if (title) {
            [self setTitle:title forState:UIControlStateNormal];
        }
        if (color) {
            [self setTitleColor:color forState:UIControlStateNormal];
        }
        UIImage *im = nil;
        if (image && [image isKindOfClass:UIImage.class]) {
            im = image;
        } else if (image && [image isKindOfClass:NSString.class] && ((NSString *)image).length > 0) {
            im = [UIImage imageNamed:(NSString *)image];
        }
        if (im) {
            [self setImage:im forState:UIControlStateNormal];
        }
    }
    return self;
}

- (instancetype)initWithBKColor:(UIColor *)color target:(id)target action:(SEL)action {
    if (self = [self initWithTitle:nil font:nil color:nil image:nil bgColor:nil]) {
        if (color) self.backgroundColor = color;
        if (target && action && [target respondsToSelector:action]) {
            [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [self initWithTitle:nil font:nil color:nil image:nil bgColor:nil]) {
    } return self;
}

- (void)resetInitProperty {
    _data = nil;
    _fixSize = CGSizeZero;
    _isUseGrayImage = NO;
    _isManualImageSize = NO;
    _isManualTitleSize = NO;
    _imageViewSize = CGSizeZero;
    _titleLabelSize = CGSizeZero;
    _isTopImageBottomTitle = NO;
    _topImageBottomTitleSpace = 0;
    _isRightImageLeftTitle = NO;
    _isLeftImageRightTitle = NO;
    _horImageTitleSpace = 0;
    _horImageTitleOffset = 0;
    _horImageTitleTopOffset = 0;
    _responseAreaExtend = UIEdgeInsetsZero;
    _ignoreConstraintSelector = nil;
    _responseTouchInterval = 0.3;
    _delayResponseTime = 0;
    _ignoreFlagSelector = nil;
    self.touchAction = nil;
    [self layoutSubviews];
}

#pragma mark - Reset
- (void)resetIsTopImageBottomTitleAndSpace:(CGFloat)space {
    _isTopImageBottomTitle = fabs(space + 1.0) > 0.000001;
    _topImageBottomTitleSpace = space;
    [self layoutSubviews];
}

- (void)resetIsRightImageLeftTitleAndSpace:(CGFloat)space offset:(CGFloat)offset titleTopExtraOffset:(CGFloat)titleTopExtraOffset {
    _isRightImageLeftTitle = fabs(space + 1.0) > 0.000001;
    _horImageTitleSpace = space;
    _horImageTitleOffset = offset;
    _horImageTitleTopOffset = titleTopExtraOffset;
    [self layoutSubviews];
}

- (void)resetIsLeftImageRightTitleAndSpace:(CGFloat)space offset:(CGFloat)offset titleTopExtraOffset:(CGFloat)titleTopExtraOffset {
    _isLeftImageRightTitle = fabs(space + 1.0) > 0.000001;
    _horImageTitleSpace = space;
    _horImageTitleOffset = offset;
    _horImageTitleTopOffset = titleTopExtraOffset;
    [self layoutSubviews];
}

- (void)resetImageSize:(CGSize)imageSize titleSize:(CGSize)titleSize {
    _imageViewSize = imageSize;
    _isManualImageSize = !(CGSizeEqualToSize(imageSize, CGSizeZero));
    _titleLabelSize = titleSize;
    _isManualTitleSize = !(CGSizeEqualToSize(titleSize, CGSizeZero));
    [self layoutSubviews];
}

#pragma mark - Override1
- (CGSize)sizeThatFits:(CGSize)size {
    if (CGSizeEqualToSize(_fixSize, CGSizeZero)) {
        return [super sizeThatFits:size];
    } else {
        return _fixSize;
    }
}

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

#pragma mark - Set
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

#pragma mark - Override2
- (CGSize)superSizeIsImage:(BOOL)isImage {
    CGSize size = CGSizeZero;
    if (isImage) {
        size = [super imageRectForContentRect:CGRectMake(1000, 1000, 8000, 8000)].size;
    } else {
        size = [super titleRectForContentRect:CGRectMake(1000, 1000, 8000, 8000)].size;
    }
    return size;
}

- (void)resetSomeCustomSize {
    if (!self.isManualImageSize) {
        if (self.isTopImageBottomTitle || self.isRightImageLeftTitle || self.isLeftImageRightTitle) {
            CGSize imageSize = [self superSizeIsImage:YES];
            if (imageSize.height > 1.0 && imageSize.width > 1.0) {
                _imageViewSize = imageSize;
            } else {
                _imageViewSize = CGSizeZero;
            }
        } else {
            _imageViewSize = CGSizeZero;
        }
    }
    if (!self.isManualTitleSize) {
        if (self.isTopImageBottomTitle || self.isRightImageLeftTitle || self.isLeftImageRightTitle) {
            CGSize titleSize = [self superSizeIsImage:NO];
            if (titleSize.height > 1.0 && titleSize.width > 1.0) {
                _titleLabelSize = titleSize;
            } else {
                _titleLabelSize = CGSizeZero;
            }
        } else {
            _titleLabelSize = CGSizeZero;
        }
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    [self resetSomeCustomSize];
    CGRect oImageRect = [super imageRectForContentRect:contentRect];
    BOOL isCustomImageSize = !CGSizeEqualToSize(self.imageViewSize, CGSizeZero);
    BOOL isCustomTitleSize = !CGSizeEqualToSize(self.titleLabelSize, CGSizeZero);
    if (!isCustomImageSize && !isCustomTitleSize) { return oImageRect; }
    
    CGSize imSize = self.imageViewSize;
    CGSize txSize = self.titleLabelSize;
    if (!isCustomImageSize) { imSize = [self superSizeIsImage:YES]; }
    if (!isCustomTitleSize) { txSize = [self superSizeIsImage:NO]; }
    
    CGRect nImageRect = [self customRectIsImage:YES imSize:imSize txSize:txSize contentRect:contentRect];
    if (!CGRectEqualToRect(nImageRect, CGRectZero)) { return nImageRect; }
    return oImageRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    [self resetSomeCustomSize];
    CGRect oTitleRect = [super titleRectForContentRect:contentRect];
    BOOL isCustomImageSize = !CGSizeEqualToSize(self.imageViewSize, CGSizeZero);
    BOOL isCustomTitleSize = !CGSizeEqualToSize(self.titleLabelSize, CGSizeZero);
    if (!isCustomImageSize && !isCustomTitleSize) { return oTitleRect; }
    
    CGSize imSize = self.imageViewSize;
    CGSize txSize = self.titleLabelSize;
    if (!isCustomImageSize) { imSize = [self superSizeIsImage:YES]; }
    if (!isCustomTitleSize) { txSize = [self superSizeIsImage:NO]; }
    
    CGRect nTitleRect = [self customRectIsImage:NO imSize:imSize txSize:txSize contentRect:contentRect];
    if (!CGRectEqualToRect(nTitleRect, CGRectZero)) { return nTitleRect; }
    return oTitleRect;
}

- (CGRect)customRectIsImage:(BOOL)isImage imSize:(CGSize)imSize txSize:(CGSize)txSize contentRect:(CGRect)contentRect {
    BOOL isHasImSize = !CGSizeEqualToSize(imSize, CGSizeZero);
    BOOL isHasTxSize = !CGSizeEqualToSize(txSize, CGSizeZero);
    
    if (isHasImSize && isHasTxSize) {
        BOOL isInvaild = NO;
        CGFloat left = 0;
        CGFloat top = 0;
        CGFloat crw = contentRect.size.width;
        CGFloat crh = contentRect.size.height;
        CGFloat width = isImage ? imSize.width : txSize.width;
        CGFloat height = isImage ? imSize.height : txSize.height;
        CGFloat cross_width = isImage ? txSize.width : imSize.width;
        CGFloat cross_height = isImage ? txSize.height : imSize.height;
        
        if (self.isTopImageBottomTitle) {
            left = (crw - width) / 2.0;
            CGFloat space = (crh - height - self.topImageBottomTitleSpace - cross_height) / 2.0;
            top = isImage ? space : (crh - space - height);
        }
        else if (self.isRightImageLeftTitle) {
            if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
                left = (isImage ? (cross_width + self.horImageTitleSpace) : 0) + self.horImageTitleOffset;
            }
            else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {
                CGFloat space = crw - width - cross_width - self.horImageTitleSpace;
                left = (isImage ? (crw - width) : space) + self.horImageTitleOffset;
            }
            else {
                CGFloat space = (crw - width - self.horImageTitleSpace - cross_width) / 2.0;
                left = (isImage ? (crw - space - width) : space) + self.horImageTitleOffset;
            }
            top = (crh - height) / 2.0 + (isImage ? 0 : self.horImageTitleTopOffset);
        }
        else if (self.isLeftImageRightTitle) {
            if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
                left = (!isImage ? (cross_width + self.horImageTitleSpace) : 0) + self.horImageTitleOffset;
            }
            else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {
                CGFloat space = crw - width - cross_width - self.horImageTitleSpace;
                left = (!isImage ? (crw - width) : space) + self.horImageTitleOffset;
            }
            else {
                CGFloat space = (crw - width - self.horImageTitleSpace - cross_width) / 2.0;
                left = (!isImage ? (crw - space - width) : space) + self.horImageTitleOffset;
            }
            top = (crh - height) / 2.0 + (isImage ? 0 : self.horImageTitleTopOffset);
        }
        else {
            CGFloat offset_x = isImage ? 0 : imSize.width;
            CGFloat cross_offset_x = isImage ? txSize.width : 0;
            UIEdgeInsets edge = isImage ? self.imageEdgeInsets : self.titleEdgeInsets;
            
            if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentCenter) {
                CGFloat w = crw - cross_width - edge.left - edge.right;
                left = offset_x + edge.left + (w - width) / 2.0;
            }
            else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
                left = offset_x + edge.left;
            }
            else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {
                left = crw - edge.right - width - cross_offset_x;
            }
            else {
                isInvaild = YES;
            }
            
            if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentCenter) {
                CGFloat h = crh - edge.top - edge.bottom;
                top = edge.top + (h - height) / 2.0;
            }
            else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop) {
                top = edge.top;
            }
            else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom) {
                top = crh - edge.bottom - height;
            }
            else {
                isInvaild = YES;
            }
        }
        return isInvaild ? CGRectZero : CGRectMake(contentRect.origin.x + left, contentRect.origin.y + top, width, height);
    }
    else if ((isImage && isHasImSize) || (!isImage && isHasTxSize)) {
        BOOL isInvaild = NO;
        CGFloat left = 0;
        CGFloat top = 0;
        CGFloat crw = contentRect.size.width;
        CGFloat crh = contentRect.size.height;
        CGFloat width = isImage ? imSize.width : txSize.width;
        CGFloat height = isImage ? imSize.height : txSize.height;
        UIEdgeInsets edge = isImage ? self.imageEdgeInsets : self.titleEdgeInsets;
        
        if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentCenter) {
            CGFloat w = crw - edge.left - edge.right;
            left = edge.left + (w - width) / 2.0;
        }
        else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
            left = edge.left;
        }
        else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {
            left = crw - edge.right - width;
        }
        else {
            isInvaild = YES;
        }
        
        if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentCenter) {
            CGFloat h = crh - edge.top - edge.bottom;
            top = edge.top + (h - height) / 2.0;
        }
        else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentTop) {
            top = edge.top;
        }
        else if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom) {
            top = crh - edge.bottom - height;
        }
        else {
            isInvaild = YES;
        }
        return isInvaild ? CGRectZero : CGRectMake(contentRect.origin.x + left, contentRect.origin.y + top, width, height);
    }
    return CGRectZero;
}

@end
