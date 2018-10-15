//
//  ZCDateManager.h
//  ZCKit
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCDateManager : NSObject

@property (nonatomic, strong) NSLocale *chinaLocale;

@property (nonatomic, strong) NSTimeZone *beijingTimeZone;

+ (instancetype)instance;

+ (NSDateFormatter *)dateFormatter:(nullable NSString *)format;   /**< 此处拿到的DateFormatter有缓存，外部不可对其属性赋值 */

@end

NS_ASSUME_NONNULL_END

