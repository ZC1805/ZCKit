//
//  ZCPhotoPreviewer.m
//  ZCKit
//
//  Created by admin on 2018/10/26.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCPhotoPreviewer.h"
#import "ZCScrollView.h"
#import "ZCKitBridge.h"
#import "ZCImageView.h"
#import "ZCLabel.h"
#import "UIView+ZC.h"
#import "ZCMacro.h"

@interface ZCPhotoPreviewer () <UIScrollViewDelegate>

@property (nonatomic, strong) UIVisualEffectView *blurBKView; //背景视图

@property (nonatomic, strong) ZCScrollView *scrollView; //滑动视图

@property (nonatomic, strong) UIView *containerView; //容器视图

@property (nonatomic, strong) ZCImageView *imageView; //显示的图片

@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGR; //双击

@property (nonatomic, strong) UITapGestureRecognizer *singleTapGR; //单击

@property (nonatomic, strong) UIColor *textOriginColor; //默认文字颜色

@property (nonatomic, assign) CGRect fromRect; //从哪显示的位置

@property (nonatomic, assign) CGFloat originAlpha; //carrier初始的透明度

@property (nonatomic, assign) BOOL isOriginStatusBarHidden; //原本是否隐藏状态栏

@property (nonatomic, assign) BOOL isInAnimation; //是否正在动画中

@property (nonatomic, assign) BOOL isUseObserve; //是否观察了imageView

@end

@implementation ZCPhotoPreviewer

@synthesize titleLabel = _titleLabel;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialSet];
    }
    return self;
}

- (void)initialSet {
    self.backgroundColor = kZCClear;
    self.frame = kZSScreen;
    self.textOriginColor = kZCPad;
    self.isAllowDoubleTap = NO;
    self.isUseDarkStyle = YES;
    self.isInAnimation = NO;
    self.isUseObserve = NO;
    self.radius = 0;
    
    self.singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    [self addGestureRecognizer:self.singleTapGR];
    self.doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
    self.doubleTapGR.numberOfTapsRequired = 2;
    [self addGestureRecognizer:self.doubleTapGR];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    longPress.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPress];
    
    self.scrollView = [[ZCScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.bounces = YES;
    self.scrollView.delegate = self;
    self.scrollView.bouncesZoom = YES;
    self.scrollView.maximumZoomScale = 3.0;
    self.scrollView.multipleTouchEnabled = YES;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    self.containerView = [[UIView alloc] init];
    [self.scrollView addSubview:self.containerView];
    
    self.imageView = [[ZCImageView alloc] initWithFrame:CGRectZero image:nil];
    self.imageView.clipsToBounds = YES;
    [self.containerView addSubview:self.imageView];
}

- (ZCLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[ZCLabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = self.isUseDarkStyle ? self.textOriginColor : kZCBlack30;
        _titleLabel.frame = CGRectMake(30.0, kZSStuBarHei, self.zc_width - 60.0, kZSNaviBarHei);
        [self addSubview:self.titleLabel];
    }
    return _titleLabel;
}

- (UIVisualEffectView *)blurBKView {
    if (!_blurBKView) {
        UIBlurEffectStyle style = self.isUseDarkStyle ? UIBlurEffectStyleDark : UIBlurEffectStyleExtraLight;
        _blurBKView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:style]];
        _blurBKView.frame = self.frame;
        [self insertSubview:_blurBKView atIndex:0];
    }
    return _blurBKView;
}

- (void)setIsUseDarkStyle:(BOOL)isUseDarkStyle {
    _isUseDarkStyle = isUseDarkStyle;
    if (_titleLabel && [_titleLabel.textColor isEqual:self.textOriginColor]) {
        _titleLabel.textColor = kZCBlack30;
    }
}

#pragma mark - Kvo
static NSString * const observeImageKey = @"image";
static void *imageObserveContext = @"imageObserveContext";
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:observeImageKey] && object == self.carrier && context == imageObserveContext) {
        UIImage *image = [change objectForKey:NSKeyValueChangeNewKey];
        if ([image isKindOfClass:UIImage.class]) {
            [self layoutFrame:image.size];
            self.imageView.image = image;
            self.imageView.frame = self.containerView.bounds;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)addImageViewObserve {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.carrier addObserver:self forKeyPath:observeImageKey options:options context:imageObserveContext];
    self.isUseObserve = YES;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview && self.isUseObserve) {
        [self.carrier removeObserver:self forKeyPath:observeImageKey context:imageObserveContext];
    }
}

#pragma mark - Func
+ (void)display:(UIImage *)image ctor:(void (^)(ZCPhotoPreviewer * _Nonnull))ctor {
    ZCPhotoPreviewer *previewer = [[ZCPhotoPreviewer alloc] initWithFrame:CGRectZero];
    if (ctor) ctor(previewer);
    [previewer previewImage:image];
}

+ (void)displayImageView:(ZCImageView *)imageView ctor:(nullable void (^)(ZCPhotoPreviewer * _Nonnull))ctor {
    if (!imageView) return;
    ZCPhotoPreviewer *previewer = [[ZCPhotoPreviewer alloc] initWithFrame:CGRectZero];
    if (imageView.layer.cornerRadius) previewer.radius = imageView.layer.cornerRadius;
    previewer.carrier = imageView;
    if (ctor) ctor(previewer);
    [previewer previewImage:imageView.image];
    [previewer addImageViewObserve];
}

