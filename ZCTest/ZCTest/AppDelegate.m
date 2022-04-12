//
//  AppDelegate.m
//  ZCTest
//
//  Created by zjy on 2021/7/22.
//

#import "AppDelegate.h"
#import "KKViewController.h"
#import "ZCKitBridge.h"
#import "ZCGlobal.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ZCKitBridge.isPrintLog = YES;
    ZCKitBridge.classNamePrefix = @"KK";
    ZCKitBridge.isStrToAccurateFloat = YES;
    ZCKitBridge.naviBackImage = [ZCGlobal ZCImageName:@"zc_image_back_black"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[KKViewController alloc] init]];
    self.window.rootViewController.view.backgroundColor = UIColor.whiteColor;
    self.window.rootViewController.view.backgroundColor = UIColor.whiteColor;
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
