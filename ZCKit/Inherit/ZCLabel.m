//
//  ZCLabel.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCLabel.h"

@implementation ZCLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isUseAutoSize = YES;
    }
    return self;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if (self.isUseAutoSize) {
        [self sizeToFit];
    }
    if (self.textSetBlock) {
        self.textSetBlock();
    }
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    if (self.isUseAutoSize) {
        [self sizeToFit];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (self.fitSize) {
        return [self.fitSize CGSizeValue];
    } else {
        return [super sizeThatFits:size];
    }
}

@end
