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
#import "ZCBoxView.h"
#import "UIResponder+ZC.h"
#import "ZCQueueHandler.h"

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
#warning - ZCTableView分类初始化方法 & JSON object & 自定义导航替换问题
    
    
    main_delay(2, ^{
        [self tx];
    });
    
}

- (void)tx {
    NSLog(@"start------%@", NSThread.currentThread);
    
    group_concurrent(100, NO, ^(int index, void (^ _Nonnull operateCompletion)(BOOL isSuccess)) {
        NSLog(@"a1-%d------%@", index, NSThread.currentThread);
        [NSThread sleepForTimeInterval:1];
        NSLog(@"a2-%d------%@", index, NSThread.currentThread);
        
        //dispatch_async(dispatch_get_main_queue(), ^{
            operateCompletion(index == 1);
        //});
        
    }, ^(NSArray <NSNumber *>*failIndexs){
        NSLog(@"comp------%@ - %d", NSThread.currentThread, failIndexs.count);
    });
    
//    barrier_concurrent(2, ^(int index) {
//        NSLog(@"before1------%@", NSThread.currentThread);
//        [NSThread sleepForTimeInterval:1];
//        NSLog(@"before2------%@", NSThread.currentThread);
//    }, ^{
//        NSLog(@"barrier------%@", NSThread.currentThread);
//    }, 2, ^(int index) {
//        NSLog(@"after1------%@", NSThread.currentThread);
//        [NSThread sleepForTimeInterval:5];
//        NSLog(@"after2------%@", NSThread.currentThread);
//    });
    
    NSLog(@"stop------%@", NSThread.currentThread);
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
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
