//
//  ZCSheetControl.m
//  ZCKit
//
//  Created by admin on 2018/10/22.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCSheetControl.h"
#import "ZCMaskView.h"
#import "ZCLabel.h"
#import "ZCMacro.h"

static const CGFloat sheetEdgeTop = 7.0;
static const CGFloat sheetMsgHei  = 60.0;
static const CGFloat sheetItemHei = 47.0;
static const CGFloat sheetFlagTag = 83803;

@interface ZCSheetControl ()

@property (nonatomic, assign) BOOL isCanTouch;

@property (nonatomic, copy) NSString *msgText;

@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) NSMutableArray <NSString *>*items;

@property (nonatomic, copy) void(^sheetBlock)(NSInteger selectIndex);

@property (nonatomic, copy) void(^msgLabelCtor)(ZCLabel *msgLabel);

@property (nonatomic, copy) void(^itemBtnCtor)(ZCButton *itemBtn, NSInteger itemIndex, BOOL isCancelBtn);

@end

@implementation ZCSheetControl

+ (void)display:(NSString *)msg sheet:(NSArray<NSString *> *)sheet ctor:(void (^)(ZCSheetControl * _Nonnull))ctor action:(void (^)(NSInteger))action {
    [self display:msg sheet:sheet ctor:ctor labelCtor:nil buttonCtor:nil action:action];
}

+ (void)display:(NSString *)msg sheet:(NSArray<NSString *> *)sheet ctor:(void (^)(ZCSheetControl * _Nonnull))ctor
      labelCtor:(void (^)(ZCLabel * _Nonnull))labelCtor buttonCtor:(void (^)(ZCButton * _Nonnull, NSInteger, BOOL))buttonCtor action:(void (^)(NSInteger))action {
    ZCSheetControl *sheetControl = [[ZCSheetControl alloc] initWithMsg:msg sheets:sheet action:action labelCtor:labelCtor buttonCtor:buttonCtor];
    [sheetControl initProperty];
    if (ctor) ctor(sheetControl);
    [sheetControl resetItems];
    [sheetControl initialHei];
    [sheetControl showItems];
}

- (instancetype)initWithMsg:(NSString *)msg sheets:(NSArray <NSString *>*)sheets action:(void(^)(NSInteger selectIndex))action
                  labelCtor:(void (^)(ZCLabel * _Nonnull))labelCtor buttonCtor:(void (^)(ZCButton * _Nonnull, NSInteger, BOOL))buttonCtor {
    if (self = [super initWithFrame:CGRectZero]) {
        self.items = [NSMutableArray array];
        if (sheets.count) [self.items addObjectsFromArray:sheets];
        self.msgLabelCtor = labelCtor;
        self.itemBtnCtor = buttonCtor;
        self.sheetBlock = action;
        self.msgText = msg;
    }
    return self;
}

- (void)initProperty {
    self.isMaskHide = YES;
    self.isMaskClear = NO;
    self.isCanTouch = NO;
    self.dangerous = nil;
    self.cancelTitle = NSLocalizedString(@"Cancel", nil); //取消
    self.maxHeight = 383.0;
}

- (void)resetItems {
    if (self.cancelTitle.length) [self.items addObject:self.cancelTitle];
}

- (BOOL)isDangerousForIndex:(NSInteger)index {
    BOOL isDangerous = NO;
    if (self.dangerous && self.dangerous.count) {
        if (self.cancelTitle.length && (index == self.items.count - 1)) index = -1;
        for (NSNumber *num in self.dangerous) {
            if ([num integerValue] == index) {
                isDangerous = YES; break;
            }
        }
    }
    return isDangerous;
}

#pragma mark - Display
- (void)showItems {
    [ZCWindowView display:self time:0.25 blur:NO clear:self.isMaskClear action:(self.isMaskHide ? (^{[self disappearItems:-1];}) : nil)];
    self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, self.frame.size.height);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.isCanTouch = YES;
    }];
}

- (void)onItem:(ZCButton *)itemBtn {
    NSInteger selectIndex = itemBtn.tag - sheetFlagTag;
    if (self.cancelTitle.length && (selectIndex == self.items.count - 1)) selectIndex = -1;
    [self disappearItems:selectIndex];
}

- (void)disappearItems:(NSInteger)selectIndex {
    if (!self.isCanTouch) return;
    self.isCanTouch = NO;
    [ZCWindowView dismissSubview];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.contentView removeFromSuperview];
        if (self.sheetBlock) {self.sheetBlock(selectIndex); self.sheetBlock = nil;}
    }];
}

#pragma mark - Constructor
- (void)initialHei {
    BOOL messageExist = self.msgText.length ? YES : NO;
    BOOL cancelExist = self.cancelTitle.length ? YES : NO;
    BOOL itemIsOnly = (self.items.count == 1) ? YES : NO;
    BOOL itemIsZero = (self.items.count == 0) ? YES : NO;
    CGFloat conHei = 0.0;
    if (messageExist) {
        if (!itemIsOnly) {
            if (itemIsZero) {
                conHei = sheetMsgHei - sheetEdgeTop;
            } else {
                if (cancelExist) {
                    conHei = self.items.count * sheetItemHei + sheetMsgHei + sheetEdgeTop;
                } else {
                    conHei = self.items.count * sheetItemHei + sheetMsgHei;
                }
            }
        } else {
            conHei = self.items.count * sheetItemHei + sheetMsgHei;
        }
    } else {
        if (!itemIsOnly) {
            if (cancelExist) {
                conHei = self.items.count * sheetItemHei + sheetEdgeTop;
            } else {
                conHei = self.items.count * sheetItemHei;
            }
        } else {
            conHei = self.items.count * sheetItemHei;
        }
    }
    CGFloat safeHei = [ZCGlobal isiPhoneX] ? 24.0 : 0;
    CGFloat initHei = MIN(conHei + safeHei, self.maxHeight);
    [self build:messageExist cancel:cancelExist only:itemIsOnly safeHei:safeHei initHei:initHei conHei:conHei];
}

