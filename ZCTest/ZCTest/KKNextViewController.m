//
//  KKNextViewController.m
//  ZCTest
//
//  Created by zjy on 2021/7/22.
//

#import "KKNextViewController.h"
#import "ZCTest-Swift.h"
#import "ZCNaviView.h"
#import "ZCKit.h"

@interface KKNextViewController ()

@end

@implementation KKNextViewController

- (BOOL)isPageHiddenNavigationBar {
    return YES;
}

- (BOOL)isNaviUseClearBar {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.title = @"2";
    self.view.backgroundColor = kZCRGB(0xEEEEEE);
    
    [self.view addSubview:[ZCNaviView viewWithTitle:@"2"]];
    
    
    
}

- (void)onPageCustomTapBackAction {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //[self.navigationController pushViewController:[[SwiftViewController alloc] init] animated:YES];
}

@end
