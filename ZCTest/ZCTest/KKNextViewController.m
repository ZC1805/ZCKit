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
    self.view.backgroundColor = kZCRGB(0xEE8800);
    
    //ZCNaviView *v = [ZCNaviView viewWithAssociate:self title:@"2"];
    //[v setTitle:@"2" rightName:@"2Xx" rightColor:UIColor.redColor];
    //[self.view addSubview:v];
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
