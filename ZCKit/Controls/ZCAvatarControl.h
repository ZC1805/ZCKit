//
//  ZCAvatarControl.h
//  ZCKit
//
//  Created by admin on 2018/10/25.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCAvatarControl : UIControl  /**< 头像类视图，显示模式是按比例铺满，可自己添加Action */

@property (nonatomic, assign) CGFloat cornerRadius;  /**< 圆角半径，默认0 */

@property (nullable, nonatomic, strong) UIImage *loaclImage;  /**< 赋值显示本地图片，默认nil */

@property (nullable, nonatomic, copy) void(^touchAction)(void);  /**< 添加TouchUpInset回调 */

- (void)imageUrl:(NSString *)url holder:(nullable UIImage *)holder;  /**< 加载网路图片 */

@end

NS_ASSUME_NONNULL_END
