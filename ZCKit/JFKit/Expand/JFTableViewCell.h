//
//  JFTableViewCell.h
//  gobe
//
//  Created by zjy on 2019/3/16.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *topSepLineView;  /**< 懒加载 */

@property (nonatomic, strong) UIView *bottomSepLineView;  /**< 懒加载 */

@end

NS_ASSUME_NONNULL_END
