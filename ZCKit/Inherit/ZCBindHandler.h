//
//  ZCBindHandler.h
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCGlobal.h"

NS_ASSUME_NONNULL_BEGIN

@class ZCBindHandler;

#pragma mark - ~~~~~~~~~~ ZCBindUnit ~~~~~~~~~~
@interface ZCBindUnit : NSObject  /**< 绑定关联对象 */

@property (nullable, nonatomic, copy, readonly) NSString *tip;  /**< 展示的tip，默认nil */

@property (nullable, nonatomic, copy, readonly) NSString *title;  /**< 展示的title，默认nil */

@property (nullable, nonatomic, copy, readonly) NSString *prompt;  /**< 展示的prompt，默认nil */

@property (nullable, nonatomic, strong, readonly) id showValue;  /**< 当前展示的值，默认nil */

@property (nullable, nonatomic, strong, readonly) ZCJsonValue gainValue;  /**< 初始获取的值，默认nil */

@property (nullable, nonatomic, strong, readonly) ZCJsonValue saveValue;  /**< 当前保存的值，默认nil */

/** 展示 */
+ (ZCBindUnit *)unitGainKp:(nullable NSString *)gainKp model:(nullable id)model;

/** 保存 */
+ (ZCBindUnit *)unitHandler:(nullable ZCBindHandler *)handler saveKp:(nullable NSString *)saveKp;

/** 更改 */
+ (ZCBindUnit *)unitGainKp:(nullable NSString *)gainKp model:(nullable id)model
                   handler:(nullable ZCBindHandler *)handler saveKp:(nullable NSString *)saveKp;

/** 初始化设置tip、title、prompt */
- (ZCBindUnit *)setTip:(nullable NSString *)tip title:(nullable NSString *)title prompt:(nullable NSString *)prompt;

/** 将展示的值转换成保存的值，showValue->saveValue */
- (ZCBindUnit *)showToSave:(nullable ZCJsonValue _Nullable(^)(ZCBindUnit *unit, id _Nullable showValue))block;

/** 将保存的值转换成展示的值，saveValue->showValue */
- (ZCBindUnit *)saveToShow:(nullable id _Nullable(^)(ZCBindUnit *unit, ZCJsonValue _Nullable saveValue))block;

/** 检查原值和新值是否改变的回调，若果不设置或者设置nil，将进行预设检查 */
- (ZCBindUnit *)checkChange:(nullable BOOL(^)(ZCBindUnit *unit, ZCJsonValue _Nullable gainValue, ZCJsonValue _Nullable saveValue))block;

/** 取值时检查原值和新值是否规范回调，若果不设置或者设置nil，将不会检查 */
- (ZCBindUnit *)checkAllow:(nullable BOOL(^)(ZCBindUnit *unit, ZCJsonValue _Nullable saveValue))block;

/** 重设管理者，只能设置一个handler且在此handler中自己不会重复，设置nil会将自己从当前的handler中移除，kp保存值时用到 */
- (ZCBindUnit *)relyHandler:(nullable ZCBindHandler *)handler kp:(nullable NSString *)kp;

/** 绑定展示对象，设置nil可移除当前观察者，更改绑定时kp按照KVC从object中取值的类型要和之前的一样，此处会自动移除之前的绑定者 */
- (ZCBindUnit *)bindObject:(nullable id)object kp:(nullable NSString *)kp;

/** 载入初始数据，且会显示到界面，有kp时按照KVC从model中取值，kp为nil直接取model */
- (ZCBindUnit *)loadModel:(id)model kp:(nullable NSString *)kp;

@end


#pragma mark - ~~~~~~~~~~ ZCBindHandler ~~~~~~~~~~
@interface ZCBindHandler : NSObject  /**< 对unit管理类 */

/** 返回units数组中是否checkAllow全部通过，如果通过，将对容器接收者按以下规则赋值 */
/** 1.如果容器接收者为可变数组，按saveValue对receiveContainer进行injectValue:赋值 */
/** 2.如果容器接收者为可变字典，按saveKp&saveValue对receiveContainer进行injectValue:forKey:赋值 */
/** 3.如果容器接收者为其余类型对象，按saveKp&saveValue对receiveContainer进行setValue:forKey:赋值 */
+ (BOOL)extract:(nullable id)receiveContainer units:(NSArray <ZCBindUnit *>*)units;

/** 返回units中是否有gainValue不等于saveValue */
+ (BOOL)change:(NSArray <ZCBindUnit *>*)units;

/** 返回管理中的unit是否checkAllow全部通过，如果通过，将对容器接收者按同上规则赋值 */
- (BOOL)extract:(nullable id)receiveContainer;

/** 返回管理中的unit是否有gainValue不等于saveValue */
- (BOOL)change;

/** 向管理中心添加需要管理的unit，不会重复添加 */
- (void)addUnit:(ZCBindUnit *)unit;

/** 向管理中心移除已经管理的unit */
- (void)removeUnit:(ZCBindUnit *)unit;

/** 根据object&kp移除之前的绑定的(非自己)观察者信息 */
- (void)removeEarlierBind:(ZCBindUnit *)unit object:(id)object kp:(NSString *)kp;

@end

NS_ASSUME_NONNULL_END
