//
//  KKNextViewController.m
//  ZCTest
//
//  Created by zjy on 2021/7/22.
//

#import "KKNextViewController.h"
#import "ZCTest-Swift.h"
#import "ZCMacro.h"
#import "UIView+ZC.h"
#import "ZCNaviView.h"

@interface KKNextViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation KKNextViewController




- (void)onPageCustomInitSet:(ZCViewControllerCustomPageSet *)customPageSet {
    customPageSet.isNaviUseClearBar = NO;
    customPageSet.isNaviUseShieldBarLine = NO;
    customPageSet.isNaviUseBarShadowColor = YES;
    customPageSet.isPageHiddenNavigationBar = NO;
    customPageSet.isPageShieldInteractivePop = NO;
    customPageSet.naviUseCustomBackgroundName = @"#FF0000";
    customPageSet.naviUseCustomTitleColor = @"#FFFFFF";
    customPageSet.naviUseCustomBackArrowImage = kZIN(@"zc_image_back_black");
}


- (nullable UIViewController *)onPageCustomPanBackAction { /**< 自定义手动侧换返回实现，返回需要手动侧滑到的目标控制器，返回nil或不实现此方法则按系统处理 */
    return self.navigationController.viewControllers.firstObject;
}

- (void)onPageCustomTapBackAction { /**< 自定义点击返回按钮的实现，注意手动返回将不走此方法 */
    [self.navigationController popViewControllerAnimated:YES];
}



//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc] init];
//    appperance.backgroundEffect = nil;
//    appperance.backgroundImage = nil;
//    appperance.backgroundColor = nil;
//    appperance.shadowImage = nil;
//    [appperance setBackIndicatorImage:nil transitionMaskImage:nil];
//    self.navigationController.navigationBar.standardAppearance = appperance;
//    self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"3";
    self.view.backgroundColor = kZCRGB(0xEE8800);
    self.hidesBottomBarWhenPushed = YES;
    
    ZCNaviView *v = [ZCNaviView viewWithAssociate:self title:@"2"];
    [v setTitle:@"3" rightName:@"Xx" rightColor:UIColor.redColor];
    
    
    
    
    UITableView *listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    listView.dataSource = self; listView.delegate = self;
    if (@available(iOS 11.0, *)) {
        listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    listView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    listView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 80.0)];
    listView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listView.estimatedSectionFooterHeight = 0;
    listView.estimatedSectionHeaderHeight = 0;
    listView.estimatedRowHeight = 0;
    listView.sectionHeaderHeight = 0;
    listView.sectionFooterHeight = 0;
    listView.rowHeight = UITableViewAutomaticDimension;
    listView.showsHorizontalScrollIndicator = NO;
    listView.showsVerticalScrollIndicator = YES;
    listView.separatorInset = UIEdgeInsetsZero;
    listView.directionalLockEnabled = YES;
    listView.bounces = YES;
    listView.backgroundColor = [UIColor clearColor];
    listView.frame = CGRectMake(0, 0, kZSWid, kZSHei - 200); //这里要设置大些
    [self.view addSubview:listView];
    
    [self.view addSubview:v];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kZSWid, 150) color:kZCRGB(0xFFFFFF)];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    iv.image = [UIImage imageNamed:@"Wallet"];
    [v addSubview:iv];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kZSWid, 50) color:kZCRGB(0xFFFFFF)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = kZStrFormat(@"%ld", indexPath.row);
    cell.backgroundColor = kZCRGB(0xEEEEEE);
    return cell;
}

@end
