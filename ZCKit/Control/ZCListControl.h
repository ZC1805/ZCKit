//
//  ZCListControl.h
//  ZCKit
//
//  Created by admin on 2018/10/22.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCListControl : UIView  /**< 底部弹出选择列表控件，加载在自定义window上 */

@property (nonatomic, assign) CGFloat minContentHei;  /**< 内容最小高度，默认100 */

@property (nonatomic, assign) CGFloat maxContentHei;  /**< 内容最大高度，默认400 */

@property (nonatomic, assign) BOOL isMaskHide;  /**< 点击背景是否隐藏，默认YES */

@property (nonatomic, assign) BOOL isMaskClear;  /**< 是否使用透明背景，默认NO，用灰色 */

@property (nonatomic, assign) BOOL isUseTopCorner;  /**< 是否顶部使用圆角，默认自适应 */

@property (nonatomic, assign) BOOL isShowCloseButton;  /**< 是否显示关闭按钮，默认NO，不显示 */

@property (nonatomic, assign) CGFloat rowHei;  /**< 行高，值为0的话则是自动行高，默认0 */

@property (nonatomic, copy) NSString *cellClassName;  /**< 使用的cell，默认是UITableViewCell */

@property (nullable, nonatomic, copy) NSString *sectionIndexTitleKey;  /**< 取值左边索引的键，外部需先排序，默认nil */

/**< cellCtor重用cell的设置，action点击时候的响应(-1时为点击背景隐藏此时selectItem为nil) */
+ (void)display:(NSArray <NSDictionary *>*)items title:(nullable NSString *)title message:(nullable NSString *)message
           ctor:(nullable void(^)(ZCListControl *listControl))ctor
       cellCtor:(nullable void(^)(__kindof UITableViewCell *cell, NSIndexPath *idxp, NSDictionary *item))cellCtor
         action:(nullable void(^)(NSInteger selectIndex, NSDictionary * _Nullable selectItem))action;

@end

NS_ASSUME_NONNULL_END
