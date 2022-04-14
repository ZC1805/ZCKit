//
//  UITableView+ZXXXXX.h
//  ZCTest
//
//  Created by zjy on 2022/4/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (ZXXXXX)

@property (nullable, nonatomic, readonly) NSIndexPath *recentlyTouchIndexPath;  /**< 返回最近触摸的cell(或cell的子视图的响应)的indexPath */

@end

NS_ASSUME_NONNULL_END
