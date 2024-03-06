//
//  ZCTextView.h
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCTextView : UITextView  /**< 可设置占位文字 */

@property (nonatomic, assign) CGSize fixSize;  /**< 自适应size大小，需实现sizeThatFits，默认sizeZero，即无效设置 */

@property (nonatomic, assign) BOOL isForbidVisibleMenu;  /**< 是否禁止长按弹出菜单框，默认NO，不禁止 */

@property (nonatomic, assign) BOOL isOnlyAllowCopyPasteSelect;  /**< forbidVisibleMenu为NO的时候是否只显示拷贝粘贴选择，默认NO */

@property (nullable, nonatomic, copy) NSString *placeholder;  /**< 占位字符串，默认nil */

@property (nullable, nonatomic, copy) UIColor *placeholderTextColor;  /**< 占位字符串颜色，默认0.7灰色 */

@property (nullable, nonatomic, copy) NSAttributedString *attributedPlaceholder;  /**< 富文本占位字符串，默认nil */

@property (nullable, nonatomic, copy) void(^textChangeBlock)(ZCTextView *textView);  /**< 内容改变回调，默认nil */

#pragma mark - Delegate block
/**< 以下方法将会设置delegate为self */
- (ZCTextView *)shouldBeginEdit:(nullable BOOL(^)(ZCTextView *textView))block;

- (ZCTextView *)shouldEndEdit:(nullable BOOL(^)(ZCTextView *textView))block;

- (ZCTextView *)shouldChangeText:(nullable BOOL(^)(ZCTextView *textView, NSRange range, NSString *string))block;

- (ZCTextView *)didBeginEdit:(nullable void(^)(ZCTextView *textView))block;

- (ZCTextView *)didEndEdit:(nullable void(^)(ZCTextView *textView))block;

- (ZCTextView *)didChangeText:(nullable void(^)(ZCTextView *textView))block;

- (ZCTextView *)didChangeSelect:(nullable void(^)(ZCTextView *textView))block;

@end

NS_ASSUME_NONNULL_END
