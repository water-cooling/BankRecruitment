//
//  LLRequestClass.m
//  ZhiLi
//
//  Created by 夏建清 on 2017/1/10.
//  Copyright © 2017年 xia jianqing. All rights reserved.
//

#import "LLRequestClass.h"
#import "AFNetworking.h"

#define kPreGetOrSendCount 30

@implementation LLRequestClass
//发起POST请求直接调用
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(HttpSuccess)success failure:(HttpFailure)failure {
    if(!url) {
        return;
    } else {
        
        if ([LdGlobalObj sharedInstanse].httpSelect == GlobalHttpSelectOpen) {
            if ([url hasPrefix:@"http:"]) {
                url = [NSString stringWithFormat:@"https:%@",[url substringFromIndex:5]];
            }
        }
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
    } else {

        if ([LdGlobalObj sharedInstanse].httpSelect == GlobalHttpSelectOpen) {
            if ([url hasPrefix:@"http:"]) {
                url = [NSString stringWithFormat:@"https:%@",[url substringFromIndex:5]];
            }
        }
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

/**
 开机广告图片
 */
+ (void)requestBootScrollPicsBysuccess:(HttpSuccess)success failure:(HttpFailure)failure{
    
//    NSString *url = [NSString stringWithFormat:@"%@?action=getBootScrollPics&uid=0", [LdGlobalObj sharedInstanse].webAppIp];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"getBootScrollPics" forKey:@"action"];
    [dict setObject:@"0" forKey:@"uid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 登录
 */
+ (void)requestLoginByPhone:(NSString *)phone Password:(NSString *)password success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doLogin&mobile=%@&pass=%@", [LdGlobalObj sharedInstanse].webAppIp, phone, password];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doLogin" forKey:@"action"];
    [dict setObject:phone forKey:@"mobile"];
    [dict setObject:password forKey:@"pass"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 重设密码
 */
+ (void)requestResetPassWordByOldPwd:(NSString *)passOld NewPassword:(NSString *)password success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doUpPass&uid=%@&pass=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, password];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doUpPass" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:password forKey:@"pass"];
     [dict setObject:passOld forKey:@"passOld"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 修改昵称
 */
+ (void)requestmodifyNameByPet:(NSString *)Pet success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doPutPet&uid=%@&Pet=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, Pet];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doPutPet" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:Pet forKey:@"Pet"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 短信验证码 type :0 注册 1：找回密码 ：3 微信注册增加手机号
 */
+ (void)requestSMSByPhone:(NSString *)phone type:(NSString *)type success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doIdentifying&mobile=%@&type=%@", [LdGlobalObj sharedInstanse].webAppIp, phone, type];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doIdentifying" forKey:@"action"];
    [dict setObject:phone forKey:@"mobile"];
    [dict setObject:type forKey:@"type"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 注册
 */
+ (void)requestRegisterByPhone:(NSString *)phone Password:(NSString *)password success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doRegister&mobile=%@&pass=%@", [LdGlobalObj sharedInstanse].webAppIp, phone, password];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doRegister" forKey:@"action"];
    [dict setObject:phone forKey:@"mobile"];
    [dict setObject:password forKey:@"pass"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 微信注册
 unionid：微信唯一ID
 nickname：微信昵称
 */
+ (void)requestRegisterWXByunionid:(NSString *)unionid nickname:(NSString *)nickname success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doRegisterWX" forKey:@"action"];
    [dict setObject:unionid forKey:@"unionid"];
    [dict setObject:nickname forKey:@"nickname"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 苹果登录
 unionid  苹果唯一ID
 nickname：苹果昵称
 */
+ (void)requestRegisterAppleByunionid:(NSString *)unionid nickname:(NSString *)nickname success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doRegisterWX" forKey:@"action"];
    [dict setObject:[NSString stringWithFormat:@"IOS_%@",unionid] forKey:@"unionid"];
    [dict setObject:nickname ? nickname : @"" forKey:@"nickname"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}


/**
 微信登录 注册手机号码
 mobile：手机号码
 uid：由微信注册接口 传回来的UID
 */
+ (void)requestCheckWXBymobile:(NSString *)mobile uid:(NSString *)uid success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doCheckWxRegisterPhone" forKey:@"action"];
    [dict setObject:mobile forKey:@"mobile"];
    [dict setObject:uid forKey:@"uid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 找回密码
 */
+ (void)requestFindPasswordByPhone:(NSString *)phone Password:(NSString *)password success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetPass&mobile=%@&pass=%@", [LdGlobalObj sharedInstanse].webAppIp, phone, password];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetPass" forKey:@"action"];
    [dict setObject:phone forKey:@"mobile"];
    [dict setObject:password forKey:@"pass"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取所有广告
 */
+ (void)requestGetAllAdBySuccess:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetAdv", [LdGlobalObj sharedInstanse].webAppIp];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetAdv" forKey:@"action"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 根据开放时间获取符合条件的试卷
 */
+ (void)requestdoGetExaminByTypeInfo:(NSString *)TypeInfo Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetExamin&uid=%@&TypeInfo=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, TypeInfo];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetExamin" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:TypeInfo forKey:@"TypeInfo"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取首页目录提纲
 */
+ (void)requestdoGetFirstBySuccess:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetFirstHis&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetFirstHis" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取模考试题目录提纲
 */
+ (void)requestdoGetMockOutlineByEID:(NSString *)EID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetOutline&uid=%@&EID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, EID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetOutline" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:EID forKey:@"EID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 根据试卷提纲获取已经做的试题列表(已做练习明细)
 */
+ (void)requestdoGetOutlineTitleHisByOID:(NSString *)OID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doOutlineTitleHis&uid=%@&OID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, OID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doOutlineTitleHis" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:OID forKey:@"OID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 刷新题纲及子题纲信息
 */
+ (void)requestdoGetFreOutlineByOID:(NSString *)OID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doFreOutline&uid=%@&OID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, OID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doFreOutline" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:OID forKey:@"OID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取试卷试题列表
 */
+ (void)requestGetExamTitleByEID:(NSString *)EID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doExaminTitle&uid=%@&EID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, EID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doExaminTitle" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:EID forKey:@"EID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取试卷试题列表  返回前50条数据，是没做的或错的试题
 */
+ (void)requestGetExamTitleExByEID:(NSString *)EID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doExaminTitleEx&uid=%@&EID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, EID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doExaminTitleEx" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:EID forKey:@"EID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 根据试卷提纲获取试题列表
 */
+ (void)requestGetOutlineTitleByOID:(NSString *)OID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doOutlineTitle&uid=%@&OID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, OID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doOutlineTitle" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:OID forKey:@"OID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 根据试卷提纲获取试题列表
 action=doOutlineTitleEx&uid=25&OID=324&NPage=1&tCount=10
 */
+ (void)requestGetOutlineTitleExByOID:(NSString *)OID tCount:(int)tCount Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doOutlineTitleEx&uid=%@&OID=%@&NPage=1&tCount=%d", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, OID, tCount];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doOutlineTitleEx" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:OID forKey:@"OID"];
    [dict setObject:@"1" forKey:@"NPage"];
    [dict setObject:[NSString stringWithFormat:@"%d", tCount] forKey:@"tCount"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取试卷题目明细信息
 http://120.26.198.113/bshApp/AppAction?action=doGetExaminTitles&uid=0&idlist=[{"ID":"5"},{"ID":"6"},{"ID":"7"}]
 */
+ (void)requestGetExamDetailsByTitleList:(NSArray *)titleList Success:(HttpSuccess)success failure:(HttpFailure)failure{
//[NSString stringWithFormat:@"%@?action=doGetExaminTitles&idlist=%@&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LLRequestClass getStringByExamTitleListArray:titleList], [LdGlobalObj sharedInstanse].user_id].
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetExaminTitles" forKey:@"action"];
    [dict setObject:[LLRequestClass getStringByExamTitleListArray:titleList] forKey:@"idlist"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取智能练习、组卷的题目列表明细信息
 http://120.26.198.113/bshApp/AppAction?action=doGetPractTitles&uid=0&idlist=[{"ID":"5"},{"ID":"6"},{"ID":"7"}]
 */
NSMutableArray *examDetailArray;
+ (void)requestGetIntelligentExamDetailsByTitleList:(NSArray *)titleList Success:(HttpSuccess)success failure:(HttpFailure)failure{
    examDetailArray = [NSMutableArray arrayWithCapacity:9];
    NSInteger perCount = kPreGetOrSendCount;
    NSInteger maxCount = titleList.count/perCount+1;
    NSInteger yushu = titleList.count%perCount;
    if((perCount == yushu)||(0 == yushu))
    {
        maxCount = titleList.count/perCount;
    }
    if(titleList.count > perCount)
    {
        for(NSInteger index=0; index<maxCount; index++)
        {
            NSInteger currentCount = perCount;
            if((index+1)*perCount >= titleList.count)
            {
                currentCount = yushu;
            }
            if(currentCount == 0)
            {
                currentCount = perCount;
            }
            NSArray *array = [titleList subarrayWithRange:NSMakeRange(index*perCount, currentCount)];
            NSString *url = [NSString stringWithFormat:@"%@?action=doGetPractTitles&idlist=%@&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LLRequestClass getStringByExamTitleListArray:array], [LdGlobalObj sharedInstanse].user_id];
            [LLRequestClass getWithURL:url success:^(id jsonData) {
                NSDictionary *contentDict=[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
                NSLog(@"%@", contentDict);
                NSString *result = contentDict[@"result"];
                if([result isEqualToString:@"success"])
                {
                    NSArray *examArray = contentDict[@"list"];
                    [examDetailArray addObjectsFromArray:examArray];
                }
                
                if(examDetailArray.count == titleList.count)
                {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
                    [dict setObject:@"success" forKey:@"result"];
                    [dict setObject:examDetailArray forKey:@"list"];
                    id tempJsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
                    success(tempJsonData);
                }
            } failure:^(NSError *error) {
                [examDetailArray removeAllObjects];
                if (error) {
                    failure(error);
                }
            }];
        }
    }
    else
    {
        NSString *url = [NSString stringWithFormat:@"%@?action=doGetPractTitles&idlist=%@&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LLRequestClass getStringByExamTitleListArray:titleList], [LdGlobalObj sharedInstanse].user_id];
        [LLRequestClass getWithURL:url success:^(id jsonData) {
            success(jsonData);
        } failure:^(NSError *error) {
            if (error) {
                failure(error);
            }
        }];
    }
}

+ (NSString *)getStringByExamTitleListArray:(NSArray *)array
{
    NSString *string = @"[";
    for(NSDictionary *dict in array)
    {
        string = [string stringByAppendingFormat:@"{\"%@\":\"%@\"}", dict.allKeys.firstObject, dict.allValues.firstObject];
        if(dict != [array lastObject])
        {
            string = [string stringByAppendingString:@","];
        }
    }
    string = [string stringByAppendingString:@"]"];
    return string;
}

/**
 试卷提交答题卡（包含首页习题）
 */
NSMutableArray *examResultArray;
+ (void)requestSubmitExamResultBySlist:(NSMutableArray *)slist Success:(HttpSuccess)success failure:(HttpFailure)failure{
    
    examResultArray = [NSMutableArray arrayWithCapacity:9];
    NSInteger perCount = kPreGetOrSendCount;
    NSInteger maxCount = slist.count/perCount+1;
    NSInteger yushu = slist.count%perCount;
    if((perCount == yushu)||(0 == yushu))
    {
        maxCount = slist.count/perCount;
    }
    if(slist.count > perCount)
    {
        for(NSInteger index=0; index<maxCount; index++)
        {
            NSInteger currentCount = perCount;
            if((index+1)*perCount >= slist.count)
            {
                currentCount = yushu;
            }
            if(currentCount == 0)
            {
                currentCount = perCount;
            }
            NSArray *array = [slist subarrayWithRange:NSMakeRange(index*perCount, currentCount)];
            NSMutableArray *resultList = [NSMutableArray arrayWithArray:array];
            for(int index=0; index<resultList.count; index++)
            {
                NSDictionary *resultDict = resultList[index];
                NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithCapacity:9];
                [tempDict setDictionary:resultDict];
                [tempDict setObject:resultDict[@"ExamID"] forKey:@"ID"];
                [tempDict removeObjectForKey:@"ExamID"];
                [tempDict removeObjectForKey:@"TagFlag"];
                [tempDict removeObjectForKey:@"isFromIntelligent"];
                [tempDict removeObjectForKey:@"isFromOutLine"];
                [tempDict removeObjectForKey:@"OID"];
                [resultList replaceObjectAtIndex:index withObject:tempDict];
            }
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
            [dict setObject:@"doPutExaminScantron" forKey:@"action"];
            [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
            [dict setObject:[self getStringByExamResultListArray:resultList] forKey:@"slist"];
            [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
                [examResultArray addObjectsFromArray:array];
                if(examResultArray.count == slist.count)
                {
                    success(jsonData);
                }
            } failure:^(NSError *error) {
                if (error) {
                    [examResultArray removeAllObjects];
                    failure(error);
                }
            }];
        }
    }
    else
    {
        NSMutableArray *resultList = [NSMutableArray arrayWithArray:slist];
        for(int index=0; index<resultList.count; index++)
        {
            NSDictionary *resultDict = resultList[index];
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithCapacity:9];
            [tempDict setDictionary:resultDict];
            [tempDict setObject:resultDict[@"ExamID"] forKey:@"ID"];
            [tempDict removeObjectForKey:@"ExamID"];
            [tempDict removeObjectForKey:@"TagFlag"];
            [tempDict removeObjectForKey:@"isFromIntelligent"];
            [tempDict removeObjectForKey:@"isFromOutLine"];
            [tempDict removeObjectForKey:@"OID"];
            [resultList replaceObjectAtIndex:index withObject:tempDict];
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
        [dict setObject:@"doPutExaminScantron" forKey:@"action"];
        [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
        [dict setObject:[self getStringByExamResultListArray:resultList] forKey:@"slist"];
        [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
            success(jsonData);
        } failure:^(NSError *error) {
            if (error) {
                failure(error);
            }
        }];
    }
}

/**
 智能练习、智能组卷提交答题卡
 */
+ (void)requestSubmitIntelligentExerciseResultBySlist:(NSMutableArray *)slist Success:(HttpSuccess)success failure:(HttpFailure)failure{
    examResultArray = [NSMutableArray arrayWithCapacity:9];
    NSInteger perCount = kPreGetOrSendCount;
    NSInteger maxCount = slist.count/perCount+1;
    NSInteger yushu = slist.count%perCount;
    if((perCount == yushu)||(0 == yushu))
    {
        maxCount = slist.count/perCount;
    }
    if(slist.count > perCount)
    {
        for(NSInteger index=0; index<maxCount; index++)
        {
            NSInteger currentCount = perCount;
            if((index+1)*perCount >= slist.count)
            {
                currentCount = yushu;
            }
            if(currentCount == 0)
            {
                currentCount = perCount;
            }
            NSArray *array = [slist subarrayWithRange:NSMakeRange(index*perCount, currentCount)];
            NSMutableArray *resultList = [NSMutableArray arrayWithArray:array];
            for(int index=0; index<resultList.count; index++)
            {
                NSDictionary *resultDict = resultList[index];
                NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithCapacity:9];
                [tempDict setDictionary:resultDict];
                [tempDict setObject:resultDict[@"ExamID"] forKey:@"ID"];
                [tempDict removeObjectForKey:@"ExamID"];
                [tempDict removeObjectForKey:@"TagFlag"];
                [tempDict removeObjectForKey:@"isFromIntelligent"];
                [tempDict removeObjectForKey:@"isFromOutLine"];
                [tempDict removeObjectForKey:@"OID"];
                [resultList replaceObjectAtIndex:index withObject:tempDict];
            }
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
            [dict setObject:@"doPutPractScantron" forKey:@"action"];
            [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
            [dict setObject:[self getStringByExamResultListArray:resultList] forKey:@"slist"];
            [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
                [examResultArray addObjectsFromArray:array];
                if(examResultArray.count == slist.count)
                {
                    success(jsonData);
                }
            } failure:^(NSError *error) {
                if (error) {
                    [examResultArray removeAllObjects];
                    failure(error);
                }
            }];
        }
    }
    else
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
        [dict setObject:@"doPutPractScantron" forKey:@"action"];
        [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
        
        NSMutableArray *resultList = [NSMutableArray arrayWithArray:slist];
        for(int index=0; index<resultList.count; index++)
        {
            NSDictionary *resultDict = resultList[index];
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithCapacity:9];
            [tempDict setDictionary:resultDict];
            [tempDict setObject:resultDict[@"ExamID"] forKey:@"ID"];
            [tempDict removeObjectForKey:@"ExamID"];
            [tempDict removeObjectForKey:@"TagFlag"];
            [tempDict removeObjectForKey:@"isFromIntelligent"];
            [tempDict removeObjectForKey:@"isFromOutLine"];
            [tempDict removeObjectForKey:@"OID"];
            [resultList replaceObjectAtIndex:index withObject:tempDict];
        }
        
        [dict setObject:[self getStringByExamResultListArray:resultList] forKey:@"slist"];
        [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
            success(jsonData);
        } failure:^(NSError *error) {
            if (error) {
                failure(error);
            }
        }];
    }
}

// http:// 120.26.198.113/bshApp/AppAction?action=doPutPractScantron&uid=0&slist=[{"ATime":"2017-4-24 10:10:10","ID":"0","Answer":"A","isOK":"是","GetScore":"10","UserTime":"5"},{"ATime":"2017-4-24 10:10:10","ID":"1","Answer":"A","isOK":"是","GetScore":"10","UserTime":"5"}]
+ (NSString *)getStringByExamResultListArray:(NSArray *)array
{
    NSString *string = @"[";
    for(NSDictionary *dict in array)
    {
        string = [string stringByAppendingString:@"{"];
        for(NSString *key in dict.allKeys)
        {
            if([key isEqualToString:@"ExamID"])
            {
                string = [string stringByAppendingFormat:@"\"%@\":\"%@\"", @"ID", dict[key]];
            }
            else if ([key isEqualToString:@"isOK"])
            {
                string = [string stringByAppendingFormat:@"\"%@\":\"%@\"", key, dict[key]];
            }
            else
            {
                string = [string stringByAppendingFormat:@"\"%@\":\"%@\"", key, dict[key]];
            }
            
            if(key != [dict.allKeys lastObject])
            {
                string = [string stringByAppendingString:@","];
            }
            else
            {
                string = [string stringByAppendingString:@"}"];
            }
        }
        
        if(dict != [array lastObject])
        {
            string = [string stringByAppendingString:@","];
        }
        
    }
    string = [string stringByAppendingString:@"]"];
    return string;
}

/**
 收藏信息提交
 */
+ (void)requestPutFavoriteByLinkID:(NSString *)LinkID FType:(NSString *)FType Success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSString *url = [NSString stringWithFormat:@"%@?action=doPutFavorite&uid=%@&ATime=%@&LinkID=%@&FType=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, [formatter stringFromDate:[NSDate date]], LinkID, FType];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doPutFavorite" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:[formatter stringFromDate:[NSDate date]] forKey:@"ATime"];
    [dict setObject:LinkID forKey:@"LinkID"];
    [dict setObject:FType forKey:@"FType"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 取消收藏信息
 */
+ (void)requestDeleteFavoriteByLinkID:(NSString *)LinkID FType:(NSString *)FType Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doDelFavorite&uid=%@&LinkID=%@&FType=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, LinkID, FType];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doDelFavorite" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:LinkID forKey:@"LinkID"];
    [dict setObject:FType forKey:@"FType"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取收藏列表
 */
+ (void)requestGetFavoriteListBySuccess:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetFavorite&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetFavorite" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 提交笔记
 */
+ (void)requestPutNoteByID:(NSString *)ID Note:(NSString *)Note Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doPutNote&uid=%@&nDate=%@&ID=%@&Note=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, [[LdGlobalObj sharedInstanse].formatter stringFromDate:[NSDate date]], ID, Note];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doPutNote" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:[[LdGlobalObj sharedInstanse].formatter stringFromDate:[NSDate date]] forKey:@"nDate"];
    [dict setObject:ID forKey:@"ID"];
    [dict setObject:Note forKey:@"Note"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取笔记
 */
+ (void)requestGetNoteByID:(NSString *)ID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetNote&uid=%@&ID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, ID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetNote" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:ID forKey:@"ID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 删除笔记
 */
+ (void)requestDeleteNoteByID:(NSString *)ID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doDelNote&uid=%@&ID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, ID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doDelNote" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:ID forKey:@"ID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取笔记题目
 */
+ (void)requestGetNoteTitlesBySuccess:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetNoteS&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetNoteS" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取错题信息
 */
+ (void)requestGetErrorExamsByEID:(NSString *)EID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetErrTitle&uid=%@&EID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, EID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetErrTitle" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:EID forKey:@"EID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 学生提交试题纠错信息
 */
+ (void)requestPutExaminTitleErrByID:(NSString *)ID intro:(NSString *)intro Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doPutExaminTitleErr&uid=%@&ID=%@&intro=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, ID, intro];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doPutExaminTitleErr" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:ID forKey:@"ID"];
    [dict setObject:intro forKey:@"intro"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 学生提交智能纠错信息
 */
+ (void)requestPutPractTitleErrByID:(NSString *)ID intro:(NSString *)intro Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doPutPractTitleErr&uid=%@&ID=%@&intro=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, ID, intro];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doPutPractTitleErr" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:ID forKey:@"ID"];
    [dict setObject:intro forKey:@"intro"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取视频分类
 */
+ (void)requestGetVideoTypeBySuccess:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetVideoType&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetVideoTypeNew" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取视频目录
 */
+ (void)requestGetVideoCatalogListByType:(NSString *)VType Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetVideoCatalog&uid=%@&VType=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, VType];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetVideoCatalog" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:VType forKey:@"VType"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 首页广告（视频）跳转到第二页 使用ID 获取类型和章节
 */
+ (void)requestGetADVideoCatalogListByID:(NSString *)ID Success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetVideoCatalogNewByID" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:ID forKey:@"VType"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取视频列表
 */
+ (void)requestGetVideoListByCatalog:(NSString *)Catalog Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetVideo&uid=%@&cID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, Catalog];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetVideo" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:Catalog forKey:@"cID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取所有直播课列表
 */
+ (void)requestGetAllLiveListBySuccess:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetLive&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetLive" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取直播课课程表
 */
+ (void)requestGetLiveScheduleListByLID:(NSString *)LID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetLiveSchedule&uid=%@&LID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, LID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetLiveSchedule" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:LID forKey:@"LID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取会员课程日程
 */
+ (void)requestGetUserLiveScheduleListBySuccess:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetSchedule&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetSchedule" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取会员已经购买的直播课列表
 */
+ (void)requestGetUserBuyedLiveListBySuccess:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetScheduleZhibo&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetScheduleZhibo" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取直播课教室
 */
+ (void)requestGetLiveClassRoomBySID:(NSString *)SID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetClassroom&uid=%@&SID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, SID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetClassroom" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:SID forKey:@"SID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取直播课老师信息
 */
+ (void)requestGetLiveTecherInfoByLID:(NSString *)LID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetLiveTeche&uid=%@&LID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, LID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetLiveTeche" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:LID forKey:@"LID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取当前收费类项目，是/否已经支付
 */
+ (void)requestGetDoIsPayByid:(NSString *)ID type:(NSString *)type Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doIsPay&uid=%@&id=%@&type=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, ID, type];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doIsPay" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:ID forKey:@"id"];
    [dict setObject:type forKey:@"type"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取支付sign
 */
+ (void)requestGetPayInfoBytype_pay:(NSString *)type_pay type:(NSString *)type ID:(NSString *)ID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetPayInfo&uid=%@&id=%@&type=%@&type_pay=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, ID, type, type_pay];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetPayInfo" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:ID forKey:@"id"];
    [dict setObject:type forKey:@"type"];
    [dict setObject:type_pay forKey:@"type_pay"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 支付成功 向后台回传
 */
+ (void)requestSendPaySuccessById:(NSString *)Id LinkID:(NSString *)LinkID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doPutPurch2&uid=%@&id=%@&LinkID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, Id, LinkID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doPutPurch2" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:Id forKey:@"id"];
    [dict setObject:LinkID forKey:@"LinkID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 提交支付信息  价格为零时，添加到已购买的数据库
 帐号ID  ：uid
 支付类别：PType
 订单日期：FeeDate
 关联ID  ：LinkID
 支付费用：Fee
 订单摘要：Abstract
 支付说明：Intro
 支付状态：PState
 */
+ (void)requestSendZeroPaySuccessByLinkID:(NSString *)LinkID PType:(NSString *)PType Abstract:(NSString *)Abstract Success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSString *url = [NSString stringWithFormat:@"%@?action=doPutPurch&uid=%@&LinkID=%@&Fee=0&Intro=免费&FeeDate=%@&PType=%@&Abstract=%@&PState=已支付", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, LinkID, [formatter stringFromDate:[NSDate date]], PType,Abstract];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doPutPurch" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:LinkID forKey:@"LinkID"];
    [dict setObject:@"0" forKey:@"Fee"];
    [dict setObject:@"免费" forKey:@"Intro"];
    [dict setObject:[formatter stringFromDate:[NSDate date]] forKey:@"FeeDate"];
    [dict setObject:PType forKey:@"PType"];
    [dict setObject:Abstract forKey:@"Abstract"];
    [dict setObject:@"已支付" forKey:@"PState"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 提交支付信息  苹果内购，添加到已购买的数据库
 帐号ID  ：uid
 支付类别：PType
 订单日期：FeeDate
 关联ID  ：LinkID
 支付费用：Fee
 订单摘要：Abstract
 支付说明：Intro
 支付状态：PState
 */
+ (void)requestSendApplePaySuccessByLinkID:(NSString *)LinkID Fee:(NSString *)Fee PType:(NSString *)PType Abstract:(NSString *)Abstract Success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSString *url = [NSString stringWithFormat:@"%@?action=doPutPurch&uid=%@&LinkID=%@&Fee=%@&Intro=苹果内购&FeeDate=%@&PType=%@&Abstract=%@&PState=已支付", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, LinkID, Fee, [formatter stringFromDate:[NSDate date]], PType, Abstract];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doPutPurch" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:LinkID forKey:@"LinkID"];
    [dict setObject:Fee forKey:@"Fee"];
    [dict setObject:@"苹果内购" forKey:@"Intro"];
    [dict setObject:[formatter stringFromDate:[NSDate date]] forKey:@"FeeDate"];
    [dict setObject:PType forKey:@"PType"];
    [dict setObject:Abstract forKey:@"Abstract"];
    [dict setObject:@"已支付" forKey:@"PState"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 新建智能练习取题
 */
+ (void)requestGetPractIntelligentExerciseListByQPoint:(NSString *)QPoint Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doNewPractList&uid=%@&QPoint=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, QPoint];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doNewPractList" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:QPoint forKey:@"QPoint"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 新建智能组卷取题
 */
+ (void)requestGetIntelligentExamListByContent:(NSString *)Content Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doNewExPractList&uid=%@&Content=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, Content];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doNewExPractList" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:Content forKey:@"Content"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取全部智能组卷/练习
 按时间倒叙
 */
+ (void)requestGetHistoryIntelligentListSuccess:(HttpSuccess)success failure:(HttpFailure)failure{
    NSString *url = [NSString stringWithFormat:@"%@?action=doGetAllHisPract&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetAllHisPract" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取智能练习、组卷的题目列表
 */
+ (void)requestGetHistoryPractTitleListByPID:(NSString *)PID Success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSString *url = [NSString stringWithFormat:@"%@?action=doGetPractTitle&uid=%@&PID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, PID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetPractTitle" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:PID forKey:@"PID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取历史智能组卷
 */
+ (void)requestGetHisExPractListSuccess:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetHisExPract&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetHisExPract" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取APP参数 获取首页做题n题：FirstCnt  首页提纲n题：OutlineCnt   ；客户端限制取得的数量显示出来
 */
+ (void)requestGetParamBySuccess:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetParam", [LdGlobalObj sharedInstanse].webAppIp];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetParam" forKey:@"action"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取订购信息
 */
+ (void)requestGetPurchListByPType:(NSString *)PType Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetPurch&uid=%@&PType=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, PType];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetPurch" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:PType forKey:@"PType"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取数据报告
 */
+ (void)requestGetDataReportByEID:(NSString *)EID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetRepPractice&uid=%@&EID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, EID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetRepPractice" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:EID forKey:@"EID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 题库搜题
 */
+ (void)requestGetSearchListByKeyWord:(NSString *)KeyWord NPage:(int)NPage Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetSearch&uid=%@&KeyWord=%@&NPage=%d&tCount=10", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, KeyWord, NPage];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetSearch" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:KeyWord forKey:@"KeyWord"];
    [dict setObject:[NSString stringWithFormat:@"%d", NPage] forKey:@"NPage"];
    [dict setObject:@"10" forKey:@"tCount"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 提交消息令牌
 */
+ (void)requestdoPutMsgTokenBytoken:(NSString *)token Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doPutMsgToken&uid=%@&token=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, token];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doPutMsgToken" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:token forKey:@"token"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 根据ID获取获取明细
 */
+ (void)requestdoGetAdvDetailBytitle:(NSString *)title path:(NSString *)path Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetAdvID&uid=%@&title=%@&path=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, title, path];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetAdvID" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:title forKey:@"title"];
    [dict setObject:path forKey:@"path"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取所有模考大赛信息
 */
+ (void)requestdoGetAllMockBySuccess:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetAllMock&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetAllMock" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取模考报名信息
 */
+ (void)requestdoGetMockSignBySuccess:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetSign&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetSign" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 提交模考报名信息
 帐号ID  ：uid
 报名时间：sDate
 模考ID  ：MockID
 省      ：Province
 市      ：City
 银行分类：Bank
 分行    ：subBank
 报考职位：job
 */
+ (void)requestdoPutMockSignByDict:(NSDictionary *)dict Success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSString *url = [NSString stringWithFormat:@"%@?action=doPutSign&uid=%@&sDate=%@&MockID=%@&Province=%@&City=%@&Bank=%@&subBank=%@&job=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, [formatter stringFromDate:[NSDate date]], dict[@"MockID"], dict[@"Province"], dict[@"City"], dict[@"Bank"], dict[@"subBank"], dict[@"job"]];
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict1 setObject:@"doPutSign" forKey:@"action"];
    [dict1 setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict1 setObject:[formatter stringFromDate:[NSDate date]] forKey:@"sDate"];
    [dict1 setObject:dict[@"MockID"] forKey:@"MockID"];
    [dict1 setObject:dict[@"Province"] forKey:@"Province"];
    [dict1 setObject:dict[@"City"] forKey:@"City"];
    [dict1 setObject:dict[@"Bank"] forKey:@"Bank"];
    [dict1 setObject:dict[@"subBank"] forKey:@"subBank"];
    [dict1 setObject:dict[@"job"] forKey:@"job"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict1 success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 根据课程的ID获取直播课的详细信息
 */
+ (void)requestdoGetLiveInfoBySID:(NSString *)SID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetLiveInfo&SID=%@", [LdGlobalObj sharedInstanse].webAppIp, SID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetLiveInfo" forKey:@"action"];
    [dict setObject:SID forKey:@"SID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 我的消息列表
 */
+ (void)requestGetMyMessageByNPage:(int)NPage tCount:(int)tCount Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetMsg&uid=%@&NPage=%d&tCount=%d", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, NPage, tCount];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetMsg" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:[NSString stringWithFormat:@"%d", NPage] forKey:@"NPage"];
    [dict setObject:[NSString stringWithFormat:@"%d", tCount] forKey:@"tCount"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 招聘列表
 http://120.26.198.113/bshApp/AppAction?action=doGetInfo&KeyWord=&NPage=1&tCount=10
 */
+ (void)requestGetZhaopinByNPage:(int)NPage tCount:(int)tCount Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetInfo&KeyWord=&NPage=%d&tCount=%d", [LdGlobalObj sharedInstanse].webAppIp, NPage, tCount];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetInfo" forKey:@"action"];
    [dict setObject:@"" forKey:@"KeyWord"];
    [dict setObject:[NSString stringWithFormat:@"%d", NPage] forKey:@"NPage"];
    [dict setObject:[NSString stringWithFormat:@"%d", tCount] forKey:@"tCount"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 增改收货地址
 */
+ (void)requestPutAddressByName:(NSString *)Name Tel:(NSString *)Tel Addr:(NSString *)Addr Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doPutAddr&uid=%@&Name=%@&Tel=%@&Addr=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, Name, Tel, Addr];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doPutAddr" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:Name forKey:@"Name"];
    [dict setObject:Tel forKey:@"Tel"];
    [dict setObject:Addr forKey:@"Addr"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 查询收货地址
 */
+ (void)requestGetAddressBySuccess:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetAddr&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetAddr" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 根据试卷提纲获取已经做的试题列表(已做练习明细)
 */
+ (void)requestGetOutlineTitleHisByOID:(NSString *)OID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetErrTitleOut&uid=%@&OID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, OID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetErrTitleOut" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:OID forKey:@"OID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 上传直播课日志
 */
+ (void)requestUploadLiveScheduleLogBySID:(NSString *)SID Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doPutScheduleLog&uid=%@&SID=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id,SID];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doPutScheduleLog" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:SID forKey:@"SID"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 每日签到接口
 */
+ (void)requestSignAppSuccess:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doCard&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doCard" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取打卡记录
 */
+ (void)requestGetSignAppListSuccess:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetCard&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetCard" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 根据时间段，获取所有的每日一练
 */
+ (void)requestGetExamDayBybegin:(NSString *)begin end:(NSString *)end Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetExamDay&uid=%@&begin=%@&end=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id, begin, end];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetExamDay" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:begin forKey:@"begin"];
    [dict setObject:end forKey:@"end"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取游客号
 */
+ (void)requestGetVisitorSuccess:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetVisitor", [LdGlobalObj sharedInstanse].webAppIp];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doGetVisitor" forKey:@"action"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 游客转正
 */
+ (void)requestUpdateVisitorByVid:(NSString *)vid uid:(NSString *)uid Success:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doUpdateVisitor&vid=%@&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, vid, uid];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"doUpdateVisitor" forKey:@"action"];
    [dict setObject:[LdGlobalObj sharedInstanse].user_id forKey:@"uid"];
    [dict setObject:vid forKey:@"vid"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 首页获取模块
 */
+ (void)requestGetFirstPageModuleBySuccess:(HttpSuccess)success failure:(HttpFailure)failure{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"getModule" forKey:@"action"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

/**
 获取资讯
 Type：资讯类别名称（可为空）
 NPage：页数  从0 开始
 tCount：一页多少条
 */
+ (void)requestGetNewsByType:(NSString *)Type NPage:(int)NPage Success:(HttpSuccess)success failure:(HttpFailure)failure{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    [dict setObject:@"getNews" forKey:@"action"];
    [dict setObject:Type forKey:@"Type"];
    [dict setObject:[NSString stringWithFormat:@"%d", NPage] forKey:@"NPage"];
    [dict setObject:@"10" forKey:@"tCount"];
    [LLRequestClass postWithURL:[LdGlobalObj sharedInstanse].webAppIp params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}
/**
 获取首页招聘信息
 */
+ (void)requestdoGetApplicationBySuccess:(HttpSuccess)success failure:(HttpFailure)failure{
//    NSString *url = [NSString stringWithFormat:@"%@?action=doGetAllMock&uid=%@", [LdGlobalObj sharedInstanse].webAppIp, [LdGlobalObj sharedInstanse].user_id];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
 NSString * url =  @"http://yhyk.project.njagan.org//dw.yikao/api/yikao/index/getIndex";
    [LLRequestClass postWithURL:url params:dict success:^(id jsonData) {
        success(jsonData);
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}
@end
