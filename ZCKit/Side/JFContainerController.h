//
//  JFContainerController.h
//  gobe
//
//  Created by zjy on 2019/3/20.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFViewController.h"
#import "JFMainController.h"
#import "JFSideViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFContainerController : JFViewController

+ (nullable instancetype)instance;  //可能返回nil

- (instancetype)initWithSideVc:(JFSideViewController *)leftVc mainVc:(JFMainController *)mainVc;  //初始化方法

- (void)closeSide;  //关闭侧边栏，无动画

- (void)hideSide;  //关闭侧边栏，有动画

- (void)openSide;  //打开侧边栏，有动画

@end

NS_ASSUME_NONNULL_END
