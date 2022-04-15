//
//  KK2ViewController.m
//  ZCTest
//
//  Created by zjy on 2022/4/15.
//

#import "KK2ViewController.h"
#import "ZCMacro.h"

@interface KK2ViewController ()

@end

@implementation KK2ViewController

- (void)onPageCustomInitSet:(ZCViewControllerCustomPageSet *)customPageSet {
    customPageSet.isNaviUseClearBar = NO;
    customPageSet.isNaviUseShieldBarLine = NO;
    customPageSet.isNaviUseBarShadowColor = NO;
    customPageSet.isPageHiddenNavigationBar = NO;
    customPageSet.isPageShieldInteractivePop = NO;
    customPageSet.naviUseCustomBackgroundName = @"#008800";
    customPageSet.naviUseCustomTitleColor = @"#880088";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"3-2";
    self.view.backgroundColor = UIColor.lightGrayColor;
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //[self.navigationController presentViewController:[NSClassFromString(@"KK1ViewController") new] animated:YES completion:nil];
}

@end
