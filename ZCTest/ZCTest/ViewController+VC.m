//
//  ViewController+VC.m
//  ZCTest
//
//  Created by zjy on 2021/7/29.
//

#import "ViewController+VC.h"

@implementation ViewController (VC)

+ (void)load {
    NSLog(@"load-%@", NSStringFromClass(self));
}

+ (void)initialize {
    NSLog(@"init-%@", NSStringFromClass(self));
}

@end
