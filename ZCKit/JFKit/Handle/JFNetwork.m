//
//  JFNetwork.m
//  gobe
//
//  Created by zjy on 2019/3/16.
//  Copyright © 2019年 com.jinfeng.credit. All rights reserved.
//

#import "JFNetwork.h"
#import <AFNetworking.h>

static const BOOL JFNetDoLog = YES;

@interface JFNetwork ()

@end

@implementation JFNetwork

+ (instancetype)sharedNetwork {
    static dispatch_once_t onceToken;
    static JFNetwork *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[JFNetwork alloc] init];
        instance.networkState = NSLocalizedString(@"当前在WIFI网络下", nil);
        [instance startReachabilityStatus];
    });
    return instance;
}

- (void)startReachabilityStatus {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{
                self.networkState = NSLocalizedString(@"未知网络", nil);
                self.isBreakContact = YES;
            } break;
            case AFNetworkReachabilityStatusNotReachable: {
                self.networkState = NSLocalizedString(@"无法联网", nil);
                self.isBreakContact = YES;
            } break;
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                self.networkState = NSLocalizedString(@"当前使用的是2G/3G/4G网络", nil);
                self.isBreakContact = NO;
            } break;
            default: {
                self.networkState = NSLocalizedString(@"当前在WIFI网络下", nil);
                self.isBreakContact = NO;
            }
        }
    }];
}

- (void)request:(NSString *)cmdUrl pars:(NSDictionary *)pars post:(BOOL)isPost header:(NSDictionary *)header
         upload:(NSArray <id >*)upload base64:(BOOL)isBase64 progress:(void(^)(float progress))progress
          block:(void (^)(NSString * _Nullable, NSDictionary * _Nullable))block {
    if (self.isBreakContact) {if (block) {block(NSLocalizedString(@"无法连接到网络！", nil), nil); return;}}
    if (cmdUrl == nil || cmdUrl.length == 0) {NSAssert(0, @"request cmd is nil"); return;}
    [self logRequest:cmdUrl pars:pars isUpload:(isBase64 || (upload && upload.count))];
    NSURL *basicUrl = [NSURL URLWithString:[JFOfficer sharedOfficer].basicUrl];
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] initWithBaseURL:basicUrl];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    if ([[JFOfficer sharedOfficer].basicUrl hasPrefix:@"https://"] || [cmdUrl hasPrefix:@"https://"]) {
        session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    }
    [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [session.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    [session.requestSerializer setTimeoutInterval:30];
    [session.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    if (isBase64) {
        NSString *putStr = [JFHSUtilsTool convertToJsonData:pars];
        NSData *putData = [putStr dataUsingEncoding:NSUTF8StringEncoding];
        //NSData *data = [NSJSONSerialization dataWithJSONObject:pars options:NSJSONWritingPrettyPrinted error:nil];
        [session POST:cmdUrl parameters:putData progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                });
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handle:cmdUrl object:responseObject error:nil block:block];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handle:cmdUrl object:nil error:error block:block];
        }];
    } else if (upload && upload.count) {
        [session POST:cmdUrl parameters:pars constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//            // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
//            // 这里的_photoArr是你存放图片的数组
//            for (int i = 0; i < images.count; i++) {
//                UIImage *image = images[i];
//                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
//                // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名 要解决此问题，可以在上传时使用当前的系统事件作为文件名
//                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                // 设置时间格式
//                [formatter setDateFormat:@"yyyyMMddHHmmss"];
//                NSString *dateString = [formatter stringFromDate:[NSDate date]];
//                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", dateString];
//                /*
//                 *该方法的参数1. appendPartWithFileData：要上传的照片[二进制流]
//                 2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
//                 3. fileName：要保存在服务器上的文件名
//                 4. mimeType：上传的文件的类型
//                 */
//                [formData appendPartWithFileData:imageData name:@"upload" fileName:fileName mimeType:@"image/jpeg"]; //
//            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                });
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handle:cmdUrl object:responseObject error:nil block:block];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handle:cmdUrl object:nil error:error block:block];
        }];
    } else if (isPost) {
        [session POST:cmdUrl parameters:pars progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handle:cmdUrl object:responseObject error:nil block:block];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handle:cmdUrl object:nil error:error block:block];
        }];
    } else {
        [session GET:cmdUrl parameters:pars progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handle:cmdUrl object:responseObject error:nil block:block];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handle:cmdUrl object:nil error:error block:block];
        }];
    }
}

