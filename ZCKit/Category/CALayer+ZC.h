//
//  CALayer+ZC.h
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (ZC)

/** 变换深度，- 1/1000是是很好的值，应该在其他转换快捷方式之前设置 */
@property (nonatomic) CGFloat transformDepth;

/** 不带变换的快照，图像的大小等于bounds */
- (nullable UIImage *)snapshotImage;

/** 不带转换的快照，PDF的页面大小等于bounds */
- (nullable NSData *)snapshotPDF;

/** 给图层添加阴影 */
- (void)setLayerShadow:(nullable UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

/** 移除所有子图层 */
- (void)removeAllSublayers;

@end

NS_ASSUME_NONNULL_END








