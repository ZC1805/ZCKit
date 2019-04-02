//
//  JFOfficer.m
//  gobe
//
//  Created by zjy on 2019/3/15.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFOfficer.h"
#import "ZCService.h"
#import "ZCKitBridge.h"

@implementation JFOfficer

+ (instancetype)sharedOfficer {
    static dispatch_once_t onceToken;
    static JFOfficer *instace = nil;
    dispatch_once(&onceToken, ^{
        instace = [[JFOfficer alloc] init];
        [instace initValue];
        [instace initSetting];
    });
    return instace;
}

#pragma mark - set & get
- (NSString *)basicUrl {
    switch (_runServer) {
        case JFEnumRunServerTest:{
            return @"";
        } break;
        case JFEnumRunServerInside:{
            return @"";
        } break;
        case JFEnumRunServerFormal:{
            return @"";
        } break;
    }
}

- (NSString *)basicApi {
    switch (_runServer) {
        case JFEnumRunServerTest:{
            return @"";
        } break;
        case JFEnumRunServerInside:{
            return @"";
        } break;
        case JFEnumRunServerFormal:{
            return @"";
        } break;
    }
}

#pragma mark - init
- (void)initValue {
    _appkeyPath = @"gode";
}

- (void)initSetting {
    ZCKitBridge.isPrintLog = NO;
    //小金条
    ZCKitBridge.naviBackImageName = @"i_home_back";
    ZCKitBridge.naviBarImageOrColor = @"0xFFFFFF";
    ZCKitBridge.naviBarTitleColor = @"#222222";
}


- (void)start {
    [ZCServiceManager fire:@""];
    
}

- (void)stop {
    [ZCServiceManager destory];
}

@end
