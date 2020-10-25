//
//  QuestionListModel.m
//  Recruitment
//
//  Created by humengfan on 2020/10/23.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "QuestionListModel.h"

@implementation QuestionListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"questionId": @"id"};
}
@end
