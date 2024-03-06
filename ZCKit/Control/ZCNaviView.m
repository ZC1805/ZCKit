//
//  ZCNaviView.m
//  ZCKit
//
//  Created by admin on 2018/10/23.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCNaviView.h"
#import "ZCNavigationController.h"
#import "ZCViewController.h"
#import "ZCQueueHandler.h"
#import "ZCImageView.h"
#import "ZCKitBridge.h"
#import "NSString+ZC.h"
#import "UIView+ZC.h"
#import "ZCButton.h"
#import "ZCLabel.h"
#import "ZCMacro.h"

@interface ZCNaviView ()

@property (nonatomic, strong) ZCButton *leftButton;

@property (nonatomic, strong) ZCLabel *middleLabel;

@property (nonatomic, strong) ZCButton *rightButton;

@property (nonatomic, strong) UIView *leftCustomView;

@property (nonatomic, strong) UIView *middleCustomView;

@property (nonatomic, strong) UIView *rightCustomView;

@property (nonatomic, strong, readonly) ZCImageView *cushionView; //背景视图，外部可设置颜色和透明度

@property (nonatomic, strong, readonly) ZCImageView *lineShadowView; //阴影线，外部可设置颜色和透明度

@property (nonatomic, weak) UIViewController *weakAssociate; //关联控制器

@property (nonatomic, copy) void(^rightBlock)(void);

@property (nonatomic, strong) UIImage *arrowImage;

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
    _cushionView = [[ZCImageView alloc] initWithFrame:self.bounds image:nil isInteract:YES isAspectFit:NO];
    _lineShadowView = [[ZCImageView alloc] initWithFrame:CGRectMake(0, _cushionView.zc_height - kZSPixel, _cushionView.zc_width, kZSPixel) image:nil isInteract:NO isAspectFit:NO];
    [_cushionView addSubview:_lineShadowView];
    [self addSubview:_cushionView];
    
    self.leftButton = [[ZCButton alloc] initWithTitle:nil font:[UIFont fontWithName:@"HelveticaNeue" size:15] color:nil image:nil bgColor:nil];
    self.leftButton.responseAreaExtend = UIEdgeInsetsMake(10, 10, 10, 10);
    self.leftButton.adjustsImageWhenHighlighted = YES;
    [self.leftButton addTarget:self action:@selector(onLeftItem) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftButton];
    
    self.rightButton = [[ZCButton alloc] initWithTitle:nil font:[UIFont fontWithName:@"HelveticaNeue" size:15] color:nil image:nil bgColor:nil];
    self.rightButton.responseAreaExtend = UIEdgeInsetsMake(10, 10, 10, 10);
    self.rightButton.adjustsImageWhenHighlighted = YES;
    [self.rightButton addTarget:self action:@selector(onRightItem) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rightButton];
    
    self.middleLabel = [[ZCLabel alloc] initWithColor:nil font:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17] alignment:NSTextAlignmentCenter adjustsSize:NO];
    self.middleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self addSubview:self.middleLabel];
    [self setTitle:nil rightName:nil rightColor:nil];
}

