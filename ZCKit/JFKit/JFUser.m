//
//  JFUser.m
//  gobe
//
//  Created by zjy on 2019/3/20.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFUser.h"
#import "JFFileHelper.h"

#pragma mark - Class JFUser
@implementation JFUser

+ (instancetype)currentUser {
    static dispatch_once_t onceToken;
    static JFUser *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[JFUser alloc] init];
    });
    return instance;
}

@end



#pragma mark - Class JFUserItem

#define JFAIcon           @"icon"
#define JFAMobile         @"mobile"
#define JFAAccid          @"accid"
#define JFANike           @"nike"
#define JFAToken          @"token"
#define JFAMd5Password    @"md5Password"
#define JFAAutoLogin      @"autoLogin"
#define JFARememberCode   @"rememberCode"
#define JFALastLogin      @"lastLogin"
#define JFAPassLength     @"passLength"

@implementation JFUserItem

+ (BOOL)supportsSecureCoding {
    return YES;
}

+ (NSString *)saveString:(NSString *)md5s {
    NSMutableString *s = [[NSMutableString alloc] init];
    for (int i = 0; i < md5s.length; i++) {
        unichar x = [md5s characterAtIndex:i];
        NSInteger y = (NSInteger)x;
        y = y ^ (1080*(i%2 ? -i-320 : i+320) + i);
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"%ld", ABS(y)];
        NSString *c4 = [str substringWithRange:NSMakeRange(4, 1)];
        NSString *c5 = [str substringWithRange:NSMakeRange(5, 1)];
        [str replaceCharactersInRange:NSMakeRange(0, 1) withString:c4];
        [str replaceCharactersInRange:NSMakeRange(4, 1) withString:c5];
        NSString *tar = [str substringToIndex:5];
        [s appendString:tar];
    }
    return s;
}

+ (NSString *)obtainString:(NSString *)pass {
    NSMutableString *s = [[NSMutableString alloc] init];
    NSInteger length = pass.length / 5;
    for (int i = 0; i < length; i++) {
        NSMutableString *str = [[pass substringWithRange:NSMakeRange(i*5, 5)] mutableCopy];
        NSString *c1 = [str substringWithRange:NSMakeRange(0, 1)];
        [str insertString:c1 atIndex:4];
        [str replaceCharactersInRange:NSMakeRange(0, 1) withString:@"3"];
        NSInteger x = i%2 ? -[str integerValue] : [str integerValue];
        NSInteger y = x ^ (1080*(i%2 ? -i-320 : i+320) + i);
        [s appendFormat:@"%c",(unichar)y];
    }
    return s;
}

- (BOOL)validUserInfo {
    return (self && self.isLastLogin && self.isAutoLogin && self.md5Password.length && self.mobile && self.accid && self.token.length);
}

- (instancetype)initWithMobile:(NSString *)mobile md5Password:(NSString *)pass nike:(NSString *)nike
                         accid:(NSString *)accid token:(NSString *)md5Token passLength:(NSInteger)passLength
                          icon:(NSString *)icon autoLogin:(BOOL)autoLogin rememberPassword:(BOOL)rememberPassword {
    if (self = [super init]) {
        self.mobile = mobile;
        self.md5Password = pass;
        self.passLength = passLength;
        self.icon = icon;
        self.accid = accid;
        self.token = md5Token;
        self.nike = nike;
        self.isAutoLogin = autoLogin;
        self.isRememberCode = rememberPassword;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _icon = [aDecoder decodeObjectOfClass:[NSString class] forKey:JFAIcon];
        _nike = [aDecoder decodeObjectOfClass:[NSString class] forKey:JFANike];
        _accid = [aDecoder decodeObjectOfClass:[NSString class] forKey:JFAAccid];
        _mobile = [aDecoder decodeObjectOfClass:[NSString class] forKey:JFAMobile];
        _isAutoLogin = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:JFAAutoLogin] boolValue];
        _isRememberCode = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:JFARememberCode] boolValue];
        _isLastLogin = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:JFALastLogin] boolValue];
        _passLength = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:JFAPassLength] integerValue];
        _md5Password = [JFUserItem obtainString:[aDecoder decodeObjectOfClass:[NSString class] forKey:JFAMd5Password]];
        _token = [JFUserItem obtainString:[aDecoder decodeObjectOfClass:[NSString class] forKey:JFAToken]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    if (_accid) {
        [encoder encodeObject:_icon forKey:JFAIcon];
        [encoder encodeObject:_nike forKey:JFANike];
        [encoder encodeObject:_accid forKey:JFAAccid];
        [encoder encodeObject:_mobile forKey:JFAMobile];
        [encoder encodeObject:[NSNumber numberWithBool:_isAutoLogin] forKey:JFAAutoLogin];
        [encoder encodeObject:[NSNumber numberWithBool:_isRememberCode] forKey:JFARememberCode];
        [encoder encodeObject:[NSNumber numberWithBool:_isLastLogin] forKey:JFALastLogin];
        [encoder encodeObject:[NSNumber numberWithInteger:_passLength] forKey:JFAPassLength];
        [encoder encodeObject:[JFUserItem saveString:_md5Password] forKey:JFAMd5Password];
        [encoder encodeObject:[JFUserItem saveString:_token] forKey:JFAToken];
    }
}

