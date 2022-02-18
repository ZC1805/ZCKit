//
//  ZCCountLabel.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCCountLabel.h"
#import "ZCMacro.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark - ~ ZCCountLabelCounterAnim ~
@interface ZCCountLabelCounterLinear : NSObject

@end

@implementation ZCCountLabelCounterLinear

- (CGFloat)update:(CGFloat)t {
    return t;
}

@end


@interface ZCCountLabelCounterEaseIn : NSObject

@end

@implementation ZCCountLabelCounterEaseIn

- (CGFloat)update:(CGFloat)t {
    return powf(t, 3.0);
}

@end


@interface ZCCountLabelCounterEaseOut : NSObject

@end

@implementation ZCCountLabelCounterEaseOut

- (CGFloat)update:(CGFloat)t {
    return (1.0 - powf((1.0 - t), 3.0));
}

@end


@interface ZCCountLabelCounterEaseInOut : NSObject

@end

@implementation ZCCountLabelCounterEaseInOut

- (CGFloat)update:(CGFloat)t {
    t *= 2;
    if (t < 1.0) return (0.5 * powf (t, 3.0));
    else return (0.5 * (2.0 - powf(2.0 - t, 3.0)));
}

@end


#pragma mark - ~ ZCCountLabel ~
@interface ZCCountLabel ()

@property (nonatomic, assign) CGFloat startingValue;

@property (nonatomic, assign) CGFloat destinationValue;

@property (nonatomic, assign) NSTimeInterval progress;

@property (nonatomic, assign) NSTimeInterval lastUpdate;

@property (nonatomic, assign) NSTimeInterval totalTime;

@property (nonatomic, assign) CGFloat easingRate;

@property (nonatomic, strong) CADisplayLink *timer;

@property (nonatomic, strong) id counter;

@end

@implementation ZCCountLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = kZCClear;
        self.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    }
    return self;
}

- (void)countFrom:(CGFloat)value to:(CGFloat)endValue {
    if (self.animationDuration == 0) self.animationDuration = 2.0;
    [self countFrom:value to:endValue withDuration:self.animationDuration];
}

- (void)countFromCurrentValueTo:(CGFloat)endValue {
    [self countFrom:[self currentValue] to:endValue];
}

- (void)countFromCurrentValueTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration {
    [self countFrom:[self currentValue] to:endValue withDuration:duration];
}

- (void)countFromZeroTo:(CGFloat)endValue {
    [self countFrom:0 to:endValue];
}

- (void)countFromZeroTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration {
    [self countFrom:0 to:endValue withDuration:duration];
}

- (void)countFrom:(CGFloat)startValue to:(CGFloat)endValue withDuration:(NSTimeInterval)duration {
    self.startingValue = startValue;
    self.destinationValue = endValue;
    [self.timer invalidate];
    self.timer = nil;
    
    if (duration == 0) {
        [self setTextValue:endValue];
        [self runCompletionBlock];
        return;
    }
    
    self.easingRate = 3.0;
    self.progress = 0;
    self.totalTime = duration;
    self.lastUpdate = [NSDate timeIntervalSinceReferenceDate];
    
    if (self.format == nil) self.format = @"%f";
    switch (self.method) {
        case ZCEnumLabelCountingMethodLinear:
            self.counter = [[ZCCountLabelCounterLinear alloc] init];
            break;
        case ZCEnumLabelCountingMethodEaseIn:
            self.counter = [[ZCCountLabelCounterEaseIn alloc] init];
            break;
        case ZCEnumLabelCountingMethodEaseOut:
            self.counter = [[ZCCountLabelCounterEaseOut alloc] init];
            break;
        case ZCEnumLabelCountingMethodEaseInOut:
            self.counter = [[ZCCountLabelCounterEaseInOut alloc] init];
            break;
    }
    
    CADisplayLink *timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateValue:)];
    timer.frameInterval = 2;
    [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
    self.timer = timer;
}

- (void)updateValue:(NSTimer *)timer {
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    self.progress += now - self.lastUpdate;
    self.lastUpdate = now;
    if (self.progress >= self.totalTime) {
        [self.timer invalidate];
        self.timer = nil;
        self.progress = self.totalTime;
    }
    [self setTextValue:[self currentValue]];
    if (self.progress == self.totalTime) {
        [self runCompletionBlock];
    }
}

- (void)setTextValue:(CGFloat)value {
    if (self.attributedFormatBlock) {
        self.attributedText = self.attributedFormatBlock(value);
    } else if (self.formatBlock) {
        self.text = self.formatBlock(value);
    } else {
        if ([self.format rangeOfString:@"%(.*)d" options:NSRegularExpressionSearch].location != NSNotFound ||
            [self.format rangeOfString:@"%(.*)i"].location != NSNotFound) {
            self.text = [NSString stringWithFormat:self.format, (int)value];
        } else {
            self.text = [NSString stringWithFormat:self.format, value];
        }
    }
}

- (void)setFormat:(NSString *)format {
    _format = format;
    [self setTextValue:self.currentValue]; 
}

- (void)runCompletionBlock {
    if (self.completionBlock) {
        self.completionBlock();
        self.completionBlock = nil;
    }
}

- (CGFloat)currentValue {
    if (self.progress >= self.totalTime) {
        return self.destinationValue;
    }
    CGFloat percent = self.progress / self.totalTime;
    CGFloat updateVal = [self.counter update:percent];
    return self.startingValue + (updateVal * (self.destinationValue - self.startingValue));
}

@end
