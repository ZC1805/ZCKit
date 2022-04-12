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
#import "ZCButton.h"
#import "ZCMacro.h"

@implementation UINavigationItem (ZC)

- (ZCButton *)itemCustomBackTitle:(NSString *)title color:(UIColor *)color image:(UIImage *)image {
    CGFloat offset = 8.0;
    CGFloat height = 32.0;
    UIImage *iamgeIm = image;
    if (title == nil) title = @"";
    if (color == nil) color = kZCWhite;
    if (!iamgeIm) iamgeIm = ZCKitBridge.naviBackImage;
    iamgeIm = [iamgeIm imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ZCButton *back = [[ZCButton alloc] initWithFrame:CGRectZero];
    [back setTitle:title forState:UIControlStateNormal];
    [back setTitle:title forState:UIControlStateHighlighted];
    [back setTitleColor:color forState:UIControlStateNormal];
    [back setTitleColor:kZCA(color, 0.3) forState:UIControlStateHighlighted];
    [back setImage:iamgeIm forState:UIControlStateNormal];
    [back setImage:[iamgeIm imageWithAlpha:0.3] forState:UIControlStateHighlighted];
    [back addTarget:self action:@selector(onManualPop:) forControlEvents:UIControlEventTouchUpInside];
    back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    back.adjustsImageWhenHighlighted = YES;
    back.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    CGSize size = [back.titleLabel sizeThatFits:CGSizeMake(100.0, height)];
    size = CGSizeMake(ceilf(size.width), ceilf(size.height));
    CGRect bframe = back.frame; bframe.size = CGSizeMake(MAX(size.width + 18.0, height), height);
    back.frame = bframe;
    back.responseTouchInterval = 0.3;
    back.responseAreaExtend = UIEdgeInsetsMake(10, 10, 10, 10);
    back.imageEdgeInsets = UIEdgeInsetsMake(-kZSPixel, -offset, 0, 0);
    back.titleEdgeInsets = UIEdgeInsetsMake(-kZSPixel, -offset, 0, 0);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.leftItemsSupplementBackButton = NO;
    self.leftBarButtonItem = item;
    self.hidesBackButton = YES;
    return back;
}

- (void)x { //这可以隐藏返回箭头
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.leftItemsSupplementBackButton = NO;
        self.hidesBackButton = YES;
        //下面三种情况系统侧滑返回手势会失效
        //1. 自定义了navigationItem的leftBarButtonItem或leftBarButtonItems
        //2. self.navigationItem.hidesBackButton = YES
        //3. self.navigationItem.leftItemsSupplementBackButton = NO
    });
}

- (void)onManualPop:(id)sender {
    UIViewController *vc = [ZCGlobal currentController];
    if (vc == nil) return;
    BOOL isCanBack = YES;
    if ([vc respondsToSelector:@selector(isPageCanResponseTouchPop)]) {
        isCanBack = [(id<ZCViewControllerPageBackProtocol>)vc isPageCanResponseTouchPop];
    }
    if (isCanBack) {
        main_imp(^{
            if ([vc respondsToSelector:@selector(onPageCustomTapBackAction)]) {
                [(id<ZCViewControllerPageBackProtocol>)vc onPageCustomTapBackAction];
            } else {
                [vc backToUpControllerAnimated:YES];
            }
        });
    }
}

- (ZCButton *)itemRightOneItem:(NSString *)item color:(UIColor *)color target:(id)target action:(SEL)action {
    CGFloat height = 32.0;
    if (item == nil) item = @"";
    if (color == nil) color = kZCWhite;
    ZCButton *rightBtn = [[ZCButton alloc] initWithFrame:CGRectZero];
    UIImage *iamgeIm = [[UIImage imageNamed:item] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (iamgeIm) {
        [rightBtn setImage:iamgeIm forState:UIControlStateNormal];
        [rightBtn setImage:[iamgeIm imageWithAlpha:0.3] forState:UIControlStateHighlighted];
    } else {
        [rightBtn setTitle:item forState:UIControlStateNormal];
        [rightBtn setTitle:item forState:UIControlStateHighlighted];
        [rightBtn setTitleColor:color forState:UIControlStateNormal];
        [rightBtn setTitleColor:kZCA(color, 0.3) forState:UIControlStateHighlighted];
    }
    if (target && action && [target respondsToSelector:action]) {
        [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBtn.adjustsImageWhenHighlighted = YES;
    rightBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    rightBtn.titleLabel.numberOfLines = 0;
    CGSize size = [rightBtn.titleLabel sizeThatFits:CGSizeMake(100.0, height)];
    size = CGSizeMake(ceilf(size.width), ceilf(size.height));
    CGRect bframe = rightBtn.frame; bframe.size = CGSizeMake(MAX(size.width, 30.0), height);
    rightBtn.frame = bframe;
    rightBtn.responseTouchInterval = 0.3;
    rightBtn.responseAreaExtend = UIEdgeInsetsMake(10, 10, 10, 10);
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    return rightBtn;
}

- (ZCButton *)itemAddRightImage:(NSString *)image target:(id)target action:(SEL)action {
    CGFloat height = 32.0, width = 30.0, offset = 5.0;
    UIImage *iamgeIm = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ZCButton *rightBtn = [[ZCButton alloc] initWithFrame:CGRectZero]; //size 32 * 32 image 22 * 22
    [rightBtn setImage:iamgeIm forState:UIControlStateNormal];
    [rightBtn setImage:[iamgeIm imageWithAlpha:0.3] forState:UIControlStateHighlighted];
    if (target && action && [target respondsToSelector:action]) {
        [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    rightBtn.adjustsImageWhenHighlighted = YES;
    CGRect bframe = rightBtn.frame; bframe.size = CGSizeMake(width, height);
    rightBtn.frame = bframe;
    rightBtn.responseTouchInterval = 0.3;
    rightBtn.responseAreaExtend = UIEdgeInsetsMake(10, 10, 10, 10);
    CGFloat edgeLeft = width - (height - 2.0 * offset), edgeRight = 0;
    if (self.rightBarButtonItems.count) { edgeLeft = edgeLeft / 2.0; edgeRight = edgeLeft; }
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
