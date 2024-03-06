//
//  ZCPartControl.h
//  ZCKit
//
//  Created by admin on 2019/1/22.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZCButton, ZCScrollView;

NS_ASSUME_NONNULL_BEGIN

@interface ZCPartSet : NSObject  /**< 通用设置 */

@property (nullable, nonatomic, copy) NSString *title;  /**< 默认nil */

@property (nullable, nonatomic, copy) NSAttributedString *normalAttTitle;  /**< 默认nil，设置了此的话则需包含设置color、font */

@property (nullable, nonatomic, copy) NSAttributedString *selectAttTitle;  /**< 默认nil，设置了此的话则需包含设置color、font */

@property (nullable, nonatomic, strong) UIImage *normalImage;  /**< 默认nil */

@property (nullable, nonatomic, strong) UIImage *selectImage;  /**< 默认nil */

@property (nonatomic, strong) UIFont *normalTitleFont;  /**< 默认system15 */

@property (nonatomic, strong) UIFont *selectTitleFont;  /**< 默认system15 */

@property (nonatomic, assign) uint32_t normalColorRGB;  /**< 默认0x303030 */

@property (nonatomic, assign) uint32_t selectColorRGB;  /**< 默认0x303030 */

@property (nonatomic, assign) CGFloat spaceHeight;  /**< 分割线高度，默认0 */

@property (nonatomic, assign) CGSize imageSize;  /**< 自定义图片的大小，默认{20, 20} */

@property (nonatomic, assign) CGFloat imageTitleSpace;  /**< 图片和文字的竖直间距，默认0 */

@property (nonatomic, assign) BOOL isVerticalAlignment;  /**< 图片和文字是否是竖直居中对齐，默认YES */

@property (nonatomic, assign) BOOL isUseFixSelMarkSize;  /**< 计算宽度是是否固定markView宽度(30，3)，默认YES */

@property (nonatomic, assign) CGFloat calExtraAddWidth;  /**< 计算宽度增加的宽度，默认0 */

- (instancetype)initWithTitle:(NSString *)title;  /**< 默认初始化方法 */

@end


@class ZCPartControl;

@protocol ZCPartControlDelegate <NSObject>  /**< 回调可实现的方法 */

@optional

/**< 用户点击头部item按钮响应不响应事件 */
- (BOOL)partControlCanTouchBarItem:(ZCPartControl *)partControl;

/**< 用户点击触发barBtn在此回调，from可能为-1 */
- (void)partControl:(ZCPartControl *)partControl didSelectItemAtIndex:(NSUInteger)aimIndex fromIndex:(NSUInteger)fromIndex;

/**< selectIndexd发生改变(index有可能会等于-1)，关联scroll view时候，可能会3->2->1->0，而不是3->0，isTouchTrigger是非滑动触发，isActiveSlid是否是主动滑动 */
- (void)partControl:(ZCPartControl *)partControl selectIndexDidChange:(NSInteger)index isTouchTrigger:(BOOL)isTouchTrigger isActiveSlid:(BOOL)isActiveSlid;

/**< 在此回调可以设置ZCPartSet属性 */
- (void)partControl:(ZCPartControl *)partControl didInitialPartSet:(ZCPartSet *)partSet index:(NSInteger)index;

/**< 没有关联scroll view时候，markview将要改变位置回调，在此可以设置动画 */
- (void)partControl:(ZCPartControl *)partControl didMoveMark:(UIView *)view from:(CGRect)fromRect to:(CGRect)toRect index:(NSInteger)index;

@end


@interface ZCPartControl : UIView  /**< 分段控件 */

@property (nonatomic, assign) UIEdgeInsets contentEdge;  /**< 内容区域边距，默认zero */

@property (nonatomic, assign) CGSize markSize;  /**< fix wid模式下，mark view size，默认zero */

@property (nonatomic, assign) CGFloat itemWidth;  /**< fix wid模式下，item宽，items小于4项会自动设置，默认0 */

@property (nonatomic, assign) CGFloat interval;  /**< fix wid模式下，各item的间距，默认0 */

@property (nonatomic, strong) UIColor *barColor;  /**< 内容区域背景颜色，默认clear */

@property (nonatomic, strong) UIColor *markColor;  /**< mark view背景颜色，默认grey */

@property (nullable, nonatomic, strong) UIImage *alphaImage;  /**< 两头半透明视图，默认nil */

@property (nonatomic, strong, readonly) UIView *backgroundView;  /**< 背景视图，默认为透明的view */

@property (nonatomic, readonly) NSInteger currentSelectIndex;  /**< 当前选择index，默认-1 */

@property (nonatomic, weak) id <ZCPartControlDelegate> delegate;  /**< 代理，默认nil */

@property (nonatomic, copy) void(^onSelectIndex)(NSUInteger selectIndex);  /**< 选择BarItem的block回调 */

/**< 初始化方法，bottom mark 是否是底部指示view，fix width 是否是固定item宽度(NO就计算宽度) */
- (instancetype)initWithFrame:(CGRect)frame normalMark:(BOOL)bottomMark fixWidth:(BOOL)fixWidth;

/**< selectIndex == -1时，即一个都不选择，其余超出范围或者不规范的selectIndex将置0 */
- (void)selectToIndex:(NSInteger)selectIndex animated:(BOOL)animated;

/**< 屏蔽一次selectIndexDidChange的回调，一般用于在associate前屏蔽第一次回调 */
- (void)shieldOnceSelectIndexDidChange;

/**< 载入内容，items成员可以是NSString或者ZCPartSet对象 */
- (void)reloadItems:(NSArray *)items;

/**< 关联滑动的scroll view，会校验下设置的index，最好在reloadItems后设置 */
- (void)associateScrollView:(ZCScrollView *)scrollView;

/**< 释放滑动的scroll view，适当时候手动释放(注意:如果不是添加在当前控制器的View上需要在dealloc中手动调用此方法) */
- (void)releaseAssociateScrollView;

/**< 按index获取bar上面的button */
- (nullable ZCButton *)barButtonWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
