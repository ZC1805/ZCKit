//
//  ZCFPSLabel.m
//  ZCKit
//
//  Created by admin on 2018/10/26.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCFPSLabel.h"

@implementation ZCFPSLabel {
    NSUInteger _count;
    CADisplayLink *_link;
    NSTimeInterval _lastTime;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) frame.size = CGSizeMake(65.0, 20.0);
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        self.textColor = [UIColor redColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont systemFontOfSize:15.0];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(65.0, 20.0);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self FPSResume];
    } else {
        [self FPSInvalidate];
    }
}

- (void)FPSInvalidate; {
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
