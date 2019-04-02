//
//  JFIncrControl.h
//  ZCKit
//
//  Created by zjy on 2018/6/4.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JFIncrControl, JFDecimalKeyboardView;

typedef NS_ENUM (NSInteger, JFEnumIncrControlType) {
    JFEnumIncrControlTypeGray  = 0,  /**< 灰色样式 */
    JFEnumIncrControlTypeCyan  = 1,  /**< 青色样式 */
    JFEnumIncrControlTypeRed   = 2,  /**< 红色样式 */
    JFEnumIncrControlTypePrice = 3,  /**< 价格样式 */
};

typedef NS_ENUM (NSInteger, JFEnumIncrControlStyle) {
    JFEnumIncrControlStyleNormal = 0,  /**< 常用风格 */
    JFEnumIncrControlStyleWindow = 1,  /**< 窗口风格 */
};

@protocol JFIncrControlDelegate <NSObject>

@optional

/** 点击增加回调 */
- (void)incrControlOnIncrease:(JFIncrControl *)incrControl;

/** 点击减少回调 */
- (void)incrControlOnDecrease:(JFIncrControl *)incrControl;

/** 输入结束回调 */
- (void)incrControlOnInputEnd:(JFIncrControl *)incrControl;

/** 范围越界时多次回调，尽量在此回调中再给text赋值 */
- (void)incrControlTriggerTextLimit:(JFIncrControl *)incrControl;

/** 数据改变时多次回调，尽量在此回调中再给text赋值 */
- (void)incrControlNumberChange:(JFIncrControl *)incrControl;

/** 输入数据改变时回调，尽量不要在此再给text赋值 */
- (void)incrControlInputChange:(JFIncrControl *)incrControl text:(NSString *)text;

/** 跨入跨出警告区单次回调，尽量不要在此再给text赋值，incrWarning大于大值警告，decrWarning小于小值警告 */
- (void)incrControlTriggerWarning:(JFIncrControl *)incrControl incrWaring:(BOOL)incrWaring decrWaring:(BOOL)incrWaring;

/** autoDisable为YES时，跨入跨出失效区单次回调，尽量不要在此再给text赋值，incrDisable等于大值失效，decrDisable等于小值失效 */
- (void)incrControlTriggerDisable:(JFIncrControl *)incrControl incrDisable:(BOOL)incrDisable decrDisable:(BOOL)incrDisable;

@end


@interface JFIncrControl : UIView   

/** 后面的单位，默认nil */
@property (nonatomic, copy) NSString *unit;

/** 前边的提示，默认nil */
@property (nonatomic, copy) NSString *title;

/** 设定固定的size，默认SizeZero不设置 */
@property (nonatomic, assign) CGSize defaultSize;

/** 单位/标题，font size 默认14，不必写Fit() */
@property (nonatomic, assign) float fontUnitSize;

/** 单位/提示，font size 默认12，不必写Fit() */
@property (nonatomic, assign) float fontTextSize;

/** 增减按钮最小响应时间，默认0.35s */
@property (nonatomic, assign) float minClickInterval;

/** normal风格时，是否隐藏底部横线，默认NO */
@property (nonatomic, assign) BOOL hiddenLine;

/** normal风格时，是否隐藏text展示值，默认NO */
@property (nonatomic, assign) BOOL hiddenText;

/** 没设固定size时，size会不会动态改变，默认NO */
@property (nonatomic, assign) BOOL dynamicSize;

/** 在阈值时，是否可自动变成失效状态，默认NO */
@property (nonatomic, assign) BOOL autoDisable;

/** 是否允屏蔽手动输入，默认NO */
@property (nonatomic, assign) BOOL disableInput;

/** 是否是失效状态，默认NO */
@property (nonatomic, assign) BOOL disableState;

/** 不设定小数键盘时候，是否屏蔽点击空白自动隐藏，默认NO */
@property (nonatomic, assign) BOOL disableAutoCancel;

/** 失效等状态不响应时，是否截取事件不向上传递，默认NO */
@property (nonatomic, assign) BOOL interceptTouch;

/** 点击手动输入，是否弹出小数键盘，默认NO */
@property (nonatomic, assign) BOOL decimalKeyboard;

/** 更改属性是否验证number&触发changeNumber回调，默认NO */
@property (nonatomic, assign) BOOL numberAutoAdaption;

/** number值是否受stepOrder整除&basisOrder生效，默认NO */
@property (nonatomic, assign) BOOL numberAutoValidate;

/** 阈值值受stepOrder整除&赋值YES时需同时赋值step，默认NO */
@property (nonatomic, assign) BOOL numberAutoThreshold;

/** 显示的数值，默认0 */
@property (nonatomic, strong) NSDecimalNumber *number;

/** 最小要求值，默认0，设置时候有没有小数点会使size微变 */
@property (nonatomic, strong) NSDecimalNumber *basisOrder;

/** 单位增减值，默认根据decimal确定 */
@property (nonatomic, strong) NSDecimalNumber *stepOrder;

/** 最小有效值，默认0 */
@property (nonatomic, strong) NSDecimalNumber *minOrder;

/** 最大有效值，默认根据decimal确定 */
@property (nonatomic, strong) NSDecimalNumber *maxOrder;

/** 非警告区间，默认+—0，闭区间，需要的时候应注意精度一致 */
@property (nonatomic, strong) NSArray <NSDecimalNumber *>*warningSection;

/** 样式风格，默认normal风格，window风格时请先设置defaultSize */
@property (nonatomic, assign) JFEnumIncrControlStyle style;

/** 回调代理，主要监测值的改变，默认 nil */
@property (nonatomic, weak) id<JFIncrControlDelegate> delegate;


/** 初始化方法，length 输入最长位数，decimal 小数位数 */
- (instancetype)initWithType:(JFEnumIncrControlType)type length:(short)length decimal:(short)decimal;

/** 设置隐藏减按钮和输入框的动画 */
- (void)setHiddenText:(BOOL)hiddenText animate:(BOOL)animate;

/** 不设定小数键盘时候，取消输入，在结束编辑前调用 */
- (void)cancelInputNumber;

/** 警告状态 */
- (BOOL)warning;

/** 返回当前number的copy值 */
- (NSDecimalNumber *)copyNumber;

/** 输入框 */
- (UITextField *)inputTextField;

/** 最大值 */
- (NSString *)max;

/** 最小值 */
- (NSString *)min;

/** text值 */
- (NSString *)text;

@end


@interface JFIncrControl ()  //decimalKeyboard 输入键盘相关属性设置，"#" 表示目标属性最好在初始化时候设置，暂不设置警告区域

@property (nonatomic, assign) BOOL keyboardDoneValidate;  /**< 点击确认时候是否需要验证 (受incrControl验证) #，默认 NO */

@property (nonatomic, assign) BOOL keyboardPeripheryHide;  /**< 点击外围是否隐藏 #，默认 NO */

@property (nonatomic, copy) NSString *keyboardDoneTitle;  /**< done按钮文案 #，默认"确定" */

@property (nonatomic, copy) NSString *keyboardHideTitle;  /**< hide按钮文案 #，默认"隐藏" */

@property (nonatomic, copy) NSString *keyboardHolderText;  /**< 占位内容 #，默认"" */

@property (nonatomic, copy) NSString *keyboardClearText;  /**< 清空后显示内容 #，默认"" */

@property (nonatomic, copy) NSString *(^keyboardPrompt)(NSString *max, NSString *min, NSString *moq);  /**< 返回提示文案，谁有值说明要提示谁 */

@end

