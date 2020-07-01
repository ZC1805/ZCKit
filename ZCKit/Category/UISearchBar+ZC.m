//
//  UISearchBar+ZC.h
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "UISearchBar+ZC.h"
#import "ZCMacro.h"

@implementation UISearchBar (ZC)

- (void)setRightCancelText:(NSString *)rightCancelText { //iOS13问题
    [self setValue:[rightCancelText copy] forKey:@"_cancelButtonText"];
}

- (NSString *)rightCancelText {
    NSString *text = [self valueForKey:@"_cancelButtonText"];
    return (text && [text isKindOfClass:[NSString class]]) ? [text copy] : nil;
}

- (void)setLeftSearchIcon:(UIImage *)leftSearchIcon {
    [self setImage:leftSearchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
}

- (UIImage *)leftSearchIcon {
    return [self imageForSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
}

- (void)setInsideFieldBKImage:(UIImage *)insideFieldBKImage {
    [self setSearchFieldBackgroundImage:insideFieldBKImage forState:UIControlStateNormal];
}

- (UIImage *)insideFieldBKImage {
    return [self searchFieldBackgroundImageForState:UIControlStateNormal];
}

- (UITextField *)insideTextField {
    UITextField *filed = [self valueForKey:@"searchBarTextField"];
    return (filed && [filed isKindOfClass:[UITextField class]]) ? filed : nil;
}

- (UIButton *)rightCancelButton {
    UIButton *button = [self valueForKey:@"cancelButton"];
    return (button && [button isKindOfClass:[UIButton class]]) ? button : nil;
}

@end
