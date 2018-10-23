//
//  ZCSheetControl.m
//  ZCKit
//
//  Created by admin on 2018/10/22.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCSheetControl.h"
#import "ZCMaskView.h"
#import "UIImage+ZC.h"
#import "UIColor+ZC.h"
#import "ZCButton.h"
#import "ZCGlobal.h"

#define sheet_cal_top   7.0
#define sheet_msg_hei   60.0
#define sheet_item_hei  47.0
#define sheet_flag_tag  83803

@interface ZCSheetControl ()

@property (nonatomic, assign) BOOL canTouch;

@property (nonatomic, copy  ) NSString *msgText;

@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) NSMutableArray <NSString *>*items;

@property (nonatomic, copy  ) void(^sheetBlock)(NSInteger selectIndex);

@end

@implementation ZCSheetControl

+ (void)display:(NSString *)msg sheet:(NSArray<NSString *> *)sheet ctor:(void (^)(ZCSheetControl * _Nonnull))ctor action:(void (^)(NSInteger))action {
    ZCSheetControl *sheetControl = [[ZCSheetControl alloc] initWithMsg:msg sheets:sheet action:action];
    [sheetControl initProperty];
    if (ctor) ctor(sheetControl);
    [sheetControl resetItems];
    [sheetControl initialHei];
    [sheetControl showItems];
}

- (instancetype)initWithMsg:(NSString *)msg sheets:(NSArray <NSString *>*)sheets action:(void(^)(NSInteger selectIndex))action {
    if (self = [super initWithFrame:CGRectZero]) {
        self.items = [NSMutableArray array];
        if (sheets.count) [self.items addObjectsFromArray:sheets];
        self.sheetBlock = action;
        self.msgText = msg;
    }
    return self;
}

- (void)initProperty {
    self.maskHide = YES;
    self.maskClear = NO;
    self.canTouch = NO;
    self.dangerous = nil;
    self.cancelTitle = @"取消";
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
    [ZCWindowView display:self time:0.3 blur:NO clear:self.maskClear action:(self.maskHide ? (^{[self disappearItems:-1];}) : nil)];
    self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, self.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.canTouch = YES;
    }];
}

- (void)onItem:(UIButton *)itemBtn {
    NSInteger selectIndex = itemBtn.tag - sheet_flag_tag;
    if (self.cancelTitle.length && (selectIndex == self.items.count - 1)) selectIndex = -1;
    [self disappearItems:selectIndex];
}

- (void)disappearItems:(NSInteger)selectIndex {
    if (!self.canTouch) return;
    self.canTouch = NO;
    [ZCWindowView dismissSubview];
    [UIView animateWithDuration:0.3 animations:^{
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
                conHei = sheet_msg_hei - sheet_cal_top;
            } else {
                if (cancelExist) {
                    conHei = self.items.count * sheet_item_hei + sheet_msg_hei + sheet_cal_top;
                } else {
                    conHei = self.items.count * sheet_item_hei + sheet_msg_hei;
                }
            }
        } else {
            conHei = self.items.count * sheet_item_hei + sheet_msg_hei;
        }
    } else {
        if (!itemIsOnly) {
            if (cancelExist) {
                conHei = self.items.count * sheet_item_hei + sheet_cal_top;
            } else {
                conHei = self.items.count * sheet_item_hei;
            }
        } else {
            conHei = self.items.count * sheet_item_hei;
        }
    }
    CGFloat safeHei = [ZCGlobal isiPhoneX] ? 24.0 : 0;
    CGFloat initHei = MIN(conHei + safeHei, self.maxHeight);
    [self build:messageExist cancel:cancelExist only:itemIsOnly safeHei:safeHei initHei:initHei conHei:conHei];
}

