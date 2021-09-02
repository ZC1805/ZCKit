//
//  ZCFPSLabel.m
//  ZCKit
//
//  Created by admin on 2018/10/26.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCFPSLabel.h"
#import "ZCMacro.h"

@implementation ZCFPSLabel {
    NSUInteger _count;
    CADisplayLink *_link;
    NSTimeInterval _lastTime;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) frame.size = CGSizeMake(15 * 4 + 5, 20);
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = NO;
        self.backgroundColor = kZCClear;
        self.textColor = kZCRGB(0xFF0000);
        self.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(15 * 4 + 5, 20);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self FPSResume];
    } else {
        [self FPSInvalidate];
    }
}

- (void)FPSInvalidate {
    [_link invalidate];
    _link = nil;
    self.text = nil;
}

- (void)FPSResume {
    [self FPSInvalidate];
    _count = 0;
    _lastTime = 0;
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp; return;
    }
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    self.text = [NSString stringWithFormat:@"%d FPS", (int)round(fps)];
}

@end
