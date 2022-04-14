//
//  AppDelegate.m
//  ZCTest
//
//  Created by zjy on 2021/7/22.
//

#import "AppDelegate.h"
#import "KKViewController.h"
#import "ZCTabBarController.h"
#import "ZCNavigationController.h"
#import "ZCKitBridge.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    ZCKitBridge.isPrintLog = YES;
    ZCKitBridge.classNamePrefix = @"KK";
    ZCKitBridge.isStrToAccurateFloat = YES;
    ZCKitBridge.naviBarImageOrColor = @"#CCCCCC";
    ZCKitBridge.naviBarTitleColor = @"#0000FF";

    
    UINavigationController *nvc = [[ZCNavigationController alloc] initWithRootViewController:[[KKViewController alloc] init]];
    nvc.view.backgroundColor = UIColor.whiteColor;
    nvc.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:0];
    UITabBarController *tab = [[ZCTabBarController alloc] init];
    tab.view.backgroundColor = UIColor.whiteColor;
    tab.viewControllers = @[nvc];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