- (void)previewImage:(UIImage *)image {
    UIView *container = [UIApplication sharedApplication].delegate.window;
    if (!container) return;
    self.doubleTapGR.enabled = self.isAllowDoubleTap;
    if (self.isAllowDoubleTap) [self.singleTapGR requireGestureRecognizerToFail:self.doubleTapGR];
    [container addSubview:self];
    
    [self layoutFrame:image.size];
    self.imageView.frame = self.fromRect;
    self.imageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.imageURL) [ZCKitBridge.realize imageViewWebCache:self.imageView url:self.imageURL holder:image];
    else self.imageView.image = image;
    [self preview];
}

- (void)preview {
    self.blurBKView.alpha = 0;
    if (_titleLabel) _titleLabel.alpha = 0;
    if (!self.carrier) self.imageView.alpha = 0;
    if (self.carrier) self.originAlpha = self.carrier.alpha;
    if (self.radius) self.imageView.layer.cornerRadius = self.radius;
    if (self.carrier) self.carrier.alpha = 0;
    self.isOriginStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    #pragma clang diagnostic pop
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut;
    [UIView animateWithDuration:0.25 delay:0 options:options animations:^{
        self.isInAnimation = YES;
        self.blurBKView.alpha = 1;
        self.imageView.frame = self.containerView.bounds;
        if (!self.carrier) self.imageView.alpha = 1;
        if (self->_titleLabel) self->_titleLabel.alpha = 1;
        if (self.radius) self.imageView.layer.cornerRadius = 0;
    } completion:^(BOOL finished) {
        self.isInAnimation = NO;
        self.imageView.frame = self.containerView.bounds;
        self.imageView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut;
    [UIView animateWithDuration:0.25 delay:0 options:options animations:^{
        self.isInAnimation = YES;
        self.blurBKView.alpha = 0;
        self.imageView.frame = self.fromRect;
        if (!self.carrier) self.imageView.alpha = 0;
        if (self->_titleLabel) self->_titleLabel.alpha = 0;
        if (self.radius) self.imageView.layer.cornerRadius = self.radius;
        if (self.carrier) self.imageView.contentMode = self.carrier.contentMode;
    } completion:^(BOOL finished) {
        self.isInAnimation = NO;
        if (self.carrier) self.carrier.alpha = self.originAlpha;
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarHidden:self.isOriginStatusBarHidden];
        #pragma clang diagnostic pop
        [self removeFromSuperview];
    }];
}

#pragma mark - Misc
- (void)layoutFrame:(CGSize)imageSize {
    if (@available(iOS 11.0, *)) { self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; }
    CGFloat height = self.zc_height;
    if (imageSize.width > 0) height = imageSize.height / imageSize.width * self.zc_width;
    if (height < 1.0) height = self.zc_height;
    height = floorf(height);
    if (ABS(height - self.zc_height) <= 1.0) height = self.zc_height;
    self.containerView.zc_height = height;
    self.containerView.zc_width = self.zc_width;
    self.containerView.center = CGPointMake(self.zc_width / 2.0, MAX(self.zc_height, height) / 2.0);
    
    self.scrollView.alwaysBounceVertical = self.containerView.zc_height > self.zc_height;
    self.scrollView.contentSize = CGSizeMake(self.zc_width, MAX(height, self.zc_height));
    CGRect visible = CGRectOffset(self.bounds, 0, MAX((height - self.zc_height) / 2.0, 0));
    [self.scrollView scrollRectToVisible:visible animated:NO];
    
    if (self.carrier && self.carrier.superview) {
        self.fromRect = [self.carrier.superview convertRect:self.carrier.frame toView:self.containerView];
    } else {
        CGFloat height = 100.0;
        if (imageSize.width > 0) height = 100.0 * imageSize.height / imageSize.width;
        self.fromRect = CGRectMake(self.containerView.zc_width / 2.0 - 50.0, self.containerView.zc_height / 2.0 - height / 2.0, 100.0, height);
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(ZCScrollView *)scrollView {
    return self.containerView;
}

- (void)scrollViewDidZoom:(ZCScrollView *)scrollView {
    CGFloat offsetX = 0, offsetY = 0;
    if (scrollView.bounds.size.width > scrollView.contentSize.width) {
        offsetX = (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5;
    }
    if (scrollView.bounds.size.height > scrollView.contentSize.height) {
        offsetY = (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5;
    }
    self.containerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - GestureRecognizer
- (void)onSingleTap:(UITapGestureRecognizer *)recognizer {
    if (self.isInAnimation) return;
    if (self.scrollView.zoomScale == 1.0) {
        [self dismiss];
    } else {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
}

- (void)onDoubleTap:(UITapGestureRecognizer *)recognizer {
    if (self.isInAnimation) return;
    if (self.scrollView.zoomScale > 1.0) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [recognizer locationInView:self.imageView];
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xSize = self.zc_width / newZoomScale;
        CGFloat ySize = self.zc_height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xSize / 2.0, touchPoint.y - ySize / 2.0, xSize, ySize) animated:YES];
    }
}

- (void)onLongPress:(UILongPressGestureRecognizer *)recognizer {
    if (self.isInAnimation) return;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (self.longPressAction) self.longPressAction();
    }
}

@end
