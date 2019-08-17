//
//  ZCBindHandler.m
//  ZCKit
//
//  Created by admin on 2018/11/3.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCBindHandler.h"
#import "NSDictionary+ZC.h"
#import "NSArray+ZC.h"

#pragma mark - ~~~~~~~~~~ ZCBindUnit ~~~~~~~~~~
@interface ZCBindUnit ()

@property (nonatomic, assign) int intRecord;

@property (nullable, nonatomic, weak) id object;

@property (nullable, nonatomic, copy) NSString *showKp;

@property (nullable, nonatomic, copy) NSString *gainKp;

@property (nullable, nonatomic, copy) NSString *saveKp;

@property (nullable, nonatomic, weak) ZCBindHandler *handler;

@property (nullable, nonatomic, copy) BOOL(^allowBlock)(ZCBindUnit *, ZCJsonValue _Nullable);

@property (nullable, nonatomic, copy) ZCJsonValue _Nullable(^saveBlock)(ZCBindUnit *, id _Nullable);

@property (nullable, nonatomic, copy) id _Nullable(^showBlock)(ZCBindUnit *, ZCJsonValue _Nullable);

@property (nullable, nonatomic, copy) BOOL(^changeBlock)(ZCBindUnit *, ZCJsonValue _Nullable, ZCJsonValue _Nullable);

@end

static void *recordContext = @"recordContext";
static int recordMaxMask = (1 << 10) - 1;
static int recordObserverMask = 1 << 0;
static int recordNewSaveMask = 1 << 1;
static int recordLockMask = 1 << 2;

@implementation ZCBindUnit

#pragma mark - init
+ (ZCBindUnit *)unitGainKp:(NSString *)gainKp model:(id)model {
    return [self unitGainKp:gainKp model:model handler:nil saveKp:nil];
}

+ (ZCBindUnit *)unitHandler:(ZCBindHandler *)handler saveKp:(NSString *)saveKp {
    return [self unitGainKp:nil model:nil handler:handler saveKp:saveKp];
}

+ (ZCBindUnit *)unitGainKp:(NSString *)gainKp model:(id)model handler:(ZCBindHandler *)handler saveKp:(NSString *)saveKp {
    ZCBindUnit *unit = [[ZCBindUnit alloc] init];
    unit.gainKp = [gainKp copy]; unit.saveKp = [saveKp copy];
    unit.handler = handler; [unit.handler addUnit:unit];
    return [unit streamObject:nil showKp:nil model:model];
}

#pragma mark - obse
- (void)dealloc {
    if (_intRecord & recordObserverMask) {
        [self removeBindObserver];
    }
}

///!!!:object强引用问题 & 将此设置成rowOperate属性 & 观察者刷新数据问题
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (_showKp && [_showKp isEqualToString:keyPath] && _object && _object == object && context == recordContext) {
        if (!(_intRecord & recordLockMask)) {
            [self injectShowValue:[change objectForKey:NSKeyValueChangeNewKey] manual:NO];
        }
    }
}

- (void)removeBindObserver {
    _intRecord = _intRecord & (recordMaxMask ^ recordObserverMask);
    if (_object && _showKp) {
        [_object removeObserver:self forKeyPath:_showKp context:recordContext];
    }
}

- (void)addBindObserver {
    _intRecord = _intRecord | recordObserverMask;
    if (_object && _showKp) {
        [_object addObserver:self forKeyPath:_showKp options:NSKeyValueObservingOptionNew context:recordContext];
    }
}

#pragma mark - core
- (void)injectShowValue:(id)value manual:(BOOL)isManual {
    _showValue = value;
    if (isManual) {
        _intRecord = _intRecord | recordLockMask;
        [_object setValue:_showValue forKeyPath:_showKp];
        _intRecord = _intRecord & (recordMaxMask ^ recordLockMask);
    } else {
        _saveValue = (_saveBlock ? _saveBlock(self, _showValue) : _showValue);
        if (![ZCGlobal isJsonValue:_saveValue]) {
            NSAssert(0, @"ZCKit: save value is not json value");
            _saveValue = nil;
        }
    }
}

