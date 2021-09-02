//
//  ZCTableView.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCTableView.h"
#import "NSArray+ZC.h"
#import "UIView+ZC.h"
#import "ZCMacro.h"

#pragma mark - ~ ZCRowOperate ~
@interface ZCRowOperate ()

@property (nonatomic, copy) CGFloat(^heightForRowAtIndexPath)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model);

@property (nonatomic, copy) void(^cellForRowAtIndexPath)(ZCTableView *table, __kindof UITableViewCell *cell, NSIndexPath *idxp, id _Nullable model);

@property (nonatomic, copy) void(^willDisplayCell)(ZCTableView *table, __kindof UITableViewCell *cell, NSIndexPath *idxp, id _Nullable model);

@property (nonatomic, copy) void(^didSelectRowAtIndexPath)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model);

@property (nonatomic, copy) void(^didDeselectRowAtIndexPath)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model);

@end

@implementation ZCRowOperate

@synthesize identifier = _identifier;

- (instancetype)initWithIdentifier:(NSString *)identifier {
    if (self = [super init]) {
        _identifier = identifier;
    }
    return self;
}

- (instancetype)initWithModel:(nullable id)model {
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

- (ZCRowOperate *)injectInitialModel:(nullable id)model {
    _model = model; return self;
}

#pragma mark - Get
- (NSString *)identifier {
    if (!_identifier) {
        _identifier = @"cell";
    }
    return _identifier;
}

#pragma mark - Func
- (ZCRowOperate *)height:(nullable CGFloat(^)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model))block {
    self.heightForRowAtIndexPath = block; return self;
}

- (ZCRowOperate *)reprocess:(nullable void(^)(ZCTableView *table, __kindof UITableViewCell *cell, NSIndexPath *idxp, id _Nullable model))block {
    self.cellForRowAtIndexPath = block; return self;
}

- (ZCRowOperate *)display:(nullable void(^)(ZCTableView *table, __kindof UITableViewCell *cell, NSIndexPath *idxp, id _Nullable model))block {
    self.willDisplayCell = block; return self;
}

- (ZCRowOperate *)select:(nullable void(^)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model))block {
    self.didSelectRowAtIndexPath = block; return self;
}

- (ZCRowOperate *)deselect:(nullable void(^)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model))block {
    self.didDeselectRowAtIndexPath = block; return self;
}

@end


#pragma mark - ~ ZCSectionOperate ~
@interface ZCSectionOperate ()

@property (nonatomic, copy) CGFloat(^heightForHeaderInSection)(ZCTableView *table, NSInteger sect, id _Nullable model);

@property (nonatomic, copy) void(^viewForHeaderInSection)(ZCTableView *table, __kindof UITableViewHeaderFooterView *header, NSInteger sect, id _Nullable model);

@property (nonatomic, copy) void(^willDisplayHeaderView)(ZCTableView *table, UIView *header, NSInteger sect, id _Nullable model);

@property (nonatomic, copy) CGFloat(^heightForFooterInSection)(ZCTableView *table, NSInteger sect, id _Nullable model);

@property (nonatomic, copy) void(^viewForFooterInSection)(ZCTableView *table, __kindof UITableViewHeaderFooterView *footer, NSInteger sect, id _Nullable model);

@property (nonatomic, copy) void(^willDisplayFooterView)(ZCTableView *table, UIView *footer, NSInteger sect, id _Nullable model);

@property (nonatomic, copy) CGFloat(^shareCellHeight)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model);

@property (nonatomic, copy) void(^shareCellReprocess)(ZCTableView *table, __kindof UITableViewCell *cell, NSIndexPath *idxp, id _Nullable model);

@property (nonatomic, copy) void(^shareCellDisplay)(ZCTableView *table, __kindof UITableViewCell *cell, NSIndexPath *idxp, id _Nullable model);

@property (nonatomic, copy) void(^shareCellSelect)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model);

@property (nonatomic, copy) void(^shareCellDeselect)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model);

@end

@implementation ZCSectionOperate

@synthesize rows = _rows, header = _header, footer = _footer;
@synthesize headerIdentifier = _headerIdentifier, footerIdentifier = _footerIdentifier;

