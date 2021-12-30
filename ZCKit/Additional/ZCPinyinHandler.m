//
//  ZCPinyinHandler.m
//  ZCKit
//
//  Created by admin on 2019/1/9.
//  Copyright © 2019 Squat in house. All rights reserved.
//

#import "ZCPinyinHandler.h"

#define K_SPELL_UNIT_FULLSPELL   @"f"
#define K_SPELL_UNIT_SHORTSPELL  @"s"
#define K_SPELL_CACHE            @"sc"

#pragma mark - ~ ZCPinyinConverter ~
@interface ZCPinyinConverter : NSObject {
    BOOL _inited;
    char *_pinyin;
    int  *_codeIndex;
}

@end

@implementation ZCPinyinConverter

+ (ZCPinyinConverter *)sharedConverter {
    static dispatch_once_t onceToken;
    static ZCPinyinConverter *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[ZCPinyinConverter alloc] init];
    });
    return instance;
}

- (NSString *)toPinyin:(NSString *)source {
    if ([source length] == 0) return nil;
    NSMutableString *mutableString = [NSMutableString stringWithString:source];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:NSLocale.currentLocale];
    return [mutableString stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

@end


#pragma mark - ~ ZCSpellUnit ~
@interface ZCSpellUnit : NSObject <NSCoding>

@property (nonatomic, copy) NSString *fullSpell;  /**< 全拼 */

@property (nonatomic, copy) NSString *shortSpell;  /**< 简写 */

@end

@implementation ZCSpellUnit

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_fullSpell forKey:K_SPELL_UNIT_FULLSPELL];
    [aCoder encodeObject:_shortSpell forKey:K_SPELL_UNIT_SHORTSPELL];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.fullSpell = [aDecoder decodeObjectForKey:K_SPELL_UNIT_FULLSPELL];
        self.shortSpell = [aDecoder decodeObjectForKey:K_SPELL_UNIT_SHORTSPELL];
    }
    return self;
}

@end


#pragma mark - ~ ZCPinyinHandler ~
@interface ZCPinyinHandler () {
    NSMutableDictionary *_spellCache;
    NSString *_filePath;
}

@end

@implementation ZCPinyinHandler

+ (ZCPinyinHandler *)sharedHandler {
    static dispatch_once_t onceToken;
    static ZCPinyinHandler *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[ZCPinyinHandler alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *appDocumentPath = [[NSString alloc] initWithFormat:@"%@/", [paths objectAtIndex:0]];
        _filePath = [appDocumentPath stringByAppendingPathComponent:K_SPELL_CACHE];
        _spellCache = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:_filePath];
            if ([dict isKindOfClass:NSDictionary.class]) {
                _spellCache = [[NSMutableDictionary alloc] initWithDictionary:dict];
            }
        }
        if (!_spellCache) {
            _spellCache = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (void)saveCache {
    static const NSInteger kMaxEntriesCount = 5000;
    @synchronized(self) {
        NSInteger count = [_spellCache count];
        if (count >= kMaxEntriesCount) {
            [_spellCache removeAllObjects];
        }
        if (_spellCache) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_spellCache];
            [data writeToFile:_filePath atomically:YES];
        }
    }
}

- (ZCSpellUnit *)spellForString:(NSString *)source {
    ZCSpellUnit *spellUnit = nil;
    if (!source || !source.length) return spellUnit;
    @synchronized(self) {
        ZCSpellUnit *unit = [_spellCache objectForKey:source];
        if (!unit) {
            unit = [self calcSpellOfString:source];
            if ([unit.fullSpell length] && [unit.shortSpell length]) {
                [_spellCache setObject:unit forKey:source];
            }
        }
        spellUnit = unit;
    }
    return spellUnit;
}

- (ZCSpellUnit *)calcSpellOfString:(NSString *)source {
    NSMutableString *fullSpell = [[NSMutableString alloc] init];
    NSMutableString *shortSpell = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < [source length]; i++) {
        NSString *word = [source substringWithRange:NSMakeRange(i, 1)];
        NSString *pinyin = [[ZCPinyinConverter sharedConverter] toPinyin:word];
        if ([pinyin length]) {
            [fullSpell appendString:pinyin];
            [shortSpell appendString:[pinyin substringToIndex:1]];
        }
    }
    ZCSpellUnit *unit = [[ZCSpellUnit alloc] init];
    unit.fullSpell = [fullSpell lowercaseString];
    unit.shortSpell = [shortSpell lowercaseString];
    return unit;
}

+ (void)saveSpellCache {
    [[ZCPinyinHandler sharedHandler] saveCache];
}

+ (NSString *)firstLetter:(NSString *)source {
    ZCSpellUnit *unit = [[ZCPinyinHandler sharedHandler] spellForString:source];
    if (!unit) return @"";
    NSString *spell = unit.fullSpell;
    return spell.length ? [spell substringWithRange:NSMakeRange(0, 1)] : @"";
}

+ (NSString *)fullSpell:(NSString *)source {
    ZCSpellUnit *unit = [[ZCPinyinHandler sharedHandler] spellForString:source];
    if (!unit || !unit.fullSpell) return @"";
    return unit.fullSpell;
}

+ (NSString *)shortSpell:(NSString *)source {
    ZCSpellUnit *unit = [[ZCPinyinHandler sharedHandler] spellForString:source];
    if (!unit || !unit.shortSpell) return @"";
    return unit.shortSpell;
}

@end
