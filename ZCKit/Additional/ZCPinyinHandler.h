//
//  ZCPinyinHandler.h
//  ZCKit
//
//  Created by admin on 2019/1/9.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCPinyinHandler : NSObject  /**< 拼音处理类 */

+ (void)saveSpellCache;  /**< 写入缓存 */

+ (NSString *)fullSpell:(NSString *)source;  /**< 全拼小写 */

+ (NSString *)shortSpell:(NSString *)source;  /**< 简拼小写 */

+ (NSString *)firstLetter:(NSString *)input;  /**< 拼写首字母小写 */

@end

NS_ASSUME_NONNULL_END