- (ZCBindUnit *)streamObject:(id)object showKp:(NSString *)showKp model:(id)model  {
    if (_intRecord & recordObserverMask) {
        if (!object || object != _object || !showKp || ![_showKp isEqualToString:showKp]) {
            [self removeBindObserver];
        }
    }
    if (!(_intRecord & recordObserverMask)) {
        if (object && showKp) {
            _object = object; _showKp = [showKp copy];
            [self addBindObserver];
        }
    }
    if (model) {
        _gainValue = _gainKp ? [model valueForKeyPath:_gainKp] : model;
        if (![ZCGlobal isJsonValue:_gainValue]) {
            NSAssert(0, @"ZCKit: gain value is not json value");
            _gainValue = nil;
        }
        _saveValue = [_gainValue copy];
        _intRecord = _intRecord | recordNewSaveMask;
        if (_object && _showKp) {
            [self injectShowValue:(_showBlock ? _showBlock(self, _saveValue) : _saveValue) manual:YES];
        }
    } else {
        if (_intRecord & recordNewSaveMask) {
            if (_object && _showKp) {
                [self injectShowValue:(_showBlock ? _showBlock(self, _saveValue) : _saveValue) manual:YES];
            }
        } else {
            if (_object && _showKp) {
                _intRecord = _intRecord | recordNewSaveMask;
                [self injectShowValue:[_object valueForKey:_showKp] manual:NO];
            }
        }
    }
    return self;
}

- (BOOL)allow {
    if (_allowBlock) {
        return _allowBlock(self, _saveValue);
    }
    return YES;
}

- (BOOL)change {
    if (_changeBlock) {
        return _changeBlock(self, _gainValue, _saveValue);
    } else {
        return ![ZCGlobal isEqualToJsonValue:_gainValue other:_saveValue];
    }
}

#pragma mark - api
- (ZCBindUnit *)setTip:(NSString *)tip title:(NSString *)title prompt:(NSString *)prompt {
    _tip = [tip copy]; _title = [title copy]; _prompt = [prompt copy];
    return self;
}

- (ZCBindUnit *)showToSave:(ZCJsonValue _Nullable (^)(ZCBindUnit *, id _Nullable))block {
    self.saveBlock = block;
    return [self streamObject:_object showKp:_showKp model:nil];
}

- (ZCBindUnit *)saveToShow:(id _Nullable (^)(ZCBindUnit *, ZCJsonValue _Nullable))block {
    self.showBlock = block;
    return [self streamObject:_object showKp:_showKp model:nil];
}

- (ZCBindUnit *)checkChange:(BOOL (^)(ZCBindUnit *, ZCJsonValue _Nullable, ZCJsonValue _Nullable))block {
    self.changeBlock = block;
    return self;
}

- (ZCBindUnit *)checkAllow:(BOOL (^)(ZCBindUnit *, ZCJsonValue _Nullable))block {
    self.allowBlock = block;
    return self;
}

- (ZCBindUnit *)relyHandler:(ZCBindHandler *)handler kp:(NSString *)kp {
    [self.handler removeUnit:self]; [handler addUnit:self];
    self.handler = handler; self.saveKp = [kp copy];
    return self;
}

- (ZCBindUnit *)bindObject:(id)object kp:(NSString *)kp {
    [self.handler removeEarlierBind:self object:object kp:kp];
    return [self streamObject:object showKp:kp model:nil];
}

- (ZCBindUnit *)loadModel:(id)model kp:(NSString *)kp {
    self.gainKp = [kp copy];
    return [self streamObject:_object showKp:_showKp model:model];
}

@end


#pragma mark - ~~~~~~~~~~ ZCBindUnitCoat ~~~~~~~~~~
@interface ZCBindUnitCoat : NSObject

@property (nullable, nonatomic, weak) ZCBindUnit *unit;

@end

@implementation ZCBindUnitCoat

- (instancetype)initWithUnit:(ZCBindUnit *)unit {
    if (self = [super init]) {
        self.unit = unit;
    }
    return self;
}

