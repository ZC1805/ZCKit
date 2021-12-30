//
//  NSNumber+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/27.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCDecimalManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (ZC)

+ (nullable NSNumber *)numberWithString:(NSString *)string;

@end


@interface NSDecimalNumber (ZC)

+ (NSDecimalNumber *)nOne;

+ (NSDecimalNumber *)decimalString:(nullable NSString *)strValue;

+ (NSDecimalNumber *)decimalInteger:(long)lonValue;

+ (NSDecimalNumber *)decimalDouble:(double)douValue;

+ (NSDecimalNumber *)decimalNumber:(nullable NSNumber *)number;  

- (NSDecimalNumber *)decimalRound:(short)decimal mode:(ZCEnumRoundType)mode;

- (NSDecimalNumber *)decimalPrecise;

- (NSDecimalNumber *)plus:(NSDecimalNumber *)number;

- (NSDecimalNumber *)minus:(NSDecimalNumber *)number;

- (NSDecimalNumber *)mltiply:(NSDecimalNumber *)number;

- (NSDecimalNumber *)divide:(NSDecimalNumber *)number;

- (NSDecimalNumber *)raisingToPower:(NSUInteger)power;

- (NSDecimalNumber *)mltiplyPower10:(short)power;

- (BOOL)less:(NSDecimalNumber *)number;

- (BOOL)more:(NSDecimalNumber *)number;

- (BOOL)equal:(NSDecimalNumber *)number;

- (NSString *)priceValue;

- (BOOL)isANumber;

@end

NS_ASSUME_NONNULL_END
