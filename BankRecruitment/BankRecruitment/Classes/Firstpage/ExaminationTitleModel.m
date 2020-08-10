//
//  ExaminationQuestionModel.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/18.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ExaminationTitleModel.h"

@implementation ExaminationTitleModel

+ (instancetype)model
{
    __autoreleasing ExaminationTitleModel *model = [[ExaminationTitleModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.EID = dic[@"EID"];
    self.ID = dic[@"ID"];
    self.OID = dic[@"OID"];
    self.OrdID = dic[@"ordID"];
    self.TitleID = dic[@"TitleID"];
    self.Score = dic[@"Score"];
    self.ATime = dic[@"ATime"];
    self.Answer = dic[@"Answer"];
    self.isOK = dic[@"isOK"];
    self.GetScore = dic[@"GetScore"];
    self.UserTime = dic[@"UserTime"];
}

@end
