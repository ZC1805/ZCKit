//
//  JFNetworkRequest.m
//  ZCKit
//
//  Created by zjy on 2018/4/27.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFNetworkRequest.h"

@interface JFNetworkRequest ()

@end

@implementation JFNetworkRequest

@synthesize parameter = _parameter;

- (JFNetworkParameter *)parameter {
    if (!_parameter) {
        _parameter = [[JFNetworkParameter alloc] init];
    }
    return _parameter;
}
#warning - xxxx & 侧滑手势不可透传
///** 一次性请求，返回了再次请求下一个 */
//- (void)impOncePost:(NSString *)cmd response:(void(^)(id response, NSError *error))response {
//    if (self.concurrencyRequest == NO && self.parameter.var_loading) return;
//    self.parameter.var_loading = YES;
//    NSDictionary *par = [self.parameter injectPropertyToParameter];
//    [[JFBaseManager manager] POSTCmd:cmd par:par success:^(id responseObject) {
//        self.parameter.var_loading = NO;
//        if (response) {
//            if (responseObject == nil || responseObject == NULL) {
//                NSError *error = [NSError errorWithDomain:cmd code:-1004 userInfo:@{@"errorMsg" : NSLocalizedString(@"数据异常！", nil)}];
//                response(nil, error);
//            } else {
//                response(responseObject, nil);
//            }
//        }
//    } failure:^(NSError *error) {
//        self.parameter.var_loading = NO;
//        if (response) response(nil, error);
//    }];
//}
//
//#pragma mark - 我的问价
//- (void)requestMineAskingPriceList:(void(^)(NSArray *list, BOOL last, long wait, NSString *warning))callback {
//    [self impOncePost:cmd_store_offer_findMyProductOffer response:^(id response, NSError *error) {
//        if (error) {
//            if (callback) callback(nil, NO, 0, [self errorString:error]);
//        } else {
//            BOOL last = NO;
//            long wait = 0;
//            NSArray *list = nil;
//            NSArray *array = [response checkInvalidKeys:@"content", @"last", @"askWaitTime", nil];
//            if (array && DEFObjectIsValidArray(array[0])) list = array[0];
//            if (array && array[1]) last = [array[1] boolValue];
//            if (array && array[2]) wait = MAX(0, [array[2] intValue]);
//            if (list && list.count) {
//                if (callback) callback(list, last, wait, nil);
//            } else {
//                if (callback) callback(list, last, wait, @"");
//            }
//        }
//    }];
//}
//
//#pragma mark - 问价列表
//- (void)requestCityAskingPriceList:(void(^)(NSArray <NSArray *>*list, NSString *warning))callback {
//    [self impOncePost:cmd_order_offer_list response:^(id response, NSError *error) {
//        if (error) {
//            if (callback) callback(nil, [self errorString:error]);
//        } else {
//            NSMutableArray *list = [NSMutableArray array];
//            NSArray *arr = [response checkInvalidKeys:@"markList", nil];
//            if (arr && DEFObjectIsValidArray(arr[0])) {
//                NSArray *dics = arr[0];
//                for (NSDictionary *dic in dics) {
//                    if (DEFObjectIsValidDictionary(dic)) {
//                        NSArray *items = [dic arrayValueForKey:@"productList"];
//                        if (DEFObjectIsValidArray(items)) [list addObject:items];
//                    }
//                }
//            }
//            if (callback) callback(list, (list && list.count) ? nil : @"");
//        }
//    }];
//}
//

@end

























