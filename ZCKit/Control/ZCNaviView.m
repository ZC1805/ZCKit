//
//  ZCNaviView.m
//  ZCKit
//
//  Created by admin on 2018/10/23.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCNaviView.h"
#import "UIViewController+ZC.h"
#import "ZCViewController.h"
#import "ZCQueueHandler.h"
#import "ZCKitBridge.h"
#import "NSString+ZC.h"
#import "UIView+ZC.h"
#import "ZCButton.h"
#import "ZCMacro.h"

@interface ZCNaviView ()

@property (nonatomic, strong) ZCButton *leftButton;

@property (nonatomic, strong) ZCLabel *middleLabel;

@property (nonatomic, strong) ZCButton *rightButton;

@property (nonatomic, strong) UIView *leftCustomView;

@property (nonatomic, strong) UIView *middleCustomView;

@property (nonatomic, strong) UIView *rightCustomView;

@property (nonatomic, copy) void(^leftBlock)(void);

@property (nonatomic, copy) void(^rightBlock)(void);

@property (nonatomic, weak) UIViewController *associate;

@end

@implementation ZCNaviView

#pragma mark - InstanceFunc
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    } return self;
}

- (void)initUI {
    self.backgroundColor = kZCClear;
    UIImage *imageBar = [UIImage imageNamed:ZCKitBridge.naviBarImageOrColor];
    if (!imageBar) imageBar = [UIImage imageWithColor:kZCS(ZCKitBridge.naviBarImageOrColor)];
    _cushionView = [[ZCImageView alloc] initWithFrame:self.bounds image:imageBar isInteract:YES isAspectFit:NO];
    _lineShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, self.zc_height - kZSPixel, self.zc_width, kZSPixel) color:kZCSplit];
    [self addSubview:self.cushionView];
    
    self.leftButton = [[ZCButton alloc] initWithTitle:nil font:[UIFont fontWithName:@"HelveticaNeue" size:14] color:nil image:nil target:self action:@selector(onLeftItem)];
    self.leftButton.responseAreaExtend = UIEdgeInsetsMake(10, 10, 10, 10);
    self.leftButton.adjustsImageWhenHighlighted = YES;
    [self.leftButton setTitleColor:kZCS(ZCKitBridge.naviBarTitleColor) forState:UIControlStateNormal];
    [self.leftButton setTitleColor:kZCSA(ZCKitBridge.naviBarTitleColor, 0.3) forState:UIControlStateHighlighted];
    [self addSubview:self.leftButton];
    
    self.rightButton = [[ZCButton alloc] initWithTitle:nil font:[UIFont fontWithName:@"HelveticaNeue" size:14] color:nil image:nil target:self action:@selector(onRightItem)];
    self.rightButton.responseAreaExtend = UIEdgeInsetsMake(10, 10, 10, 10);
    self.rightButton.adjustsImageWhenHighlighted = YES;
    [self.rightButton setTitleColor:kZCS(ZCKitBridge.naviBarTitleColor) forState:UIControlStateNormal];
    [self.rightButton setTitleColor:kZCSA(ZCKitBridge.naviBarTitleColor, 0.3) forState:UIControlStateHighlighted];
    [self addSubview:self.rightButton];
    
    self.middleLabel = [[ZCLabel alloc] initWithColor:kZCS(ZCKitBridge.naviBarTitleColor) font:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16] alignment:NSTextAlignmentCenter adjustsSize:NO];
    self.middleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self addSubview:self.middleLabel];
    
    [self addSubview:self.lineShadowView];
    [self setTitle:nil leftName:(NSString *)ZCKitBridge.naviBackImage rightName:nil];
}

#pragma mark - ClassFunc
+ (instancetype)viewWithTitle:(NSString *)title {
    return [self viewWithTitle:title rightName:nil leftBlock:nil rightBlock:nil];
}

