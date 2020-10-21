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
@end

NS_ASSUME_NONNULL_END
