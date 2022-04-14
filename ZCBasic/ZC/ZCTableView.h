//
//  ZCTableView.h
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class ZCTableView;

#pragma mark - ~ ZCRowOperate ~
@interface ZCRowOperate : NSObject  /**< row相关操作 */

@property (nullable, nonatomic, strong, readonly) id model;  /**< 保存的模型数据 */

@property (nonatomic, copy, readonly) NSString *identifier;  /**< 当前cell的重用标识，默认@"cell" */

- (instancetype)initWithIdentifier:(NSString *)identifier;  /**< 此初始化方法cell的identifier */

- (instancetype)initWithModel:(nullable id)model;  /**< 按初始化模型数据来初始化 */

- (ZCRowOperate *)injectInitialModel:(nullable id)model;  /**< 重新注初始化模型数据 */

/** 返回cell行高 */
- (ZCRowOperate *)height:(nullable CGFloat(^)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model))block;

/** 重用cell时进行视图和数据的重新配置 */
- (ZCRowOperate *)reprocess:(nullable void(^)(ZCTableView *table, __kindof UITableViewCell *cell, NSIndexPath *idxp, id _Nullable model))block;

/** 将要显示cell时候调用 */
- (ZCRowOperate *)display:(nullable void(^)(ZCTableView *table, __kindof UITableViewCell *cell, NSIndexPath *idxp, id _Nullable model))block;

/** 点击cell的时候调用 */
- (ZCRowOperate *)select:(nullable void(^)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model))block;

/** 取消cell选中时候调用 */
- (ZCRowOperate *)deselect:(nullable void(^)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model))block;

@end


#pragma mark - ~ ZCSectionOperate ~
@interface ZCSectionOperate : NSObject  /**< section相关操作 */

@property (nullable, nonatomic, strong, readonly) id model;  /**< 保存的模型数据 */

@property (nonatomic, strong, readonly) NSMutableArray <ZCRowOperate *>*rows;  /**< 添加或者移除最后都要调用reloadData */

@property (nonatomic, copy, readonly) NSString *headerIdentifier;  /**< 使用block设置头部视图时的重用标识，默认@"header" */

@property (nonatomic, copy, readonly) NSString *footerIdentifier;  /**< 使用block设置尾部视图时的重用标识，默认@"footer" */

@property (nullable, nonatomic, strong, readonly) UIView *header;  /**< 不使用下面block时将用此作为分区头部视图，且不会重用 */

@property (nullable, nonatomic, strong, readonly) UIView *footer;  /**< 不使用下面block时将用此作为分区尾部视图，且不会重用 */

/** 此初始化方法将以此高度初始化header&footer */
- (instancetype)initWithHeaderHei:(CGFloat)headerHei footerHei:(CGFloat)footerHei color:(nullable UIColor *)color;

/** 此初始化方法将设置头部和尾部视图的identifier */
- (instancetype)initWithHeaderIdent:(NSString *)headerIdent footerIdent:(NSString *)footerIdent;

/** 按初始化模型数据来初始化 */
- (instancetype)initWithModel:(nullable id)model;

/** 注入初始化的模型数据 */
- (ZCSectionOperate *)injectInitialModel:(nullable id)model;

/** 向当前self.rows中移除row */
- (ZCSectionOperate *)removeAllRows;

/** 向当前self.rows中添加row */
- (ZCSectionOperate *)addRow:(ZCRowOperate *)row;

/** 向当前self.rows中移除row */
- (ZCSectionOperate *)removeRow:(ZCRowOperate *)row;

/** 向当前self.rows中移除row */
- (ZCSectionOperate *)removeRowAtIndex:(NSUInteger)index;

/** 向当前self.rows中添加row */
- (ZCSectionOperate *)addRows:(NSArray <ZCRowOperate *>*)rows;

/** 向当前self.rows中插入row */
- (ZCSectionOperate *)insertRows:(NSArray <ZCRowOperate *>*)rows atIndex:(NSUInteger)index;

/** 分区头的高度，设置此将不会使用self.header.height当做分区头高度 */
- (ZCSectionOperate *)headerHeight:(nullable CGFloat(^)(ZCTableView *table, NSInteger sect, id _Nullable model))block;

/** 重用分区头时进行视图和数据的重新配置，设置此将不会使用self.header当做分区头 */
- (ZCSectionOperate *)headerReprocess:(nullable void(^)(ZCTableView *table, __kindof UITableViewHeaderFooterView *header, NSInteger sect, id _Nullable model))block;

