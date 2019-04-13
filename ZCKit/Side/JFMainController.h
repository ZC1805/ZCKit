//
//  JFMainController.h
//  gobe
//
//  Created by zjy on 2019/3/15.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFTabBarController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFMainController : JFTabBarController

+ (nullable instancetype)instance;  /** 可能返回nil */

+ (nullable UINavigationController *)currentNavigationController;  /**< 当前选择的导航，可能nil */

@end

NS_ASSUME_NONNULL_END
