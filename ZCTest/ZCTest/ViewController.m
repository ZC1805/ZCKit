//
//  ViewController.m
//  ZCTest
//
//  Created by zjy on 2021/7/22.
//

#import "ViewController.h"
#import "NextViewController.h"
#import "ZCKit.h"
#import "NSDate+ZC.h"
#import "ZCDateManager.h"
#import "ZCKitBridge.h"
#import "VCIdManager.h"
#import "ZCMaskView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

+ (void)load {
    NSLog(@"1-%@", NSStringFromClass(self));
    [[VCIdManager share].vcs addObject:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"1";
    self.view.backgroundColor = kZCRGB(0xEE88AA);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    UITableView *listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    listView.dataSource = self; listView.delegate = self;
    listView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    listView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
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
    listView.frame = CGRectMake(0, 64, kZSWid, kZSHei - 64 - 200); //这里要设置大些
    listView.backgroundColor = kZCRGB(0xEEEEEE);
    [self.view addSubview:listView];
    UIColor *a = kZCA(UIColor.whiteColor, 0.5);
    ZCButton *btn1 = [[ZCButton alloc] initWithFrame:CGRectZero color:a];
    btn1.frame = CGRectMake(100, 100, 100, 100);
    NSLog(@"%p, %p, %x", a, btn1.backgroundColor, a.RGBAValue);
    [self.view addSubview:btn1];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //[self.navigationController pushViewController:[NSClassFromString(@"NextViewController") new] animated:YES];
    [ZCMaskView dismissSubview];
    
    ZCLabel *label = [[ZCLabel alloc] initWithFrame:CGRectMake(100, 200, 200, 50)];
    label.text = @"哈哈哈哈哈哈哈哈哈 we auto releass!";
    label.backgroundColor = kZCS(@"#EEEEEE");
    
    [ZCMaskView display:label didHide:^(BOOL isByAutoHide) {
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ZCMaskView dismissSubview];
    });
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kZSWid, 50) color:kZCRGB(0xFFFFFF)];
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
    cell.backgroundColor = kZCClear;
    return cell;
}

@end
