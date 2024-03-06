//
//  ZCMenuControl.m
//  ZCKit
//
//  Created by admin on 2018/10/29.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCMenuControl.h"
#import "ZCScrollView.h"
#import "ZCMaskView.h"
#import "UIView+ZC.h"
#import "ZCButton.h"
#import "ZCMacro.h"

@interface ZCMenuControl ()

@property (nonatomic, assign) BOOL isCanTouch;

@property (nonatomic, assign) CGFloat initWid;

@property (nonatomic, assign) CGPoint initVertex;

@property (nonatomic, strong) ZCScrollView *contentView;

@property (nonatomic, strong) NSMutableArray <NSString *>*items;

@property (nonatomic, copy) void(^menuBlock)(NSInteger selectIndex);

@end

@implementation ZCMenuControl

+ (void)display:(NSArray <NSString *>*)menus width:(CGFloat)width vertex:(CGPoint)vertex
            set:(void(^)(ZCMenuControl *menuControl))set
         btnSet:(void(^)(NSInteger index, ZCButton *btn, UIView *line))btnSet
          click:(void(^)(NSInteger selectIndex))click {
    ZCMenuControl *menuControl = [[ZCMenuControl alloc] initWithMenus:menus width:(CGFloat)width vertex:vertex click:click];
    [menuControl initProperty];
    if (set) set(menuControl);
    [menuControl showItems:[menuControl initialUI:btnSet]];
}

- (instancetype)initWithMenus:(NSArray <NSString *>*)menus width:(CGFloat)width vertex:(CGPoint)vertex click:(void(^)(NSInteger selectIndex))click {
    if (self = [super initWithFrame:CGRectZero]) {
        self.items = [NSMutableArray array];
        if (menus.count) [self.items addObjectsFromArray:menus];
        self.initVertex = vertex;
        self.menuBlock = click;
        self.initWid = MAX(width, 10);
    }
    return self;
}

- (void)initProperty {
    self.isShowShadow = NO;
    self.isMaskHide = YES;
    self.isMaskClear = YES;
    self.isCanTouch = NO;
    self.fillColor = kZCWhite;
    self.maxLine = 7;
    self.rowHeight = 47.0;
    self.topHeight = 5.0;
    self.initArrowRect = CGRectMake(self.initWid * 2.0 / 3.0, 0, 13.0, 8.0);
}

#pragma mark - Display
- (void)showItems:(BOOL)isInBottom {
    [ZCWindowView display:self time:0.25 blur:NO clear:self.isMaskClear action:(self.isMaskHide ? (^{ [self disappearItems:-1]; }) : nil)];
    if (self.initArrowRect.size.height > 0) {
        CGFloat acScale = (self.initArrowRect.origin.x + self.initArrowRect.size.width / 2.0) / self.zc_width;
        if (isInBottom) {
            self.layer.opacity = 0;
            self.layer.anchorPoint = CGPointMake(acScale, 1);
            self.layer.position = CGPointMake(self.zc_left + self.zc_width * (acScale * 2.0 - 0.5), self.zc_top + self.zc_height * 1.5);
            self.layer.transform = CATransform3DScale(CATransform3DIdentity, 0, 0, 1);
        } else {
            self.layer.opacity = 0;
            self.layer.anchorPoint = CGPointMake(acScale, 0);
            self.layer.position = CGPointMake(self.zc_left + self.zc_width * (acScale * 2.0 - 0.5), self.zc_top - self.zc_height * 0.5);
            self.layer.transform = CATransform3DScale(CATransform3DIdentity, 0, 0, 1);
        }
    } else {
        if (isInBottom) {
            self.layer.opacity = 0;
            self.layer.anchorPoint = CGPointMake(0.5, 1);
            self.layer.position = CGPointMake(self.zc_left + self.zc_width / 2.0, self.zc_top + self.zc_height * 1.5);
            self.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 0, 1);
        } else {
            self.layer.opacity = 0;
            self.layer.anchorPoint = CGPointMake(0.5, 0);
            self.layer.position = CGPointMake(self.zc_left + self.zc_width / 2.0, self.zc_top - self.zc_height * 0.5);
            self.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 0, 1);
        }
    }
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.layer.opacity = 1;
        self.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        self.isCanTouch = YES;
    }];
}

- (void)onItem:(ZCButton *)itemBtn {
    NSInteger selectIndex = itemBtn.tag - 73203;
    [self disappearItems:selectIndex];
}

