//
//  UIView+ZXXXXX.h
//  ZCTest
//
//  Created by zjy on 2022/4/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZXXXXX)

@property (nullable, nonatomic, readonly) UITableViewCell *currentCell;  /**< 返回当前所在最近的cell */

@property (nullable, nonatomic, readonly) NSIndexPath *currentCellIndexPath;  /**< 返回当前cell显示时的indexPath */

@end

NS_ASSUME_NONNULL_END
