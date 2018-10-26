//
//  ZCPhotoPreviewer.m
//  ZCKit
//
//  Created by admin on 2018/10/26.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCPhotoPreviewer.h"
#import "ZCKitBridge.h"
#import "UIView+ZC.h"
#import "ZCMacro.h"

@interface ZCPhotoPreviewer () <UIScrollViewDelegate>

@property (strong, nonatomic) UIVisualEffectView *blurBKView; //背景视图

@property (strong, nonatomic) UIScrollView *scrollView; //滑动视图

@property (strong, nonatomic) UIView *containerView; //容器视图

@property (strong, nonatomic) UIImageView *imageView; //显示的图片

@property (strong, nonatomic) UITapGestureRecognizer *doubleTapGR; //双击

@property (strong, nonatomic) UITapGestureRecognizer *singleTapGR; //单击

@property (assign, nonatomic) CGRect fromRect; //从哪显示的位置

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
    self.backgroundColor = [UIColor clearColor];
    self.frame = [UIScreen mainScreen].bounds;
    self.doubleTap = YES;
    self.radius = 0;
    
    self.singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    [self addGestureRecognizer:self.singleTapGR];
    self.doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
    self.doubleTapGR.numberOfTapsRequired = 2;
    [self addGestureRecognizer:self.doubleTapGR];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    longPress.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPress];
    
    self.blurBKView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    self.blurBKView.frame = self.frame;
    self.blurBKView.alpha = 0.01;
    [self addSubview:self.blurBKView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
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
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.clipsToBounds = YES;
    self.imageView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [self.containerView addSubview:self.imageView];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero color:[UIColor clearColor]];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.frame = CGRectMake(30.0, ZSStuBarHei, self.width - 60.0, ZSNaviBarHei);
        _titleLabel.alpha = 0.01;
        [self addSubview:self.titleLabel];
    }
    return _titleLabel;
}

#pragma mark - func
+ (void)display:(UIImage *)image ctor:(void (^)(ZCPhotoPreviewer * _Nonnull))ctor {
    ZCPhotoPreviewer *previewer = [[ZCPhotoPreviewer alloc] initWithFrame:CGRectZero];
    if (ctor) ctor(previewer);
    [previewer previewImage:image];
}

- (void)previewImage:(UIImage *)image {
    UIView *container = [UIApplication sharedApplication].delegate.window;
    if (!container) return;
    self.doubleTapGR.enabled = self.doubleTap;
    if (self.doubleTap) [self.singleTapGR requireGestureRecognizerToFail:self.doubleTapGR];
    self.containerView.origin = CGPointZero;
    self.containerView.width = self.width;
    [container addSubview:self];
    
    if (image.size.height / image.size.height > self.height / self.width) {
        self.containerView.height = floor(image.size.height / (image.size.width / self.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        self.containerView.height = height;
        self.containerView.centerY = self.height / 2.0;
    }
    if (self.containerView.height > self.height && (self.containerView.height - self.height) <= 1) {
        self.containerView.height = self.height;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.width, MAX(self.containerView.height, self.height));
    [self.scrollView scrollRectToVisible:self.bounds animated:NO];
    if (self.containerView.height <= self.height) {
        self.scrollView.alwaysBounceVertical = NO;
    } else {
        self.scrollView.alwaysBounceVertical = YES;
    }
    
    if (self.carrier && self.carrier.superview) {
        self.fromRect = [self.carrier.superview convertRect:self.carrier.frame toView:container];
    } else {
        self.fromRect = CGRectMake(self.width / 2.0, self.height / 2.0, 0, 0);
    }
    self.imageView.frame = self.fromRect;
    self.imageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.imageURL) [ZCKitBridge.realize imageViewWebCache:self.imageView url:self.imageURL holder:image];
    else self.imageView.image = image;
    [self preview];
}
#warning - 位置吧不对
- (void)preview {
    if (!self.carrier) self.imageView.alpha = 0;
    if (self.radius) self.imageView.layer.cornerRadius = self.radius;
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut;
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.5 options:options animations:^{
        self.blurBKView.alpha = 1.0;
        if (!self.carrier) self.imageView.alpha = 1.0;
        if (self->_titleLabel) self->_titleLabel.alpha = 1.0;
        self.imageView.frame = self.containerView.bounds;
        if (self.radius) self.imageView.layer.cornerRadius = 0;
    } completion:^(BOOL finished) {
        if (self.carrier) self.carrier.hidden = YES;
        self.imageView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn;
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:5.0 options:options animations:^{
        self.blurBKView.alpha = 0.01;
        self.imageView.frame = self.fromRect;
        if (!self.carrier) self.imageView.alpha = 0;
        if (self->_titleLabel) self->_titleLabel.alpha = 0;
        if (self.radius) self.imageView.layer.cornerRadius = self.radius;
        if (self.carrier) self.imageView.contentMode = self.carrier.contentMode;
    } completion:^(BOOL finished) {
        self.alpha = 0;
        if (self.carrier) self.carrier.hidden = NO;
        [self removeFromSuperview];
    }];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = self.containerView;
    CGFloat offsetX = 0, offsetY = 0;
    if (scrollView.bounds.size.width > scrollView.contentSize.width) {
        offsetX = (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5;
    }
    if (scrollView.bounds.size.height > scrollView.contentSize.height) {
        offsetY = (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5;
    }
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - GestureRecognizer
- (void)onSingleTap:(UITapGestureRecognizer *)recognizer {
    if (self.scrollView.zoomScale == 1.0) {
        [self dismiss];
    } else {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
}

- (void)onDoubleTap:(UITapGestureRecognizer *)recognizer {
    if (self.scrollView.zoomScale > 1.0) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [recognizer locationInView:self.imageView];
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xSize = self.width / newZoomScale;
        CGFloat ySize = self.height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xSize / 2.0, touchPoint.y - ySize / 2.0, xSize, ySize) animated:YES];
    }
}

- (void)onLongPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (self.longPressAction) self.longPressAction();
    }
}

@end
