//
//  UITextField+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (ZC)

/** 左边空余位置，暂无leftview */
@property (nonatomic, assign) float leftSpace;   /**< 左边空余位置，leftview有就不设置，暂无leftview */

@property (nonatomic, assign, readonly) NSRange currentRange;   /**< 计算当前选择的Range */

@property (nonatomic, assign, readonly) NSInteger currentOffset;   /**< 基于文首计算出到光标的偏移数值 */

/** 初始化 */
- (instancetype)initWithFrame:(CGRect)frame holder:(nullable NSString *)holder font:(nullable UIFont *)font color:(nullable UIColor *)color;

/** 选定所有文本 */
- (void)selectAllText;

/** 选定目标范围文本 */
- (void)setSelectedRange:(NSRange)range;

/** 基于文首设置光标位置 */
- (void)makeOffsetPosition:(NSInteger)position;

/** 实现原理是先获取一个基于文尾的偏移，然后加上要施加的偏移，再重新根据文尾计算位置，最后利用选取来实现光标定位 */
- (void)makeOffset:(NSInteger)offset;

/** 先把光标移动到文首，然后再调用上面实现的偏移函数 */
- (void)makeOffsetFromBeginning:(NSInteger)offset;

@end

NS_ASSUME_NONNULL_END










