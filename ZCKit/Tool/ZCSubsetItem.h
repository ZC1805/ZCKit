//
//  ZCSubsetItem.h
//  ZCKit
//
//  Created by admin on 2019/1/22.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZCEnumSubsetUnique) {
    ZCEnumSubsetUniqueZero  = 0,
    ZCEnumSubsetUniqueOne   = 1,
    ZCEnumSubsetUniqueTwo   = 2,
    ZCEnumSubsetUniqueThree = 3,
    ZCEnumSubsetUniqueFour  = 4,
    ZCEnumSubsetUniqueFive  = 5,
    ZCEnumSubsetUniqueSix   = 6,
    ZCEnumSubsetUniqueSeven = 7,
    ZCEnumSubsetUniqueEight = 8,
    ZCEnumSubsetUniqueNine  = 9,
};

#pragma mark - ~ ZCSubsetItem ~
@interface ZCSubsetItem : NSObject  /**< 管理请求状态对象 */

@property (nonatomic, copy, readonly) NSString *requestUrl;  /**< 请求url */

@property (nonatomic, strong, readonly) NSMutableDictionary *requestParam;  /**< 请求参数 */

@property (nonatomic, strong, readonly) NSMutableDictionary *attachInfo;  /**< 表视图显示的数组需手动维护添加或移除数据，懒加载 */

@property (nonatomic, strong, readonly) NSArray *dataItems;  /**< 表视图数组 */

@property (nonatomic, strong, readonly) NSMutableArray *displayItems;  /**< 表视图显示的数组需手动维护添加或移除数据，懒加载 */

@property (nullable, nonatomic, strong, readonly) UITableView *listView;  /**< 绑定表视图 */

@property (nonatomic, assign, readonly) ZCEnumSubsetUnique unique;  /**< 唯一标识 */

@property (nonatomic, assign, readonly) BOOL isAlreadyLoad;  /**< 是否请求过，初始NO */

@property (nonatomic, assign, readonly) BOOL isOnRequest;  /**< 是否请求中，初始NO */

@property (nullable, nonatomic, strong) UIView *blankView;  /**< 暂存绑定的透明视图，初始nil */

/**< 初始化方法，innate为固定请求参数 */
- (instancetype)initWithListView:(nullable UITableView *)listView url:(nullable NSString *)url innate:(nullable NSDictionary *)innate unique:(ZCEnumSubsetUnique)unique;

/**< 重置载入状态为未载入 */
- (void)resetLoadStateNo;

/**< 重置请求状态&载入状态&请求参数&请求数据(&请求Page相关&重置日期到当)&调用后最好及时刷新表视图 */
- (void)resetAllBasicData;

/**< 重置请求状态为请求中(&请求Page相关页数越界返回NO) */
- (BOOL)resetRequestStart:(BOOL)isRefresh;

/**< 重置请求状态&载入状态&请求参数(list没有传非nil表示请求成功)，isInsert为是否将数组数据顺序插入到最前面 */
- (void)resetRequestComplete:(BOOL)isRefresh list:(nullable NSArray *)list isInsert:(BOOL)isInsert isAddToLast:(BOOL)isAddToLast;

/**< 外部手动重置数据 */
- (void)resetManualDataItems:(nullable NSArray *)dataItems;

@end


#pragma mark - ~ ZCPageItem ~
@interface ZCPageItem : ZCSubsetItem  /**< 管理分页请求状态对象 */

@property (nonatomic, assign, readonly) NSInteger currentPage;  /**< 当前页，默认0 */

@property (nonatomic, assign, readonly) NSInteger totalPage;  /**< 总页数，默认1 */

/**< 重置请求状态&载入状态&请求参数(list没有传非nil表示请求成功&total没有传则传-1)，isInsert为是否将数组数据顺序插入到最前面，isAddToLast是否有数据且全合并到上页数据中 */
- (void)resetRequestComplete:(BOOL)isRefresh list:(nullable NSArray *)list isInsert:(BOOL)isInsert total:(NSInteger)total isAddToLast:(BOOL)isAddToLast;

@end


#pragma mark - ~ ZCPageDateItem ~
@interface ZCPageDateItem : ZCPageItem  /**< 管理按日期分页请求状态对象 */

@property (nonatomic, assign, readonly) NSInteger month;  /**< 当月 */

@property (nonatomic, assign, readonly) NSInteger year;  /**< 当年 */

@property (nonatomic, assign, readonly) NSInteger day;  /**< 当天 */

- (void)resetYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;  /**< 刷新数据 */

@end

NS_ASSUME_NONNULL_END
