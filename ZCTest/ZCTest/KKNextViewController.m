//
//  KKNextViewController.m
//  ZCTest
//
//  Created by zjy on 2021/7/22.
//

#import "KKNextViewController.h"
#import "ZCKit.h"

@interface KKNextViewController ()

@end

@implementation KKNextViewController

+ (void)load {
    NSLog(@"2-%@", NSStringFromClass(self));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"2";
    self.view.backgroundColor = kZCRGB(0xEEEEEE);
}

+ (void)aa {
    
}

//+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    return nil;
//}

@end