- (void)handle:(NSString *)cmdUrl object:(id)responseObject error:(NSError *)error
        block:(void (^)(NSString * _Nullable, NSDictionary * _Nullable))block {
    if (error) {
        NSString *errorStr = [JFNetwork errorString:error];
        [self logResponse:cmdUrl data:nil fail:nil error:errorStr];
        if (block) block(errorStr, nil);
    } else {
        NSDictionary *data = nil;
        NSString *errorStr = nil;
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            data = [responseObject jsonObject];
        }
        if (data == nil || [data isKindOfClass:[NSDictionary class]] == NO) {
            data = [NSDictionary dictionary];
            if (errorStr == nil) errorStr = [JFNetwork errorString:nil];
            [self logResponse:cmdUrl data:nil fail:responseObject error:errorStr];
        } else {
            if ([data longValueForKey:@"resultCode"] == 0) {
                [self logResponse:cmdUrl data:data fail:nil error:nil];
                //NSDictionary *info = [data objectForKey:@"systemsHome"];
                //if (info && [info isKindOfClass:[NSDictionary class]]) {
                //    [self logResponse:cmdUrl data:data fail:nil error:nil];
                //    data = [data dictionaryValueForKey:@"systemsHome"];
                //} else {
                //    if (errorStr == nil) errorStr = [JFNetwork errorString:nil];
                //    [self logResponse:cmdUrl data:data fail:nil error:errorStr];
                //}
            } else {
                if ([data longValueForKey:@"resultCode"] == 2) [self clearSaveUserData];
                errorStr = [data stringValueForKey:@"resultCodeMessage"];
                if (errorStr == nil) errorStr = [JFNetwork errorString:nil];
                [self logResponse:cmdUrl data:data fail:nil error:errorStr];
            }
        }
        if (block) block(errorStr, data);
    }
}

+ (void)image:(UIImage *)image block:(void (^)(NSString * _Nullable, NSString * _Nullable))block {
    if (image == nil) return;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
    NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSMutableDictionary *pars = [NSMutableDictionary dictionary];
    [pars injectValue:imageStr forKey:@"image"];
    [pars injectValue:@"1" forKey:@"type"];
    [JFHttpsTool requestType:@"POST" passwordStr:@"" putWithUrl:[JT_MS_URL stringByAppendingString:@"/xjt/uploadImage"]
               withParameter:pars withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if (block) {
            if ((msg && msg.length) || ![data objectForKey:@"imagePath"]) {
                block(msg, nil);
            } else {
                block(nil, [data objectForKey:@"imagePath"]);
            }
        }
    } withErrorCodeTwo:^{
        
    } withErrorBlock:^(NSError * _Nonnull error) {
        if (block) block([self errorString:nil], nil);
    }];
}

+ (void)post:(NSString *)cmdUrl pars:(NSDictionary *)pars block:(void (^)(NSString * _Nullable, NSDictionary * _Nullable))block {
    [JFHttpsTool requestType:@"POST" passwordStr:@"" putWithUrl:cmdUrl
               withParameter:pars withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
                   if (block) {
                       if (msg && msg.length) {
                           block(msg, nil);
                       } else {
                           block(nil, data);
                       }
                   }
               } withErrorCodeTwo:^{
                   
               } withErrorBlock:^(NSError * _Nonnull error) {
                   if (block) block([self errorString:nil], nil);
               }];
}

//+ (void)post:(NSString *)cmdUrl pars:(NSDictionary *)pars block:(void (^)(NSString * _Nullable, NSDictionary * _Nullable))block {
//    NSDictionary *header = nil;
//    NSString *api_key = [pars stringValueForKey:@"API_KEY"];
//    if (api_key.length) header = [NSDictionary dictionaryWithObject:api_key forKey:@"API_KEY"];
//    if (api_key.length) pars = [pars restExceptForKeys:@[@"API_KEY"]];
//    [[JFNetwork sharedNetwork] request:cmdUrl pars:pars post:YES header:header upload:nil base64:NO progress:nil block:block];
//}

