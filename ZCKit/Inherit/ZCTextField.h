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

@property (nonatomic, assign) BOOL isShowUnderline;  /**< 是否显示下划线，默认NO */

@property (nonatomic, assign) BOOL isForbidVisibleMenu;  /**< 是否禁止长按弹出菜单框，默认NO，不禁止 */

@property (nonatomic, assign) BOOL isOnlyAllowCopyPasteSelect;  /**< forbidVisibleMenu为NO的时候是否只显示拷贝粘贴选择，默认NO */

@property (nonatomic, assign) NSUInteger limitLength;  /**< 最大长度，大于0的值 */

@property (nonatomic, nullable, copy) BOOL(^limitTipBlock)(NSString *originText);  /**< 越界提示回调，返回是否舍去超出部分，默认nil */

@property (nonatomic, nullable, copy) void(^textChangeBlock)(NSString *originText);  /**< 内容改变回调，默认nil */

@end

NS_ASSUME_NONNULL_END