@end



//#pragma mark - Class JFUserManager
//@interface JFUserManager ()
//
//@property (nonatomic, copy) NSString  *filepath;
//
//@property (nonatomic, strong) NSArray <JFUserItem *>* loginUserInfos;
//
//@end
//
//@implementation JFUserManager
//
//+ (instancetype)sharedManager {
//    static dispatch_once_t onceToken;
//    static JFUserManager *instance = nil;
//    dispatch_once(&onceToken, ^{
//        NSString *filepath = [[JFFileHelper appDocumentPath] stringByAppendingPathComponent:@"login_data"];
//        instance = [[JFUserManager alloc] initWithPath:filepath];
//    });
//    return instance;
//}
//
//- (instancetype)initWithPath:(NSString *)filepath {
//    if (self = [super init]) {
//        _filepath = filepath;
//        [self readData];
//    }
//    return self;
//}
//
//- (void)readData {
//    NSString *filepath = [self filepath];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
//        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
//        _loginUserInfos = [object isKindOfClass:[NSArray class]] ? object : nil;
//    }
//}
//
//- (void)saveData {
//    if (_loginUserInfos.count) {
//        [NSKeyedArchiver archiveRootObject:_loginUserInfos toFile:_filepath];
//    } else {
//        if ([[NSFileManager defaultManager] fileExistsAtPath:_filepath]) {
//            [[NSFileManager defaultManager] removeItemAtPath:_filepath error:nil];
//        }
//    }
//}
//
//#pragma mark - Api
//- (void)saveLoginUserInfo:(JFUserItem *)loginUserInfo {
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    for (JFUserItem *loginUser in _loginUserInfos) {
//        if (![loginUserInfo.accid isEqualToString:loginUser.accid]) {
//            loginUser.isLastLogin = NO;
//            [array addObject:loginUser];
//        }
//    }
//    loginUserInfo.isLastLogin = YES;
//    [array addObject:loginUserInfo];
//    _loginUserInfos = [array copy];
//    [self saveData];
//}
//
//- (void)removeLoginUserInfoAtIndex:(NSInteger)index {
//    NSMutableArray *array = [_loginUserInfos mutableCopy];
//    [array removeObjectAtIndex:index];
//    _loginUserInfos = [array copy];
//    [self saveData];
//}
//
//- (void)cancelLoginUser {
//    JFUserItem *loginUser = [JFUserManager sharedManager].currentUser;
//    if (loginUser && loginUser.isLastLogin) {
//        loginUser.md5Password = nil;
//        [[JFUserManager sharedManager] saveLoginUserInfo:loginUser];
//    }
//}
//
//#pragma mark - Get
//- (NSArray <JFUserItem *>*)obtainHistoryLoginUser {
//    return _loginUserInfos;
//}
//
//- (JFUserItem *)currentUser {
//    if (_loginUserInfos.count) {
//        return _loginUserInfos.lastObject;
//    } else {
//        return nil;
//    }
//}
//
//@end
