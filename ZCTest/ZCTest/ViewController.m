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

@interface ViewController ()

@end

@implementation ViewController

+ (void)load {
    NSLog(@"1-%@", NSStringFromClass(self));
    [[VCIdManager share].vcs addObject:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"1";
    self.view.backgroundColor = ZCRGB(0xEE88AA);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController pushViewController:[NSClassFromString(@"NextViewController") new] animated:YES];
}

@end
