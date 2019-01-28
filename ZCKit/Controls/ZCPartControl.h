//
//  ZCPartControl.h
//  ZCKit
//
//  Created by admin on 2019/1/22.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCPartSet : NSObject

@property (nullable, nonatomic, copy) NSString *title;  /**< 默认nil */

@property (nullable, nonatomic, strong) UIImage *normalImage;  /**< 默认nil */

@property (nullable, nonatomic, strong) UIImage *selectImage;  /**< 默认nil */

@property (nonatomic, strong) UIFont *normalTitleFont;  /**< 默认system15 */

@property (nonatomic, strong) UIFont *selectTitleFont;  /**< 默认system15 */

@property (nonatomic, assign) int normalColorRGB;  /**< 默认0x303030 */

@property (nonatomic, assign) int selectColorRGB;  /**< 默认0xff0000 */

@property (nonatomic, assign) CGFloat spaceHeight;  /**< 分割线高度，默认20 */

@property (nonatomic, assign) CGSize imageSize;  /**< 自定义图片的大小，默认{20, 20} */

@property (nonatomic, assign) CGFloat imageTitleSpace;  /**< 图片和文字的竖直间距，默认5 */

@property (nonatomic, assign) BOOL isVerticalAlignment;  /**< 图片和文字是否是竖直居中对齐，默认YES */

@end



@class ZCPartControl;

@protocol ZCPartControlDelegate <NSObject>

@optional

/** 点击触发selectIndex值改变在此回调 */
- (void)partControl:(ZCPartControl *)partControl didSelectItemAtIndex:(NSUInteger)index;

/** selectIndexd发生改变(index有可能会等于-1)，关联scroll view时候，可能会3->2->1->0，而不是3->0 */
- (void)partControl:(ZCPartControl *)partControl selectIndexDidChange:(NSInteger)index;

/** 在此回调可以设置ZCPartSet属性 */
- (void)partControl:(ZCPartControl *)partControl didInitialPartSet:(ZCPartSet *)partSet index:(NSInteger)index;

/** 没有关联scroll view时候，markview将要改变位置回调，在此可以设置动画 */
- (void)partControl:(ZCPartControl *)partControl didMoveMark:(UIView *)view from:(CGRect)fromRect to:(CGRect)toRect index:(NSInteger)index;

@end



@interface ZCPartControl : UIView

@property (nonatomic, assign) UIEdgeInsets contentEdge;  /**< 内容区域边距，默认zero */

@property (nonatomic, assign) CGSize markSize;  /**< fix wid模式下，mark view size，默认zero */

@property (nonatomic, assign) CGFloat itemWidth;  /**< fix wid模式下，item宽，items小于4项会自动设置，默认0 */

@property (nonatomic, assign) CGFloat interval;  /**< fix wid模式下，各item的间距，默认0 */

@property (nonatomic, strong) UIColor *barColor;  /**< 内容区域背景颜色，默认clear */

@property (nonatomic, strong) UIColor *markColor;  /**< mark view背景颜色，默认grey */

@property (nonatomic, strong) UIImage *alphaImage;  /**< 两头半透明视图，默认nil */

@property (nonatomic, readonly) NSInteger currentSelectIndex;  /**< 当前选择index，默认-1 */

@property (nonatomic, weak) id <ZCPartControlDelegate> delegate;  /**< 代理，默认nil */

@property (nonatomic, copy) void(^onSelectIndex)(NSUInteger selectIndex);  /**< 选择BarItem的block回调 */

/** 初始化方法，bottom mark 是否是底部指示view，fix width 是否是固定item宽度(NO就计算宽度) */
- (instancetype)initWithFrame:(CGRect)frame normalMark:(BOOL)bottomMark fixWidth:(BOOL)fixWidth;

/** selectIndex == -1时，即一个都不选择，其余超出范围或者不规范的selectIndex将置0 */
- (void)selectToIndex:(NSInteger)selectIndex animated:(BOOL)animated;

/** 载入内容，items成员可以是NSString或者ZCPartSet对象 */
- (void)reloadItems:(NSArray *)items;

/** 关联滑动的scroll view，最好在reloadItems后设置 */
- (void)associateScrollView:(UIScrollView *)scrollView;

/** 释放滑动的scroll view，适当时候手动释放 */
- (void)releaseAssociateScrollView;

@end

NS_ASSUME_NONNULL_END
