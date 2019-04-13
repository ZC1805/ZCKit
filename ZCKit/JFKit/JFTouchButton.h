//
//  JFTouchButton.h
//  gobe
//
//  Created by zjy on 2019/3/23.
//  Copyright © 2019 com.jinfeng.credit. All rights reserved.
//

#import "ZCButton.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JFEnumTouchButtonStyle) {
    JFEnumTouchButtonStyleYellow    = 0,  //黄色
    JFEnumTouchButtonStyleTint      = 1,  //黄色(有选择样式)
    JFEnumTouchButtonStyleGray      = 2,  //深灰色样式
    JFEnumTouchButtonStyleLightGray = 3,  //亮灰色样式
};

@interface JFTouchButton : ZCButton  //默认宽是距离屏幕左右各ZSA(15)，高ZSA(46)

@property (nonatomic, strong, readonly) CALayer *shadowlayer;  //阴影图层

+ (instancetype)style:(JFEnumTouchButtonStyle)style title:(nullable NSString *)title obj:(nullable id)obj sel:(nullable SEL)sel;

@end

NS_ASSUME_NONNULL_END