- (void)disappearItems:(NSInteger)selectIndex {
    if (!self.isCanTouch) return;
    self.isCanTouch = NO;
    [ZCWindowView dismissSubview];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.contentView removeFromSuperview];
        if (self.menuBlock) { self.menuBlock(selectIndex); self.menuBlock = nil; }
    }];
}

#pragma mark - Build
- (BOOL)initialUI:(void(^)(NSInteger index, ZCButton *btn, UIView *line))btnSet {
    self.backgroundColor = kZCClear;
    if (CGRectEqualToRect(self.initArrowRect, CGRectZero)) { self.initArrowRect = CGRectMake(self.initWid / 2.0, 0, 0, 0); }
    CGFloat initHei = MIN(self.items.count * self.rowHeight, self.maxLine * self.rowHeight);
    self.zc_size = CGSizeMake(self.initWid, initHei + 2.0 * self.topHeight + self.initArrowRect.size.height);
    BOOL isInBottom = self.initVertex.y + self.zc_height > kZSHei - kZSBomSafeHei;
    self.zc_origin = CGPointMake(self.initVertex.x - self.initArrowRect.origin.x - self.initArrowRect.size.width / 2.0,
                                 self.initVertex.y - (isInBottom ? self.zc_height : 0));
    [self initialBKlayer:isInBottom];

#warning - 设置iOS11不能不偏移顶部20像素
    self.contentView = [[ZCScrollView alloc] initWithFrame:CGRectZero color:nil];
    self.contentView.backgroundColor = kZCClear;
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.bounces = NO;
    self.contentView.delaysContentTouches = (self.items.count > self.maxLine);
    self.contentView.frame = CGRectMake(0, self.topHeight + (isInBottom ? 0 : self.initArrowRect.size.height), self.initWid, initHei);
    self.contentView.contentSize = CGSizeMake(self.initWid, self.items.count * self.rowHeight);
    [self addSubview:self.contentView];

    for (int i = 0; i < self.items.count; i ++) {
        UIView *topSep = nil;
        ZCButton *itemBtn = [[ZCButton alloc] initWithFrame:CGRectZero color:kZCWhite];
        UIColor *titleColor = kZCBlack;
        itemBtn.tag = 73203 + i;
        itemBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        [itemBtn setTitle:self.items[i] forState:UIControlStateNormal];
        [itemBtn setTitleColor:titleColor forState:UIControlStateNormal];
        [itemBtn setTitleColor:kZCA(titleColor, 0.25) forState:UIControlStateHighlighted];
        [itemBtn addTarget:self action:@selector(onItem:) forControlEvents:UIControlEventTouchUpInside];
        itemBtn.frame = CGRectMake(0, i * self.rowHeight, self.initWid, self.rowHeight);
        if (i != 0) topSep = [[UIView alloc] initWithFrame:CGRectMake(0, i * self.rowHeight, self.initWid, 0.35)];
        if (topSep) topSep.backgroundColor = kZCBlackDE;
        [self.contentView addSubview:itemBtn];
        if (topSep) [self.contentView addSubview:topSep];
        if (btnSet) btnSet(i, itemBtn, topSep);
    }
    return isInBottom;
}

- (void)initialBKlayer:(BOOL)isInBottom {
    CGSize size = self.initArrowRect.size;
    CGPoint origin = self.initArrowRect.origin;
    CGRect rect = CGRectMake(0, (isInBottom ? 0 : size.height), self.zc_width, self.zc_height - size.height);
    UIBezierPath *bkPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:6.0];
    [bkPath moveToPoint:CGPointMake(origin.x, (isInBottom ? rect.size.height : size.height))];
    [bkPath addLineToPoint:CGPointMake(origin.x + size.width / 2.0, (isInBottom ? self.zc_height : 0))];
    [bkPath addLineToPoint:CGPointMake(origin.x + size.width, (isInBottom ? rect.size.height : size.height))];
    [bkPath closePath];
    CAShapeLayer *bkLayer = [CAShapeLayer layer];
    bkLayer.path = bkPath.CGPath;
    bkLayer.fillColor = self.fillColor.CGColor;
    bkLayer.strokeColor = kZCClear.CGColor;
    bkLayer.lineWidth = 0.35;
    bkLayer.lineJoin = @"round";
    bkLayer.shadowColor = kZCBlackDE.CGColor;
    bkLayer.shadowOffset = CGSizeMake(0, 0);
    bkLayer.shadowRadius = 7.0;
    bkLayer.shadowOpacity = self.isShowShadow ? 1.0 : 0;
    [self.layer addSublayer:bkLayer];
}

@end
