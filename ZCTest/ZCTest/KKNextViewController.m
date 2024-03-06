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
#import "ZCTabBarController.h"
#import "ZCNavigationController.h"
#import "KK1ViewController.h"
#import "KK2ViewController.h"

@interface KKNextViewController ()

@end

@implementation KKNextViewController

- (void)onPageCustomInitSet:(ZCViewControllerCustomPageSet *)customPageSet {
//    customPageSet.isNaviUseClearBar = NO;
//    customPageSet.isNaviUseShieldBarLine = NO;
//    customPageSet.isNaviUseBarShadowColor = YES;
    customPageSet.isPageHiddenNavigationBar = YES;
//    customPageSet.isPageShieldInteractivePop = NO;
//    customPageSet.naviUseCustomBackgroundName = @"#FF0000";
//    customPageSet.naviUseCustomTitleColor = @"#FFFFFF";
//    customPageSet.naviUseCustomBackArrowImage = kZIN(@"zc_image_back_black");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"2";
    self.view.backgroundColor = kZCRGBA(0xEE8800, 0.3);
    
    //ZCNaviView *v = [ZCNaviView viewWithAssociate:self title:@"2"];
    //[v setTitle:@"2" rightName:@"2Xx" rightColor:UIColor.redColor];
    //[self.view addSubview:v];
    
    
    
    UIView *redVi = [[UIView alloc] initWithFrame:CGRectZero color:UIColor.whiteColor];
    redVi.center = CGPointMake(100, 100);
    redVi.bounds = CGRectMake(-20, -50, 100, kZSA(100));
    redVi.transform = CGAffineTransformTranslate(redVi.transform, 50, 0);
    //redVi.transform = CGAffineTransformTranslate(redVi.transform, 50, 0);
    //redVi.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [self.view addSubview:redVi];
    kZLog(@"----->>>>>frame:%@   bounds:%@   center:%@", NSStringFromCGRect(redVi.frame), NSStringFromCGRect(redVi.bounds), NSStringFromCGPoint(redVi.center));
    
    ZCLabel *lab = [[ZCLabel alloc] initWithColor:UIColor.whiteColor font:kZFR(10) alignment:NSTextAlignmentLeft adjustsSize:YES];
    lab.frame = CGRectMake(0, 0, 80, 20);
    lab.text = @"ZXCY UREA";
    lab.backgroundColor = UIColor.greenColor;
    [redVi addSubview:lab];
    
    
    
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UINavigationController *nvc1 = [[ZCNavigationController alloc] initWithRootViewController:[[KK1ViewController alloc] init]];
    nvc1.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:0];
    nvc1.hidesBottomBarWhenPushed = NO;
    
    UINavigationController *nvc2 = [[ZCNavigationController alloc] initWithRootViewController:[[KK2ViewController alloc] init]];
    nvc2.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
    nvc2.hidesBottomBarWhenPushed = NO;
    
    UITabBarController *tab = [[ZCTabBarController alloc] init];
    tab.viewControllers = @[[[KK1ViewController alloc] init], [[KK2ViewController alloc] init]];
    //self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:tab animated:YES];
}

@end
