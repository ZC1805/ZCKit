//
//  JFUser.h
//  gobe
//
//  Created by zjy on 2019/3/20.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFUser : NSObject

@property (nonatomic, copy) NSString *nike;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *accid;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, assign) BOOL isLoginSuccess;

+ (instancetype)currentUser;  //为nil时候即未登陆

+ (void)save;

@end



@interface JFUserItem : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString *nike;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *token;  //必须有

@property (nonatomic, copy) NSString *accid;  //必须有，用户唯一标示

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *md5Password;  //必须有，扥光

@property (nonatomic, assign) NSInteger passLength;

@property (nonatomic, assign) BOOL isRememberCode;

@property (nonatomic, assign) BOOL isAutoLogin;

@property (nonatomic, assign) BOOL isLastLogin;

- (BOOL)validUserInfo;

- (instancetype)initWithMobile:(NSString *)mobile md5Password:(NSString *)pass nike:(NSString *)nike
                         accid:(NSString *)accid token:(NSString *)md5Token passLength:(NSInteger)passLength
                          icon:(NSString *)icon autoLogin:(BOOL)autoLogin rememberPassword:(BOOL)rememberPassword;

@end



//@interface JFUserManager : NSObject
//
//+ (instancetype)sharedManager;
//
//@property (nullable, nonatomic, strong) JFUserItem *currentUser;
//
//- (nullable NSArray <JFUserItem *>*)obtainHistoryLoginUser;
//
//- (void)saveLoginUserInfo:(JFUserItem *)loginUserInfo;
//
//- (void)removeLoginUserInfoAtIndex:(NSInteger)index;
//
//- (void)cancelLoginUser;
//
//@end

NS_ASSUME_NONNULL_END
