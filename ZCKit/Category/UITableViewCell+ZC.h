//
//  UITableViewCell+ZC.h
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (ZC)

@property (nullable, nonatomic, readonly) UIGestureRecognizer *longPressEventGesture;  /**< cell长按事件手势 */

@property (nullable, nonatomic, readonly) UITableView *currentTableView;  /**< 返回当前所在最近的tableView */

@end

NS_ASSUME_NONNULL_END
