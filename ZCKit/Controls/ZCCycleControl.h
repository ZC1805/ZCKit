//
//  ZCCycleControl.h
//  ZCKit
//
//  Created by admin on 2018/10/15.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZCEnumCycleAliment) {
    ZCEnumCycleAlimentRight,
    ZCEnumCycleAlimentCenter,
};

typedef NS_ENUM(NSInteger, ZCEnumCyclePageStyle) {
    ZCEnumCyclePageStyleClassic,    /**< 系统自带样式 */
    ZCEnumCyclePageStyleAnimated,   /**< 自定义动画效果 */
    ZCEnumCyclePageStyleNone,       /**< 不显示PageControl */
};


@class ZCCycleControl;

@protocol ZCCycleControlDelegate <NSObject>

@optional

- (void)cycleControl:(ZCCycleControl *)cycleControl didScrollToIndex:(NSInteger)index;   /**< 图片滚动 */

- (void)cycleControl:(ZCCycleControl *)cycleControl didSelectAtIndex:(NSInteger)index;   /**< 点击图片 */

@end


@interface ZCCycleControl : UIView

#pragma mark - 配置
@property (nonatomic, assign) BOOL autoScroll;   /**< 是否自动滚动，默认YES */

@property (nonatomic, assign) BOOL infiniteLoop;   /**< 是否无限循环，默认YES */

@property (nonatomic, assign) BOOL showPageControl;   /**< 是否显示分页控件，默认YES */

@property (nonatomic, assign) BOOL onlyDisplayText;   /**< 只展示文字轮播，默认NO */

@property (nonatomic, assign) CGFloat autoScrollTimeInterval;   /**< 自动滚动间隔时间，默认4s */

@property (nonatomic, assign) UIViewContentMode imageViewContentMode;   /**< 轮播图片Mode，默认ScaleToFill */

@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;   /**< 图片滚动方向，默认为水平滚动 */

@property (nonatomic, assign) ZCEnumCyclePageStyle pageControlStyle;   /**< pagecontrol 样式，默认为动画样式 */

@property (nonatomic, assign) ZCEnumCycleAliment pageControlAliment;   /**< 分页控件位置，默认居中*/

@property (nonatomic, assign) CGFloat pageControlBottomOffset;   /**< 分页控件距离轮播图的底部间距，在默认间距基础上的偏移量 */

@property (nonatomic, assign) CGFloat pageControlRightOffset;   /**< 分页控件距离轮播图的右边间距，在默认间距基础上的偏移量 */

@property (nonatomic, assign) CGSize pageControlDotSize;   /**< 分页控件小圆标大小，默认{6, 6} */

@property (nonatomic, assign) CGFloat pageControlSpacing;   /**< 分页控件的间隔，默认7.0 */

@property (nonatomic, strong) UIColor *pageDotSelectColor;   /**< 当前分页控件小圆标颜色，白色 */

@property (nonatomic, strong) UIColor *pageDotColor;   /**< 其他分页控件小圆标颜色，灰色 */

@property (nullable, nonatomic, strong) UIImage *placeholderImage;   /**< 占位图，用于网络未加载到图片时，默认nil */

@property (nullable, nonatomic, strong) UIImage *currentPageDotImage;   /**< 当前分页控件小圆标图片，nil */

@property (nullable, nonatomic, strong) UIImage *pageDotImage;   /**< 其他分页控件小圆标图片，nil */

#pragma mark - 数据&回调
@property (nullable, nonatomic, strong) NSArray *titlesGroup;   /**< 每张图片对应要显示的文字数组，默认nil */

@property (nullable, nonatomic, strong) NSArray *imageURLStringsGroup;   /**< 网络图片 url string 数组，默认nil */

@property (nullable, nonatomic, strong) NSArray *localizationImageNamesGroup;   /**< 本地图片数组 (本地图片请填写全名)，默认nil */

@property (nullable, nonatomic, weak) id<ZCCycleControlDelegate> delegate;   /**< 回调代理，默认nil */

@property (nullable, nonatomic, copy) void (^titleLableSet)(UILabel *titleLabel);   /**< 文字属性的设置回调，默认nil */

@property (nullable, nonatomic, copy) void (^clickCallback)(NSInteger currentIndex);   /**< block方式监听点击回调，默认nil */

@property (nullable, nonatomic, copy) void (^scrollCallback)(NSInteger currentIndex);   /**< block方式监听滚动回调，默认nil */

#pragma mark - 构建
/** URL初始化 */
+ (instancetype)cycleControlFrame:(CGRect)frame imageURLStringsGroup:(nullable NSArray *)imageURLStringsGroup;

/** 代理初始化 */
+ (instancetype)cycleControlFrame:(CGRect)frame delegate:(nullable id<ZCCycleControlDelegate>)delegate holderImage:(nullable UIImage *)holderImage;

/** 本地图片初始化 */
+ (instancetype)cycleControlFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop imageNamesGroup:(nullable NSArray *)imageNamesGroup;

/** 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 */
- (void)adjustWhenControllerViewWillAppera;

@end

NS_ASSUME_NONNULL_END
