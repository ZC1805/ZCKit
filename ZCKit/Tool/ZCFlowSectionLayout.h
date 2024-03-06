//
//  ZCFlowSectionLayout.h
//  ZCKit
//
//  Created by admin on 2019/1/11.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCFlowSectionLayout : UICollectionViewLayout  /**< 纵向排列或者横向分页排列布局 */

@property (nonatomic, assign, readonly) CGSize itemSize;  /**< 每项的大小 */

@property (nonatomic, assign, readonly) CGSize sectionHeaderSize;  /**< 分区头的大小 */

/**< 初始化方法，分别为宽度、每行数、是否水平排列即是否水平左右滑动 */
- (instancetype)initWithContainerWidth:(CGFloat)containerWidth lineCount:(int)lineCount isHorLayout:(BOOL)isHorLayout;

/**< 重置布局信息 */
- (void)resetHorSpace:(CGFloat)horSpace verSpace:(CGFloat)verSpace sectionInsets:(UIEdgeInsets)sectionInsets itemHei:(CGFloat)itemHei sectionHeaderHei:(CGFloat)sectionHeaderHei;

/**< 重置布局信息 */
- (void)resetAdditionalHei:(CGFloat)additionalHei;

@end

NS_ASSUME_NONNULL_END
