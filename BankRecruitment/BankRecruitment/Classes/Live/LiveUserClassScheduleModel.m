//
//  LiveUserClassScheduleModel.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/11.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "LiveUserClassScheduleModel.h"

@implementation LiveUserClassScheduleModel
+ (instancetype)model
{
    __autoreleasing LiveUserClassScheduleModel *model = [[LiveUserClassScheduleModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.AFile = dic[@"AFile"];
    self.BegDate = dic[@"BegDate"];
    self.EndDate = dic[@"EndDate"];
    self.Intro = dic[@"Intro"];
    self.LID = dic[@"LID"];
    self.SID = dic[@"SID"];
    self.TecheName = dic[@"TecheName"];
    self.Name = dic[@"Name"];
}
@end