@end


#pragma mark - ~~~~~~~~~~ ZCBindHandler ~~~~~~~~~~
@interface ZCBindHandler ()

@property (nonatomic, strong) NSMutableArray <ZCBindUnitCoat *>*handleUnits;

@end

@implementation ZCBindHandler

#pragma mark - api
+ (BOOL)extract:(id)receiveContainer units:(NSArray <ZCBindUnit *>*)units {
    BOOL isAllow = YES;
    for (ZCBindUnit *unit in units) {
        if (![unit allow]) {
            isAllow = NO; break;
        }
    }
    if (isAllow && receiveContainer) {
        for (ZCBindUnit *unit in units) {
            if ([receiveContainer isKindOfClass:[NSMutableArray class]]) {
                [receiveContainer injectValue:unit.saveValue];
            } else if ([receiveContainer isKindOfClass:[NSMutableDictionary class]]) {
                [receiveContainer injectValue:unit.saveValue forKey:unit.saveKp];
            } else {
                [receiveContainer setValue:unit.saveValue forKey:unit.saveKp];
            }
        }
    }
    return isAllow;
}

+ (BOOL)change:(NSArray <ZCBindUnit *>*)units {
    BOOL isChange = NO;
    for (ZCBindUnit *unit in units) {
        if ([unit change]) {
            isChange = YES; break;
        }
    }
    return isChange;
}

#pragma mark - api
- (BOOL)extract:(id)receiveContainer {
    BOOL isAllow = YES;
    for (ZCBindUnitCoat *coat in _handleUnits) {
        if (coat.unit && ![coat.unit allow]) {
            isAllow = NO; break;
        }
    }
    if (isAllow && receiveContainer) {
        for (ZCBindUnitCoat *coat in _handleUnits) {
            if (coat.unit) {
                if ([receiveContainer isKindOfClass:[NSMutableArray class]]) {
                    [receiveContainer injectValue:coat.unit.saveValue];
                } else if ([receiveContainer isKindOfClass:[NSMutableDictionary class]]) {
                    [receiveContainer injectValue:coat.unit.saveValue forKey:coat.unit.saveKp];
                } else {
                    [receiveContainer setValue:coat.unit.saveValue forKey:coat.unit.saveKp];
                }
            }
        }
    }
    return isAllow;
}

- (BOOL)change {
    BOOL isChange = NO;
    for (ZCBindUnitCoat *coat in _handleUnits) {
        if (coat.unit && [coat.unit change]) {
            isChange = YES; break;
        }
    }
    return isChange;
}

- (void)addUnit:(ZCBindUnit *)unit {
    if (!unit) return; BOOL isExist = NO;
    for (ZCBindUnitCoat *coat in self.handleUnits) {
        if (coat.unit && coat.unit == unit) {
            isExist = YES;
        }
    }
    if (!isExist) {
        [self.handleUnits addObject:[[ZCBindUnitCoat alloc] initWithUnit:unit]];
    }
}

- (void)removeUnit:(ZCBindUnit *)unit {
    if (!unit) return;
    ZCBindUnitCoat *aCoat = nil;
    for (ZCBindUnitCoat *coat in self.handleUnits) {
        if (coat.unit && coat.unit == unit) {
            aCoat = coat;
        }
    }
    if (aCoat) {
        [self.handleUnits removeObject:aCoat];
    }
}

- (void)removeEarlierBind:(ZCBindUnit *)unit object:(id)object kp:(NSString *)kp {
    for (ZCBindUnitCoat *coat in self.handleUnits) {
        if (coat.unit && object && kp && coat.unit != unit && (coat.unit.intRecord & recordObserverMask)) {
            if (coat.unit.object == object && [coat.unit.showKp isEqualToString:kp]) {
                [coat.unit removeBindObserver];
            }
        }
    }
}

#pragma mark - get
- (NSMutableArray <ZCBindUnitCoat *>*)handleUnits {
    if (!_handleUnits) {
        _handleUnits = [NSMutableArray array];
    }
    return _handleUnits;
}

@end
