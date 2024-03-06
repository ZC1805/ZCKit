//
//  ZCAvatarControl.m
//  ZCKit
//
//  Created by admin on 2018/10/25.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCAvatarControl.h"
#import "ZCKitBridge.h"
#import "UIView+ZC.h"
#import "ZCLabel.h"
#import "ZCMacro.h"

@implementation ZCAvatarControl

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kZCClear;
        self.layer.geometryFlipped = YES;
        [self resetInitProperty];
    }
    return self;
}

- (void)resetInitProperty {
    _alignment = 0;
    _descLabel = nil;
    _cornerRadius = 0;
    _localImage = nil;
    _isAspectFit = NO;
    self.touchAction = nil;
    [self setNeedsDisplay];
}

#pragma mark - Override
- (CGSize)sizeThatFits:(CGSize)size {
    if (_descLabel) {
        return [_descLabel sizeThatFits:size];
    }
    return [super sizeThatFits:size];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_descLabel) {
        _descLabel.frame = self.bounds;
    }
}

#pragma mark - Set
- (void)setLocalImage:(UIImage *)localImage {
    if (_localImage != localImage) {
        _localImage = localImage;
        [self setNeedsDisplay];
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius != cornerRadius) {
        _cornerRadius = cornerRadius;
        [self setNeedsDisplay];
    }
}

- (void)setAlignment:(NSInteger)alignment {
    if (_alignment != alignment) {
        _alignment = alignment;
        [self setNeedsDisplay];
    }
}

- (void)setIsAspectFit:(BOOL)isAspectFit {
    if (_isAspectFit != isAspectFit) {
        _isAspectFit = isAspectFit;
        [self setNeedsDisplay];
    }
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    [self setNeedsDisplay];
}

- (void)setTouchAction:(void (^)(ZCAvatarControl * _Nonnull))touchAction {
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

- (ZCLabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[ZCLabel alloc] initWithFrame:CGRectZero];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.textColor = kZCBlack30;
        _descLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        [self addSubview:_descLabel];
    }
    return _descLabel;
}

#pragma mark - Misc
- (void)onTouchActionZC:(id)sender {
    if (_touchAction) _touchAction(self);
}

- (void)drawRect:(CGRect)rect {
    if (!self.zc_width || !self.zc_height) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if (_cornerRadius > 0) {
        CGContextAddPath(context, [self cornerPath]);
        CGContextClip(context);
    }
    UIImage *image = _localImage;
    if (image && image.size.height && image.size.width) { //此处使用ScaleAspectFill模式
        CGPoint center = CGPointMake(self.zc_width / 2.0, self.zc_height / 2.0);
        CGFloat widScale = image.size.width / self.zc_width;
        CGFloat heiScale = image.size.height / self.zc_height;
        CGFloat scale = self.isAspectFit ? MAX(widScale, heiScale) : MIN(widScale, heiScale);
        CGSize size = CGSizeMake(image.size.width / scale, image.size.height / scale);
        CGRect draw = CGRectMake(center.x - (size.width / 2.0), center.y - (size.height / 2.0), size.width, size.height);
        if (self.alignment == 1) {
            draw.origin.y = 0;
        } else if (self.alignment == 2) {
            draw.origin.x = 0;
        } else if (self.alignment == 3) {
            draw.origin.y = self.zc_height - size.height;
        } else if (self.alignment == 4) {
            draw.origin.x = self.zc_width - size.width;
        }
        CGContextDrawImage(context, draw, image.CGImage);
    }
}

- (CGPathRef)cornerPath {
    return [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius] CGPath];
}

- (void)imageUrl:(NSString *)url holder:(UIImage *)holder {
    [ZCKitBridge.realize imageWebCache:self url:[NSURL URLWithString:kZStrNonnil(url)] holder:holder
                            assignment:^(UIImage * _Nullable image, NSData * _Nullable imageData,
                                         NSInteger cacheType, NSURL * _Nullable imageURL) {
                                self.localImage = image;
                            }];
}

@end