+ (instancetype)viewWithTitle:(NSString *)title rightName:(NSString *)rightName leftBlock:(void(^)(void))leftBlock rightBlock:(void(^)(void))rightBlock {
    ZCNaviView *customView = [[ZCNaviView alloc] initWithFrame:CGRectMake(0, 0, kZSWid, kZSNaviHei)];
    customView.leftBlock = leftBlock;
    customView.rightBlock = rightBlock;
    [customView setTitle:title leftName:(NSString *)ZCKitBridge.naviBackImage rightName:rightName];
    return customView;
}

+ (instancetype)viewWithTitle:(NSString *)title rightView:(UIView *)rightView {
    ZCNaviView *customView = [[ZCNaviView alloc] initWithFrame:CGRectMake(0, 0, kZSWid, kZSNaviHei)];
    customView.rightCustomView = rightView;
    [customView setTitle:title leftName:(NSString *)ZCKitBridge.naviBackImage rightName:nil];
    return customView;
}

#pragma mark - ApiFunc
- (void)setTitle:(NSString *)title leftName:(NSString *)leftName rightName:(NSString *)rightName {
    CGFloat left_wid = 0;
    if (self.leftCustomView) {
        self.leftButton.hidden = YES;
        if (self.leftCustomView.zc_width == 0) { left_wid = 10; }
        else { left_wid = self.leftCustomView.zc_width; }
        self.leftCustomView.zc_size = CGSizeMake(left_wid, self.leftCustomView.zc_height);
    } else {
        self.leftButton.hidden = NO;
        self.leftButton.userInteractionEnabled = NO;
        self.leftButton.imageViewSize = CGSizeZero;
        [self.leftButton setTitle:nil forState:UIControlStateNormal];
        [self.leftButton setImage:nil forState:UIControlStateNormal];
        [self.leftButton setImage:nil forState:UIControlStateHighlighted];
        if (leftName && [leftName isKindOfClass:NSString.class] && leftName.length) {
            UIImage *leftImage = [UIImage imageNamed:leftName];
            if (leftImage) { leftName = (NSString *)leftImage; }
        }
        if (leftName && [leftName isKindOfClass:NSString.class] && leftName.length) {
            self.leftButton.userInteractionEnabled = YES;
            left_wid = [leftName sizeLabelForFont:self.leftButton.titleLabel.font width:CGFLOAT_MAX alignment:self.leftButton.titleLabel.textAlignment spacing:0].width + 10;
            [self.leftButton setTitle:leftName forState:UIControlStateNormal];
        } else if (leftName && [leftName isKindOfClass:UIImage.class]) {
            self.leftButton.userInteractionEnabled = YES;
            left_wid = 22;
            [self.leftButton setImage:(UIImage *)leftName forState:UIControlStateNormal];
            [self.leftButton setImage:[(UIImage *)leftName imageWithAlpha:0.3] forState:UIControlStateHighlighted];
            self.leftButton.imageViewSize = CGSizeMake(22, 22);
        } else {
            left_wid = 10;
        } left_wid = MIN(left_wid, self.cushionView.zc_width - 150);
        self.leftButton.zc_size = CGSizeMake(left_wid, 22);
    }
    
    CGFloat right_wid = 0;
    if (self.rightCustomView) {
        self.rightButton.hidden = YES;
        if (self.rightCustomView.zc_width == 0) { right_wid = 10; }
        else { right_wid = self.rightCustomView.zc_width; }
        self.rightCustomView.zc_size = CGSizeMake(right_wid, self.rightCustomView.zc_height);
    } else {
        self.rightButton.hidden = NO;
        self.rightButton.userInteractionEnabled = NO;
        self.rightButton.imageViewSize = CGSizeZero;
        [self.rightButton setTitle:nil forState:UIControlStateNormal];
        [self.rightButton setImage:nil forState:UIControlStateNormal];
        [self.rightButton setImage:nil forState:UIControlStateHighlighted];
        if (rightName && [rightName isKindOfClass:NSString.class] && rightName.length) {
            UIImage *rightImage = [UIImage imageNamed:rightName];
            if (rightImage) { rightName = (NSString *)rightImage; }
        }
        if (rightName && [rightName isKindOfClass:NSString.class] && rightName.length) {
            self.rightButton.userInteractionEnabled = YES;
            right_wid = [rightName sizeLabelForFont:self.rightButton.titleLabel.font width:CGFLOAT_MAX alignment:self.rightButton.titleLabel.textAlignment spacing:0].width + 10;
            [self.rightButton setTitle:rightName forState:UIControlStateNormal];
        } else if (rightName && [rightName isKindOfClass:UIImage.class]) {
            self.rightButton.userInteractionEnabled = YES;
            right_wid = 22;
            [self.rightButton setImage:(UIImage *)rightName forState:UIControlStateNormal];
            [self.rightButton setImage:[(UIImage *)rightName imageWithAlpha:0.3] forState:UIControlStateHighlighted];
            self.rightButton.imageViewSize = CGSizeMake(22, 22);
        } else {
            right_wid = 10;
        } right_wid = MIN(right_wid, self.cushionView.zc_width - left_wid - 80);
        self.rightButton.zc_size = CGSizeMake(right_wid, 22);
    }
    
    CGFloat middle_wid = 0;
    if (self.middleCustomView) {
        self.middleLabel.hidden = YES;
        if (self.middleCustomView.zc_width == 0) { middle_wid = 10; }
        else { middle_wid = self.middleCustomView.zc_width; }
        self.middleCustomView.zc_size = CGSizeMake(middle_wid, self.middleCustomView.zc_height);
    } else {
        self.middleLabel.hidden = NO;
        if (title.length) { middle_wid = [title sizeLabelForFont:self.middleLabel.font width:CGFLOAT_MAX alignment:self.middleLabel.textAlignment spacing:0].width + 10; }
        else { middle_wid = 10; }
        self.middleLabel.zc_size = CGSizeMake(middle_wid, 22);
        self.middleLabel.text = title;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)resetTitleView:(nullable UIView *)titleView leftView:(nullable UIView *)leftView rightView:(nullable UIView *)rightView {
    if (titleView) self.middleCustomView = titleView;
    if (titleView && ![titleView isDescendantOfView:self]) [self addSubview:titleView];
    if (leftView) self.leftCustomView = leftView;
    if (leftView && ![leftView isDescendantOfView:self]) [self addSubview:leftView];
    if (rightView) self.rightCustomView = rightView;
    if (rightView && ![rightView isDescendantOfView:self]) [self addSubview:rightView];
    [self bringSubviewToFront:self.lineShadowView];
    [self resetTitleFont:nil leftFont:nil rightFont:nil];
}

- (void)resetTitleFont:(UIFont *)titleFont leftFont:(UIFont *)leftFont rightFont:(UIFont *)rightFont { //重设置文本的字体，传入nil将不做更改，调用有可能会更改子视图布局
    if (titleFont) self.middleLabel.font = titleFont;
    if (leftFont) self.leftButton.titleLabel.font = leftFont;
    if (rightFont) self.rightButton.titleLabel.font = rightFont;
    UIImage *leftImage = [self.leftButton imageForState:UIControlStateNormal];
    NSString *leftTitle = [self.leftButton titleForState:UIControlStateNormal];
    NSString *title = self.middleLabel.text;
    UIImage *rightImage = [self.rightButton imageForState:UIControlStateNormal];
    NSString *rightTtitle = [self.rightButton titleForState:UIControlStateNormal];
    [self setTitle:title leftName:(leftTitle.length ? leftTitle : (NSString *)leftImage) rightName:(rightTtitle.length ? rightTtitle : (NSString *)rightImage)];
}

- (void)resetCushionImage:(UIImage *)cushionImage titleColor:(UIColor *)titleColor leftColor:(UIColor *)leftColor rightColor:(UIColor *)rightColor {
    if (cushionImage) { self.cushionView.image = cushionImage; self.cushionView.backgroundColor = kZCClear; }
    if (titleColor) self.middleLabel.textColor = titleColor;
    if (leftColor) { [self.leftButton setTitleColor:leftColor forState:UIControlStateNormal]; [self.leftButton setTitleColor:kZCA(leftColor, 0.3) forState:UIControlStateHighlighted]; }
    if (rightColor) { [self.rightButton setTitleColor:rightColor forState:UIControlStateNormal]; [self.rightButton setTitleColor:kZCA(rightColor, 0.3) forState:UIControlStateHighlighted]; }
}

#pragma mark - Override
- (void)layoutSubviews {
    [super layoutSubviews];
    UIView *leftVi = self.leftCustomView ? self.leftCustomView : self.leftButton;
    UIView *rightVi = self.rightCustomView ? self.rightCustomView : self.rightButton;
    UIView *middleVi = self.middleCustomView ? self.middleCustomView : self.middleLabel;
    
    leftVi.zc_origin = CGPointMake(12, kZSStuBarHei + (kZSNaviBarHei - leftVi.zc_height)/2.0);
    rightVi.zc_origin = CGPointMake(self.cushionView.zc_width - 14 - rightVi.zc_width, kZSStuBarHei + (kZSNaviBarHei - rightVi.zc_height)/2.0);
    CGFloat ital_left = self.cushionView.zc_width/2.0 - leftVi.zc_right - 5;
    CGFloat ital_right = rightVi.zc_left - self.cushionView.zc_width/2.0 - 5;
    CGFloat ival = MIN(ital_left, ital_right);
    CGFloat max_wid = ital_left + ital_right;
    
    middleVi.zc_top = kZSStuBarHei + (kZSNaviBarHei - middleVi.zc_height)/2.0;
    if (ival * 2.0 > middleVi.zc_width) { //居中
        middleVi.zc_centerX = self.cushionView.zc_width/2.0;
    } else if (max_wid > middleVi.zc_width + 16) { //右固定
        middleVi.zc_right = rightVi.zc_left - 5 - 8;
    } else {
        middleVi.zc_width = MIN(max_wid, middleVi.zc_width);
        middleVi.zc_centerX = leftVi.zc_right + 5 + max_wid/2.0;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        self.associate = newSuperview.currentViewController;
        if ([self.associate respondsToSelector:@selector(isPageHiddenNavigationBar)]) {
            if (![(id<ZCViewControllerPageBackProtocol>)self.associate isPageHiddenNavigationBar]) {
                NSAssert(0, @"ZCKit: this need manual completion");
            }
        } else if (self.associate.navigationController) {
            if (!self.associate.navigationController.navigationBarHidden || !self.associate.navigationController.navigationBar.hidden) {
                NSAssert(0, @"ZCKit: this need manual completion");
            }
        }
        if ([self.associate respondsToSelector:@selector(isNaviUseClearBar)]) {
            if ([(id<ZCViewControllerNaviBarProtocol>)self.associate isNaviUseClearBar]) {
                self.cushionView.image = nil;
                self.cushionView.backgroundColor = kZCClear;
                self.lineShadowView.backgroundColor = kZCClear;
            }
        }
        if ([self.associate respondsToSelector:@selector(isNaviUseBarBottomLine)]) {
            if (![(id<ZCViewControllerNaviBarProtocol>)self.associate isNaviUseBarBottomLine]) {
                self.lineShadowView.backgroundColor = kZCClear;
            }
        }
    } else {
        self.associate = nil;
    }
}

#pragma mark - Action
- (void)onLeftItem {
    if (self.leftBlock) {
        self.leftBlock();
    } else if (self.associate) {
        BOOL isCanBack = YES;
        if ([self.associate respondsToSelector:@selector(isPageCanResponseTouchPop)]) {
            isCanBack = [(id<ZCViewControllerPageBackProtocol>)self.associate isPageCanResponseTouchPop];
        }
        if (isCanBack) {
            main_imp(^{
                if ([self.associate respondsToSelector:@selector(onPageCustomTapBackAction)]) {
                    [(id<ZCViewControllerPageBackProtocol>)self.associate onPageCustomTapBackAction];
                } else {
                    [self.associate backToUpControllerAnimated:YES];
                }
            });
        }
    }
}

- (void)onRightItem {
    if (self.rightBlock) {
        self.rightBlock();
    }
}

@end
