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

@property (nonatomic, assign) CGFloat leftSpace;  /**< 左边空余位置，leftview有就不设置，暂无leftview */

@property (nullable, nonatomic, strong) UIImage *leftImage;  /**< 设置左侧imageView */

@property (nonatomic, assign, readonly) NSInteger currentOffset;  /**< 基于文首计算出到光标的偏移数值 */

@property (nonatomic, assign, readonly) NSRange currentSelectRange;  /**< 计算当前选择的Range */


/**< 带字体的初始化和占位文字的初始化，color为textColor */
- (instancetype)initWithFrame:(CGRect)frame holder:(nullable NSString *)holder font:(UIFont *)font color:(UIColor *)color;

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

