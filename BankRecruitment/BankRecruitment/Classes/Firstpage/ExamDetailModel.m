//
//  ExamDetailModel.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/19.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "ExamDetailModel.h"
#import "ExamDetailOptionModel.h"

@implementation ExamDetailModel

+ (instancetype)model
{
    __autoreleasing ExamDetailModel *model = [[ExamDetailModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.isFromIntelligent = dic[@"isFromIntelligent"];
    self.isFromOutLine = dic[@"isFromOutLine"];
    self.ID = dic[@"ID"];
    self.EID = dic[@"EID"];
    self.OID = dic[@"OID"];
    self.ordID = dic[@"ordID"];
    self.titleID = dic[@"titleID"];
    self.score = dic[@"score"];
    self.ATime = dic[@"ATime"];
    self.answer = dic[@"answer"];
    self.isOK = dic[@"isOK"];
    self.getScore = dic[@"getScore"];
    self.userTime = dic[@"userTime"];
    self.bank = dic[@"bank"];
    self.TYear = dic[@"TYear"];
    self.QType = dic[@"QType"];
    self.content = dic[@"content"];
    self.QPoint = dic[@"QPoint"];
    self.isBank = dic[@"isBank"];
    self.title = dic[@"title"];
    self.ID_Ord1 = dic[@"ID_Ord1"];
    self.CCount = dic[@"CCount"];
    self.ord = dic[@"ord"];
    self.CDate = dic[@"CDate"];
    self.solution = dic[@"solution"];
    self.analysis = dic[@"analysis"];
    self.material = dic[@"material"];
    self.totalCount = dic[@"totalCount"];
    self.rightCount = dic[@"rightCount"];
    self.errCount = dic[@"errCount"];
    self.badAnswer = dic[@"badAnswer"];
    
    NSMutableArray *list = [NSMutableArray arrayWithArray:dic[@"list_TitleList"]];
    NSMutableArray *list_TitleListArray = [NSMutableArray arrayWithCapacity:9];
    for(NSDictionary *subDic in list)
    {
        ExamDetailOptionModel *subModel = [ExamDetailOptionModel model];
        [subModel setDataWithDic:subDic];
        [list_TitleListArray addObject:subModel];
    }
    self.list_TitleList = [NSMutableArray arrayWithArray:list_TitleListArray];
}

@end
