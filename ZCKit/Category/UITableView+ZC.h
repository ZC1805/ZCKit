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

@property (nonatomic, readonly) CGFloat bottomGroupStyleHei;  /**< groupe类型底部默认偏移高度 */

@property (nullable, nonatomic, readonly) UIGestureRecognizer *panEventGesture;  /**< 表视图的点击手势 */

@property (nullable, nonatomic, readonly) NSIndexPath *recentlyTouchIndexPath;  /**< 返回最近触摸的cell(或cell的子视图的响应)的indexPath */

- (void)clearSelectedRowsAnimated:(BOOL)animated;  /**< 清除所有选择的行 */

- (void)updateWithBlock:(void(^)(UITableView *tableView))block;  /**< 执行beginUpdates & endUpdates，block执行插入、删除、选择，block不可执行reloadData */

@end

NS_ASSUME_NONNULL_END

