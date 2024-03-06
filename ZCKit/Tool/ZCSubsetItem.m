//
//  ZCSubsetItem.m
//  ZCKit
//
//  Created by admin on 2019/1/22.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import "ZCSubsetItem.h"
#import "NSDate+ZC.h"
#import "ZCMacro.h"

#pragma mark - ~ ZCSubsetItem ~
@interface ZCSubsetItem ()

@property (nonatomic, strong) NSDictionary *innate;

@end

@implementation ZCSubsetItem

@synthesize displayItems = _displayItems, attachInfo = _attachInfo;

- (instancetype)initWithListView:(UITableView *)listView url:(NSString *)url innate:(NSDictionary *)innate unique:(ZCEnumSubsetUnique)unique {
    if (self = [super init]) {
        _unique = unique;
        _innate = innate;
        _isOnRequest = NO;
        _isAlreadyLoad = NO;
        _listView = listView;
        _requestUrl = kZStrNonnil(url);
        _dataItems = [NSMutableArray array];
        _requestParam = [NSMutableDictionary dictionary];
        if (_innate && _innate.count) [_requestParam addEntriesFromDictionary:_innate];
    }
    return self;
}

- (NSMutableArray *)displayItems {
    if (!_displayItems) {
        _displayItems = [NSMutableArray array];
    }
    return _displayItems;
}

- (NSMutableDictionary *)attachInfo {
    if (!_attachInfo) {
        _attachInfo = [NSMutableDictionary dictionary];
    }
    return _attachInfo;
}

- (void)resetAllBasicData {
    _isOnRequest = NO;
    _isAlreadyLoad = NO;
    [(NSMutableArray *)_dataItems removeAllObjects];
    [_requestParam removeAllObjects];
    if (_innate && _innate.count) [_requestParam addEntriesFromDictionary:_innate];
}

- (void)resetLoadStateNo {
    _isAlreadyLoad = NO;
}

- (BOOL)resetRequestStart:(BOOL)isRefresh {
    _isOnRequest = YES;
    return YES;
}

- (void)resetRequestComplete:(BOOL)isRefresh list:(NSArray *)list isInsert:(BOOL)isInsert isAddToLast:(BOOL)isAddToLast {
    _isOnRequest = NO;
    _isAlreadyLoad = YES;
    [_requestParam removeAllObjects];
    if (_innate && _innate.count) [_requestParam addEntriesFromDictionary:_innate];
    //刷新时候list不为nil则移除数据刷新，即如果list返回你来则表示请求数据失败&不做处理
    if (isAddToLast) list = @[];
    if (isRefresh && list) [(NSMutableArray *)_dataItems removeAllObjects];
    if (list.count) {
        if (isInsert) {
            NSUInteger iidx = 0; for (id item in list) { [(NSMutableArray *)_dataItems insertObject:item atIndex:iidx++]; }
        } else {
            [(NSMutableArray *)_dataItems addObjectsFromArray:list];
        }
    }
}

- (void)resetManualDataItems:(NSArray *)dataItems {
    [(NSMutableArray *)_dataItems removeAllObjects];
    if (dataItems && dataItems.count) [(NSMutableArray *)_dataItems addObjectsFromArray:dataItems];
}

@end


#pragma mark - ~ ZCPageItem ~
@interface ZCPageItem ()

@property (nonatomic, assign) NSInteger lastPage;

@end

@implementation ZCPageItem

- (instancetype)initWithListView:(UITableView *)listView url:(NSString *)url innate:(NSDictionary *)innate unique:(ZCEnumSubsetUnique)unique {
    if (self = [super initWithListView:listView url:url innate:innate unique:unique]) {
        [self resetPage];
    }
    return self;
}

- (void)resetPage {
    _lastPage = _currentPage;
    _totalPage = 1;
    _currentPage = 0;
}

- (void)resetAllBasicData {
    [super resetAllBasicData];
    [self resetPage];
}

- (BOOL)resetRequestStart:(BOOL)isRefresh {
    BOOL isAllow = [super resetRequestStart:isRefresh];
    if (isRefresh) [self resetPage];
    if (_totalPage < 0) {_totalPage = 0;}
    if (_currentPage < 0) {_currentPage = 0;}
    if (_currentPage < _totalPage) {_currentPage = _currentPage + 1;}
    else {_currentPage = _totalPage + 1; isAllow = NO;}
    return isAllow;
}

- (void)resetRequestComplete:(BOOL)isRefresh list:(NSArray *)list isInsert:(BOOL)isInsert total:(NSInteger)total isAddToLast:(BOOL)isAddToLast {
    [super resetRequestComplete:isRefresh list:list isInsert:isInsert isAddToLast:isAddToLast];
    //1.list为nil、count为0分别表示请求失败、没数据，页数需要重置到上一页
    //2.isAddToLast为YES可能是请求到数据但是此数据全追加到上页数据的末尾数组中了
    if (isAddToLast) list = @[];
    if (isRefresh && !list) _currentPage = _lastPage; //刷新失败重置到刷新前的页码
    else if (!list || (!list.count && !isAddToLast)) _currentPage = _currentPage - 1;
    if (list && total >= 0) _totalPage = total; //list不为nil且total不小于0则会重置总页数total
}

@end


#pragma mark - ~ ZCPageDateItem ~
@implementation ZCPageDateItem

- (instancetype)initWithListView:(UITableView *)listView url:(NSString *)url innate:(NSDictionary *)innate unique:(ZCEnumSubsetUnique)unique {
    if (self = [super initWithListView:listView url:url innate:innate unique:unique]) {
        [self resetYear:NSDate.date.year month:NSDate.date.month day:NSDate.date.day];
    }
    return self;
}

- (void)resetYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    _day = day;
    _year = year;
    _month = month;
}

- (void)resetAllBasicData {
    [super resetAllBasicData];
    [self resetYear:NSDate.date.year month:NSDate.date.month day:NSDate.date.day];
}

@end