- (void)build:(BOOL)msgExist cancel:(BOOL)celExist only:(BOOL)isOnly safeHei:(CGFloat)safeHei initHei:(CGFloat)initHei conHei:(CGFloat)conHei {
    CGFloat initWid = kZSWid;
    self.backgroundColor = kZCPad;
    self.frame = CGRectMake(0, kZSHei - initHei, initWid, initHei);
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.contentView.backgroundColor = kZCClear;
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.delaysContentTouches = (conHei + safeHei > self.maxHeight);
    self.contentView.bounces = NO;
    [self addSubview:self.contentView];
    if (msgExist) {
        if (celExist) {
            self.contentView.frame = CGRectMake(0, sheetMsgHei, initWid, initHei - sheetMsgHei - sheetItemHei - sheetEdgeTop - safeHei);
            self.contentView.contentSize = CGSizeMake(initWid, conHei - sheetMsgHei - sheetItemHei - sheetEdgeTop);
        } else {
            self.contentView.frame = CGRectMake(0, sheetMsgHei, initWid, initHei - sheetMsgHei - safeHei);
            self.contentView.contentSize = CGSizeMake(initWid, conHei - sheetMsgHei);
        }
    } else {
        if (celExist) {
            self.contentView.frame = CGRectMake(0, 0, initWid, initHei - sheetItemHei - sheetEdgeTop - safeHei);
            self.contentView.contentSize = CGSizeMake(initWid, conHei - sheetItemHei - sheetEdgeTop);
        } else {
            self.contentView.frame = CGRectMake(0, 0, initWid, initHei - safeHei);
            self.contentView.contentSize = CGSizeMake(initWid, conHei);
        }
    }
    if (msgExist) {
        ZCLabel *msglabel = [[ZCLabel alloc] initWithFrame:CGRectMake(0, 0, initWid, sheetMsgHei - sheetEdgeTop)];
        msglabel.text = self.msgText;
        msglabel.numberOfLines = 0;
        msglabel.textColor = kZCBlack80;
        msglabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        msglabel.backgroundColor = kZCWhite;
        msglabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:msglabel];
        if (self.isMaskClear) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, initWid, kZSPixel)];
            line.backgroundColor = kZCBlackDC;
            [msglabel addSubview:line];
        }
        if (self.msgLabelCtor) {self.msgLabelCtor(msglabel); self.msgLabelCtor = nil;}
    }
    for (int i = 0; i < self.items.count; i ++) {
        BOOL isCancel = NO;
        UIView *topSep = nil;
        ZCButton *itemBtn = [ZCButton buttonWithType:UIButtonTypeCustom];
        itemBtn.delayResponseTime = 0.1;
        UIColor *titleColor = [self isDangerousForIndex:i] ? kZCRGB(0xFF0000) : kZCBlack;
        UIImage *imageBk = [UIImage imageWithColor:[UIColor colorFormHex:0xE1E1E3 alpha:1.0] size:CGSizeMake(1.0, 1.0)];
        itemBtn.tag = sheetFlagTag + i;
        itemBtn.backgroundColor = kZCWhite;
        itemBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        [itemBtn setTitle:self.items[i] forState:UIControlStateNormal];
        [itemBtn setTitleColor:titleColor forState:UIControlStateNormal];
        [itemBtn setTitleColor:[titleColor colorWithAlphaComponent:0.2] forState:UIControlStateHighlighted];
        [itemBtn setBackgroundImage:imageBk forState:UIControlStateHighlighted];
        [itemBtn addTarget:self action:@selector(onItem:) forControlEvents:UIControlEventTouchUpInside];
        if (isOnly && celExist) {
            itemBtn.frame = CGRectMake(0, initHei - sheetItemHei - safeHei, initWid, sheetItemHei + safeHei);
            isCancel = YES;
        } else if (isOnly) {
            itemBtn.frame = CGRectMake(0, i * sheetItemHei, initWid, sheetItemHei);
        } else {
            if (celExist && (i == self.items.count - 1)) {
                itemBtn.frame = CGRectMake(0, initHei - sheetItemHei - safeHei, initWid, sheetItemHei + safeHei);
                isCancel = YES;
            } else {
                itemBtn.frame = CGRectMake(0, i * sheetItemHei, initWid, sheetItemHei);
                if (i != 0 || (!msgExist && self.isMaskClear)) {
                    topSep = [[UIView alloc] initWithFrame:CGRectMake(0, i * sheetItemHei, initWid, kZSPixel)];
                    topSep.backgroundColor = kZCBlackDC;
                }
            }
        }
        if (isCancel) {
            itemBtn.titleEdgeInsets = UIEdgeInsetsMake(-safeHei, 0, 0, 0);
            itemBtn.responseAreaExtend = UIEdgeInsetsMake(0, 0, -safeHei, 0);
            if (isOnly && self.isMaskClear) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, initWid, kZSPixel)];
                line.backgroundColor = kZCBlackDC;
                [itemBtn addSubview:line];
            }
        }
        if (isCancel) [self addSubview:itemBtn];
        else [self.contentView addSubview:itemBtn];
        if (topSep) [self.contentView addSubview:topSep];
        
        if (self.itemBtnCtor) {self.itemBtnCtor(itemBtn, i, isCancel);}
    }
    if (self.itemBtnCtor) {self.itemBtnCtor = nil;}
}

@end
