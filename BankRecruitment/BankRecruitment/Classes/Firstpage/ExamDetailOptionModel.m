//
//  ExamDetailOptionModel.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/19.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ExamDetailOptionModel.h"

@implementation ExamDetailOptionModel

+ (instancetype)model
{
    __autoreleasing ExamDetailOptionModel *model = [[ExamDetailOptionModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.titleListID = dic[@"titleListID"];
    self.orderID = dic[@"orderID"];
    self.single = dic[@"single"];
    self.SList = dic[@"SList"];
}

@end
