//
//  JFPriceLabel.h
//  ZCKit
//
//  Created by zjy on 2018/6/19.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFPriceLabel : UILabel

@property (nonatomic, assign) BOOL isEnablePriceLine;  /**< 是否显示划横线，默认NO */

@property (nonatomic, strong) UIColor *priceLineColor;  /**< 横线颜色，默认0xbcbcbc */

@end

NS_ASSUME_NONNULL_END
