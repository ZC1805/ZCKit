//
//  JFMainController.m
//  gobe
//
//  Created by zjy on 2019/3/15.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFMainController.h"
#import "JFNavigationController.h"
#import "JFAppDelegate.h"

@interface JFMainController ()

@end

@implementation JFMainController

+ (instancetype)instance {
    JFAppDelegate *delegete = (JFAppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *tabvc = delegete.window.rootViewController;
    if ([tabvc isKindOfClass:[JFMainController class]]) {
        return (JFMainController *)tabvc;
    } else {
        for (UIViewController *vc in tabvc.childViewControllers) {
            if ([vc isKindOfClass:[JFMainController class]]) {
                return (JFMainController *)vc;
            }
        }
        return nil;
    }
}

+ (UINavigationController *)currentNavigationController {
    if ([JFMainController instance]) {
        UIViewController *vc = [JFMainController instance].selectedViewController;
        if (vc && [vc isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)vc;
        }
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBar.hidden = YES;
}

- (void)initSubVC {
    JFViewController *homeVc = [[JFViewController alloc] initWithNibName:nil bundle:nil];
    //homeVc.hidesBottomBarWhenPushed = NO;
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVc];
    UIImage *norImage = [[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selImage = [[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:norImage selectedImage:selImage];
    homeNav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -1);
    [homeNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZCRed,
                                            NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [homeNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZCGreen,
                                            NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    homeNav.tabBarItem.badgeValue = @"";
    homeNav.tabBarItem.tag = 0;
    self.viewControllers = [NSArray arrayWithObject:homeNav];
    self.tabBar.hidden = YES;
}


//- (void)view {

    
//    [JFCollection startCollectionAddressList:^(BOOL success, NSArray * _Nonnull list) {
//
//    }];
    
    
//    NSDictionary *pars1 = @{@"channel_type"     : @"YYS",
//                           @"channel_code"      : @"302002",
//                           @"app_name"          : @"test_and",
//                           @"real_name"         : @"vinaphone",
//                           @"identity_code"     : @"3301021234003",
//                           @"user_mobile"       : @"0911349450",
//                           };
//
//    NSString *url1 = @"https://talosapi.shujumohe.com/octopus/task.unify.create/v3?partner_code=jinfeng_vn_test&partner_key=ae307714801f4e7686ef840f1f2d9a54";
//    [JFNetwork request:NO isPost:YES basicUrl:nil cmdUrl:url1 pars:pars1 block:^(NSString * _Nullable fail, id  _Nullable data) {
//        NSLog(@"response1 -> %@", [data jsonString]);
//
//        NSString *taskId = [data stringValueForKey:@"task_id"];
//        NSDictionary *pars2 = @{@"task_id"      : taskId,
//                                @"user_name"    : @"0911349450",
//                                @"user_pass"    : @"2ox76xar",
//                                @"task_stage"   : @"INIT",
//                                @"request_type" : @"submit",
//                                @"login_type"   : @"2"
//                                };
//        NSLog(@"request -> %@", [pars2 jsonString]);
//        NSString *url2 = @"https://talosapi.shujumohe.com/octopus/task.unify.acquire/v3?partner_code=jinfeng_vn_test&partner_key=ae307714801f4e7686ef840f1f2d9a54";
//        [JFNetwork request:NO isPost:YES basicUrl:nil cmdUrl:url2 pars:pars2 block:^(NSString * _Nullable fail, id  _Nullable data) {
//            NSLog(@"response2 -> %@", [data jsonString]);
//
//
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSDictionary *pars3 = @{@"task_id"      : taskId,
//                                        @"user_name"    : @"0911349450",
//                                        @"user_pass"    : @"2ox76xar",
//                                        @"task_stage"   : @"INIT",
//                                        @"request_type" : @"query",
//                                        @"login_type"   : @"2"
//                                        };
//                [JFNetwork request:NO isPost:YES basicUrl:nil cmdUrl:url2 pars:pars3 block:^(NSString * _Nullable fail, id  _Nullable data) {
//                    NSLog(@"response3 -> %@", [data jsonString]);
//
//
//                    NSString *url4 = @"https://talosapi.shujumohe.com/octopus/task.unify.query/v3";
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        NSDictionary *pars4 = @{@"task_id" : taskId,
//                                                @"partner_code" : @"jinfeng_vn_test",
//                                                @"partner_key" : @"ae307714801f4e7686ef840f1f2d9a54",
//                                                };
//                        [JFNetwork request:NO isPost:YES basicUrl:nil cmdUrl:url4 pars:pars4 block:^(NSString * _Nullable fail, id  _Nullable data) {
//                            NSLog(@"response4 -> %@", [data jsonString]);
//
//                        }];
//                    });
//
//
//                }];
//            });
//
//
//        }];
//
//    }];
    
    
//}






//    static CGFloat minLineSpacing = 0.5;
//    static CGFloat viewEdge = 10.0;
//
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.headerReferenceSize = CGSizeMake(ZSWid, 35.0);
//    layout.sectionInset = UIEdgeInsetsMake(ZSA(10), ZSA(10), ZSA(10), ZSA(10));
//    layout.minimumInteritemSpacing = minLineSpacing;
//    layout.minimumLineSpacing = minLineSpacing;
//    CGFloat width = (ZSWid - 2 * viewEdge - minLineSpacing)/2;
//    CGFloat height = (ZSAvailableHei - 2 * viewEdge - 5 * minLineSpacing) / 6;
//    layout.itemSize = CGSizeMake(width, height);
//
//    self.collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//    self.collection.frame = CGRectMake(0, self.header.bottom, ZSWid, ZSHei - self.header.bottom - ZSTabBarHei);
//    _collection.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _collection.showsVerticalScrollIndicator = NO;
//    _collection.showsHorizontalScrollIndicator = NO;
//    [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//    _collection.delegate   = self;
//    _collection.dataSource = self;
//    _collection.backgroundColor = ZCBlackA2;
//    [self.view addSubview:self.collection];
//    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"section"];

//#pragma mark --- UIcollectionDelegate
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.nameArr.count;
//}
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 2;
//}
//
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
//viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//
//        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"section" forIndexPath:indexPath];
//        UILabel *label = [view viewWithTag:921];
//        if (!label) {
//            label = [[UILabel alloc] initWithFrame:view.bounds];
//            label.textAlignment = NSTextAlignmentCenter;
//            //label.font = DEFFontSize13;
//            //label.textColor = DCRForBlackA0;
//            label.tag = 921;
//            [view addSubview:label];
//        }
//        label.text = indexPath.section == 0 ? @"年 份" : @"月 份";
//        return view;
//    }
//    return nil;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor whiteColor];
//    UIView *view1 = [[UIView alloc] init];
//    view1.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    cell.backgroundView = view;
//    cell.selectedBackgroundView = view1;
//
//    NSString *billid = @"123";
//    NSString *itemName = @"456";
//    NSString *str = @"单据_";
//    NSString *imageName = [str stringByAppendingString:billid];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    CGFloat width = 108.0;
//    btn.frame = CGRectMake((cell.contentView.bounds.size.width - width)/2, (cell.contentView.bounds.size.height - 30)/2, width, 30);
//    btn.backgroundColor = [UIColor clearColor];
//    [btn setTitle:itemName forState:UIControlStateNormal];
//    [btn setTitleColor:ZCBlack30 forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
//    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    btn.titleLabel.font = [UIFont systemFontOfSize:15];
//    btn.enabled = NO;
//    [cell.contentView addSubview:btn];
//
//    return cell;
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    //    NSDictionary *dic = self.billTypeListArray[indexPath.row];
//    //    NSString *billId = [dic stringForColumn:AMPar_dm];
//    //    if (![[[[AMDataProvider sharedObject] billidExplain] allKeys] containsObject:billId] || !billId.length) {
//    //        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    //        return;
//    //    }
//    //    AMBillListViewController *vc = [[AMBillListViewController alloc] initWithBillid:billId withBillName:dic[AMPar_name] parameters:[[NSDictionary alloc] init]];
//    //    [self.navigationController pushViewController:vc animated:YES];
//    //    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//}



@end
