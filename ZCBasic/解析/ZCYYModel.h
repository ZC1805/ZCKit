//
//  ZCYYModel.h
//  ZCKit
//
//  Created by admin on 2018/10/12.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCYYModel : NSObject  /**< YYKit解析模型基类，供子类继承 */

#pragma mark - Build & extract
/**
 json数据构建对象
 1.This method is thread-safe.
 2.json -> NSDictionary . NSString . NSData.
 */
+ (nullable instancetype)instanceBulidFormJson:(nullable id)json;

/**
 字典数据构建对象
 1.This method is thread-safe.
 2.invalid key-value will be ignored.
 3.If the value's type does not match the property, this method will try to convert the value based on these rules:
   `NSString` or `NSNumber` -> c number, such as BOOL, int, long, float, NSUInteger...
   `NSString` -> NSDate, parsed with format "yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd HH:mm:ss" or "yyyy-MM-dd".
   `NSString` -> NSURL.
   `NSValue`  -> struct or union, such as CGRect, CGSize, ...
   `NSString` -> SEL, Class.
 */
+ (nullable instancetype)instanceBulidFormInformation:(nullable NSDictionary *)information;

/**
 返回成员为本类对象的数组
 Creates and returns an array from a json-array. This method is thread-safe.
 @param json  A json array of `NSArray`, `NSString` or `NSData`.
 Example: [{"name","Mary"},{name:"Joe"}]
 @return A array, or nil if an error occurs.
 */
+ (nullable NSArray *)instanceArrayFormJson:(nullable id)json;

/**
 返回成员值为本类对象的字典
 Creates and returns a dictionary from a json. This method is thread-safe.
 @param json  A json dictionary of `NSDictionary`, `NSString` or `NSData`.
 Example: {"user1":{"name","Mary"}, "user2": {name:"Joe"}}
 @return A dictionary, or nil if an error occurs.
 */
+ (nullable NSDictionary *)instanceDictionaryFormJson:(nullable id)json;

/**
 返回json数组或者字典
 1.The top level object is an NSArray or NSDictionary.
 2.All objects are instances of NSString . NSNumber . NSArray . NSDictionary . NSNull.
 3.All dictionary keys are instances of NSString.
 4.Numbers are not NaN or infinity.
 */
- (nullable id)extractInformationFromInstance;

- (nullable NSData *)extractDataFromInstance;

- (nullable NSString *)extractStringFromInstance;

- (BOOL)instanceIsEqualTo:(id)instance;

- (NSString *)instanceForDescription;

#pragma mark - Subclass rewriting (not invocation)
/** 属性 -> key 的映射 */
+ (nullable NSDictionary<NSString *, id> *)transformPropertyToKeyMappingRelation;

 /** 容器属性 -> Class 的映射 */
+ (nullable NSDictionary<NSString *, id> *)transformContainerPropertyToClassMappingRelation;

 /** 需要忽略的属性 */
+ (nullable NSArray <NSString *> *)transformIgnoreProperty;

 /** json -> 对象 是否允许转换通过 */
- (BOOL)transformCheckInstanceFromInformation:(NSDictionary *)dic;

 /** 对象 -> json 是否允许转换通过 */
- (BOOL)transformCheckInstanceToInformation:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
