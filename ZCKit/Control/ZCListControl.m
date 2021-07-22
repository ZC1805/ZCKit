//
//  ZCListControl.m
//  ZCKit
//
//  Created by admin on 2018/10/22.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCListControl.h"
#import "ZCTableViewCell.h"
#import "NSDictionary+ZC.h"
#import "NSArray+ZC.h"
#import "ZCMaskView.h"
#import "UIView+ZC.h"
#import "ZCButton.h"
#import "ZCLabel.h"
#import "ZCMacro.h"

@interface ZCListControl () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL isCanTouch;

@property (nonatomic, strong) NSArray <NSDictionary *>*items;

@property (nonatomic, copy) void(^cellResueBlock)(__kindof UITableViewCell *cell, NSIndexPath *idxp, NSDictionary *item);

@property (nonatomic, copy) void(^cellClickBlock)(NSInteger selectIdex, NSDictionary *selectItem);

@end

@implementation ZCListControl

+ (void)display:(NSArray<NSDictionary *> *)items title:(NSString *)title message:(NSString *)message
           ctor:(void (^)(ZCListControl * _Nonnull))ctor
       cellCtor:(void (^)(__kindof UITableViewCell * _Nonnull, NSIndexPath * _Nonnull, NSDictionary * _Nonnull))cellCtor
         action:(void (^)(NSInteger, NSDictionary * _Nullable))action {
    if (!items.count) {NSAssert(0, @"ZCKit: items is empty"); return;}
    ZCListControl *listControl = [[ZCListControl alloc] initWithFrame:CGRectZero];
    [listControl initProperty:items];
    listControl.cellResueBlock = cellCtor;
    listControl.cellClickBlock = action;
    if (ctor) ctor(listControl);
    [listControl title:title message:message];
    [listControl displayItems];
}

- (void)initProperty:(NSArray<NSDictionary *> *)items {
    self.rowHei = 0;
    self.items = items;
    self.isCanTouch = NO;
    self.isMaskHide = YES;
    self.isMaskClear = NO;
    self.isUseTopCorner = NO;
    self.minContentHei = 100;
    self.maxContentHei = 400;
    self.cellResueBlock = nil;
    self.cellClickBlock = nil;
    self.isShowCloseButton = NO;
    self.sectionIndexTitleKey = nil;
}

#pragma mark - Display
- (void)displayItems {
    [ZCWindowView display:self time:0.25 blur:NO clear:self.isMaskClear action:(self.isMaskHide ? (^{[self disappearItems:-1];}) : nil)];
    self.zc_top = ZSHei;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.zc_top = ZSHei - self.zc_height;
    } completion:^(BOOL finished) {
        self.isCanTouch = YES;
    }];
}

- (void)disappearItems:(NSInteger)selectIndex {
    if (!self.isCanTouch) return;
    self.isCanTouch = NO;
    [ZCWindowView dismissSubview];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.zc_top = ZSHei;
    } completion:^(BOOL finished) {
        NSDictionary *item = [self.items objectOrNilAtIndex:selectIndex];
        if (self.cellClickBlock) {self.cellClickBlock(selectIndex, item);};
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self initProperty:nil];
    }];
}