- (void)resetAssociate:(UIViewController *)associate {
    self.weakAssociate = associate;
    ZCViewControllerCustomPageSet *customPageSet = nil;
    if ([associate isKindOfClass:NSClassFromString(@"ZCViewController")]) {
        customPageSet = [associate valueForKey:@"customPageSet"];
        customPageSet.isPageHiddenNavigationBar = YES;
    } else {
        customPageSet = [[ZCViewControllerCustomPageSet alloc] init];
        NSAssert(0, @"ZCKit: need associate ZCViewController");
    }
    
    NSString *backName = ZCKitBridge.naviBarImageOrColor;
    if (customPageSet.naviUseCustomBackgroundName.length) backName = customPageSet.naviUseCustomBackgroundName;
    UIImage *backImage = [UIImage imageNamed:backName];
    if (!backImage) backImage = [UIImage imageWithColor:kZCS(backName)];
    
    UIImage *shadowImage = [UIImage imageWithColor:kZCSplit size:CGSizeMake(self.zc_width, kZSPixel)];
    if (customPageSet.isNaviUseShieldBarLine) shadowImage = [UIImage imageWithColor:kZCClear size:CGSizeMake(self.zc_width, kZSPixel)];
    
    UIColor *shadowColor = (!customPageSet.isNaviUseShieldBarLine && customPageSet.isNaviUseBarShadowColor) ? kZCSplit : kZCClear;
    CGFloat alpha = customPageSet.isNaviUseClearBar ? 0 : 1;
    
    UIColor *titleColor = kZCS(ZCKitBridge.naviBarTitleColor);
    if (customPageSet.naviUseCustomTitleColor.length) { titleColor = kZCS(customPageSet.naviUseCustomTitleColor); }
    
    self.arrowImage = ZCKitBridge.naviBackImage;
    if (customPageSet.naviUseCustomBackArrowImage) { self.arrowImage = customPageSet.naviUseCustomBackArrowImage; }
    
    [self resetCushionImage:backImage titleColor:titleColor rightColor:nil];
    [self setShadow:shadowColor offset:CGSizeZero radius:1];
    self.lineShadowView.image = shadowImage;
    self.cushionView.alpha = alpha;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - ClassFunc
+ (instancetype)viewWithAssociate:(UIViewController *)associate title:(nullable NSString *)title {
    return [self viewWithAssociate:associate title:title rightName:nil rightBlock:nil];
}

+ (instancetype)viewWithAssociate:(UIViewController *)associate title:(nullable NSString *)title rightName:(nullable NSString *)rightName rightBlock:(nullable void(^)(void))rightBlock {
    ZCNaviView *customView = [[ZCNaviView alloc] initWithFrame:CGRectMake(0, 0, kZSWid, kZSNaviHei)];
    customView.rightBlock = rightBlock;
    [customView resetAssociate:associate];
    [customView setTitle:title rightName:rightName rightColor:nil];
    return customView;
}

+ (instancetype)viewWithAssociate:(UIViewController *)associate title:(nullable NSString *)title rightView:(nullable UIView *)rightView {
    ZCNaviView *customView = [[ZCNaviView alloc] initWithFrame:CGRectMake(0, 0, kZSWid, kZSNaviHei)];
    customView.rightCustomView = rightView;
    [customView resetAssociate:associate];
    [customView setTitle:title rightName:nil rightColor:nil];
    return customView;
}

#pragma mark - ApiFunc
- (void)setTitle:(NSString *)title rightName:(NSString *)rightName rightColor:(nullable UIColor *)rightColor {
    id leftName = self.arrowImage;
    
    CGFloat left_wid = 0;
    if (self.leftCustomView) {
        self.leftButton.hidden = YES;
        if (self.leftCustomView.zc_width == 0) { left_wid = 10; }
        else { left_wid = self.leftCustomView.zc_width; }
        self.leftCustomView.zc_size = CGSizeMake(left_wid, self.leftCustomView.zc_height);
    } else {
        self.leftButton.hidden = NO;
        self.leftButton.userInteractionEnabled = NO;
        [self.leftButton setTitle:nil forState:UIControlStateNormal];
        [self.leftButton setImage:nil forState:UIControlStateNormal];
        [self.leftButton setImage:nil forState:UIControlStateHighlighted];
        [self.leftButton resetImageSize:CGSizeZero titleSize:CGSizeZero];
        if (leftName && [leftName isKindOfClass:NSString.class] && ((NSString *)leftName).length) {
            UIImage *leftImage = [UIImage imageNamed:leftName];
            if (leftImage) { leftName = (NSString *)leftImage; }
        }
        if (leftName && [leftName isKindOfClass:NSString.class] && ((NSString *)leftName).length) {
            self.leftButton.userInteractionEnabled = YES;
            left_wid = [leftName sizeFitLabelForFont:self.leftButton.titleLabel.font width:CGFLOAT_MAX alignment:self.leftButton.titleLabel.textAlignment spacing:0].width + 10;
            [self.leftButton setTitle:leftName forState:UIControlStateNormal];
        } else if (leftName && [leftName isKindOfClass:UIImage.class]) {
            self.leftButton.userInteractionEnabled = YES;
            left_wid = 22;
            [self.leftButton setImage:(UIImage *)leftName forState:UIControlStateNormal];
            [self.leftButton setImage:[(UIImage *)leftName imageWithAlpha:0.3] forState:UIControlStateHighlighted];
            [self.leftButton resetImageSize:CGSizeMake(22, 22) titleSize:CGSizeZero];
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
        [self.rightButton setTitle:nil forState:UIControlStateNormal];
        [self.rightButton setImage:nil forState:UIControlStateNormal];
        [self.rightButton setImage:nil forState:UIControlStateHighlighted];
        [self.rightButton resetImageSize:CGSizeZero titleSize:CGSizeZero];
        if (rightName && [rightName isKindOfClass:NSString.class] && rightName.length) {
            UIImage *rightImage = [UIImage imageNamed:rightName];
            if (rightImage) { rightName = (NSString *)rightImage; }
        }
        if (rightName && [rightName isKindOfClass:NSString.class] && rightName.length) {
            self.rightButton.userInteractionEnabled = YES;
            right_wid = [rightName sizeFitLabelForFont:self.rightButton.titleLabel.font width:CGFLOAT_MAX alignment:self.rightButton.titleLabel.textAlignment spacing:0].width + 10;
            [self.rightButton setTitle:rightName forState:UIControlStateNormal];
        } else if (rightName && [rightName isKindOfClass:UIImage.class]) {
            self.rightButton.userInteractionEnabled = YES;
            right_wid = 22;
            [self.rightButton setImage:(UIImage *)rightName forState:UIControlStateNormal];
            [self.rightButton setImage:[(UIImage *)rightName imageWithAlpha:0.3] forState:UIControlStateHighlighted];
            [self.rightButton resetImageSize:CGSizeMake(22, 22) titleSize:CGSizeZero];
        } else {
            right_wid = 10;
        } right_wid = MIN(right_wid, self.cushionView.zc_width - left_wid - 80);
        self.rightButton.zc_size = CGSizeMake(right_wid, 22);
    }
    if (rightColor) {
        [self.rightButton setTitleColor:rightColor forState:UIControlStateNormal];
        [self.rightButton setTitleColor:kZCA(rightColor, 0.3) forState:UIControlStateHighlighted];
    }
    
    CGFloat middle_wid = 0;
    if (self.middleCustomView) {
        self.middleLabel.hidden = YES;
        if (self.middleCustomView.zc_width == 0) { middle_wid = 10; }
        else { middle_wid = self.middleCustomView.zc_width; }
        self.middleCustomView.zc_size = CGSizeMake(middle_wid, self.middleCustomView.zc_height);
    } else {
        self.middleLabel.hidden = NO;
        if (title.length) { middle_wid = [title sizeFitLabelForFont:self.middleLabel.font width:CGFLOAT_MAX alignment:self.middleLabel.textAlignment spacing:0].width + 10; }
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
    
    NSString *title = self.middleLabel.text;
    UIImage *rightImage = [self.rightButton imageForState:UIControlStateNormal];
    NSString *rightTtitle = [self.rightButton titleForState:UIControlStateNormal];
    [self setTitle:title rightName:(rightTtitle.length ? rightTtitle : (NSString *)rightImage) rightColor:nil];
}

- (void)resetCushionImage:(UIImage *)cushionImage titleColor:(UIColor *)titleColor rightColor:(UIColor *)rightColor {
    if (cushionImage) { self.cushionView.image = cushionImage; }
    if (titleColor) self.middleLabel.textColor = titleColor;
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

#pragma mark - Action
- (void)onLeftItem {
    if (self.weakAssociate) {
        main_imp(^{
            if ([self.weakAssociate respondsToSelector:@selector(onPageCustomTapBackAction)]) {
                [(id<ZCViewControllerPageBackProtocol>)self.weakAssociate onPageCustomTapBackAction];
            } else if (!self.weakAssociate.presentedViewController && self.weakAssociate.navigationController) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ZCViewControllerWillBeTouchPopNotification object:self.weakAssociate];
                [self.weakAssociate.navigationController popViewControllerAnimated:YES];
            } else {
                NSAssert(0, @"ZCKit: left btn auto back fail");
            }
        });
    }
}

- (void)onRightItem {
    if (self.rightBlock) {
        self.rightBlock();
    }
}

@end