+ (void)get:(NSString *)cmdUrl pars:(NSDictionary *)pars block:(void (^)(NSString * _Nullable, NSDictionary * _Nullable))block {
    NSDictionary *header = nil;
    NSString *api_key = [pars stringValueForKey:@"API_KEY"];
    if (api_key.length) header = [NSDictionary dictionaryWithObject:api_key forKey:@"API_KEY"];
    if (api_key.length) pars = [pars restExceptForKeys:@[@"API_KEY"]];
    if (header == nil) header = @{@"API_KEY" : ZCStrNonnil([JFUserManager shareManager].currentUserInfo.keyStr)};
    [[JFNetwork sharedNetwork] request:cmdUrl pars:pars post:NO header:header upload:nil base64:NO progress:nil block:block];
}

+ (NSString *)errorString:(NSError *)error {
    if (error && error.userInfo && [error.userInfo stringValueForKey:@"resultCodeMessage"].length) {
        return [error.userInfo stringValueForKey:@"resultCodeMessage"];
    }
    return NSLocalizedString(@"服务器出现点小问题，请稍户再试！", nil);
}

#pragma mark - Misc
- (void)logRequest:(NSString *)cmdUrl pars:(NSDictionary *)pars isUpload:(BOOL)isUpload {
    if (!DEBUG || !JFNetDoLog) return;
    NSString *parsStr = nil;
    if (pars) parsStr = pars.jsonString;
    if (isUpload) parsStr = @"upload data";
    NSLog(@"***** request -> %@ -> %@ \n", cmdUrl, parsStr);
}

- (void)logResponse:(NSString *)cmdUrl data:(NSDictionary *)data fail:(id)fail error:(NSString *)error {
    if (!DEBUG || !JFNetDoLog) return;
    NSString *dataStr = fail;
    if (error) dataStr = error;
    if (data) dataStr = data.jsonString;
    if (fail && [fail isKindOfClass:[NSData class]]) dataStr = [(NSData *)fail utf8String];
    NSLog(@"~~~~~ receive -> %@ -> %@ -> %@ \n", cmdUrl, (error ? @"failure" : @"success"), dataStr);
}

- (void)clearSaveUserData {
    //[JFUserManager shareManager].currentUserInfo = [[JFUserInfoTool alloc] init];  //清除消息
}





//-(AFSecurityPolicy*)customSecurityPolicy1 {
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
//    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    securityPolicy.allowInvalidCertificates = YES;
//    securityPolicy.validatesDomainName=NO;
//    securityPolicy.pinnedCertificates= [NSSetsetWithArray:@[cerData]];
//    return securityPolicy;
//}


////支持https
//-  (AFSecurityPolicy *)customSecurityPolicy
//{
//    //先导入证书，找到证书的路径
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"" ofType:@"cer"];
//    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//
//    //AFSSLPinningModeCertificate 使用证书验证模式
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//
//    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//    //如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
//
//    //validatesDomainName 是否需要验证域名，默认为YES；
//    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//    //如置为NO，建议自己添加对应域名的校验逻辑。
//    securityPolicy.validatesDomainName = NO;
//    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
//    securityPolicy.pinnedCertificates = set;
//
//    return securityPolicy;
//}

//- (instancetype)initWithBaseURL:(NSURL *)url
//{
//    self = [super initWithBaseURL:url];
//    if (self) {
//        AFSecurityPolicy *securityPolicy = [self customSecurityPolicy];
//        self.securityPolicy = securityPolicy;
//        // self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
//        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
//        // self.requestSerializer = [AFHTTPRequestSerializer serializer];
//        self.requestSerializer = [AFJSONRequestSerializer serializer];
//        // [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        // NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",@"xx"];
//        // [self.requestSerializer setValue:@"multipart/form-data"  forHTTPHeaderField:@"Content-Type"];
//        // [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        // [self.requestSerializer setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
//    }
//    return self;
//}







//- (void)uploadWithURLString:(NSString *)URLString parameters:(id)parameters uploadParam:(NSArray<UploadParam *> *)uploadParams success:(void (^)())success failure:(void (^)(NSError *))failure {
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        for (UploadParam *uploadParam in uploadParams) {
//            [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
//        }
//    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//}
//
//#pragma mark - 下载数据
//- (void)downLoadWithURLString:(NSString *)URLString parameters:(id)parameters progerss:(void (^)())progress success:(void (^)())success failure:(void (^)(NSError *))failure {
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
//    NSURLSessionDownloadTask *downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        if (progress) {
//            progress();
//        }
//    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        return targetPath;
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//    [downLoadTask resume];
//}



@end