#pragma mark - Build
- (void)title:(NSString *)title message:(NSString *)message {
    self.frame = CGRectMake(0, 0, ZSWid, ZSHei);
    self.backgroundColor = ZCWhite;
    CGFloat headerHei = 18;
    ZCLabel *titleLabel = nil; ZCLabel *messageLabel = nil;
    if (self.isUseTopCorner) {
        UIView *corView = [[UIView alloc] initWithFrame:CGRectMake(0, -8, self.zc_width, 16)];
        corView.backgroundColor = self.backgroundColor;
        [corView setCorner:corView.zc_height/2.0 color:nil width:0];
        [self addSubview:corView];
        headerHei = headerHei - corView.zc_height/2.0;
    }
    if (title.length) {
        titleLabel = [[ZCLabel alloc] initWithColor:ZCBlack30 font:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16] alignment:NSTextAlignmentCenter adjustsSize:NO];
        titleLabel.frame = CGRectMake(15, headerHei, self.zc_width - 30, 0);
        titleLabel.numberOfLines = 0; titleLabel.lineSpace = 3; titleLabel.text = title;
        [titleLabel minToSize];
        [self addSubview:titleLabel];
        headerHei = titleLabel.zc_bottom;
    }
    if (message.length) {
        if (title.length) headerHei = headerHei + 5;
        messageLabel = [[ZCLabel alloc] initWithColor:ZCBlackA8 font:[UIFont fontWithName:@"HelveticaNeue" size:13] alignment:NSTextAlignmentCenter adjustsSize:NO];
        messageLabel.frame = CGRectMake(15, headerHei, self.zc_width - 30, 0);
        messageLabel.numberOfLines = 0; messageLabel.lineSpace = 3; messageLabel.text = message;
        [messageLabel minToSize];
        [self addSubview:messageLabel];
        headerHei = messageLabel.zc_bottom;
    }
    headerHei = headerHei + 18;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headerHei, self.zc_width, ZSSepHei)];
    line.backgroundColor = ZCSPColor;
    [self addSubview:line];
    
    if (self.isShowCloseButton) {
        CGFloat top = MIN((self.isUseTopCorner ? 5 : 12), (headerHei - 30)/2.0 - (self.isUseTopCorner ? 4 : 0));
        ZCButton *closeBtn = [ZCButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(self.zc_width - 45, top, 30, 30);
        closeBtn.responseAreaExtend = UIEdgeInsetsMake(4, 4, 4, 4);
        [closeBtn setImage:[ZCGlobal ZCImageName:@"zc_image_common_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
    }
    
    UITableView *listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    listView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    listView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    listView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, ZSBomSafeHei)];
    listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listView.estimatedSectionFooterHeight = 0;
    listView.estimatedSectionHeaderHeight = 0;
    listView.estimatedRowHeight = UITableViewAutomaticDimension;
    listView.sectionHeaderHeight = 0;
    listView.sectionFooterHeight = 0;
    listView.rowHeight = UITableViewAutomaticDimension;
    listView.showsHorizontalScrollIndicator = NO;
    listView.showsVerticalScrollIndicator = YES;
    listView.separatorInset = UIEdgeInsetsZero;
    listView.backgroundColor = ZCClear;
    listView.sectionIndexColor = ZCBlack30;
    listView.directionalLockEnabled = YES;
    listView.dataSource = self;
    listView.delegate = self;
    listView.bounces = YES;
    listView.frame = CGRectMake(0, line.zc_bottom, self.zc_width, 1000); //这里要设置大些
    [listView registerClass:(self.rowHei == 0 ? ZCTableViewCell.class : UITableViewCell.class) forCellReuseIdentifier:@"listCellx"];
    [self addSubview:listView];
    [listView reloadData];
    [listView reloadSectionIndexTitles];
    [listView setNeedsLayout];
    [listView layoutIfNeeded];
    
    CGFloat contentHei = listView.contentSize.height;
    if (contentHei > self.maxContentHei + ZSBomSafeHei) {
        contentHei = self.maxContentHei + ZSBomSafeHei;
    }
    if (contentHei < self.minContentHei + ZSBomSafeHei) {
        contentHei = self.minContentHei + ZSBomSafeHei;
    }
    self.zc_height = line.zc_bottom + contentHei;
    listView.zc_height = contentHei;
    [listView reloadData];
    [listView reloadSectionIndexTitles];
    [listView setNeedsLayout];
    [listView layoutIfNeeded];
}

#pragma mark - Action
- (void)onClose {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self disappearItems:-1];
    });
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.rowHei == 0) return UITableViewAutomaticDimension;
    return self.rowHei;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCellx" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds color:ZCWhite];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds color:ZCSPColor];
    NSDictionary *item = [self.items dictionaryValueForIndex:indexPath.row];
    if (cell && self.cellResueBlock) {self.cellResueBlock(cell, indexPath, item);}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self disappearItems:indexPath.row];
    });
}

- (nullable NSArray <NSString *>*)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.sectionIndexTitleKey.length) {
        NSMutableArray *titles = [NSMutableArray array];
        for (NSDictionary *item in self.items) {
            NSString *title = [item stringValueForKey:self.sectionIndexTitleKey];
            unichar firstChar = '#';
            if (title.length > 0) {
                firstChar = [title characterAtIndex:0];
                if (firstChar < 'A' || firstChar > 'Z') firstChar = '#';
            }
            NSString *firstStr = [NSString stringWithFormat:@"%c", firstChar];
            if (![titles containsObject:firstStr]) [titles addObject:firstStr];
        }
        return titles;
    }
    return nil;
}

@end
