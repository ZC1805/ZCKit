//
//  ZCTextField.h
//  ZCKit
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCTextField : UITextField

@property (nonatomic, assign) BOOL forbidVisibleMenu;   /**< 是否禁止长按弹出菜单框，默认NO，不禁止 */

@property (nonatomic, assign) BOOL onlyAllowCopyPasteSelect;   /**< forbidVisibleMenu为NO的时候是否只显示拷贝粘贴选择，默认NO */

@property (nonatomic, assign) NSUInteger limitLength;   /** 最大长度 大于0的值 */

@property (nonatomic, copy) BOOL(^limitTip)(NSString *originText);   /** 越界提示回调 返回是否可需要处理越界 */

@end

NS_ASSUME_NONNULL_END






