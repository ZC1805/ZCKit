//
//  ZCPhotoZoomControl.h
//  ZCKit
//
//  Created by admin on 2018/10/29.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCPhotoZoomControl : UIControl  /**< 头部缩放视图，显示模式是按比例铺满，可自己添加Action */

@property (nonatomic, assign) BOOL isUseBlur;  /**< 是否使用模糊，默认NO */

@property (nonatomic, assign) BOOL isNeedNarrow;  /**< 是否向上滑动的时图片收缩，即上部悬停，默认YES */

@property (nonatomic, assign) CGPoint originOffset;  /**< 初始向上偏移量，默认Zero & Auto */

@property (nullable, nonatomic, copy) void(^touchAction)(void);  /**< 添加TouchUpInset回调 */

@property (nullable, nonatomic, strong) UIImage *localImage;  /**< 显示的图片，本地图片、web图片、占位图片 */

@property (nullable, nonatomic, strong, readonly) UIVisualEffectView *blurBKView;  /**< 模糊视图 */

- (void)imageUrl:(NSString *)url holder:(nullable UIImage *)holder;  /**< 加载网路图片 */

- (void)updateHeaderImageFrame:(UIScrollView *)scrollView;  /** scrollViewDidScroll:中调用此方法 */

@end

NS_ASSUME_NONNULL_END