/** 将要显示分区头时调用 */
- (ZCSectionOperate *)headerDisplay:(nullable void(^)(ZCTableView *table, UIView *header, NSInteger sect, id _Nullable model))block;

/** 分区尾的高度，设置此将不会使用self.footer.height当做分区尾高度 */
- (ZCSectionOperate *)footerHeight:(nullable CGFloat(^)(ZCTableView *table, NSInteger sect, id _Nullable model))block;

/** 重用分区尾时进行视图和数据的重新配置，设置此将不会使用self.footer当做分区尾 */
- (ZCSectionOperate *)footerReprocess:(nullable void(^)(ZCTableView *table, __kindof UITableViewHeaderFooterView *footer, NSInteger sect, id _Nullable model))block;

/** 将要显示分区尾时调用 */
- (ZCSectionOperate *)footerDisplay:(nullable void(^)(ZCTableView *table, UIView *footer, NSInteger sect, id _Nullable model))block;

/** 分区内cell的行高 */
- (ZCSectionOperate *)cellHeight:(nullable CGFloat(^)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model))block;

/** 分区内cell重用时进行视图和数据的重新配置 */
- (ZCSectionOperate *)cellReprocess:(nullable void(^)(ZCTableView *table, __kindof UITableViewCell *cell, NSIndexPath *idxp, id _Nullable model))block;

/** 分区内cell将要显示时候调用 */
- (ZCSectionOperate *)cellDisplay:(nullable void(^)(ZCTableView *table, __kindof UITableViewCell *cell, NSIndexPath *idxp, id _Nullable model))block;

/** 分区内cell点击的时候调用 */
- (ZCSectionOperate *)cellSelect:(nullable void(^)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model))block;

/** 分区内cell取消选中时候调用 */
- (ZCSectionOperate *)cellDeselect:(nullable void(^)(ZCTableView *table, NSIndexPath *idxp, id _Nullable model))block;

@end


#pragma mark - ~ ZCTableView ~
@interface ZCTableView : UITableView  /**< block控制代理，默认代理为self */

/** 以下方法将会设置delegate和datasource为self，添加或者移除最后都要调用reloadData */
@property (nonatomic, strong, readonly) NSMutableArray <ZCSectionOperate *>*sections;

/** 返回一个标准配置的ZCTableView，其中register的key为cell的重用identifier，value为cell的类名字符串 */
+ (ZCTableView *)initialTable:(CGRect)frame style:(UITableViewStyle)style reuses:(NSDictionary <NSString *, NSString *>*)reuses;

/** 返回一个标准配置的ZCTableView，style为UITableViewStyleGrouped，cell为ZCTableViewCell, isResueAllowResetCell是否自动重置cell属性 */
+ (ZCTableView *)basicTableZCCell:(CGRect)frame resetCell:(BOOL)isResueAllowResetCell;

/** 返回一个标准配置的ZCTableView，style为UITableViewStyleGrouped，并且注册cellClass的重用identifier为@"cell" */
+ (ZCTableView *)basicTable:(CGRect)frame cellClass:(Class)cellClass;

/** 向当前self.sections中移除section */
- (ZCTableView *)removeAllSections;

/** 向当前self.sections中添加section */
- (ZCTableView *)addSection:(ZCSectionOperate *)section;

/** 向当前self.sections中移除section */
- (ZCTableView *)removeSection:(ZCSectionOperate *)section;

/** 向当前self.sections中移除section */
- (ZCTableView *)removeSectionAtIndex:(NSUInteger)index;

/** 向当前self.sections中添加section */
- (ZCTableView *)addSections:(NSArray <ZCSectionOperate *>*)sections;

/** 向当前self.sections中插入section */
- (ZCTableView *)insertSections:(NSArray <ZCSectionOperate *>*)sections atIndex:(NSUInteger)index;

/** 移动时候回调 */
- (ZCTableView *)didScroll:(nullable void(^)(ZCTableView *table))block;

/** 缩放时候回调 */
- (ZCTableView *)didZoom:(nullable void(^)(ZCTableView *table))block;

/** 拖动结束时候回调 */
- (ZCTableView *)didEndDrag:(nullable void(^)(ZCTableView *table, BOOL decelerate))block;

/** 减速结束时候回调 */
- (ZCTableView *)didEndDecelerate:(nullable void(^)(ZCTableView *table))block;

@end

NS_ASSUME_NONNULL_END