- (instancetype)initWithHeaderHei:(CGFloat)headerHei footerHei:(CGFloat)footerHei color:(UIColor *)color {
    if (self = [super init]) {
        [self buildHeaderView:headerHei color:color];
        [self buildFooterView:footerHei color:color];
    }
    return self;
}

- (instancetype)initWithHeaderIdent:(NSString *)headerIdent footerIdent:(NSString *)footerIdent {
    if (self = [super init]) {
        _headerIdentifier = headerIdent;
        _footerIdentifier = footerIdent;
    }
    return self;
}

- (instancetype)initWithModel:(nullable id)model {
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

- (ZCSectionOperate *)injectInitialModel:(nullable id)model {
    _model = model; return self;
}

#pragma mark - Misc
- (void)buildHeaderView:(CGFloat)hei color:(UIColor *)color {
    _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, hei)];
    _header.backgroundColor = color ? color : kZCClear;
}

- (void)buildFooterView:(CGFloat)hei color:(UIColor *)color {
    _footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, hei)];
    _footer.backgroundColor = color;
}

#pragma mark - Get
- (NSMutableArray <ZCRowOperate *>*)rows {
    if (!_rows) {
        _rows = [NSMutableArray array];
    }
    return _rows;
}

- (NSString *)headerIdentifier {
    if (!_headerIdentifier) {
        _headerIdentifier = @"header";
    }
    return _headerIdentifier;
}

- (NSString *)footerIdentifier {
    if (!_footerIdentifier) {
        _footerIdentifier = @"footer";
    }
    return _footerIdentifier;
}

#pragma mark - Func
- (ZCSectionOperate *)removeAllRows {
    if (self.rows.count) {
        [self.rows removeAllObjects];
    }
    return self;
}

- (ZCSectionOperate *)addRow:(ZCRowOperate *)row {
    if (row) {
        [self.rows addObject:row];
    }
    return self;
}

- (ZCSectionOperate *)removeRow:(ZCRowOperate *)row {
    if (row) {
        [self.rows removeObject:row];
    }
    return self;
}

- (ZCSectionOperate *)removeRowAtIndex:(NSUInteger)index {
    if (index >= 0 && index < self.rows.count) {
        [self.rows removeObjectAtIndex:index];
    }
    return self;
}

- (ZCSectionOperate *)addRows:(NSArray <ZCRowOperate *>*)rows {
    if (rows.count) {
        [self.rows addObjectsFromArray:rows];
    }
    return self;
}

- (ZCSectionOperate *)insertRows:(NSArray <ZCRowOperate *>*)rows atIndex:(NSUInteger)index {
    if (rows.count && index >= 0 && index <= self.rows.count) {
        [self.rows insertObjects:rows atIndex:index];
    }
    return self;
}

#pragma mark - Func
- (ZCSectionOperate *)headerHeight:(nullable CGFloat(^)(ZCTableView *table, NSInteger sect, id _Nullable model))block {
    self.heightForHeaderInSection = block; return self;
}

- (ZCSectionOperate *)headerReprocess:(nullable void(^)(ZCTableView *table, __kindof UITableViewHeaderFooterView *header, NSInteger sect, id _Nullable model))block {
    self.viewForHeaderInSection = block; return self;
}

- (ZCSectionOperate *)headerDisplay:(nullable void(^)(ZCTableView *table, UIView *header, NSInteger sect, id _Nullable model))block {
    self.willDisplayHeaderView = block; return self;
}

- (ZCSectionOperate *)footerHeight:(nullable CGFloat(^)(ZCTableView *table, NSInteger sect, id _Nullable model))block {
    self.heightForFooterInSection = block; return self;
}

- (ZCSectionOperate *)footerReprocess:(nullable void(^)(ZCTableView *table, __kindof UITableViewHeaderFooterView *footer, NSInteger sect, id _Nullable model))block {
    self.viewForFooterInSection = block; return self;
}

- (ZCSectionOperate *)footerDisplay:(nullable void(^)(ZCTableView *table, UIView *footer, NSInteger sect, id _Nullable model))block {
    self.willDisplayFooterView = block; return self;
}

- (ZCSectionOperate *)cellHeight:(nullable CGFloat(^)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model))block {
    self.shareCellHeight = block; return self;
}

