//
//  ZCAvatarControl.m
//  ZCKit
//
//  Created by admin on 2018/10/25.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCAvatarControl.h"
#import "ZCKitBridge.h"

@implementation ZCAvatarControl

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.geometryFlipped = YES;
        _cornerRadius = 0;
        _localImage = nil;
    }
    return self;
}

#pragma mark - set
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

- (void)setTouchAction:(void (^)(ZCAvatarControl * _Nonnull))touchAction {
    _touchAction = touchAction;
    [self removeTarget:self action:@selector(onTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(onTouchAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - misc
- (void)onTouchAction:(id)sender {
    if (_touchAction) _touchAction(self);
}

- (void)drawRect:(CGRect)rect {
    if (!self.frame.size.width || !self.frame.size.height) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if (_cornerRadius > 0) {
        CGContextAddPath(context, [self cornerPath]);
        CGContextClip(context);
    }
    UIImage *image = _localImage;
    if (image && image.size.height && image.size.width) { //ScaleAspectFill模式
        CGPoint center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        CGFloat widScale = image.size.width / self.frame.size.width;
        CGFloat heiScale = image.size.height / self.frame.size.height;
        CGFloat scale = widScale < heiScale ? widScale : heiScale;
        CGSize size = CGSizeMake(image.size.width / scale, image.size.height / scale);
        CGRect draw = CGRectMake(center.x - (size.width / 2.0), center.y - (size.height / 2.0), size.width, size.height);
        CGContextDrawImage(context, draw, image.CGImage);
    }
    CGContextRestoreGState(context);
}

- (CGPathRef)cornerPath {
    return [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius] CGPath];
}

- (void)imageUrl:(NSString *)url holder:(UIImage *)holder {
    [ZCKitBridge.realize imageWebCache:self url:[NSURL URLWithString:url] holder:holder
                            assignment:^(UIImage * _Nullable image, NSData * _Nullable imageData) {
                                self.localImage = image;
                            }];
}

@end
