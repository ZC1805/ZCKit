//
//  AppDelegate.m
//  ZCTest
//
//  Created by zjy on 2021/7/22.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ZCKitBridge.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    ZCKitBridge.isPrintLog = YES;
    ZCKitBridge.isStrToAccurateFloat = YES;
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    self.window.rootViewController.view.backgroundColor = UIColor.whiteColor;
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
