//
//  ZCTextField.h
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCTextField : UITextField  /**< 长按菜单和最大输入数 */

@property (nonatomic, assign) CGSize fixSize;  /**< 自适应size大小，需实现sizeThatFits，默认sizeZero，即无效设置 */

@property (nonatomic, assign) CGSize cursorSize;  /**< 光标大小，默认sizeZero，即无效设置 */

@property (nonatomic, assign) UIOffset cursorOffset;  /**< 光标相对于原位置偏移，默认sizeZero，即无效设置 */

@property (nonatomic, assign) UIEdgeInsets underlineEdgeInsets;  /**< 下划线位置(top表示下划线高)，默认Zero，即不显示下划线 */

@property (nonatomic, assign) BOOL isForbidVisibleMenu;  /**< 是否禁止长按弹出菜单框，默认NO，不禁止 */

@property (nonatomic, assign) BOOL isOnlyAllowCopyPasteSelect;  /**< forbidVisibleMenu为NO的时候是否只显示拷贝粘贴选择，默认NO */

@property (nonatomic, assign) UIEdgeInsets responseAreaExtend;  /**< 延伸响应区域，默认zero */

@property (nonatomic, assign) NSUInteger limitTextLength;  /**< 最大长度，默认0，即不限制输入长度 */

@property (nonatomic, strong, readonly) UIView *underlineView;  /**< 当前下划线视图 */

@property (nullable, nonatomic, copy) BOOL(^limitTipBlock)(NSString *originText);  /**< 越界提示回调，返回是否舍去超出部分，默认nil */

@property (nullable, nonatomic, copy) void(^textChangeBlock)(ZCTextField *field);  /**< 内容改变回调，不可与didTextChange:同时生效，默认nil */

@property (nullable, nonatomic, copy) void(^touchAction)(ZCTextField *sender);  /**< 添加allEditEvent回调，默认nil */

- (instancetype)initWithHolder:(nullable NSString *)holder font:(nullable UIFont *)font color:(nullable UIColor *)color;  /**< 初始化方法 */

#pragma mark - Delegate block
/**< 以下方法将会设置delegate为self */
- (ZCTextField *)shouldBeginEdit:(nullable BOOL(^)(ZCTextField *field))block;

- (ZCTextField *)shouldEndEdit:(nullable BOOL(^)(ZCTextField *field))block;

- (ZCTextField *)shouldEndReturn:(nullable BOOL(^)(ZCTextField *field))block;

- (ZCTextField *)shouldChangeChar:(nullable BOOL(^)(ZCTextField *field, NSRange range, NSString *string))block;

- (ZCTextField *)didBeginEdit:(nullable void(^)(ZCTextField *field))block;

- (ZCTextField *)didEndEdit:(nullable void(^)(ZCTextField *field))block;

- (ZCTextField *)didTextChange:(nullable void(^)(ZCTextField *field))block;  /**< 内容改变回调，不可与textChangeBlock同时生效 */

@end

NS_ASSUME_NONNULL_END