- (ZCSectionOperate *)cellReprocess:(nullable void(^)(ZCTableView *table, __kindof UITableViewCell *cell, NSIndexPath *idxp, id _Nullable model))block {
    self.shareCellReprocess = block; return self;
}

- (ZCSectionOperate *)cellDisplay:(nullable void(^)(ZCTableView *table, __kindof UITableViewCell *cell, NSIndexPath *idxp, id _Nullable model))block {
    self.shareCellDisplay = block; return self;
}

- (ZCSectionOperate *)cellSelect:(nullable void(^)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model))block {
    self.shareCellSelect = block; return self;
}

- (ZCSectionOperate *)cellDeselect:(nullable void(^)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model))block {
    self.shareCellDeselect = block; return self;
}

@end


#pragma mark - ~ ZCTableView ~
@interface ZCTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) void(^didZoom1)(ZCTableView *table);

@property (nonatomic, copy) void(^didScroll1)(ZCTableView *table);

@property (nonatomic, copy) void(^didEndDrag1)(ZCTableView *table, BOOL decelerate);

@property (nonatomic, copy) void(^didEndDecelerate1)(ZCTableView *table);

@property (nonatomic, assign) BOOL isShieldResetZCCell;

@end

@implementation ZCTableView

@synthesize sections = _sections;

+ (ZCTableView *)initialTable:(CGRect)frame style:(UITableViewStyle)style reuses:(NSDictionary <NSString *, NSString *>*)reuses {
    BOOL isGroup = style == UITableViewStyleGrouped;
    ZCTableView *table = [[ZCTableView alloc] initWithFrame:frame style:style];
    table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, isGroup ? 0.01 : 0)];
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, isGroup ? 0.01 : 0)];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.estimatedSectionFooterHeight = 0;
    table.estimatedSectionHeaderHeight = 0;
    table.estimatedRowHeight = 100;
    table.sectionHeaderHeight = 0;
    table.sectionFooterHeight = 0;
    table.rowHeight = UITableViewAutomaticDimension;
    table.backgroundColor = kZCClear;
    table.showsHorizontalScrollIndicator = NO;
    table.separatorInset = UIEdgeInsetsZero;
    table.directionalLockEnabled = YES;
    table.bounces = YES;
    [reuses enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [table registerClass:NSClassFromString(obj) forCellReuseIdentifier:key];
    }];
    [table delegateAndDataSourceToSelf];
    return table;
}

+ (ZCTableView *)basicTable:(CGRect)frame cellClass:(Class)cellClass {
    return [self initialTable:frame style:UITableViewStyleGrouped reuses:@{@"cell":NSStringFromClass(cellClass)}];
}

+ (ZCTableView *)basicTableZCCell:(CGRect)frame resetCell:(BOOL)isResueAllowResetCell {
    ZCTableView *table = [self initialTable:frame style:UITableViewStyleGrouped reuses:@{@"cell":@"ZCTableViewCell"}];
    table.isShieldResetZCCell = !isResueAllowResetCell; return table;
}

#pragma mark - Misc
- (void)delegateAndDataSourceToSelf {
    if (self.delegate != self) self.delegate = self;
    if (self.dataSource != self) self.dataSource = self;
}

#pragma mark - Get
- (NSMutableArray <ZCSectionOperate *>*)sections {
    if (!_sections) {
        [self delegateAndDataSourceToSelf];
        _sections = [NSMutableArray array];
    }
    return _sections;
}

#pragma mark - Func
- (ZCTableView *)removeAllSections {
    if (self.sections.count) {
        [self.sections removeAllObjects];
    }
    return self;
}

- (ZCTableView *)addSection:(ZCSectionOperate *)section {
    if (section) {
        [self.sections addObject:section];
    }
    return self;
}

- (ZCTableView *)removeSection:(ZCSectionOperate *)section {
    if (section) {
        [self.sections removeObject:section];
    }
    return self;
}

- (ZCTableView *)removeSectionAtIndex:(NSUInteger)index {
    if (index >= 0 && index < self.sections.count) {
        [self.sections removeObjectAtIndex:index];
    }
    return self;
}

