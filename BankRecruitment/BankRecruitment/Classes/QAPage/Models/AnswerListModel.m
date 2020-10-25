//
//  AnswerList.m
//  Recruitment
//
//  Created by humengfan on 2020/10/24.
//  Copyright © 2020 LongLian. All rights reserved.
//

#import "AnswerListModel.h"

@implementation AnswerListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"answerId": @"id"};
}
@end
