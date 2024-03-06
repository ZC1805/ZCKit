//
//  ZCAvatarControl.h
//  ZCKit
//
//  Created by admin on 2018/10/25.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZCLabel;

NS_ASSUME_NONNULL_BEGIN

@interface ZCAvatarControl : UIControl  /**< 头像类视图，显示模式是按比例铺满，可自己添加Action，可设置AspectFit模式 */

@property (nonatomic, assign) BOOL isAspectFit;  /**< 是否是AspectFit模式 */

@property (nonatomic, assign) NSInteger alignment;  /**< 0居中，1上中，2左中，3下中，4右中，默认居中 */

@property (nonatomic, assign) CGFloat cornerRadius;  /**< 圆角半径，默认0 */

@property (null_resettable, nonatomic, strong) ZCLabel *descLabel;  /**< 提示视图，懒加载，默认nil */

@property (nullable, nonatomic, strong) UIImage *localImage;  /**< 赋值显示本地图片，默认nil */

@property (nullable, nonatomic, copy) void(^touchAction)(ZCAvatarControl *sender);  /**< 添加TouchUpInset回调，默认nil */

- (void)imageUrl:(nullable NSString *)url holder:(nullable UIImage *)holder;  /**< 加载网路图片 */

@end

NS_ASSUME_NONNULL_END
