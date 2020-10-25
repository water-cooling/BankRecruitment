//
//  NewRequestClass.h
//  Recruitment
//
//  Created by humengfan on 2020/10/20.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewRequestClass : NSObject
//获取评论选择分类
+ (void)requestQuestionCats:(NSMutableDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;
//登录
+ (void)requestLogin:(NSMutableDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;
//退出登录
+ (void)requestLogOut:(NSMutableDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;
 //获取问题列表
+ (void)requestQuestionList:(NSMutableDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;
 //新增问题
+ (void)requestAddQuestion:(NSMutableDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;
/**
 问题详情
 */
+ (void)requestQuestionDetail:(NSMutableDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;
/**
 获取我的问题列表
 */
+ (void)requestGetMyQuestionList:(NSMutableDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;
/**
 获取问题回答列表
 */
+ (void)requestGetAnswerList:(NSMutableDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;
/**
 回答问题
 */
+ (void)requestAddAnswer:(NSMutableDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;
/**
 点赞
 */
+ (void)requestPraiseAnswer:(NSMutableDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;
/**
 删除答案
 */
+ (void)requestDeleteAnswer:(NSMutableDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;
/**
 取消点赞
 */
+ (void)requestPraiseCancel:(NSMutableDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;
@end

NS_ASSUME_NONNULL_END
