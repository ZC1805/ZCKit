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
#import "XXView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL isA;

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
    
    XXView *box = [[XXView alloc] initWithFrame:CGRectMake(kZSA(25), kZSA(100), kZSA(325), kZSA(200)) color:kZCS(@"#FFFFFF")];
    if (self.isA) {



        ZCLabel *label1 = [[ZCLabel alloc] initWithFrame:CGRectMake(25, 25, 100, 50)];
        label1.text = @"哈哈哈哈哈哈哈哈哈";
        label1.backgroundColor = kZCS(@"#EEEEEE");
        [box addSubview:label1];

        ZCLabel *label2 = [[ZCLabel alloc] initWithFrame:CGRectMake(75, 100, 100, 50)];
        label2.text = @"啦啦啦啦啦啦啦";
        label2.textColor = kZCRGB(0xFFFFFF);
        label2.font = kZFB(18);
        label2.backgroundColor = kZCS(@"#32EE98");
        [box addSubview:label2];

        [box setCorner:kZSA(24) color:nil width:0];
        [ZCMaskView display:box didHide:^(BOOL isByAutoHide) {

        }];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ZCMaskView dismissSubview];
        });
    } else {
        box.zc_top = -kZSA(200);
        [ZCMaskView display:box autoHide:NO clearMask:NO showAnimate:^(UIView * _Nonnull displayView) {
            box.zc_top = kZSA(100);
        } hideAnimate:^(UIView * _Nonnull displayView) {
            box.zc_top = kZSA(300);
        } willHide:^(BOOL isByAutoHide) {
            NSLog(@"1->%f", NSDate.date.timeIntervalSince1970);
        } didHide:^(BOOL isByAutoHide) {
            NSLog(@"2->%f", NSDate.date.timeIntervalSince1970);
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"0->%f", NSDate.date.timeIntervalSince1970);
            [ZCMaskView dismissSubview];
        });
    }
    self.isA = !self.isA;
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
