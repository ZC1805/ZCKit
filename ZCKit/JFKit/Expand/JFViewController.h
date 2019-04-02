//
//  JFViewController.h
//  ZCKit
//
//  Created by zjy on 2018/4/20.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFNetworkRequest.h"
#import "JFNetworkModel.h"
#import "ZCAdaptBar.h"
#import "MJRefresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

/** 是否是自适应safe区域，默认YES */
@property (nonatomic, assign) BOOL isInsetAdjustment;

/** 界面是否正在可见中 */
@property (nonatomic, assign, readonly) BOOL isVisible;

/** 表视图键盘隐藏点击处理，点击空白隐藏键盘，默认NO */
@property (nonatomic, assign) BOOL isTableViewKeyboardControl;

/** 在table初始化前设置，默认UITableViewStyleGrouped */
@property (nonatomic, assign) UITableViewStyle tableViewStyple;

/** 懒加载，暂未加入到视图中 */
@property (nonatomic, strong, readonly) UITableView *tableView;

/** 懒加载，已加入self.view中 */
@property (nonatomic, strong, readonly) ZCAdaptBar *topAdaptBar;

/** 懒加载，已加入self.view中 */
@property (nonatomic, strong, readonly) ZCAdaptBar *bottomAdaptBar;

/** 懒加载，数据请求 */
@property (nonatomic, strong, readonly) JFNetworkRequest *request;

/** 懒加载，数据发送 */
@property (nonatomic, strong, readonly) JFNetworkRequest *upload;

/** 暂存传递过来的数组，可能为空 */
@property (nullable, nonatomic, strong) NSArray *deliverArr;

/** 暂存传递过来的字典，可能为空 */
@property (nullable, nonatomic, strong) NSDictionary *deliverDic;


/** 初始化信息，deliverData为数组或者字典 */
- (instancetype)initWithDeliverData:(nullable id)deliverData;

/** 结束头部和尾部的刷新 */
- (void)stopMJRefresh:(UITableView *)tableView;

/** 保存&刷新尾部的状态，last是否是加载到最末尾 */
- (void)saveMJRefresh:(UITableView *)tableView parameter:(JFNetworkParameter *)parameter last:(BOOL)last;

/** 结束刷新&重置状态，同时重置上拉加载状态 */
- (void)resetMJRefresh:(UITableView *)tableView parameter:(JFNetworkParameter *)parameter;

/** 结束刷新&重载状态，同时重载上拉加载状态 */
- (void)reloadMJRefresh:(UITableView *)tableView parameter:(JFNetworkParameter *)parameter;


/** 显示提示信息、图片或gif图片，tap为点击响应区域隐藏后的处理 */
- (void)showContentTip:(NSString *)tip image:(nullable UIImage *)image tap:(nullable void(^)(void))tap;

@end

NS_ASSUME_NONNULL_END
