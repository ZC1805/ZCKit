//
//  ZCTableViewCell.h
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCAvatarControl.h"
#import "ZCBadgeView.h"
#import "ZCTextField.h"
#import "ZCTextView.h"
#import "ZCSwitch.h"
#import "ZCButton.h"
#import "ZCLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCTableViewCell : UITableViewCell  /**< 通用表视图单元格，自动计算行高 */

/** cell布局是自动行高，所以代理不需要返回行高，如属性需要改变，最好在子类initComplete赋值 */
@property (nonatomic, assign) NSInteger level;  /**< 当前水平层级，默认0 */

@property (nonatomic, assign) CGFloat levelSpacing;  /**< 各层级间的水平缩进距离，默认ZSA(30) */

@property (nonatomic, assign) CGFloat verticalSpacing;  /**< 各子视图的竖直最小间距，默认ZSA(3) */

@property (nonatomic, assign) CGFloat horizontalSpacing;  /**< 各子视图的水平间距，默认ZSA(10) */

@property (nonatomic, assign) UIEdgeInsets marginInset;  /**< 边缘间距，手动设置行高底部距离可能不对，默认(ZSMInvl...ZSMInvl) */

@property (nonatomic, assign) UIEdgeInsets topSeparatorInset;  /**< 顶部分离器，上左高右(top, left, height, right)，默认Zero，隐藏 */

@property (nonatomic, assign) UIEdgeInsets bottomSeparatorInset;  /**< 低部分离器，高左下右(height, left, bottom, right)，默认Auto */

@property (nonatomic, assign) UIEdgeInsets insideMargin;  /**< 内侧背景视图距离外侧位置，默认Zero */

@property (nonatomic, assign) CGFloat bottomClickOffsetY;  /**< 底部点击按钮，与当前底部向下的偏移量，居中，默认0，即不偏移 */

@property (nonatomic, assign) BOOL isSelectAvatarBeCenter;  /**< avatarControl和selectButton是否是垂直居中，行高不会计算它，默认NO */

@property (nonatomic, assign) BOOL isLeadingBeCenter;  /**< leadingLabel是否是垂直居中，自动行高不会拿leadingLabel计算最大高，默认NO */

@property (nonatomic, assign) BOOL isAccessBeCenter;  /**< accessControl是否是垂直居中，自动行高不会拿accessControl计算最大高，默认NO */

@property (nullable, nonatomic, strong) UIColor *separatorBKColor;  /**< 分离器颜色，默认ZCSPColor */

@property (nullable, nonatomic, strong) UIColor *insideBKColor;  /**< 内侧背景视图颜色，默认ZCSPColor */

@property (nullable, nonatomic, strong) UIColor *selectBKColor;  /**< 选中状态下的背景颜色，默认nil，即无选中风格 */


/** 子视图布局样式排列 */
/** ---------------------------------------------- separator --------------------------------------------------------- */
/** ⇠    ⇡        ⇡       ⇡      ⇡       ⇡     ⇡        ⇡           ⇡         ⇡        ⇡       ⇡        ⇡        ⇡        ⇡        ⇡        ⇢ */
/** ⇠ select - avatar - label - flag - field ~~~~~ label/field - container - click - switch - badge - access ⇢ */
/** ⇠    |                                               |                                                  |                                                   ⇢ */
/** ⇠ +1level - describe/text - flag - field ~~~~~ ~~~~~~ ~~~~~~ ~~  label - container - click - badge ⇢ */
/** ⇠    ⇣            ⇣                        ⇣                             ⇣         ⇣         ⇣        ⇣         ⇣        ⇣          ⇣         ⇢ */
/** ---------------------------------------------- separator --------------------------------------------------------- */

/** 以下子视图只有创建且不隐藏的时候，才会显示出来从而为其分配位置，有需要特定大小的需要设置size */
/** 以下子视图使用懒加载的模式，隐藏已经显示出来的子视图，可设置隐藏(此操作会重新布局，回收之前分配的位置)，或alpha改为0 */
/** 使用时候表视图需要先[tableView registerClass:forCellReuseIdentifier:] */
/** 取重用单元格时候使用[tableView dequeueReusableCellWithIdentifier:forIndexPath:] */
/** 表视图分割线风格设置[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone] */
/** 表视图要设置自动行高[tableView setRowHeight:UITableViewAutomaticDimension] */
/** 表视图要设置估计行高[tableView setEstimatedRowHeight:50] */

