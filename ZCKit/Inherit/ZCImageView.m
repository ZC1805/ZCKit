//
//  ZCImageView.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCImageView.h"
#import "ZCMacro.h"

@implementation ZCImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kZCClear;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super initWithImage:image]) {
        self.backgroundColor = kZCClear;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image interact:(BOOL)interact {
    if (self = [self initWithFrame:frame]) {
        self.userInteractionEnabled = interact;
        self.image = image;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image {
    if (self = [self initWithFrame:frame]) {
        self.image = image;
    }
    return self;
}

@end
