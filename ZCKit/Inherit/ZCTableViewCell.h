//
//  ZCTableViewCell.h
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCAvatarControl.h"
#import "ZCTextField.h"
#import "ZCBadgeView.h"
#import "ZCSwitch.h"
#import "ZCButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCTableViewCell : UITableViewCell  /**< 通用表视图单元格 */

/** 布局是自动行高，代理可不返回行高 */
/** 属性需要改变，最好在initComplete赋值 */

@property (nonatomic, assign) NSInteger level;  /**< 当前水平层级，默认0 */

@property (nonatomic, assign) CGFloat horSpacing;  /**< 各子视图的水平间距，默认10 */

@property (nonatomic, assign) CGFloat verSpacing;  /**< 各子视图的竖直最小间距，默认10 */

@property (nonatomic, assign) CGFloat levelSpacing;  /**< 各层级间的水平缩进j距离，默认30 */

@property (nonatomic, assign) UIEdgeInsets marginInset;  /**< 上下左右各边缘间距，手动设置行高底部距离可能不对，默认(15, 15, 15, 15) */

@property (nonatomic, assign) UIEdgeInsets topSeparatorInset;  /**< 顶部分离器，上左高右(top, left, height, right)，默认Zero，隐藏 */

@property (nonatomic, assign) UIEdgeInsets bottomSeparatorInset;  /**< 低部分离器，高左下右(height, left, bottom, right)，默认Auto */

@property (nonatomic, strong) UIColor *separatorBKColor;  /**< 分离器颜色，默认ZCSPColor */

@property (nonatomic, assign) BOOL isAvatarBeCenter;  /**< avatarControl 是否垂直居中，默认NO */

@property (nullable, nonatomic, strong) UIColor *selectBKColor;  /**< 选中状态下的背景颜色，默认nil，即无选中风格 */

/** 子视图布局样式排列 */
/** --------------------------------------- separator ------------------------------------------- */
/** ⇠    ⇡        ⇡       ⇡      ⇡       ⇡     ⇡     ⇡       ⇡          ⇡         ⇡       ⇡    ⇢ */
/** ⇠ select - avatar - label - flag - field ~~~~~ label - switch - container - badge - access ⇢ */
/** ⇠    |                  ~~~~~              |                ~~~~~                      |   ⇢ */
/** ⇠ +onelevel - describe ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ container - badge ⇢ */
/** ⇠    ⇣        ⇣       ⇣      ⇣       ⇣     ⇣     ⇣       ⇣          ⇣         ⇣       ⇣    ⇢ */
/** --------------------------------------- separator ------------------------------------------- */

/** 以下子视图只有创建且不隐藏的时候，才会显示出来从而为其分配位置，有需要特定大小的需要设置size */
/** 以下子视图使用懒加载的模式，隐藏已经显示出来的子视图，可设置隐藏(此操作会重新布局，回收之前分配的位置)，或alpha改为0 */
/** 使用时候表视图需要先[tableView registerClass:forCellReuseIdentifier:] */
/** 取重用单元格时候使用[tableView dequeueReusableCellWithIdentifier:forIndexPath:] */
/** 表视图分割线风格设置[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] */
/** 表视图要设置自动行高[tableView setRowHeight:UITableViewAutomaticDimension] */
/** 表视图要设置估计行高[tableView setEstimatedRowHeight:100.0] */

@property (nonatomic, strong, readonly) ZCButton *selectButton;  /**< 可设置图片和点击事件，重设图片，默认size(20*20) */

@property (nonatomic, strong, readonly) ZCAvatarControl *avatarControl;  /**< 可设置图片和点击事件，默认size(40*40) */

@property (nonatomic, strong, readonly) UILabel *leadingLabel;  /**< 布局在Avatar后面，默认size是Auto */

@property (nonatomic, strong, readonly) UIView *flagView;  /**< 布局在leadingLabel后面，默认size是(20*20) */

@property (nonatomic, strong, readonly) ZCTextField *inputField;  /**< 布局在leadingLabel后面，默认size(160*30) */

@property (nonatomic, strong, readonly) ZCAvatarControl *accessControl;  /**< 可设置图片和点击事件，重设图片，默认size(6*12) */

@property (nonatomic, strong, readonly) ZCBadgeView *badgeView;  /**< 布局在Access前面，默认size是Auto */

@property (nonatomic, strong, readonly) UIView *containerView;  /**< 可在里面添加子视图，默认size(30*30) */

@property (nonatomic, strong, readonly) ZCSwitch *switchControl;  /**< 布局在Access前面，默认size是Auto */

@property (nonatomic, strong, readonly) UILabel *trailingLabel;  /**< 布局在Access前面，默认size是Auto */

@property (nonatomic, strong, readonly) UILabel *describeLabel;  /**< 前部偏移levelSpaceing，默认size是Auto */

@property (nonatomic, strong, readonly) ZCBadgeView *bottomBadgeView;  /**< 布局在trailingLabel下面，默认size是Auto */

@property (nonatomic, strong, readonly) UIView *bottomContainerView;  /**< 布局在trailingLabel下面，默认size(30*30) */


- (void)initComplete;  /**< 初始化完成，在此懒加载生成子视图，子类可重写此方法对不经常改变的属性赋值 */

- (void)resetConstraint;  /**< 重载约束布局，子视图重新设置 size & hidden & font 调用此方法刷新布局同时，必要时reloadCell */

@end

NS_ASSUME_NONNULL_END