- (ZCTableView *)addSections:(NSArray <ZCSectionOperate *>*)sections {
    if (sections.count) {
        [self.sections addObjectsFromArray:sections];
    }
    return self;
}

- (ZCTableView *)insertSections:(NSArray <ZCSectionOperate *>*)sections atIndex:(NSUInteger)index {
    if (sections.count && index >= 0 && index <= self.sections.count) {
        [self.sections insertObjects:sections atIndex:index];
    }
    return self;
}

#pragma mark - Func
- (ZCTableView *)didScroll:(nullable void(^)(ZCTableView *table))block {
    [self delegateAndDataSourceToSelf];
    self.didScroll1 = block; return self;
}

- (ZCTableView *)didZoom:(nullable void(^)(ZCTableView *table))block {
    [self delegateAndDataSourceToSelf];
    self.didZoom1 = block; return self;
}

- (ZCTableView *)didEndDrag:(nullable void(^)(ZCTableView *table, BOOL decelerate))block {
    [self delegateAndDataSourceToSelf];
    self.didEndDrag1 = block; return self;
}

- (ZCTableView *)didEndDecelerate:(nullable void(^)(ZCTableView *table))block {
    [self delegateAndDataSourceToSelf];
    self.didEndDecelerate1 = block; return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self && _sections) {
        if (self.didScroll1) {
            self.didScroll1((ZCTableView *)scrollView);
        }
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView == self && _sections) {
        if (self.didZoom1) {
            self.didZoom1((ZCTableView *)scrollView);
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self && _sections) {
        if (self.didEndDrag1) {
            self.didEndDrag1((ZCTableView *)scrollView, decelerate);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self && _sections) {
        if (self.didEndDecelerate1) {
            self.didEndDecelerate1((ZCTableView *)scrollView);
        }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self && _sections) {
        ZCSectionOperate *slice = _sections[indexPath.section];
        ZCRowOperate *unit = slice.rows[indexPath.row];
        void(^share)(ZCTableView *, UITableViewCell *, NSIndexPath *, id _Nullable) = [slice valueForKey:@"shareCellDisplay"];
        if (share) {share((ZCTableView *)tableView, cell, indexPath, unit.model);}
        void(^block)(ZCTableView *, UITableViewCell *, NSIndexPath *, id _Nullable) = [unit valueForKey:@"willDisplayCell"];
        if (block) {block((ZCTableView *)tableView, cell, indexPath, unit.model);}
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self && _sections) {
        ZCSectionOperate *slice = _sections[indexPath.section];
        ZCRowOperate *unit = slice.rows[indexPath.row];
        CGFloat(^block)(ZCTableView *, NSIndexPath *, id _Nullable) = [unit valueForKey:@"heightForRowAtIndexPath"];
        if (block) {return block((ZCTableView *)tableView, indexPath, unit.model);}
        CGFloat(^share)(ZCTableView *, NSIndexPath *, id _Nullable) = [slice valueForKey:@"shareCellHeight"];
        if (share) {return share((ZCTableView *)tableView, indexPath, unit.model);}
    }
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self && _sections) {
        if (!tableView.allowsMultipleSelection) [tableView deselectRowAtIndexPath:indexPath animated:YES];
        ZCSectionOperate *slice = _sections[indexPath.section];
        ZCRowOperate *unit = slice.rows[indexPath.row];
        void(^share)(ZCTableView *, NSIndexPath *, id _Nullable) = [slice valueForKey:@"shareCellSelect"];
        if (share) {share((ZCTableView *)tableView, indexPath, unit.model);}
        void(^block)(ZCTableView *, NSIndexPath *, id _Nullable) = [unit valueForKey:@"didSelectRowAtIndexPath"];
        if (block) {block((ZCTableView *)tableView, indexPath, unit.model);}
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self && _sections) {
        ZCSectionOperate *slice = _sections[indexPath.section];
        ZCRowOperate *unit = slice.rows[indexPath.row];
        void(^share)(ZCTableView *, NSIndexPath *, id _Nullable) = [slice valueForKey:@"shareCellDeselect"];
        if (share) {share((ZCTableView *)tableView, indexPath, unit.model);}
        void(^block)(ZCTableView *, NSIndexPath *, id _Nullable) = [unit valueForKey:@"didDeselectRowAtIndexPath"];
        if (block) {block((ZCTableView *)tableView, indexPath, unit.model);}
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self && _sections) {
        ZCSectionOperate *slice = _sections[section];
        CGFloat(^block)(ZCTableView *, NSInteger, id _Nullable) = [slice valueForKey:@"heightForHeaderInSection"];
        if (block) {return block((ZCTableView *)tableView, section, slice.model);}
        if (slice.header) {return slice.header.zc_height;}
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self && _sections) {
        ZCSectionOperate *slice = _sections[section];
        void(^block)(ZCTableView *, UITableViewHeaderFooterView *, NSInteger, id _Nullable) = [slice valueForKey:@"viewForHeaderInSection"];
        if (block) {
            UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:slice.headerIdentifier];
            if (!header) header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:slice.headerIdentifier];
            block((ZCTableView *)tableView, header, section, slice.model);
            return header;
        }
        if (slice.header) {return slice.header;}
    }
    CGFloat hei = [self tableView:tableView heightForHeaderInSection:section];
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.zc_width, hei)];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (tableView == self && _sections) {
        ZCSectionOperate *slice = _sections[section];
        void(^block)(ZCTableView *, UIView *, NSInteger, id _Nullable) = [slice valueForKey:@"willDisplayHeaderView"];
        if (block) {block((ZCTableView *)tableView, view, section, slice.model);}
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self && _sections) {
        ZCSectionOperate *slice = _sections[section];
        CGFloat(^block)(ZCTableView *, NSInteger, id _Nullable) = [slice valueForKey:@"heightForFooterInSection"];
        if (block) {return block((ZCTableView *)tableView, section, slice.model);}
        if (slice.footer) {return slice.footer.zc_height;}
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self && _sections) {
        ZCSectionOperate *slice = _sections[section];
        void(^block)(ZCTableView *, UITableViewHeaderFooterView *, NSInteger, id _Nullable) = [slice valueForKey:@"viewForFooterInSection"];
        if (block) {
            UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:slice.footerIdentifier];
            if (!footer) footer = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:slice.footerIdentifier];
            block((ZCTableView *)tableView, footer, section, slice.model);
            return footer;
        }
        if (slice.footer) {return slice.footer;}
    }
    CGFloat hei = [self tableView:tableView heightForFooterInSection:section];
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.zc_width, hei)];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if (tableView == self && _sections) {
        ZCSectionOperate *slice = _sections[section];
        void(^block)(ZCTableView *, UIView *, NSInteger, id _Nullable) = [slice valueForKey:@"willDisplayFooterView"];
        if (block) {block((ZCTableView *)tableView, view, section, slice.model);}
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self && _sections) {
        return _sections.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self && _sections) {
        return _sections[section].rows.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self && _sections) {
        ZCSectionOperate *slice = _sections[indexPath.section];
        ZCRowOperate *unit = slice.rows[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:unit.identifier forIndexPath:indexPath];
        if ([cell isKindOfClass:[ZCTableViewCell class]]) {
            if (!self.isShieldResetZCCell) [((ZCTableViewCell *)cell) resetAllItemHiddenAndProperty];
            BOOL islast = indexPath.row == slice.rows.count - 1;
            ((ZCTableViewCell *)cell).topSeparatorInset = UIEdgeInsetsMake(0, 0, indexPath.row ? 0 : kZSPixel, 0);
            ((ZCTableViewCell *)cell).bottomSeparatorInset = UIEdgeInsetsMake(kZSPixel, islast ? 0 : kZSInvl, 0, 0);
        }
        void(^share)(ZCTableView *, UITableViewCell *, NSIndexPath *, id _Nullable) = [slice valueForKey:@"shareCellReprocess"];
        if (share) {share((ZCTableView *)tableView, cell, indexPath, unit.model);}
        void(^block)(ZCTableView *, UITableViewCell *, NSIndexPath *, id _Nullable) = [unit valueForKey:@"cellForRowAtIndexPath"];
        if (block) {block((ZCTableView *)tableView, cell, indexPath, unit.model);}
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"invalidCell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"invalidCell"];
    return cell;
}

@end
