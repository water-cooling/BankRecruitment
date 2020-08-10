//
//  LiveClassScheduleModel.m
//  BankRecruitment
//
//  Created by 夏建清 on 2017/5/4.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "LiveClassScheduleModel.h"

@implementation LiveClassScheduleModel
+ (instancetype)model
{
    __autoreleasing LiveClassScheduleModel *model = [[LiveClassScheduleModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.AFile = dic[@"AFile"];
    self.BegDate = dic[@"BegDate"];
    self.EndDate = dic[@"EndDate"];
    self.Intro = dic[@"Intro"];
    self.LID = dic[@"LID"];
    self.Resume = dic[@"Resume"];
    self.SID = dic[@"SID"];
    self.TecheAFile = dic[@"TecheAFile"];
    self.TecheID = dic[@"TecheID"];
    self.TecheIntro = dic[@"TecheIntro"];
    self.TecheName = dic[@"TecheName"];
    self.materials = dic[@"materials"];
}
@end