- (void)build:(BOOL)msgExist cancel:(BOOL)celExist only:(BOOL)isOnly safeHei:(CGFloat)safeHei initHei:(CGFloat)initHei conHei:(CGFloat)conHei {
    CGFloat initWid = [UIScreen mainScreen].bounds.size.width;
    self.backgroundColor = [UIColor colorFormHex:0xf5f5f7 alpha:1.0];
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - initHei, initWid, initHei);
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.delaysContentTouches = (conHei + safeHei > self.maxHeight);
    self.contentView.bounces = NO;
    [self addSubview:self.contentView];
    if (msgExist) {
        if (celExist) {
            self.contentView.frame = CGRectMake(0, sheet_msg_hei, initWid, initHei - sheet_msg_hei - sheet_item_hei - sheet_cal_top - safeHei);
            self.contentView.contentSize = CGSizeMake(initWid, conHei - sheet_msg_hei - sheet_item_hei - sheet_cal_top);
        } else {
            self.contentView.frame = CGRectMake(0, sheet_msg_hei, initWid, initHei - sheet_msg_hei - safeHei);
            self.contentView.contentSize = CGSizeMake(initWid, conHei - sheet_msg_hei);
        }
    } else {
        if (celExist) {
            self.contentView.frame = CGRectMake(0, 0, initWid, initHei - sheet_item_hei - sheet_cal_top - safeHei);
            self.contentView.contentSize = CGSizeMake(initWid, conHei - sheet_item_hei - sheet_cal_top);
        } else {
            self.contentView.frame = CGRectMake(0, 0, initWid, initHei - safeHei);
            self.contentView.contentSize = CGSizeMake(initWid, conHei);
        }
    }
    if (msgExist) {
        UILabel *msglabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, initWid, sheet_msg_hei - sheet_cal_top)];
        msglabel.text = self.msgText;
        msglabel.numberOfLines = 0;
        msglabel.textColor = [UIColor colorFormHex:0x808080 alpha:1.0];
        msglabel.font = [UIFont systemFontOfSize:13];
        msglabel.backgroundColor = [UIColor whiteColor];
        msglabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:msglabel];
        if (self.maskClear) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, initWid, 1.0 / [UIScreen mainScreen].scale)];
            line.backgroundColor = [UIColor colorFormHex:0xdcdcdc alpha:1.0];
            [msglabel addSubview:line];
        }
    }
    for (int i = 0; i < self.items.count; i ++) {
        BOOL isCancel = NO;
        UIView *topSep = nil;
        ZCButton *itemBtn = [ZCButton buttonWithType:UIButtonTypeCustom];
        itemBtn.delayResponseTime = 0.1;
        UIColor *titleColor = [self isDangerousForIndex:i] ? [UIColor redColor] : [UIColor blackColor];
        UIImage *imageBk = [UIImage imageWithColor:[UIColor colorFormHex:0xe1e1e3 alpha:1.0] size:CGSizeMake(1.0, 1.0)];
        itemBtn.tag = sheet_flag_tag + i;
        itemBtn.backgroundColor = [UIColor whiteColor];
        itemBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [itemBtn setTitle:self.items[i] forState:UIControlStateNormal];
        [itemBtn setTitleColor:titleColor forState:UIControlStateNormal];
        [itemBtn setTitleColor:[titleColor colorWithAlphaComponent:0.2] forState:UIControlStateHighlighted];
        [itemBtn setBackgroundImage:imageBk forState:UIControlStateHighlighted];
        [itemBtn addTarget:self action:@selector(onItem:) forControlEvents:UIControlEventTouchUpInside];
        if (isOnly && celExist) {
            itemBtn.frame = CGRectMake(0, initHei - sheet_item_hei - safeHei, initWid, sheet_item_hei + safeHei);
            isCancel = YES;
        } else if (isOnly) {
            itemBtn.frame = CGRectMake(0, i * sheet_item_hei, initWid, sheet_item_hei);
        } else {
            if (celExist && (i == self.items.count - 1)) {
                itemBtn.frame = CGRectMake(0, initHei - sheet_item_hei - safeHei, initWid, sheet_item_hei + safeHei);
                isCancel = YES;
            } else {
                itemBtn.frame = CGRectMake(0, i * sheet_item_hei, initWid, sheet_item_hei);
                if (i != 0 || (!msgExist && self.maskClear)) {
                    topSep = [[UIView alloc] initWithFrame:CGRectMake(0, i * sheet_item_hei, initWid, 1.0 / [UIScreen mainScreen].scale)];
                    topSep.backgroundColor = [UIColor colorFormHex:0xdcdcdc alpha:1.0];
                }
            }
        }
        if (isCancel) {
            itemBtn.titleEdgeInsets = UIEdgeInsetsMake(-safeHei, 0, 0, 0);
            itemBtn.responseAreaExtend = UIEdgeInsetsMake(0, 0, -safeHei, 0);
            if (isOnly && self.maskClear) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, initWid, 1.0 / [UIScreen mainScreen].scale)];
                line.backgroundColor = [UIColor colorFormHex:0xdcdcdc alpha:1.0];
                [itemBtn addSubview:line];
            }
        }
        if (isCancel) [self addSubview:itemBtn];
        else [self.contentView addSubview:itemBtn];
        if (topSep) [self.contentView addSubview:topSep];
    }
}

@end
