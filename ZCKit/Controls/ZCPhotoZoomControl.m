//
//  ZCPhotoZoomControl.m
//  ZCKit
//
//  Created by admin on 2018/10/29.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCPhotoZoomControl.h"
#import "UIScrollView+ZC.h"
#import "ZCKitBridge.h"
#import "UIView+ZC.h"
#import "ZCMacro.h"

@interface ZCPhotoZoomControl ()

@property (nonatomic, strong) UIImageView *headerIv;

@property (nonatomic, strong) UIView *headerMask;

@property (nonatomic, assign) CGRect originFrame;

@property (nonatomic, assign) BOOL isAutoOfset;

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation ZCPhotoZoomControl

static float initAdditional = 30.0;
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isUseBlur = NO;
        _isAutoOfset = YES;
        _isNeedNarrow = YES;
        _originOffset = CGPointZero;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)imageUrl:(NSString *)url holder:(UIImage *)holder {
    [ZCKitBridge.realize imageWebCache:self url:[NSURL URLWithString:url] holder:holder
                            assignment:^(UIImage * _Nullable image, NSData * _Nullable imageData) {
                                self.localImage = image;
                            }];
}

- (void)onTouchAction:(id)sender {
    if (_touchAction) _touchAction(self);
}

#pragma mark - set
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self resetImage];
}

- (void)setLocalImage:(UIImage *)localImage {
    if (_localImage != localImage) {
        _localImage = localImage;
        [self resetImage];
    }
}

- (void)setOriginOffset:(CGPoint)originOffset {
    _originOffset = originOffset;
    _isAutoOfset = CGPointEqualToPoint(originOffset, CGPointZero);
    [self resetImage];
}

- (void)setIsUseBlur:(BOOL)isUseBlur {
    _isUseBlur = isUseBlur;
    if (isUseBlur && !_blurBKView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _blurBKView = [[UIVisualEffectView alloc] initWithEffect:blur];
        [_headerIv addSubview:_blurBKView];
    }
    if (!isUseBlur && _blurBKView) {
        [_blurBKView removeFromSuperview];
        _blurBKView = nil;
    }
    [self resetImage];
}

- (void)setIsNeedNarrow:(BOOL)isNeedNarrow {
    _isNeedNarrow = isNeedNarrow;
    [self resetImage];
}

- (void)setTouchAction:(void (^)(ZCPhotoZoomControl * _Nonnull))touchAction {
    _touchAction = touchAction;
    if ([self.allTargets containsObject:self]) {
        [self removeTarget:self action:@selector(onTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (touchAction) {
        [self addTarget:self action:@selector(onTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - get
- (UIImageView *)headerIv {
    if (!_headerIv) {
        _headerIv = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headerIv.contentMode = UIViewContentModeScaleAspectFill;
        _headerIv.clipsToBounds = YES;
        [self addSubview:_headerIv];
    }
    return _headerIv;
}

- (UIView *)headerMask {
    if (!_headerMask) {
        _headerMask = [[UIView alloc] initWithFrame:CGRectZero color:[UIColor blackColor]];
    }
    return _headerMask;
}

#pragma mark - ctor
- (void)resetImage {
    CGFloat height = self.height;
    if (self.localImage && self.isAutoOfset && self.localImage.size.width) {
        height = self.width * self.localImage.size.height / self.localImage.size.width + (self.isNeedNarrow ? initAdditional : 0);
        if (height < self.height) height = self.height;
        _originOffset = CGPointMake(0, (self.height - height) / 2.0);
    }
    BOOL isMask = self.originOffset.y < 0;
    self.originFrame = CGRectMake(self.originOffset.x, self.originOffset.y, self.width, height);
    self.headerIv.image = self.localImage;
    self.headerIv.frame = self.originFrame;
    self.headerMask.frame = CGRectMake(0, -self.originOffset.y, self.width, MAX(height + 2.0 * self.originOffset.y, 0));
    self.blurBKView.frame = isMask ? self.headerMask.frame : self.headerIv.bounds;
    self.headerIv.maskView = isMask ? self.headerMask : nil;
    [self updateHeaderImageFrame:self.scrollView];
}

- (void)updateHeaderImageFrame:(UIScrollView *)scrollView {
    if (!scrollView) return;
    if (self.scrollView != scrollView) self.scrollView = scrollView;
    CGFloat offsetY = scrollView.visualOffsetY;
    if (!self.isNeedNarrow && offsetY >= 0) return; //图片不变窄
    if (self.originFrame.size.height - offsetY <= 0) return; //防止高度小于0
    CGFloat x = self.originFrame.origin.x; //如果不使用约束，图片的y值要上移，height也要增加
    CGFloat y = self.originFrame.origin.y + offsetY;
    CGFloat width = self.originFrame.size.width;
    CGFloat height = self.originFrame.size.height - offsetY;
    self.headerIv.frame = CGRectMake(x, y, width, height);
    if (self.headerIv.maskView) {
        CGFloat maskHei = self.originFrame.size.height + 2.0 * self.originOffset.y - offsetY;
        self.headerMask.frame = CGRectMake(0, -self.originOffset.y, width, MAX(maskHei, 0));
    }
    self.blurBKView.frame = self.headerIv.maskView ? self.headerMask.frame : self.headerIv.bounds;
}

@end
