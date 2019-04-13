//
//  JFSideViewController.m
//  gobe
//
//  Created by zjy on 2019/3/20.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFSideViewController.h"
#import "JFContainerController.h"
#import "ZCAvatarControl.h"

@interface JFSideViewController ()

@property (nonatomic, strong) NSArray <NSArray *>*dataArr;

@end

@implementation JFSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = @[@[@{@"name":@"x1", @"image":@"image", @"action":@"JFViewController"},
                       @{@"name":@"x2", @"image":@"image", @"action":@"JFViewController"},
                       @{@"name":@"x3", @"image":@"image", @"action":@"JFViewController"},
                       @{@"name":@"x4", @"image":@"image", @"action":@"JFViewController"},
                       @{@"name":@"x5", @"image":@"image", @"action":@"JFViewController"},
                       @{@"name":@"x6", @"image":@"image", @"action":@"JFViewController"}],
                     @[@{@"name":@"x7", @"image":@"image", @"action":@"JFViewController"}]];
    self.tableView.backgroundColor = ZCBKColor;
    self.tableView.width = ZSWid * 0.8;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ZCTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self createUI];
}

- (void)createUI {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, ZSA(190))];
    self.tableView.tableHeaderView = headerView;
    
    ZCAvatarControl *avater = [[ZCAvatarControl alloc] initWithFrame:CGRectZero];
    avater.frame = CGRectMake((headerView.width - ZSA(50)) / 2.0, ZSA(40), ZSA(50), ZSA(50));
    avater.cornerRadius = ZSA(25);
    avater.localImage = ZCIN(@"image");
    [headerView addSubview:avater];
    
    UILabel *nikeLabel = [[UILabel alloc] initWithFrame:CGRectZero font:ZCFS(13) color:ZCBlack30];
    nikeLabel.frame = CGRectMake(ZSA(20), ZSA(110), (headerView.width - ZSA(40)), ZSA(20));
    nikeLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:nikeLabel];
    
    UILabel *mobileLabel = [[UILabel alloc] initWithFrame:CGRectZero font:ZCFS(13) color:ZCBlack30];
    mobileLabel.frame = CGRectMake(ZSA(20), ZSA(130), (headerView.width - ZSA(40)), ZSA(20));
    mobileLabel.textAlignment = NSTextAlignmentCenter;
    mobileLabel.text = @"18818807170";
    [headerView addSubview:mobileLabel];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return ZSA(20);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.separatorBKColor = ZCBKColor;
    cell.bottomSeparatorInset = UIEdgeInsetsMake(ZSA(1), 0, 0, 0);
    cell.leadingLabel.text = self.dataArr[indexPath.section][indexPath.row][@"name"];
    cell.avatarControl.localImage = ZCIN(self.dataArr[indexPath.section][indexPath.row][@"image"]);
    cell.avatarControl.size = CGSizeMake(ZSA(18), ZSA(18));
    cell.accessControl.hidden = NO;
    cell.backgroundColor = ZCBlackC8;
    cell.selectBKColor = ZCBKColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *className = self.dataArr[indexPath.section][indexPath.row][@"action"];
    if (className && [JFMainController currentNavigationController]) {
        [[JFContainerController instance] closeSide];
        UIViewController *vc = [[NSClassFromString(className) alloc] init];
        [[JFMainController currentNavigationController] pushViewController:vc animated:YES];
    }
}

@end
