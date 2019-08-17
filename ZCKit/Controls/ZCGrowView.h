//
//  ZCGrowView.h
//  ZCKit
//
//  Created by admin on 2018/9/30.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZCGrowView;

@protocol ZCGrowViewDelegate <NSObject>  /**< 回调可实现的方法 */

@optional

- (BOOL)growViewShouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText;

- (BOOL)growViewShouldBeginEditing:(ZCGrowView *)growingTextView;

- (BOOL)growViewShouldEndEditing:(ZCGrowView *)growingTextView;

- (void)growViewDidBeginEditing:(ZCGrowView *)growingTextView;

- (void)growViewDidEndEditing:(ZCGrowView *)growingTextView;

- (void)growViewDidChangeSelection:(ZCGrowView *)growingTextView;

- (void)growViewDidChange:(ZCGrowView *)growingTextView;

- (BOOL)growViewDidSend:(ZCGrowView *)growingTextView;  /**< 点击send处理，返回是否不能输入\n */

- (void)growViewWillChangeHeight:(CGFloat)height;  /**< 将要改变self的行高 */

- (void)growViewDidChangeHeight:(CGFloat)height;  /**< 已经改变self的行高 */

@end



@interface ZCGrowView : UIScrollView  /**< 输入框view，didChangeHeight中需要改变外部位置 */

@property (nonatomic, assign) NSInteger minLines;  /**< 可最小显示的行数，默认为1行 */

@property (nonatomic, assign) NSInteger maxLines;  /**< 可最大显示的行数，默认为3行 */

@property (nullable, nonatomic, weak) id<ZCGrowViewDelegate> textDelegate;  /**< 当前代理，可用于接收回到处理 */

@property (nullable, nonatomic, strong) UIView *inputAccessoryView;  /**< 内部输入框的inputView */

@property (nullable, nonatomic, strong) UIView *inputView;  /**< 内部输入框的inputView */

@end



@interface ZCGrowView(TextView)

@property (nonatomic, strong) UIFont *font;  /**< 默认ZCFS(16) */

@property (nonatomic, strong) UIColor *textColor;  /**< 默认Black30 */

@property (nullable, nonatomic, copy) NSString *text;   /**< 默认nil */

@property (nullable, nonatomic, copy) NSString *placeholderText;  /**< 默认nil */

@property (nonatomic, assign) BOOL editable;  /**< 默认YES */

@property (nonatomic, assign) BOOL selectable;  /**< 默认YES */

@property (nonatomic, assign) NSRange selectedRange;  /**< 默认None */

@property (nonatomic, assign) UIReturnKeyType returnKeyType;  /**< 默认SendType */

- (void)scrollRangeToVisible:(NSRange)range;  /**< 滑动过去 */

@end

NS_ASSUME_NONNULL_END
