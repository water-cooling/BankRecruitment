//
//  MockModel.m
//  BankRecruitment
//
//  Created by xia jianqing on 2017/6/3.
//  Copyright © 2017年 LongLian. All rights reserved.
//

#import "MockModel.h"

@implementation MockModel
+ (instancetype)model
{
    __autoreleasing MockModel *model = [[MockModel alloc] init];
    return model;
}

- (void)setDataWithDic:(NSDictionary *)dic {
    self.ID = dic[@"ID"];
    self.Screen = dic[@"Screen"];
    self.PCScreen = dic[@"PCScreen"];
    self.AllScreen = dic[@"AllScreen"];
    self.Name = dic[@"Name"];
    self.BegDate = dic[@"BegDate"];
    self.EndDate = dic[@"EndDate"];
    self.MDate = dic[@"MDate"];
    self.Scope = dic[@"Scope"];
    self.LiveID = dic[@"LiveID"];
    self.VideoID = dic[@"VideoID"];
    self.ExaminID = dic[@"ExaminID"];
    self.iCount = dic[@"iCount"];
    self.IsGet = dic[@"IsGet"];
    self.SjIsGet = dic[@"SjIsGet"];
    self.ZbIsGet = dic[@"ZbIsGet"];
    self.SpIsGet = dic[@"SpIsGet"];
    self.ExName = dic[@"ExName"];
    self.ExBegDate = dic[@"ExBegDate"];
    self.ExEndDate = dic[@"ExEndDate"];
    self.LivName = dic[@"LivName"];
    self.LivBegDate = dic[@"LivBegDate"];
    self.LivEndDate = dic[@"LivEndDate"];
    self.VidName = dic[@"VidName"];
    self.ExPrice = dic[@"ExPrice"];
    self.LivPirce = dic[@"LivPirce"];
    self.VidPirce = dic[@"VidPirce"];
}
@end
