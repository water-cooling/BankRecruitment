//
//  ExamOperaterModel.m
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/24.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ExamOperaterModel.h"

@implementation ExamOperaterModel
+ (instancetype)model
{
    __autoreleasing ExamOperaterModel *model = [[ExamOperaterModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.user_id = dic[@"user_id"];
    self.ExamID = dic[@"ExamID"];
    self.Answer = dic[@"Answer"];
    self.GetScore = dic[@"GetScore"];
    self.isOK = dic[@"isOK"];
    self.TagFlag = dic[@"TagFlag"];
    self.EID = dic[@"EID"];
    self.isFromIntelligent = dic[@"isFromIntelligent"];
    self.isFromOutLine = dic[@"isFromOutLine"];
    self.OID = dic[@"OID"];
    self.isSelected = dic[@"isSelected"];
}
@end
