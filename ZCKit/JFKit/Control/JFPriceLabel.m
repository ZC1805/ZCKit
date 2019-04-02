//
//  JFPriceLabel.m
//  ZCKit
//
//  Created by zjy on 2018/6/19.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFPriceLabel.h"

@interface JFPriceLabel ()

@property (nonatomic, strong) UIView *priceline;

@end

@implementation JFPriceLabel

@synthesize priceLineColor = _priceLineColor;

- (void)setIsEnablePriceLine:(BOOL)isEnablePriceLine {
    _isEnablePriceLine = isEnablePriceLine;
    self.priceline.hidden = _isEnablePriceLine != YES;
}

- (void)setPriceLineColor:(UIColor *)priceLineColor {
    _priceLineColor = priceLineColor;
    _priceline.backgroundColor = _priceLineColor;
}

- (UIColor *)priceLineColor {
    if (_priceLineColor == nil) _priceLineColor = ZCRGB(0xbcbcbc);
    return _priceLineColor;
}

- (UIView *)priceline {
    if (_priceline == nil) {
        _priceline = [[UIView alloc] initWithFrame:CGRectZero color:self.priceLineColor];
        [self addSubview:_priceline];
        [_priceline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self).offset(2.0);
            make.centerY.equalTo(self);
            make.height.equalTo(@1.0);
        }];
    }
    return _priceline;
}

@end

