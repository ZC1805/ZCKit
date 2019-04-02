//
//  UIView+JF.m
//  gobe
//
//  Created by zjy on 2019/3/16.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "UIView+JF.h"
#import <MBProgressHUD.h>

#define JFMBTAG 70692
#define JFBKTAG 80753
#define JFHIDETIME 2

@implementation UIView (JF)

- (void)hideAllHud {
    for (UIView *subview in self.containAllSubviews) {
        if ([subview isKindOfClass:[MBProgressHUD class]]) {
            [(MBProgressHUD *)subview hideAnimated:YES afterDelay:0];
        }
    }
}

- (void)showFailureWithTip:(NSString *)tip {
    [self hideLoading];
    MBProgressHUD *mbView = [[MBProgressHUD alloc] initWithView:self];
    mbView.customView = [[UIImageView alloc] initWithImage:ZCImage(@"image_common_face_sad")];
    mbView.offset = CGPointMake(mbView.offset.x, -ZSHei / 10);
    mbView.tag = JFMBTAG;
    mbView.mode = MBProgressHUDModeCustomView;
    mbView.detailsLabel.text = tip;
    [self addSubview:mbView];
    [mbView showAnimated:YES];
    [mbView hideAnimated:YES afterDelay:JFHIDETIME];  //2秒钟后隐藏
}

- (void)showCompletedWithTip:(NSString *)tip {
    [self hideLoading];
    MBProgressHUD *mbView = [[MBProgressHUD alloc] initWithView:self];
    mbView.customView = [[UIImageView alloc]initWithImage:ZCImage(@"image_common_face_completed")];
    mbView.offset = CGPointMake(mbView.offset.x, -ZSHei / 10);
    mbView.tag = JFMBTAG;
    mbView.mode = MBProgressHUDModeCustomView;
    mbView.detailsLabel.text = tip;
    [self addSubview:mbView];
    [mbView showAnimated:YES];
    [mbView hideAnimated:YES afterDelay:JFHIDETIME];  //2秒钟后隐藏
}

- (void)showLoading:(NSString *)tip {
    [self hideLoading];
    MBProgressHUD *mbView = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:mbView];
    mbView.label.text = tip;
    mbView.tag = JFMBTAG;
    mbView.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;  //使背景成黑灰色，让MBProgressHUD成高亮显示
    mbView.backgroundView.color = [UIColor colorWithWhite:0 alpha:0.2];
    mbView.square = YES;  //设置显示框的高度和宽度一样
    [mbView showAnimated:YES];
}

- (void)showToastWithTip:(NSString *)tip {
    [self hideLoading];
    MBProgressHUD *mbView = [[MBProgressHUD alloc] initWithView:self];
    mbView.offset = CGPointMake(mbView.offset.x, -ZSHei / 10);
    mbView.tag = JFMBTAG;
    mbView.mode = MBProgressHUDModeCustomView;
    mbView.detailsLabel.text = tip;
    [self addSubview:mbView];
    [mbView showAnimated:YES];
    [mbView hideAnimated:YES afterDelay:JFHIDETIME];  //2秒钟后隐藏
}

- (void)showToastWithTip:(NSString *)tip delay:(NSTimeInterval)delay {
    [self hideLoading];
    MBProgressHUD *mbView = [[MBProgressHUD alloc] initWithView:self];
    mbView.offset = CGPointMake(mbView.offset.x, -ZSHei / 10);
    mbView.tag = JFMBTAG;
    mbView.mode = MBProgressHUDModeCustomView;
    mbView.detailsLabel.text = tip;
    [self addSubview:mbView];
    [mbView showAnimated:YES];
    [mbView hideAnimated:YES afterDelay:delay];
}

- (void)showToastWithError:(NSError *)error {
    [self showToastWithTip:[JFNetwork errorString:error]];
}

- (void)hideLoading {
    if ([self viewWithTag:JFMBTAG]) {
        MBProgressHUD *mbView = (MBProgressHUD *)[self viewWithTag:JFMBTAG];
        [mbView hideAnimated:NO];
        [mbView removeFromSuperview];
        mbView = nil;
    }
}

@end
