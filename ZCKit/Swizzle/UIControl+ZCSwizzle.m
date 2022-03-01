//
//  UIControl+ZCSwizzle.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UIControl+ZCSwizzle.h"
#import "ZCSwizzleHeader.h"

NSNotificationName const ZCControlGenerateEventNotification = @"ZCControlGenerateEventNotification";

@interface UIControl ()

- (void)setIgnoreFlagSelector:(SEL)ignoreFlagSelector;

@end

@implementation UIControl (ZCSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        SEL sel2 = @selector(addTarget:action:forControlEvents:);
//        SEL sel2x = @selector(swizzle1_ctor_addTarget:action:forControlEvents:);
//        SEL sel3 = @selector(removeTarget:action:forControlEvents:);
//        SEL sel3x = @selector(swizzle1_ctor_removeTarget:action:forControlEvents:);
//        zc_swizzle_exchange_instance_selector(UIControl.class, sel2, sel2x);
//        zc_swizzle_exchange_instance_selector(UIControl.class, sel3, sel3x);
    });
}

- (void)swizzle1_ctor_addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self swizzle1_ctor_addTarget:target action:action forControlEvents:controlEvents];
    if (target && action && [target respondsToSelector:action]) {
        UIControlEvents collectEvent = [self confirmCollectControlEvents:controlEvents];
        SEL collectSel = @selector(receiveCollectControlEvent:);
        NSArray <NSString *>*collectActions = [self actionsForTarget:self forControlEvent:collectEvent];
        if (!collectActions || ![collectActions containsObject:NSStringFromSelector(collectSel)]) {
            if (collectEvent && [self respondsToSelector:collectSel]) {
                [self swizzle1_ctor_addTarget:self action:collectSel forControlEvents:collectEvent];
                if ([self respondsToSelector:@selector(setIgnoreFlagSelector:)]) {
                    [self setIgnoreFlagSelector:collectSel];
                }
            }
        }
    }
}

- (void)swizzle1_ctor_removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self swizzle1_ctor_removeTarget:target action:action forControlEvents:controlEvents];
    if (self.allTargets && [self.allTargets containsObject:self]) {
        BOOL isOnlyCollectTarget = YES;
        for (id target in self.allTargets) {
            if (![target isKindOfClass:NSNull.class] && target != self) {
                isOnlyCollectTarget = NO; break;
            }
        }
        if (isOnlyCollectTarget) {
            UIControlEvents collectEvent = [self confirmCollectControlEvents:controlEvents];
            SEL collectSel = @selector(receiveCollectControlEvent:);
            NSArray <NSString *>*collectActions = [self actionsForTarget:self forControlEvent:collectEvent];
            if (collectActions && collectActions.count == 1 && [collectActions containsObject:NSStringFromSelector(collectSel)]) {
                if (collectEvent && [self respondsToSelector:collectSel]) {
                    [self swizzle1_ctor_removeTarget:self action:collectSel forControlEvents:collectEvent];
                    if ([self respondsToSelector:@selector(setIgnoreFlagSelector:)]) {
                        [self setIgnoreFlagSelector:nil];
                    }
                }
            }
        }
    }
}

- (UIControlEvents)confirmCollectControlEvents:(UIControlEvents)controlEvents {
    if ([self isKindOfClass:UIButton.class]) {
        return UIControlEventTouchUpInside;
    } else if ([self isKindOfClass:UISegmentedControl.class]) {
        return UIControlEventValueChanged;
    } else if ([self isKindOfClass:UISlider.class]) {
        return UIControlEventTouchDown;
    } else if ([self isKindOfClass:UISwitch.class]) {
        return UIControlEventValueChanged;
    } else if ([self isKindOfClass:UIStepper.class]) {
        return UIControlEventValueChanged;
    } else if ([self isKindOfClass:UIDatePicker.class]) {
        return UIControlEventValueChanged;
    } else if ([self isKindOfClass:UIPageControl.class]) {
        return UIControlEventValueChanged;
    } else if ([self isKindOfClass:UITextField.class]) {
        return 0;
    } else if ([self isKindOfClass:UIControl.class]) {
        return UIControlEventTouchDown;
    }
    return 0;
}

- (void)receiveCollectControlEvent:(UIControl *)control {
    [[NSNotificationCenter defaultCenter] postNotificationName:ZCControlGenerateEventNotification object:control];
}

#warning - 还差UITextView,UITextField,UITableViewCell,UICollectViewCell,UIBarBauttonItem,UIAlertAction事件记录 & 注意屏蔽系统控件的事件或者打标机来确认是否处理此事件 & 响应链寻找路径 & 修改手势锁存储位置 & 搜索//___

//UIScrollViews+ZC中
//- (void)shieldNavigationInteractivePop { //使系统导航手势失效，不可逆
//    UIViewController *controller = self.currentViewController;
//    if (controller && controller.navigationController && controller.parentViewController == controller.navigationController) {
//        [self.panGestureRecognizer requireGestureRecognizerToFail:controller.navigationController.interactivePopGestureRecognizer];
//    }
//}

@end
