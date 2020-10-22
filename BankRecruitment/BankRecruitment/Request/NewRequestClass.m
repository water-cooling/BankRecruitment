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
#define getQuestionCats     @"yikao/yk-question/getQuestionCats"//获取评论选择分类
#define Recruitmentlogin   @"yikao/uc/login"//登录
#define Recruitmentlogout  @"yikao/uc/logout"//登出
#define getQuestionList @"yikao/yk-question/list"//问题列表
#define addQuestion @"yikao/yk-question/addQuestion"//新增问题
#define questionDetail @"api/yikao/yk-question/detail"//问题详情
#define getMyQuestionList @"yikao/yk-question/myList"//我的问题列表
#define getAnswerList @"yikao/yk-question-answer/list"//解答列表
#define addAnswer @"yikao/yk-question-answer/addQuestionAnswer"//回答问题
#define praiseAnswer @"yikao/yk-question-answer/praise"//点赞解答
#define deleteAnswer @"ikao/yk-question-answer/del"//删除解答
#define cancelPraiseAnswer @"yk-question-answer/praiseCancel"//取消点赞




@implementation NewRequestClass
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
        [dict setObject:[params objectForKey:key] forKey:key];
    }
    [dict setValue:@"767348035122757632" forKey:@"appId"];
    NSLog(@"%@ %@", url, dict);
    [manager POST:[[LdGlobalObj sharedInstanse].webNewAppIp stringByAppendingString:url] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         id response =[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(response);
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
    [url stringByAppendingString:@"?appId=767348035122757632"];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = nil;
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60.0f;
    [manager GET:[[LdGlobalObj sharedInstanse].webNewAppIp stringByAppendingPathComponent:url] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(error) {
            failure(error);
        }
    }];
}

#pragma -mark sub functions

/**
 获取分类
 */
+ (void)requestQuestionCats:(NSMutableDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure{
    [NewRequestClass getWithURL:getQuestionCats success:^(id jsonData) {
        success(jsonData);

    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }

    }];
}

/**
 获取登录
 */
+ (void)requestLogin:(NSMutableDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure{
    [NewRequestClass postWithURL:Recruitmentlogin params:parameters success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}
@end
