//
//  UITableView+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (ZC)

/** 清除所有选择的行 */
- (void)clearSelectedRowsAnimated:(BOOL)animated;

/** 执行beginUpdates&endUpdates，block执行插入、删除、选择，不可在此里面执行reloadData */
- (void)updateWithBlock:(void (^)(UITableView *tableView))block;

- (void)insertRowInIndexPath:(nullable NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

- (void)reloadRowInIndexPath:(nullable NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

- (void)deleteRowInIndexPath:(nullable NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

- (void)insertSectionInIndex:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

- (void)deleteSectionInIndex:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

- (void)reloadSectionInIndex:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

@end

NS_ASSUME_NONNULL_END










