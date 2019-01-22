//
//  ZCBadgeView.m
//  ZCKit
//
//  Created by admin on 2018/10/25.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCBadgeView.h"
#import "NSString+ZC.h"

@interface ZCBadgeView ()

@property (nonatomic, strong) UIColor *badgeBKColor; //画布颜色

@property (nonatomic, assign) CGFloat badgeCircleWidth; //最外层白圈的宽度

@property (nonatomic, assign) CGFloat badgeTopPadding; //数字顶部到红圈的距离

@property (nonatomic, assign) CGFloat badgeLeftPadding; //数字左部到红圈的距离

@property (nonatomic, assign) BOOL isEllipseStroke; //是否是椭圆，包括大于两个字，汉字，大于9等情况

@end

@implementation ZCBadgeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _badgeCircleWidth = 2.0;
        _badgeBKColor = [UIColor redColor];
        _badgeTextColor = [UIColor whiteColor];
        _badgeTextFont = [UIFont boldSystemFontOfSize:12.0];
        self.backgroundColor  = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame badgeValue:(NSString *)badgeValue {
    if (self = [self initWithFrame:frame]) {
        self.badgeValue = badgeValue;
    }
    return self;
}

- (void)setBadgeTextFont:(UIFont *)badgeTextFont {
    if (!badgeTextFont) badgeTextFont = [UIFont boldSystemFontOfSize:12.0];
    _badgeTextFont = badgeTextFont;
    self.badgeValue = _badgeValue;
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor {
    _badgeTextColor = badgeTextColor;
    self.badgeValue = _badgeValue;
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    _badgeTopPadding = 2.0;
    if (badgeValue.isPureInteger && (badgeValue.integerValue < 0 || badgeValue.integerValue > 9)) {
        _isEllipseStroke = YES;
    } else if (badgeValue.length > 1) {
        _isEllipseStroke = YES;
    } else {
        _isEllipseStroke = NO;
    }
    _badgeLeftPadding = _isEllipseStroke ? 6.0 : 2.0;
    [self badgeFrameStr:badgeValue];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if (self.badgeValue.length) {
        [self drawWithContent:rect context:context];
    } else {
        [self drawWithOutContent:rect context:context];
    }
    CGContextRestoreGState(context);
}

#pragma mark - misc
- (CGSize)badgeSizeStr:(NSString *)badgeStr {
    CGSize size = [badgeStr sizeWithAttributes:@{NSFontAttributeName:self.badgeTextFont}];
    if (size.width < size.height) {
        size = CGSizeMake(size.height, size.height);
    }
    return size;
}

- (void)badgeFrameStr:(NSString *)badgeStr {
    if (!badgeStr.length) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 0);
        return;
    }
    CGSize size = [self badgeSizeStr:badgeStr];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            size.width + self.badgeLeftPadding * 2.0 + self.badgeCircleWidth * 2.0,
                            size.height + self.badgeTopPadding * 2.0 + self.badgeCircleWidth * 2.0); //8=2*2(红圈-文字)+2*2(白圈-红圈)
}

- (void)drawWithOutContent:(CGRect)rect context:(CGContextRef)context {
    CGRect bodyFrame = self.bounds;
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextFillEllipseInRect(context, bodyFrame);
}

- (void)drawWithContent:(CGRect)rect context:(CGContextRef)context {
    CGRect bodyFrame = self.bounds;
    CGRect bkgFrame = CGRectInset(self.bounds, self.badgeCircleWidth, self.badgeCircleWidth);
    CGRect badgeSize = CGRectInset(self.bounds, self.badgeCircleWidth + self.badgeLeftPadding, self.badgeCircleWidth + self.badgeTopPadding);
    if (self.badgeBKColor) { //外白色描边
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        if (self.isEllipseStroke) {
            CGFloat widTotal = bodyFrame.size.width;
            CGFloat widCircle = bodyFrame.size.height;
            CGFloat widDiff = widTotal - widCircle;
            CGPoint originPoint = bodyFrame.origin;
            CGRect leftCicleFrame = CGRectMake(originPoint.x, originPoint.y, widCircle, widCircle);
            CGRect centerFrame = CGRectMake(originPoint.x + widCircle / 2.0, originPoint.y, widDiff, widCircle);
            CGRect rightCicleFrame = CGRectMake(originPoint.x + widTotal - widCircle, originPoint.y, widCircle, widCircle);
            CGContextFillEllipseInRect(context, leftCicleFrame);
            CGContextFillRect(context, centerFrame);
            CGContextFillEllipseInRect(context, rightCicleFrame);
        } else {
            CGContextFillEllipseInRect(context, bodyFrame);
        }
        CGContextSetFillColorWithColor(context, self.badgeBKColor.CGColor); //背景色
        if (self.isEllipseStroke) {
            CGFloat widTotal = bkgFrame.size.width;
            CGFloat widCircle = bkgFrame.size.height;
            CGFloat widDiff = widTotal - widCircle;
            CGPoint originPoint = bkgFrame.origin;
            CGRect leftCicleFrame = CGRectMake(originPoint.x, originPoint.y, widCircle, widCircle);
            CGRect centerFrame = CGRectMake(originPoint.x + widCircle / 2.0, originPoint.y, widDiff, widCircle);
            CGRect rightCicleFrame = CGRectMake(originPoint.x + widTotal - widCircle, originPoint.y, widCircle, widCircle);
            CGContextFillEllipseInRect(context, leftCicleFrame);
            CGContextFillRect(context, centerFrame);
            CGContextFillEllipseInRect(context, rightCicleFrame);
        } else {
            CGContextFillEllipseInRect(context, bkgFrame);
        }
    }
    CGContextSetFillColorWithColor(context, self.badgeTextColor.CGColor);
    NSMutableParagraphStyle *badgeTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [badgeTextStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [badgeTextStyle setAlignment:NSTextAlignmentCenter];
    NSDictionary *badgeTextAttributes = @{NSFontAttributeName:self.badgeTextFont,
                                          NSForegroundColorAttributeName:self.badgeTextColor,
                                          NSParagraphStyleAttributeName:badgeTextStyle};
    CGRect draw = CGRectMake(self.badgeCircleWidth + self.badgeLeftPadding, self.badgeCircleWidth + self.badgeTopPadding,
                             badgeSize.size.width, badgeSize.size.height);
    [self.badgeValue drawInRect:draw withAttributes:badgeTextAttributes];
}

@end