//
//  NextViewController.m
//  ZCTest
//
//  Created by zjy on 2021/7/22.
//

#import "NextViewController.h"
#import "ZCKit.h"
#import "VCIdManager.h"

@interface NextViewController ()

@end

@implementation NextViewController

+ (void)load {
    NSLog(@"2-%@", NSStringFromClass(self));
    [[VCIdManager share].vcs addObject:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"2";
    self.view.backgroundColor = kZCRGB(0xEEEEEE);
}

@end
