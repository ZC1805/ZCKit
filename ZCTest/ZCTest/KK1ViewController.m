//
//  KK1ViewController.m
//  ZCTest
//
//  Created by zjy on 2022/4/15.
//

#import "KK1ViewController.h"
#import "ZCMacro.h"

@interface KK1ViewController ()

@end

@implementation KK1ViewController

- (void)onPageCustomInitSet:(ZCViewControllerCustomPageSet *)customPageSet {
    customPageSet.isNaviUseClearBar = NO;
    customPageSet.isNaviUseShieldBarLine = NO;
    customPageSet.isNaviUseBarShadowColor = NO;
    customPageSet.isPageHiddenNavigationBar = NO;
    customPageSet.isPageShieldInteractivePop = NO;
    customPageSet.naviUseCustomBackgroundName = @"#880088";
    customPageSet.naviUseCustomTitleColor = @"#008800";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"3-1";
    self.view.backgroundColor = UIColor.lightGrayColor;
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //[self dismissViewControllerAnimated:YES completion:nil];
}

@end
