//
//  UINavigationItem+ZC.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UINavigationItem+ZC.h"
#import "UIViewController+ZC.h"
#import "ZCViewController.h"
#import "ZCQueueHandler.h"
#import "ZCKitBridge.h"
#import "UIView+ZC.h"
#import "ZCButton.h"
#import "ZCMacro.h"

@implementation UINavigationItem (ZC)

- (ZCButton *)itemCustomBackTitle:(NSString *)title color:(UIColor *)color image:(UIImage *)image {
    CGFloat offset = 8.0;
    CGFloat height = 32.0;
    UIImage *iamgeIm = image;
    if (title == nil) title = @"";
    if (color == nil) color = ZCWhite;
    if (!iamgeIm) iamgeIm = ZCKitBridge.naviBackImage;
    iamgeIm = [iamgeIm imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ZCButton *back = [ZCButton buttonWithType:UIButtonTypeCustom];
    [back setTitle:title forState:UIControlStateNormal];
    [back setTitle:title forState:UIControlStateHighlighted];
    [back setTitleColor:color forState:UIControlStateNormal];
    [back setTitleColor:ZCCA(color, 0.3) forState:UIControlStateHighlighted];
    [back setImage:iamgeIm forState:UIControlStateNormal];
    [back setImage:[iamgeIm imageWithAlpha:0.3] forState:UIControlStateHighlighted];
    [back addTarget:self action:@selector(onManualPop:) forControlEvents:UIControlEventTouchUpInside];
    back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    back.adjustsImageWhenHighlighted = YES;
    back.titleLabel.font = ZCFS(15);
    CGSize size = [back.titleLabel sizeThatFits:CGSizeMake(100.0, height)];
    back.size = CGSizeMake(MAX(size.width + 18.0, height), height);
    back.responseTouchInterval = 0.3;
    back.responseAreaExtend = UIEdgeInsetsMake(10, 10, 10, 10);
    back.imageEdgeInsets = UIEdgeInsetsMake(-ZSSepHei, -offset, 0, 0);
    back.titleEdgeInsets = UIEdgeInsetsMake(-ZSSepHei, -offset, 0, 0);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.leftItemsSupplementBackButton = NO;
    self.leftBarButtonItem = item;
    self.hidesBackButton = YES;
    return back;
}

- (void)onManualPop:(id)sender {
    UIViewController *vc = [ZCGlobal currentController];
    if (vc == nil) return;
    BOOL isCanBack = YES;
    if ([vc respondsToSelector:@selector(isCanResponseTouchPop)]) {
        isCanBack = [(id<ZCViewControllerBackProtocol>)vc isCanResponseTouchPop];
    }
    if (isCanBack) {
        main_imp(^{
            if ([vc respondsToSelector:@selector(onCustomBackAction)]) {
                [(id<ZCViewControllerBackProtocol>)vc onCustomBackAction];
            } else {
                [vc backToUpControllerAnimated:YES];
            }
        });
    }
}

- (ZCButton *)itemRightOneItem:(NSString *)item color:(UIColor *)color target:(id)target action:(SEL)action {
    CGFloat height = 32.0;
    if (item == nil) item = @"";
    if (color == nil) color = ZCWhite;
    ZCButton *rightBtn = [ZCButton buttonWithType:UIButtonTypeCustom];
    UIImage *iamgeIm = [ZCIN(item) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (iamgeIm) {
        [rightBtn setImage:iamgeIm forState:UIControlStateNormal];
        [rightBtn setImage:[iamgeIm imageWithAlpha:0.3] forState:UIControlStateHighlighted];
    } else {
        [rightBtn setTitle:item forState:UIControlStateNormal];
        [rightBtn setTitle:item forState:UIControlStateHighlighted];
        [rightBtn setTitleColor:color forState:UIControlStateNormal];
        [rightBtn setTitleColor:ZCCA(color, 0.3) forState:UIControlStateHighlighted];
    }
    if (target && action && [target respondsToSelector:action]) {
        [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBtn.adjustsImageWhenHighlighted = YES;
    rightBtn.titleLabel.font = ZCFS(15);
    rightBtn.titleLabel.numberOfLines =0;
    CGSize size = [rightBtn.titleLabel sizeThatFits:CGSizeMake(100.0, height)];
    rightBtn.size = CGSizeMake(MAX(size.width, 30.0), height);
    rightBtn.responseTouchInterval = 0.3;
    rightBtn.responseAreaExtend = UIEdgeInsetsMake(10, 10, 10, 10);
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    return rightBtn;
}

- (ZCButton *)itemAddRightImage:(NSString *)image target:(id)target action:(SEL)action {
    CGFloat height = 32.0, width = 30.0, offset = 5.0;
    UIImage *iamgeIm = [ZCIN(image) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ZCButton *rightBtn = [ZCButton buttonWithType:UIButtonTypeCustom]; //size 32 * 32 image 22 * 22
    [rightBtn setImage:iamgeIm forState:UIControlStateNormal];
    [rightBtn setImage:[iamgeIm imageWithAlpha:0.3] forState:UIControlStateHighlighted];
    if (target && action && [target respondsToSelector:action]) {
        [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    rightBtn.adjustsImageWhenHighlighted = YES;
    rightBtn.size = CGSizeMake(width, height);
    rightBtn.responseTouchInterval = 0.3;
    rightBtn.responseAreaExtend = UIEdgeInsetsMake(10, 10, 10, 10);
    CGFloat edgeLeft = width - (height - 2.0 * offset), edgeRight = 0;
    if (self.rightBarButtonItems.count) {edgeLeft = edgeLeft / 2.0; edgeRight = edgeLeft;}
    rightBtn.imageView.contentMode = UIViewContentModeScaleToFill;
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(offset, edgeLeft, offset, edgeRight);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    if (self.rightBarButtonItems.count == 0) {
        self.rightBarButtonItem = rightItem;
    } else {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.rightBarButtonItems.count; i ++) {
            [items addObject:self.rightBarButtonItems[i]];
        }
        [items addObject:rightItem];
        self.rightBarButtonItems = [items copy];
    }
    return rightBtn;
}

@end
