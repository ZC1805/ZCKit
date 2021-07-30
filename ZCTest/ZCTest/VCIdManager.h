//
//  VCIdManager.h
//  ZCTest
//
//  Created by zjy on 2021/7/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCIdManager : NSObject

@property (nonatomic, strong) NSMutableArray *vcs;

+ (instancetype)share;

@end

NS_ASSUME_NONNULL_END
