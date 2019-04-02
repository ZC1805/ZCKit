//
//  JFDecimalKeyboardView.h
//  ZCKit
//
//  Created by zjy on 2018/7/23.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFDecimalKeyboardView : UIView

@property (nonatomic, assign) BOOL maskHide;  /**< 点击空白处返回，默认NO */

@property (nonatomic, assign) BOOL maskClear;  /**< 使用透明遮罩，默认NO */

@property (nonatomic, assign) BOOL forbidPaste;  /**< 禁止粘贴、拷贝、选择操作，默认NO */

@property (nonatomic, assign) BOOL midwayCheck;  /**< 输入中是否需要检查超出范围，默认NO */

@property (nonatomic, assign) BOOL canonicalInput;  /**< 是否需要规范输入，默认YES */

@property (nonatomic, assign) BOOL showMistakeTip;  /**< 是否需要输入错误提示，默认YES，为NO时校验成0 */

@property (nonatomic, assign) unsigned int decimal;  /**< 小数位数，默认2，两位小数 */

@property (nonatomic, copy) NSString *doneTitle;  /**< done按钮文案，默认"确定" */

@property (nonatomic, copy) NSString *hideTitle;  /**< hide按钮文案，默认"隐藏" */

@property (nonatomic, copy) NSString *holderText;  /**< 占位内容，默认"" */

@property (nonatomic, copy) NSString *clearText;  /**< 清空后显示内容，默认"" */

@property (nonatomic, strong) NSDecimalNumber *maxNumber;  /**< 最大值，默认-1，即不设置 */

@property (nonatomic, strong) NSDecimalNumber *minNumber;  /**< 最小值，默认-1，即不设置 */

@property (nonatomic, strong) NSDecimalNumber *moqNumber;  /**< 起定量，默认-1，即不设置 */

@property (nonatomic, strong) NSDecimalNumber *number;  /**< 初始值，默认nil，即显示@""，其余不规范值显示0 */

+ (void)display:(nullable void(^)(JFDecimalKeyboardView *decimalView))initSet
         prompt:(nullable NSString *(^)(NSString * _Nullable max, NSString * _Nullable min, NSString * _Nullable moq))prompt
          check:(nullable BOOL(^)(NSDecimalNumber *futureDecimal))check
           done:(nullable BOOL(^)(NSDecimalNumber *decimal))done
           hide:(nullable BOOL(^)(NSDecimalNumber *decimal, BOOL activeHide))hide;

+ (void)display:(nullable void(^)(JFDecimalKeyboardView *decimalView))initSet
         prompt:(nullable NSString *(^)(NSString * _Nullable max, NSString * _Nullable min, NSString * _Nullable moq))prompt
           done:(nullable BOOL(^)(NSDecimalNumber *decimal))done;

+ (nullable JFDecimalKeyboardView *)displayingKeyboard;  /**< 返回正在显示的视图，没有则返回nil */

+ (void)dismissKeyboard;  /**< 主动隐藏正在显示的keyboard (activeHide NO 模式) */

@end

NS_ASSUME_NONNULL_END
