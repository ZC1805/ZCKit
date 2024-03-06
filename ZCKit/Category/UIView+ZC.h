//
//  UIView+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZCBlankControl;

NS_ASSUME_NONNULL_BEGIN

@protocol ZCViewSyncLayoutProtocol <NSObject>  /**< 回调可实现的方法 */

@optional

- (void)onControllerDidLayout;  /**< 所在的controller调用viewDidLayoutSubviews时触发此回调 */

- (void)onControllerViewWillAppear;  /**< 所在的controller调用viewWillAppear时触发此回调 */

- (void)onControllerViewWillDisappear;  /**< 所在的controller调用viewWillDisappear时触发此回调 */

@end


@interface UIView (ZC) <ZCViewSyncLayoutProtocol>

@property (nonatomic) CGFloat zc_top;  /**< 视图顶部距离父视图顶部距离 */

@property (nonatomic) CGFloat zc_left;  /**< 视图左边距离父视图左边距离 */

@property (nonatomic) CGFloat zc_bottom;  /**< 视图底部距离父视图底部距离，在设置高度后(或size)再设置bottom，同时设置上下不能确定高 */

@property (nonatomic) CGFloat zc_right;  /**< 视图右边距离父视图右边距离，在设置宽度后(或size)再设置right，同时设置左右不能确定宽 */

@property (nonatomic) UIEdgeInsets zc_edge;  /**< 视图到父视图上下左右的间距，在设置宽度(或size)&父视图size后再设置right，同时设置左右不能确定宽 */

@property (nonatomic) CGFloat zc_edgeRight;  /**< 视图到父视图右边的间距，在设置宽度(或size)&父视图size后再设置right，同时设置左右不能确定宽 */

@property (nonatomic) CGFloat zc_edgeBottom;  /**< 视图到父视图下边的间距，在设置高度(或size)&父视图size后再设置bottom，同时设置上下不能确定高 */

@property (nonatomic) CGFloat zc_width;  /**< 视图宽度 */

@property (nonatomic) CGFloat zc_height;  /**< 视图高度 */

@property (nonatomic) CGPoint zc_origin;  /**< 视图左上顶点位置 */

@property (nonatomic) CGSize  zc_size;  /**< 视图宽高尺寸 */

@property (nonatomic) CGFloat zc_centerX;  /**< 视图x轴位置，在设置宽度后(或size)再设置centerX */

@property (nonatomic) CGFloat zc_centerY;  /**< 视图y轴位置，在设置高度后(或size)再设置centerY */

@property (nonatomic, readonly) CGFloat visibleAlpha;  /**< 返回屏幕上可见的alpha，考虑到超视窗和窗口 */

@property (nullable, nonatomic, readonly) UIViewController *currentViewController;  /**< 返回当前所在最近的controller */

@property (nonatomic, strong, readonly) ZCBlankControl *blankCoverView;  /**< 懒加载生成当前空覆盖视图 */

@property (nullable, nonatomic, copy) NSString *flagStr;  /**< 类似tag的标识，默认nil */

@property (nullable, nonatomic, strong) NSDictionary *flagDic;  /**< 类似tag的标识，默认nil */

- (void)removeAllSubviews;  /**< 移除所有子视图 */

- (NSArray <UIView *>*)containAllSubviews;  /**< 所有子视图集合 */

- (CGRect)minContainerRect;  /**< 根据子视图获取所需最小容器rect */

- (BOOL)isDisplayInScreen;  /**< 判断当前视图是否显示在屏幕上 */

- (nullable UIView *)findFirstResponder;  /**< 递归向上找到第一响应者 */

- (nullable UIView *)findSubviewLike:(Class)likeClass;  /**< 从视图顶层往下按添加的后先顺序寻找到第一个目标子视图 */

- (nullable UIView *)findSubviewTag:(NSInteger)aimTag;  /**< 从视图顶层往下按添加的后先顺序寻找到第一个目标子视图 */

- (BOOL)containSubView:(UIView *)subView;  /**< 递归向上，找到最顶层 */

- (BOOL)containSubViewOfClassType:(Class)aClass;  /**< 递归向上，找到最顶层 */

- (nullable UIImage *)clipToSubAreaImage:(CGRect)subArea;  /**< 指定区域截图，其余部分为透明颜色 */

- (nullable UIImage *)clipToImage;  /**< 当前视图的快照 */

- (CGPoint)convertPointToScrren:(CGPoint)point;  /**< 转换到屏幕的坐标 */

- (void)setShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;  /**< 阴影 */

- (void)setCorner:(CGFloat)radius color:(nullable UIColor *)color width:(CGFloat)width;  /**< 圆角 & 描边 */

- (void)setCorner:(UIRectCorner)corner radius:(CGSize)radius;  /**< 设置部分圆角 */

- (void)setGradientColors:(NSArray <UIColor *>*)colors isHor:(BOOL)isHor;  /**< 设置渐变背景色 */

/**< 使用inset来确定子视图位置，inset.bottom为视图的高，当inset为zero时，移除视图，返回nil */
- (nullable UIView *)setTopLineInsets:(UIEdgeInsets)insets color:(UIColor *)color;

/**< 使用inset来确定子视图位置，inset.right为视图的宽，当inset为zero时，移除视图，返回nil */
- (nullable UIView *)setLeftLineInsets:(UIEdgeInsets)insets color:(UIColor *)color;

/**< 使用inset来确定子视图位置，inset.top为视图的高，当inset为zero时，移除视图，返回nil */
- (nullable UIView *)setBottomLineInsets:(UIEdgeInsets)insets color:(UIColor *)color;

/**< 使用inset来确定子视图位置，inset.left为视图的宽，当inset为zero时，移除视图，返回nil */
- (nullable UIView *)setRightLineInsets:(UIEdgeInsets)insets color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
