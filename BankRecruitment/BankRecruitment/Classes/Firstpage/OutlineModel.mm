//
//  OutlineModel.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/4/17.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "OutlineModel.h"

@implementation OutlineModel

+ (instancetype)model
{
    __autoreleasing OutlineModel *model = [[OutlineModel alloc] init];
    model.isSpread = NO;
    model.ceng= 0;
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.EID = dic[@"EID"];
    self.ID = dic[@"ID"];
    self.SuperID = dic[@"superID"];
    self.OrdID = dic[@"ordID"];
    self.Name = dic[@"name"];
    self.TCount = AssignEmptyString(dic[@"TCount"]);
    self.TTime = dic[@"TTime"];
    self.IsOver = dic[@"isOver"];
    self.OType = dic[@"OType"];
    self.doCount = AssignEmptyString(dic[@"doCount"]);
    self.okCount = AssignEmptyString(dic[@"okCount"]);
    self.errCount = AssignEmptyString(dic[@"errCount"]);
    self.noCount = AssignEmptyString(dic[@"noCount"]);
    NSMutableArray *list = [NSMutableArray arrayWithArray:dic[@"list_outlineinfo"]];
    NSMutableArray *list_outlineinfoArray = [NSMutableArray arrayWithCapacity:9];
    for(NSDictionary *subDic in list)
    {
        OutlineModel *subModel = [OutlineModel model];
        [subModel setDataWithDic:subDic];
        [list_outlineinfoArray addObject:subModel];
    }
    self.list_outlineinfo = [NSMutableArray arrayWithArray:list_outlineinfoArray];
}

@end
