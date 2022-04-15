//
//  KKViewController.m
//  ZCTest
//
//  Created by zjy on 2021/7/22.
//

#import "KKViewController.h"
#import "KKNextViewController.h"
#import "ZCMacro.h"
#import "UIView+ZC.h"
#import "ZCTest-Swift.h"

@interface KKViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) long intSource;

@property (nonatomic, strong) NSLock *lock;

@end

@implementation KKViewController

- (void)onPageCustomInitSet:(ZCViewControllerCustomPageSet *)customPageSet {
    customPageSet.isNaviUseClearBar = NO;
    customPageSet.isNaviUseShieldBarLine = NO;
    customPageSet.isNaviUseBarShadowColor = YES;
    customPageSet.isPageHiddenNavigationBar = NO;
    customPageSet.isPageShieldInteractivePop = NO;
    customPageSet.naviUseCustomBackgroundName = @"#0000FF";
    customPageSet.naviUseCustomTitleColor = @"#FFFFFF";
    //customPageSet.naviUseCustomBackArrowImage = kZIN(@"zc_image_back_black");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%ld", self.navigationController.viewControllers.count];
    self.view.backgroundColor = kZCRGB(0xEE88AA);
    self.hidesBottomBarWhenPushed = NO;
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    //self.edgesForExtendedLayout = UIRectEdgeAll;
    //contentInsetAdjustmentBehavior
    
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
    
#warning - ZCTableView分类初始化方法   JSON object   tableView先设置代理在设置表头   ZCNavVC屏蔽导航过渡问题
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController pushViewController:[[KKNextViewController alloc] init] animated:YES];
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
