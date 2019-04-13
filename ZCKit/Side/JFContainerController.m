//
//  JFContainerController.m
//  gobe
//
//  Created by zjy on 2019/3/20.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFContainerController.h"
#import "ZCMaskView.h"

@interface JFContainerController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) JFMainController *mainVc;

@property (nonatomic, strong) JFSideViewController *sideVc;

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePan;  //开始的边缘平移手势

@property (nonatomic, strong) UIPanGestureRecognizer *pan;  //侧滑后的平移手势

@property (nonatomic, strong) UITapGestureRecognizer *tap;  //轻拍手势

@property (nonatomic, strong) ZCFocusView *maskCover;  //蒙版

@property (nonatomic, assign) CGFloat maxSideWid;

@property (nonatomic, assign) CGFloat maxSpeed;

@end

@implementation JFContainerController

+ (instancetype)instance {
    UIViewController *container = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([container isKindOfClass:[JFContainerController class]]) {
        return (JFContainerController *)container;
    } else {
        return nil;
    }
}

- (instancetype)initWithSideVc:(JFSideViewController *)leftVc mainVc:(JFMainController *)mainVc {
    if (self = [super init]) {
        self.sideVc = leftVc;
        self.mainVc = mainVc;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.maxSpeed = 800.0;
    self.maxSideWid = ZSWid * 0.8;
    self.view.backgroundColor = ZCWhite;
    [self initSetup];
}

- (void)initSetup {
    [self.view addSubview:self.sideVc.view];
    [self.view addSubview:self.mainVc.view];
    [self addChildViewController:self.sideVc];
    [self addChildViewController:self.mainVc];
    
    [self.mainVc didMoveToParentViewController:self];
    [self.sideVc didMoveToParentViewController:self];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    self.sideVc.view.frame = self.view.bounds;
    self.mainVc.view.frame = self.view.bounds;
    
    [self.mainVc.tabBar addSubview:self.maskCover];  //此处让点击事件向下传递了
    
    [self.view addGestureRecognizer:self.pan];  //添加平移手势
    [self.mainVc.view addGestureRecognizer:self.edgePan];  //添加屏幕边缘平移手势
    [self.mainVc.view addGestureRecognizer:self.tap];  //添加点击手势
    
    [self closeSide];
}

#pragma mark - Gesture
- (void)screenGesture:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:pan.view];
    CGPoint verPoint = [pan velocityInView:pan.view];
    
    self.mainVc.view.left += point.x;
    self.sideVc.view.left += point.x / 2.0;
    if (self.mainVc.view.left <= 0) {
        self.mainVc.view.left = 0;
        self.sideVc.view.left = -self.maxSideWid / 2.0;
    } else if (self.mainVc.view.left >= self.maxSideWid) {
        self.mainVc.view.left = self.maxSideWid;
        self.sideVc.view.left = 0;
    }
    
    CGFloat step = self.mainVc.view.left / self.maxSideWid;
    self.sideVc.view.alpha = step * 0.3 + 0.7;
    self.maskCover.alpha = step * 0.3;
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (pan == self.edgePan) {
            if (verPoint.x > self.maxSpeed) {
                [self openSide];
            } else {
                if (self.mainVc.view.left >= ZSWid / 2.0) {
                    [self openSide];
                } else {
                    [self hideSide];
                }
            }
        } else {
            if (verPoint.x < -self.maxSpeed) {
                [self hideSide];
            } else {
                if (self.mainVc.view.left >= ZSWid / 2.0) {
                    [self openSide];
                } else {
                    [self hideSide];
                }
            }
        }
    }
    [pan setTranslation:CGPointZero inView:pan.view];
}

- (void)tapGesture:(UITapGestureRecognizer *)tap {
    [self hideSide];
}

#pragma mark - Api
- (void)hideSide {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.maskCover.alpha = 0;
        self.sideVc.view.alpha = 0.7;
        self.mainVc.view.left = 0;
        self.sideVc.view.left = -self.maxSideWid / 2.0;
    } completion:^(BOOL finished) {
        self.edgePan.enabled = YES;
        self.pan.enabled = NO;
        self.tap.enabled = NO;
    }];
}

- (void)closeSide {
    self.maskCover.alpha = 0;
    self.mainVc.view.left = 0;
    self.sideVc.view.alpha = 0.7;
    self.sideVc.view.left = -self.maxSideWid / 2.0;
    self.edgePan.enabled = YES;
    self.pan.enabled = NO;
    self.tap.enabled = NO;
}

- (void)openSide {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.maskCover.alpha = 0.3;
        self.sideVc.view.alpha = 1.0;
        self.sideVc.view.left = 0;
        self.mainVc.view.left = self.maxSideWid;
    } completion:^(BOOL finished) {
        self.edgePan.enabled = NO;
        self.pan.enabled = YES;
        self.tap.enabled = YES;
    }];
}

#pragma mark - Getter
- (UIScreenEdgePanGestureRecognizer *)edgePan {
    if (!_edgePan) {
        _edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenGesture:)];
        _edgePan.edges = UIRectEdgeLeft;
        _edgePan.delegate = self;
    }
    return _edgePan;
}

- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        _tap.numberOfTapsRequired = 1;
    }
    return _tap;
}

- (UIPanGestureRecognizer *)pan {
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(screenGesture:)];
    }
    return _pan;
}

- (UIView *)maskCover {
    if (!_maskCover) {
        _maskCover = [[ZCFocusView alloc] initWithFrame:self.view.bounds];
        _maskCover.top = ZSTabBarHei - self.mainVc.view.bounds.size.height;
        _maskCover.backgroundColor = ZCBlack;
        _maskCover.alpha = 0;
    }
    return _maskCover;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.edgePan && self.mainVc.selectedViewController) {
        if ([self.mainVc.selectedViewController isKindOfClass:[UINavigationController class]]) {
            if ([(UINavigationController *)self.mainVc.selectedViewController viewControllers].count > 1) {
                return NO;
            }
        }
    }
    return YES;
}

@end

