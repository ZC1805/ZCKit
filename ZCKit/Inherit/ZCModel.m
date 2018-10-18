//
//  ZCModel.m
//  ZCKit
//
//  Created by admin on 2018/10/12.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCModel.h"
#import "NSObject+YYModel.h"
#warning - 解析协议
@implementation ZCModel

//json/dictionary中的对象类型与instance属性不一致时，将会进行自动转换。
//自动转换不支持的值将会被忽略，以避免各种潜在的崩溃问题。
//转换中不存在的值将赋值为空或者0等
+ (nullable instancetype)instanceBulidFormJson:(id)json {
    return [self modelWithJSON:json];
}

+ (nullable instancetype)instanceBulidFormInformation:(NSDictionary *)information {
    return [self modelWithDictionary:information];
}

+ (nullable NSArray *)instanceArrayFormJson:(id)json {
    return [NSArray modelArrayWithClass:self json:json];
}

+ (nullable NSDictionary *)instanceDictionaryFormJson:(id)json {
    return [NSDictionary modelDictionaryWithClass:self json:json];
}

- (nullable id)extractInformationFromInstance {
    return [self modelToJSONObject];
}

- (nullable NSData *)extractDataFromInstance {
    return [self modelToJSONData];
}

- (nullable NSString *)extractStringFromInstance {
    return [self modelToJSONString];
}

- (BOOL)instanceIsEqualTo:(id)instance {
    return [self modelIsEqual:instance];
}

- (NSString *)instanceForDescription {
    return [self modelDescription];
}

#pragma mark - optional (默认属性为自定义类的话会自动转)
//返回一个 dict，将实例属性名对映射到json的key。
//expl return @{@"name" : @"n",
//              @"page" : @"p",
//              @"desc" : @"ext.desc",
//              @"bookID" : @[@"id",@"ID",@"book_id"]};
//1.在json->model时，如果一个属性对应了多个json key，那么转换过程会按顺序查找，并使用第一个不为空的值。
//2.在model->json时，如果一个属性对应了多个json key，那么转换过程仅会处理第一个json key。
//  如果多个属性对应了同一个json key，则转换过过程会使用其中任意一个不为空的值。
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return [self transformPropertyToKeyMappingRelation];
}

//主要针对数组或字典属性，(字典写value类型，key默认为str)。
//返回容器类中的所需要存放的数据类型，(以 Class 或 Class Name 的形式)。
//expl return @{@"shadows" : [Shadow class],
//              @"borders" : Border.class,
//              @"attachments" : @"Attachment" };
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return [self transformContainerPropertyToClassMappingRelation];
}

// 如果实现了该方法，则处理过程中会忽略该列表内的所有属性
+ (nullable NSArray<NSString *> *)modelPropertyBlacklist {
    return [self transformIgnoreProperty];
}

// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    return [self transformCheckInstanceFromInformation:dic];
}

// 当 Model 转为 JSON 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    return [self transformCheckInstanceToInformation:dic];
}


#pragma mark - 供子类重写方法
+ (nullable NSDictionary<NSString *, id>*)transformPropertyToKeyMappingRelation {
    return nil;
}

+ (nullable NSDictionary<NSString *, id>*)transformContainerPropertyToClassMappingRelation {
    return nil;
}

+ (NSArray <NSString *>*)transformIgnoreProperty {
    return nil;
}

- (BOOL)transformCheckInstanceFromInformation:(NSDictionary *)dic {
    return YES;
}

- (BOOL)transformCheckInstanceToInformation:(NSDictionary *)dic {
    return YES;
}

@end