/** 以下子视图懒加载形式创建，可设置隐藏来回收为其分配的位置，auto可设置fixSize来改变视图大小，非auto可设置size来改变视图大小 */
@property (nonatomic, strong, readonly) ZCButton *selectButton;  /**< 默认size(ZSA(20)*ZSA(20)) */

@property (nonatomic, strong, readonly) ZCAvatarControl *avatarControl;  /**< 默认size(ZSA(40)*ZSA(40)) */

@property (nonatomic, strong, readonly) ZCLabel *leadingLabel;  /**< 默认size是auto */

@property (nonatomic, strong, readonly) UIView *flagContainerView;  /**< 默认size(ZSA(20)*ZSA(20)) */

@property (nonatomic, strong, readonly) ZCTextField *inputTextField;  /**< 默认size(ZSA(160)*ZSA(30)) */

@property (nonatomic, strong, readonly) ZCAvatarControl *accessControl;  /**< 默认size(ZSA(6)*ZSA(12)) */

@property (nonatomic, strong, readonly) ZCBadgeView *badgeView;  /**< fixSize无效，默认size是auto */

@property (nonatomic, strong, readonly) ZCSwitch *switchControl;  /**< fixSize无效，默认size是auto */

@property (nonatomic, strong, readonly) ZCButton *clickButton;  /**< 默认size(ZSA(30)*ZSA(30)) */

@property (nonatomic, strong, readonly) UIView *containerView;  /**< 默认size(ZSA(30)*ZSA(30)) */

@property (nonatomic, strong, readonly) ZCTextField *fitTextField;  /**< 第一行主，会布局满行，fixSize无效，默认size是auto */

@property (nonatomic, strong, readonly) ZCLabel *trailingLabel;  /**< 第一行主，不同时显示fitTextField，默认size是auto */

@property (nonatomic, strong, readonly) ZCLabel *bottomDescLabel;  /**< 不同时显示bottomTextView，默认size是auto */

@property (nonatomic, strong, readonly) ZCTextView *bottomTextView;  /**< 会布局满行，默认size是auto */

@property (nonatomic, strong, readonly) UIView *bottomFlagContainerView;  /**< 默认size(ZSA(20)*ZSA(20)) */

@property (nonatomic, strong, readonly) ZCTextField *bottomTextField;  /**< 默认size(ZSA(160)*ZSA(30)) */

@property (nonatomic, strong, readonly) ZCLabel *bottomAttachLabel;  /**< 第二行主，默认size是auto */

@property (nonatomic, strong, readonly) UIView *bottomContainerView;  /**< 默认size(ZSA(30)*ZSA(30)) */

@property (nonatomic, strong, readonly) ZCButton *bottomClickButton;  /**< 默认size(ZSA(30)*ZSA(30)) */

@property (nonatomic, strong, readonly) ZCBadgeView *bottomBadgeView;  /**< fixSize无效，默认size是auto */


/** 额外添加的占位属性，初始化为空值，供外部使用 */
@property (nullable, nonatomic, strong) UIView *holdView;  /**< 供外部持有的的视图，可设置独立的约束，默认nil */

/** 供外部调用或子类需要重写的方法 */
- (void)initComplete;  /**< 初始化完成，可在此懒加载生成子视图，子类重写此方法对属性赋值，可在此设置block */

- (void)resetConstraint;  /**< 重载约束布局，子视图重新设置属性需调用此方法刷新布局，必要时reloadCell */

/** 重置布局值，重置基本属性值(只读属性不重置)，重置所有子视图为隐藏 */
/** 重置所有子视图基本属性(只读属性不重置)，容器类子视图将移除内部所有子视图 */
/** 重置自己&所有子视图的logEventControlId&logEventPageId为nil */
/** layer层属性不会重置，非容器类子视图不会移除，有些category属性不会重置 */
- (void)resetAllItemHiddenAndProperty;

@end

NS_ASSUME_NONNULL_END
