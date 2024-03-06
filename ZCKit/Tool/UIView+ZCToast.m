//
//  UIView+ZCToast.m
//  ZCKit
//
//  Created by admin on 2018/10/12.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIView+ZCToast.h"
#import "ZCImageView.h"
#import "ZCKitBridge.h"
#import "ZCMacro.h"
#import "ZCLabel.h"
#import <objc/runtime.h>

static const CGFloat ZCToastVerticalPadding = 8.0;
static const CGFloat ZCToastHorizontalPadding = 12.0;
static const NSTimeInterval ZCToastDefaultDuration = 2.0;
static const NSString *ZCToastTapActionKey = @"ZCToastTapActionKey";

@implementation UIView (ZCToast)

#pragma mark - Toast
- (void)makeToast:(NSString *)message {
    if (!message.length) return;
    NSTimeInterval duration = 2.0 + message.length / 40;
    [self makeToast:message duration:duration position:ZCEnumToastPositionCenter title:nil image:nil];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(ZCEnumToastPosition)position {
    if (!message.length || duration < 0.1) return;
    [self makeToast:message duration:duration position:position title:nil image:nil];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(ZCEnumToastPosition)position title:(NSString *)title image:(UIImage *)image {
    UIView *toast = [self viewForMessage:message title:title image:image];
    [self showToast:toast duration:duration position:position action:nil];
}

- (void)showToast:(UIView *)toast {
    [self showToast:toast duration:ZCToastDefaultDuration position:ZCEnumToastPositionCenter action:nil];
}

- (void)showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(ZCEnumToastPosition)position {
    [self showToast:toast duration:duration position:position action:nil];
}

#pragma mark - Mine
- (void)showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(ZCEnumToastPosition)position action:(void (^)(void))action {
    if (toast == nil) return;
    if (duration < 0.5) duration = 0.5;
    if (position < ZCEnumToastPositionCenter || position > ZCEnumToastPositionBottom) position = ZCEnumToastPositionCenter;
    toast.center = [self centerPointForPosition:position withToast:toast];
    toast.alpha = 0;
    [self addSubview:toast];
    if (action) {
        objc_setAssociatedObject(toast, &ZCToastTapActionKey, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:toast action:@selector(handleToastTapped:)];
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction) animations:^{
        toast.alpha = 1;
    } completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideToast:toast tap:action];
    });
}

- (void)hideToast:(UIView *)toast tap:(void(^)(void))action {
    if (toast == nil) return;
    if (action) objc_removeAssociatedObjects(toast);
    [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionBeginFromCurrentState) animations:^{
        toast.alpha = 0;
    } completion:^(BOOL finished) {
        [toast removeFromSuperview];
    }];
}

- (void)handleToastTapped:(UITapGestureRecognizer *)recognizer {
    void(^action)(void) = objc_getAssociatedObject(self, &ZCToastTapActionKey);
    if (action) { action(); action = nil; } //暂时是等延迟执行到了时间再销毁
    [self hideToast:recognizer.view tap:action];
}

#pragma mark - Helpers
- (CGPoint)centerPointForPosition:(ZCEnumToastPosition)position withToast:(UIView *)toast {
    if (position == ZCEnumToastPositionCenter) {
        return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    } else if (position == ZCEnumToastPositionTop) {
        return CGPointMake(self.bounds.size.width / 2, toast.frame.size.height / 2 + 21.0);
    } else {
        return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - 34.0 - toast.frame.size.height / 2);
    }
}

- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
}

- (UIView *)viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    if ((message == nil) && (title == nil) && (image == nil)) return nil;
    ZCLabel *messageLabel = nil;
    ZCLabel *titleLabel = nil;
    ZCImageView *imageView = nil;
    UIView *wrapperView = [[UIView alloc] initWithFrame:CGRectZero];
    wrapperView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                   UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    wrapperView.layer.cornerRadius = 8.0;
    wrapperView.layer.shadowColor = ZCKitBridge.toastBackGroundColor.CGColor;
    wrapperView.layer.shadowOffset = CGSizeMake(1.5, 1.5);
    wrapperView.layer.shadowOpacity = 0.6;
    wrapperView.layer.shadowRadius = 5.0;
    wrapperView.backgroundColor = kZCA(ZCKitBridge.toastBackGroundColor, 0.8);
    
    CGFloat left = ZCToastHorizontalPadding, top = ZCToastVerticalPadding;
    CGFloat width = self.bounds.size.width * 0.8 - 2.0 * left, height = self.bounds.size.height * 0.8 - 2.0 * top;
    if (image != nil) {
        imageView = [[ZCImageView alloc] initWithFrame:CGRectZero image:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sizeToFit];
        imageView.frame = CGRectMake(left, top, imageView.bounds.size.width, imageView.bounds.size.height);
        left = left + imageView.bounds.size.width + ZCToastHorizontalPadding;
        width = width - imageView.bounds.size.width - ZCToastHorizontalPadding;
        [wrapperView addSubview:imageView];
    }
    if (title != nil) {
        titleLabel = [[ZCLabel alloc] initWithColor:ZCKitBridge.toastTextColor font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16] alignment:NSTextAlignmentCenter adjustsSize:NO];
        titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        titleLabel.backgroundColor = kZCClear;
        titleLabel.numberOfLines = 1;
        titleLabel.text = title;
        CGSize maxSize = CGSizeMake(width, height);
        CGSize titleSize = [self sizeForString:title font:titleLabel.font constrainedToSize:maxSize lineBreakMode:titleLabel.lineBreakMode];
        titleLabel.frame = CGRectMake(left, top, titleSize.width, titleSize.height);
        top = top + titleSize.height + ZCToastVerticalPadding;
        height = height - titleSize.height - ZCToastVerticalPadding;
        [wrapperView addSubview:titleLabel];
    }
    if (message != nil) {
        messageLabel = [[ZCLabel alloc] initWithColor:ZCKitBridge.toastTextColor font:[UIFont fontWithName:@"HelveticaNeue" size:15] alignment:NSTextAlignmentCenter adjustsSize:NO];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.backgroundColor = kZCClear;
        messageLabel.numberOfLines = 0;
        messageLabel.text = message;
        CGSize maxSize = CGSizeMake(width, height);
        CGSize msgSize = [self sizeForString:message font:messageLabel.font constrainedToSize:maxSize lineBreakMode:messageLabel.lineBreakMode];
        messageLabel.frame = CGRectMake(left, top, msgSize.width, msgSize.height);
        top = top + msgSize.height + ZCToastVerticalPadding;
        [wrapperView addSubview:messageLabel];
    }
    CGFloat right = MAX(titleLabel.bounds.size.width, messageLabel.bounds.size.width);
    width = left + (right ? (right + ZCToastHorizontalPadding) : 0);
    height = MAX(top, imageView.bounds.size.height + 2.0 * ZCToastVerticalPadding);
    CGFloat offset = (height - top) / 2.0;
    wrapperView.frame = CGRectMake(0, 0, width, height);
    imageView.center = CGPointMake(imageView.center.x, height / 2.0);
    titleLabel.center = CGPointMake((width - left - ZCToastHorizontalPadding) / 2.0 + left, titleLabel.center.y + MAX(offset, 0));
    messageLabel.center = CGPointMake((width - left - ZCToastHorizontalPadding) / 2.0 + left, messageLabel.center.y + MAX(offset, 0));
    return wrapperView;
}

@end
