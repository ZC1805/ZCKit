//
//  UINavigationItem+ZC.m
//  ZCKit
//
//  Created by admin on 2018/10/9.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UINavigationItem+ZC.h"

@implementation UINavigationItem (ZC)

#warning - xxx
//- (UIButton *)customBackItemWithBackTitle:(NSString *)title target:(id)target action:(SEL)click {
//    CGFloat height = 32.f, offset = 7.f, alpha = 0.2f;
//    UIImage *iamgeIm = [[UIImage imageNamed:DEFBackImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    LTSTMarginButton *btn = [LTSTMarginButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:title forState:UIControlStateNormal];
//    [btn setTitle:title forState:UIControlStateHighlighted];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:alpha] forState:UIControlStateHighlighted];
//    [btn setImage:iamgeIm forState:UIControlStateNormal];
//    [btn setImage:[iamgeIm imageWithAlpha:alpha] forState:UIControlStateHighlighted];
//    [btn addTarget:target action:click forControlEvents:UIControlEventTouchUpInside];
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    btn.adjustsImageWhenHighlighted = YES;
//    btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
//    CGSize size = [btn.titleLabel sizeThatFits:CGSizeMake(100.f, height)];
//    btn.customThatSize = [NSValue valueWithCGSize:CGSizeMake(size.width + 23.f, height)];
//    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -offset, 0, offset);
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.leftBarButtonItem = item;
//    return btn;
//}

//- (UIButton *)customRightOneItemWithTitle:(NSString *)title target:(id)target action:(SEL)click {
//    CGFloat height = 32.f, width = 30.f, alpha = 0.2f;
//    LTSTMarginButton *rightBtn = [LTSTMarginButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn setTitle:title forState:UIControlStateNormal];
//    [rightBtn setTitle:title forState:UIControlStateHighlighted];
//    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:alpha] forState:UIControlStateHighlighted];
//    [rightBtn addTarget:target action:click forControlEvents:UIControlEventTouchUpInside];
//    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    rightBtn.adjustsImageWhenHighlighted = YES;
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
//    CGSize size = [rightBtn.titleLabel sizeThatFits:CGSizeMake(100.f, height)];
//    rightBtn.customThatSize = [NSValue valueWithCGSize:CGSizeMake(MAX(width, size.width), height)];
//    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    return rightBtn;
//}
//
//- (UIButton *)customAddRightItemWithImage:(NSString *)image target:(id)target action:(SEL)click {
//    CGFloat height = 32.f, width = 30.f, offset = 5.f, alpha = 0.2f;
//    UIImage *iamgeIm = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    LTSTMarginButton *rightBtn = [LTSTMarginButton buttonWithType:UIButtonTypeCustom];  // size 32 * 32 image 22 * 22
//    [rightBtn setImage:iamgeIm forState:UIControlStateNormal];
//    [rightBtn setImage:[iamgeIm imageWithAlpha:alpha] forState:UIControlStateHighlighted];
//    [rightBtn addTarget:target action:click forControlEvents:UIControlEventTouchUpInside];
//    rightBtn.adjustsImageWhenHighlighted = YES;
//    rightBtn.customThatSize = [NSValue valueWithCGSize:CGSizeMake(width, height)];
//    CGFloat edgeLeft = width - (height - 2 * offset), edgeRight = 0;
//    if (self.rightBarButtonItems.count) {edgeLeft = edgeLeft / 2; edgeRight = edgeLeft;}
//    rightBtn.imageView.contentMode = UIViewContentModeScaleToFill;
//    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(offset, edgeLeft, offset, edgeRight);
//    UIBarButtonItem *ritem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    if (self.rightBarButtonItems.count == 0) {
//        self.rightBarButtonItem = ritem;
//    } else {
//        NSMutableArray *items = [[NSMutableArray alloc] init];
//        for (int i = 0; i < self.rightBarButtonItems.count; i ++) {
//            [items addObject:self.rightBarButtonItems[i]];
//        }
//        [items addObject:ritem];
//        self.rightBarButtonItems = [items copy];
//    }
//    return rightBtn;
//}

@end











