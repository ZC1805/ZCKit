//
//  JFNavigationController.m
//  gobe
//
//  Created by zjy on 2019/3/18.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFNavigationController.h"

@interface JFNavigationController ()

@end

@implementation JFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate {
    if (self.topViewController) {
        return [self.topViewController shouldAutorotate];
    } else {
        return [super shouldAutorotate];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.topViewController) {
        return [self.topViewController supportedInterfaceOrientations];
    } else {
        return [super supportedInterfaceOrientations];
    }
}

@end
