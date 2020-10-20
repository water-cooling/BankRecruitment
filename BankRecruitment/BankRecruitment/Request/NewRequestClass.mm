//
//  LLRequestClass.m
//  ZhiLi
//
//  Created by 夏建清 on 2017/1/10.
//  Copyright © 2017年 xia jianqing. All rights reserved.
//

#import "NewRequestClass.h"
#import "AFNetworking.h"

#define kPreGetOrSendCount 30

@implementation LLRequestClass
//发起POST请求直接调用
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(HttpSuccess)success failure:(HttpFailure)failure {
    if(!url) {
        return;
    }
    //判断网络状况
    if([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
    {
        ZB_Toast(@"网络连接失败，请检查网络");
        failure([NSError errorWithDomain:@"No Network" code:0 userInfo:nil]);
        return;
    }
    [self postRequestWithMethod:@"POST" url:url params:params success:success failure:failure];
}

//发起GET请求直接调用
+ (void)getWithURL:(NSString *)url success:(HttpSuccess)success failure:(HttpFailure)failure {
    if(!url) {
        return;
    }
    //判断网络状况
    if([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
    {
        ZB_Toast(@"网络连接失败，请检查网络");
        failure([NSError errorWithDomain:@"No Network" code:0 userInfo:nil]);
        return;
    }

    [self getRequestWithMethod:@"GET" url:url success:success failure:failure];
}

//POST请求（仅本类内部调用，无外部接口）
+ (void)postRequestWithMethod:(NSString *)method url:(NSString *)url params:(NSDictionary *)params success:(HttpSuccess)success failure:(HttpFailure)failure {
    if(!url)
    {
        return;
    }
    
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = nil;
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60.0f;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    for(NSString *key in params.allKeys)
    {
        [dict setObject:getISO8859withString([params objectForKey:key]) forKey:key];
    }
    
    NSLog(@"%@ %@", url, dict);
    [manager POST:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error){
            failure(error);
        }
    }];
}

//GET请求（仅本类内部调用，无外部接口）
+ (void)getRequestWithMethod:(NSString *)method url:(NSString *)url success:(HttpSuccess)success failure:(HttpFailure)failure {
    if(!url)
    {
        return;
    }

    NSLog(@"%@", url);
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = nil;
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60.0f;
    [manager GET:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(error) {
            failure(error);
        }
    }];
}

#pragma -mark sub functions

/**
 获取数据类别
 */
+ (void)requestGetTypeByIType:(NSString *)IType success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetType&IType=%@", [LdGlobalObj sharedInstanse].webAppIp, IType];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetType" forKey:@"action"];
    [dict setObject:IType forKey:@"IType"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

@end
